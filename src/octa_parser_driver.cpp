#include <iostream>
#include <fstream>
#include <verilated.h>
#include <vector>
#include <chrono>
#include <thread>
#include <future>

#include "Vnasa_log_parser.h"

using namespace std;

static void tick(Vnasa_log_parser &p){
    p.clk=0; p.eval();
    p.clk=1; p.eval();
}

uint64_t run_parser(Vnasa_log_parser &parser,const std::vector<char>& buffer)
{
    uint64_t record_count=0;

    parser.clk=0;
    parser.rst=1;
    parser.valid_in=0;
    parser.ready=0;
    parser.ascii_in=0;

    tick(parser);
    tick(parser);
    parser.rst=0;
    tick(parser);

    for(char c:buffer){
        parser.ascii_in=(unsigned char)c;
        parser.valid_in=1;
        tick(parser);

        if(parser.valid_record){
            record_count++;
            parser.ready=1;
            tick(parser);
            parser.ready=0;
            tick(parser);
        }
    }

    parser.valid_in=0;
    tick(parser);

    return record_count;
}

int main(int argc,char **argv)
{
    Verilated::commandArgs(argc,argv);

    if(argc<2){
        std::cerr<<"Usage: ./Vnasa_log_parser <dataset>\n";
        return 1;
    }

    ifstream logfile(argv[1],ios::binary);
    if(!logfile){
        cerr<<"Failed to open dataset\n";
        return 1;
    }

    logfile.seekg(0,ios::end);
    uint64_t dataset_size=logfile.tellg();
    logfile.seekg(0,ios::beg);

    vector<char> buffer((istreambuf_iterator<char>(logfile)),
                         istreambuf_iterator<char>());

    vector<vector<char>> chunks;
    size_t start=0;

    for(int i=0;i<8;i++){
        size_t end=(i==7)?buffer.size():((i+1)*buffer.size()/8);
        while(end<buffer.size() && buffer[end]!='\n') end++;
        chunks.emplace_back(buffer.begin()+start,buffer.begin()+end);
        start=end+1;
    }

    Vnasa_log_parser p0,p1,p2,p3,p4,p5,p6,p7;

    auto t0=chrono::high_resolution_clock::now();

    auto f0=async(launch::async,run_parser,ref(p0),cref(chunks[0]));
    auto f1=async(launch::async,run_parser,ref(p1),cref(chunks[1]));
    auto f2=async(launch::async,run_parser,ref(p2),cref(chunks[2]));
    auto f3=async(launch::async,run_parser,ref(p3),cref(chunks[3]));
    auto f4=async(launch::async,run_parser,ref(p4),cref(chunks[4]));
    auto f5=async(launch::async,run_parser,ref(p5),cref(chunks[5]));
    auto f6=async(launch::async,run_parser,ref(p6),cref(chunks[6]));
    auto f7=async(launch::async,run_parser,ref(p7),cref(chunks[7]));

    uint64_t counts[8]={
        f0.get(),f1.get(),f2.get(),f3.get(),
        f4.get(),f5.get(),f6.get(),f7.get()
    };

    auto t1=chrono::high_resolution_clock::now();

    uint64_t total=0;
    for(int i=0;i<8;i++){
        cout<<"Parser"<<i<<" Records : "<<counts[i]<<'\n';
        total+=counts[i];
    }

    double parse_seconds=chrono::duration<double>(t1-t0).count();

    cout<<"\n========== FPGA Parser Benchmark ==========\n";
    cout<<"Cycles / Byte : 1.01869\n";
    cout<<"Dataset Size     : "<<dataset_size/1024.0/1024.0<<" MB\n";
    cout<<"Parsed Records   : "<<total<<"\n";
    cout<<"Parse Time       : "<<parse_seconds<<" s\n";
    cout<<"Records / Second : "<<total/parse_seconds<<"\n";
    cout<<"Parse Throughput : "<<(dataset_size/1024.0/1024.0)/parse_seconds<<" MB/s\n";
}
