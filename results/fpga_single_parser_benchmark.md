# FPGA Single Parser Benchmark (Version 1)

## Objective

Evaluate the performance of a single streaming FPGA log parser implemented in Verilog.

The parser extracts the following fields from each NASA HTTP access log entry:

- Client IP
- Timestamp
- HTTP Method
- URL
- Protocol
- HTTP Status Code
- Response Size

The design was functionally verified using Verilator and synthesized using AMD Vivado.

---

# Experimental Setup

## FPGA Design

- Architecture: Single Streaming Finite State Machine (FSM)
- Language: Verilog HDL
- Input Width: 8-bit ASCII stream
- Output: Parsed Log Record
- Streaming Interface:
  - valid_in
  - valid_record
  - ready

---

## Verification

- Simulator: Verilator
- Functional verification: Passed
- Correctness: Verified on NASA HTTP Access Logs

---

## Synthesis

Tool: AMD Vivado 2024.2

Target Device:

- Artix-7 XC7A35T-CSG324-1

Maximum Stable Frequency

| Frequency | Status |
|-----------|--------|
|100 MHz|PASS|
|150 MHz|PASS|
|200 MHz|PASS|
|220 MHz|PASS|
|221 MHz|PASS|
|222 MHz|PASS|
|223 MHz|FAIL|
|224 MHz|FAIL|
|225 MHz|FAIL|
|250 MHz|FAIL|
|300 MHz|FAIL|

Maximum Operating Frequency

**222 MHz**

---

# FPGA Architecture Characteristics

Measured from Verilator

| Metric | Value |
|---------|------:|
|Total FPGA Cycles (160 MB)|170,950,105|
|Cycles per Byte|1.01869|
|Cycles per Input Character|1.01869|

Observation:

The parser requires approximately one FPGA clock cycle for every input byte, demonstrating constant streaming behavior independent of dataset size.

---

# Verilator Benchmark Results

| Dataset | Size | Read Time (s) | Parse Time (s) | Total Time (s) | Parse Throughput (MB/s) |
|---------|-----:|--------------:|---------------:|---------------:|------------------------:|
|access.log|160.04 MB|0.842|13.724|14.566|11.66|
|nasa_500MB.log|500 MB|2.581|42.857|45.438|11.67|
|nasa_1GB.log|1024 MB|5.298|87.576|92.874|11.69|
|nasa_2GB.log|2048 MB|10.554|169.896|180.450|12.05|
|nasa_4GB.log|4096 MB|20.776|339.547|360.323|12.06|
|nasa_8GB.log|8192 MB|42.196|678.495|720.692|12.07|
|nasa_10GB.log|10240 MB|52.359|875.969|928.328|11.69|

---

# Estimated Hardware Performance

Using

- Maximum Frequency = 222 MHz
- Cycles per Byte = 1.01869

Estimated Hardware Throughput

```
222 MHz / 1.01869

≈ 217.9 MB/s

≈ 208 MiB/s
```

Estimated FPGA Parse Time

| Dataset | Estimated Parse Time |
|---------|---------------------:|
|160 MB|0.75 s|
|500 MB|2.34 s|
|1 GB|4.79 s|
|2 GB|9.58 s|
|4 GB|19.17 s|
|8 GB|38.34 s|
|10 GB|47.92 s|

---

# FPGA Resource Utilization

Target Device

Artix-7 XC7A35T

| Resource | Used | Available | Utilization |
|----------|-----:|----------:|------------:|
|Slice LUTs|1223|20800|5.88%|
|Slice Registers|2438|41600|5.86%|
|LUT RAM|0|9600|0%|
|F7 Muxes|0|16300|0%|
|F8 Muxes|0|8150|0%|

Observation

The parser occupies only approximately 6% of the available LUT resources, indicating significant capacity for architectural scaling through multiple parallel parser instances.

---

# Summary

- Functional FPGA parser successfully implemented.
- Constant streaming cost of approximately one clock cycle per input byte.
- Successfully synthesized at 222 MHz.
- Estimated hardware throughput of approximately 208 MiB/s.
- FPGA utilization remains below 6%, leaving substantial resources available for future multi-parser architectures.
