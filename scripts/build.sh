#!/bin/bash

verilator \
--cc verilog/nasa_log_parser.v \
--exe src/parser_driver.cpp \
--build
