#include <iostream>
#include <fstream>

#include <verilated.h>
#include <vector>
#include <chrono>

#include "Vdual_nasa_log_parser.h"
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

void tick(Vdual_nasa_log_parser &parser)
{
    parser.clk = 0;
    parser.eval();

    parser.clk = 1;
    parser.eval();

    total_cycles++;
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

int main(int argc, char **argv)
{
    Verilated::commandArgs(argc, argv);

    Vdual_nasa_log_parser parser;
    LogRecord record;

    uint64_t record_count = 0;

    parser.clk = 0;
    parser.rst = 1;
    parser.valid0_in = 0;
    parser.ready0 = 0;
    parser.ascii0_in = 0;
    
    parser.valid1_in = 0;
    parser.ready1 = 0;
    parser.ascii1_in = 0;
    
    // Hold reset for two complete clock cycles
    tick(parser);
    tick(parser);
    
    parser.rst = 0;
    
    // Give one clean clock after reset
    tick(parser);

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

    size_t split = dataset_size / 2;
    
    while (split < buffer.size() && buffer[split] != '\n')
        split++;
    
    std::vector<char> buffer0(buffer.begin(), buffer.begin() + split);
    std::vector<char> buffer1(buffer.begin() + split, buffer.end());
    
    // ---------------- PARSE ----------------

    total_cycles = 0;
    
    auto parse_start = std::chrono::high_resolution_clock::now();
    
    size_t i0 = 0;
    size_t i1 = 0;
    
    while(i0 < buffer0.size() || i1 < buffer1.size())
    {
        //---------------- Parser 0 ----------------
    
        if(i0 < buffer0.size())
        {
            parser.ascii0_in = static_cast<unsigned char>(buffer0[i0++]);
            parser.valid0_in = 1;
        }
        else
        {
            parser.valid0_in = 0;
        }
    
        //---------------- Parser 1 ----------------
    
        if(i1 < buffer1.size())
        {
            parser.ascii1_in = static_cast<unsigned char>(buffer1[i1++]);
            parser.valid1_in = 1;
        }
        else
        {
            parser.valid1_in = 0;
        }
    
        //---------------- One FPGA clock ----------------
    
        tick(parser);
    
        //---------------- Parser 0 Output ----------------
    
        if(parser.valid0_record)
        {
            record_count++;
    
            parser.ready0 = 1;
            tick(parser);
    
            parser.ready0 = 0;
        }
    
        //---------------- Parser 1 Output ----------------
    
        if(parser.valid1_record)
        {
            record_count++;
    
            parser.ready1 = 1;
            tick(parser);
    
            parser.ready1 = 0;
        }
    }
    
    parser.valid0_in = 0;
    parser.valid1_in = 0;
    
    tick(parser);
   
    tick(parser);
    
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
            static_cast<double>(total_cycles) / dataset_size;

    cout << "\n========== FPGA Parser Benchmark ==========\n";

    cout << "Total FPGA Cycles : "
         << total_cycles
         << endl;


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
