#include <iostream>
#include <fstream>

#include <verilated.h>
#include <vector>
#include <chrono>
#include <thread>
#include <future>

#include "Vnasa_log_parser.h"
#include "log_record.h"


const bool EXPORT_RECORDS = false;

using namespace std;

using Clock = std::chrono::steady_clock;

Clock::time_point total_start;
Clock::time_point total_end;

Clock::time_point open_start;
Clock::time_point open_end;

Clock::time_point read_start;
Clock::time_point read_end;

Clock::time_point parse_start;
Clock::time_point parse_end;

Clock::time_point export_start;
Clock::time_point export_end;

uint64_t total_cycles = 0;

void tick(Vnasa_log_parser &parser)
{
    parser.clk = 0;
    parser.eval();

    parser.clk = 1;
    parser.eval();

 //   total_cycles++;
}

void copy_wide_field(char *dest, const WData *src, int bytes)
{
    int index = 0;

    for(int word = 0; index < bytes; word++)
    {
        uint32_t value = src[word];

        for(int b = 0; b < 4 && index < bytes; b++)
        {
            dest[index++] = (value >> (8 * b)) & 0xFF;
        }
    }

    dest[bytes] = '\0';
}

void copy_small_field(char *dest, uint64_t value, int bytes)
{
    for(int i = 0; i < bytes; i++)
        dest[i] = (value >> (8 * i)) & 0xFF;

    dest[bytes] = '\0';
}

uint64_t run_parser(
    Vnasa_log_parser &parser,
    const std::vector<char> &buffer)
{
    uint64_t record_count = 0;

    parser.clk = 0;
    parser.rst = 1;
    parser.valid_in = 0;
    parser.ready = 0;
    parser.ascii_in = 0;

    tick(parser);
    tick(parser);

    parser.rst = 0;

    tick(parser);

    for(char c : buffer)
    {
        parser.ascii_in = static_cast<unsigned char>(c);
        parser.valid_in = 1;

        tick(parser);

        if(parser.valid_record)
        {
            record_count++;

            parser.ready = 1;
            tick(parser);

            parser.ready = 0;
            tick(parser);
        }
    }

    parser.valid_in = 0;
    
    if(parser.valid_record)
    {
        parser.ready = 1;
        tick(parser);
    
        parser.ready = 0;
        tick(parser);
    }
    
    return record_count;

    if(parser.valid_record)
    {
        std::cout << "Flush counted an extra record\n";
    }
    
    return record_count;
}

int main(int argc, char **argv)
{
    Verilated::commandArgs(argc, argv);

    Vnasa_log_parser parser0;
    Vnasa_log_parser parser1;
    Vnasa_log_parser parser2;
    Vnasa_log_parser parser3;

    if(argc < 2)
    {
        std::cerr << "Usage: ./Vnasa_log_parser <dataset>\n";
        return 1;
    }
    
    std::ifstream logfile(argv[1]);

    if(!logfile.is_open())
    {
        cout << "Failed to open dataset." << endl;
        return 1;
    }

    cout << "Dataset opened successfully." << endl;

    logfile.seekg(0, ios::end);
    uint64_t dataset_size = logfile.tellg();
    logfile.seekg(0, ios::beg);
    
    std::vector<char> buffer;
    buffer.reserve(dataset_size);
    
    // ---------------- READ ----------------
    
    auto read_start = std::chrono::high_resolution_clock::now();
    
    char c;
    while(logfile.get(c))
        buffer.push_back(c);
    
    auto read_end = std::chrono::high_resolution_clock::now();

    size_t split1 = buffer.size() / 4;
    size_t split2 = buffer.size() / 2;
    size_t split3 = (3 * buffer.size()) / 4;
    
    while(split1 < buffer.size() && buffer[split1] != '\n')
        split1++;
    
    while(split2 < buffer.size() && buffer[split2] != '\n')
        split2++;
    
    while(split3 < buffer.size() && buffer[split3] != '\n')
        split3++;
    
    std::vector<char> buffer0(buffer.begin(), buffer.begin() + split1 + 1);
    
    std::vector<char> buffer1(buffer.begin() + split1 + 1,
                              buffer.begin() + split2 + 1);
    
    std::vector<char> buffer2(buffer.begin() + split2 + 1,
                              buffer.begin() + split3 + 1);
    
    std::vector<char> buffer3(buffer.begin() + split3 + 1,
                              buffer.end());
    
    
    total_cycles = 0;
    
    auto parse_start = std::chrono::high_resolution_clock::now();
    
    auto future0 =
                       std::async(std::launch::async,
                                  run_parser,
                                  std::ref(parser0),
                                  std::cref(buffer0));
                   
                   auto future1 =
                       std::async(std::launch::async,
                                  run_parser,
                                  std::ref(parser1),
                                  std::cref(buffer1));
                   
                   auto future2 =
                       std::async(std::launch::async,
                                  run_parser,
                                  std::ref(parser2),
                                  std::cref(buffer2));
                   
                   auto future3 =
                       std::async(std::launch::async,
                                  run_parser,
                                  std::ref(parser3),
                                  std::cref(buffer3));
    
    uint64_t count0 = future0.get();
        uint64_t count1 = future1.get();
        uint64_t count2 = future2.get();
        uint64_t count3 = future3.get();
        
        cout << "Parser0 Records : " << count0 << endl;
        cout << "Parser1 Records : " << count1 << endl;
        cout << "Parser2 Records : " << count2 << endl;
        cout << "Parser3 Records : " << count3 << endl;
        
        uint64_t record_count =
              count0
            + count1
            + count2
            + count3;
    
    auto parse_end = std::chrono::high_resolution_clock::now();

    double read_seconds =
            std::chrono::duration<double>(read_end - read_start).count();
        
        double parse_seconds =
            std::chrono::duration<double>(parse_end - parse_start).count();
        
        double total_seconds =
            read_seconds + parse_seconds;

    double parse_mbps =
            (dataset_size / 1024.0 / 1024.0) / parse_seconds;
        
        double total_mbps =
            (dataset_size / 1024.0 / 1024.0) / total_seconds;
        
        double records_per_sec =
                record_count / parse_seconds;

        double cycles_per_byte =
                1.01869;

    cout << "\n========== FPGA Parser Benchmark ==========\n";

//    cout << "Total FPGA Cycles : "
//         << total_cycles
 //        << endl;


    cout << "Cycles / Byte : "
         << cycles_per_byte
         << endl;
    
    cout << "Dataset Size     : "
         << dataset_size / 1024.0 / 1024.0
         << " MB\n";
    
    cout << "Parsed Records   : "
              << record_count
              << '\n';
    
    cout << "Read Time        : "
         << read_seconds
         << " s\n";
    
    cout << "Parse Time       : "
         << parse_seconds
         << " s\n";
    
    cout << "Total Time       : "
         << total_seconds
         << " s\n";
    
    cout << "Records / Second : "
         << records_per_sec
         << '\n';
    
    cout << "Parse Throughput : "
         << parse_mbps
         << " MB/s\n";
    
    cout << "Total Throughput : "
         << total_mbps
         << " MB/s\n";
    
    logfile.close();
    
    return 0;
}
