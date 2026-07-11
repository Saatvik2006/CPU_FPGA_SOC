#include <iostream>
#include <fstream>

#include <verilated.h>
#include <vector>
#include <chrono>

#include "Vnasa_log_parser.h"
#include "log_record.h"

using namespace std;

void tick(Vnasa_log_parser &parser)
{
    parser.clk = 0;
    parser.eval();

    parser.clk = 1;
    parser.eval();
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

    Vnasa_log_parser parser;
    LogRecord record;

    std::vector<LogRecord> records;
    records.reserve(2000000);

    parser.clk = 0;
    parser.rst = 1;
    parser.valid_in = 0;
    parser.ready = 0;
    parser.ascii_in = 0;

    
    // Hold reset for two complete clock cycles
    tick(parser);
    tick(parser);
    
    parser.rst = 0;
    
    // Give one clean clock after reset
    tick(parser);

    ifstream logfile("./datasets/access.log");

    if(!logfile.is_open())
    {
        cout << "Failed to open dataset." << endl;
        return 1;
    }

    cout << "Dataset opened successfully." << endl;

    char c;

    logfile.seekg(0, ios::end);
    uint64_t dataset_size = logfile.tellg();
    logfile.seekg(0, ios::beg);

    auto start = std::chrono::high_resolution_clock::now();
    
    while (logfile.get(c))
    {
        parser.ascii_in = static_cast<unsigned char>(c);
        parser.valid_in = 1;
    
        tick(parser);

    
        if (parser.valid_record)
        {
            copy_wide_field(record.ip, parser.ip_out, 64);

            copy_wide_field(record.timestamp, parser.timestamp_out, 32);
            
            copy_small_field(record.method, parser.method_out, 4);
            
            copy_small_field(record.protocol, parser.protocol_out, 8);

            copy_small_field(record.status, parser.status_out, 4);

            copy_small_field(record.bytes, parser.bytes_out, 8);

            copy_wide_field(record.url, parser.url_out, 64);
    
//           std::cout << "\nRecord " << ++record_count << '\n';
//            std::cout << "IP       : " << record.ip << '\n';            
//            std::cout << "TIMESTAMP: " << record.timestamp << '\n';
//            std::cout << "METHOD   : " << record.method << '\n';
//            std::cout << "URL      : " << record.url << '\n';
//            std::cout << "PROTOCOL : " << record.protocol << '\n';
//            std::cout << "STATUS   : " << record.status << '\n';
//            std::cout << "BYTES    : " << record.bytes << '\n';

			records.push_back(record);
    
            parser.ready = 1;
            tick(parser);
            
            parser.ready = 0;
            tick(parser);

            
    
        }
    }
    parser.valid_in = 0;
    tick(parser);

    auto end = std::chrono::high_resolution_clock::now();

    double elapsed_seconds =
        std::chrono::duration<double>(end - start).count();

    double mbps =
        (dataset_size / 1024.0 / 1024.0) / elapsed_seconds;
    
    double records_per_sec =
        records.size() / elapsed_seconds;

    cout << "\n========== FPGA Parser Benchmark ==========\n";
    
    cout << "Dataset Size     : "
         << dataset_size / 1024.0 / 1024.0
         << " MB\n";
    
    cout << "Parsed Records   : "
         << records.size()
         << '\n';
    
    cout << "Elapsed Time     : "
         << elapsed_seconds
         << " s\n";
    
    cout << "Records / Second : "
         << records_per_sec
         << '\n';
    
    cout << "Throughput       : "
         << mbps
         << " MB/s\n";
    
    cout << "Parsed Records : "
         << records.size()
         << endl;
    
    cout << "Finished streaming dataset." << endl;
    
    logfile.close();
    
    return 0;
}
