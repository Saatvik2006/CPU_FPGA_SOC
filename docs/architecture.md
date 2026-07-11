# CPU–FPGA Log Analytics Architecture

## Overview

This project implements a heterogeneous CPU–FPGA log analytics pipeline for parsing and analyzing large-scale HTTP access logs.

The FPGA is responsible for high-speed streaming log parsing, while the CPU performs higher-level analytics such as IP frequency analysis, status code statistics, and anomaly detection.

---

## System Architecture

```
                 +----------------------+
                 |    NASA Access Log   |
                 +----------+-----------+
                            |
                            |
                     ASCII Character Stream
                            |
                            v
                 +----------------------+
                 |   FPGA Log Parser    |
                 |  (Finite State FSM)  |
                 +----------+-----------+
                            |
                    Parsed Log Records
                            |
                            v
                 +----------------------+
                 |      CPU Memory      |
                 | vector<LogRecord>    |
                 +----------+-----------+
                            |
        +-------------------+--------------------+
        |                   |                    |
        |                   |                    |
        v                   v                    v
   IP Analysis      Status Analysis      URL Analysis
        |                   |                    |
        +-------------------+--------------------+
                            |
                            v
                   Detection / Statistics
```

---

## Design Philosophy

The project divides the workload according to hardware strengths.

### FPGA Responsibilities

- Streaming ASCII input
- Parsing HTTP log entries
- Extracting structured fields
- Producing one LogRecord per request

### CPU Responsibilities

- Hash table operations
- Frequency counting
- Statistical analysis
- Parallel analytics using OpenMP
- Distributed processing using MPI

---

## Data Flow

```
access.log
      |
      v
C++ File Reader
      |
ASCII Characters
      |
      v
Verilog Parser FSM
      |
Structured Outputs
      |
LogRecord Structure
      |
vector<LogRecord>
      |
Analytics
```

---

## Parser Outputs

Each parsed record contains:

- IP Address
- Timestamp
- HTTP Method
- URL
- HTTP Protocol
- Status Code
- Response Size (Bytes)

---

## Hardware Interface

### Inputs

| Signal | Description |
|---------|-------------|
| clk | System clock |
| rst | Active-high reset |
| ascii_in | Incoming ASCII character |
| valid_in | Indicates valid input character |
| ready | CPU acknowledges parsed record |

### Outputs

| Signal | Description |
|---------|-------------|
| valid_record | Parsed record available |
| ip_out | Parsed IP address |
| timestamp_out | Parsed timestamp |
| method_out | Parsed HTTP method |
| url_out | Parsed URL |
| protocol_out | Parsed protocol |
| status_out | Parsed status code |
| bytes_out | Parsed response size |

---

## Current Status

- FSM Parser implemented
- Full NASA dataset successfully parsed
- Verilator simulation validated
- CPU driver integration complete

Next stage:

- Hardware synthesis
- Timing analysis
- Resource utilization
- Throughput optimization
