`timescale 1ns / 1ps

module dual_nasa_log_parser(

    input wire clk,
    input wire rst,

    // Parser 0 Input
    input wire [7:0] ascii0_in,
    input wire valid0_in,
    input wire ready0,

    // Parser 1 Input
    input wire [7:0] ascii1_in,
    input wire valid1_in,
    input wire ready1,

    // Parser 0 Outputs
    output wire valid0_record,

    output wire [255:0] ip0_out,
    output wire [255:0] timestamp0_out,
    output wire [31:0] method0_out,
    output wire [511:0] url0_out,
    output wire [63:0] protocol0_out,
    output wire [31:0] status0_out,
    output wire [31:0] bytes0_out,

    // Parser 1 Outputs
    output wire valid1_record,

    output wire [255:0] ip1_out,
    output wire [255:0] timestamp1_out,
    output wire [31:0] method1_out,
    output wire [511:0] url1_out,
    output wire [63:0] protocol1_out,
    output wire [31:0] status1_out,
    output wire [31:0] bytes1_out

);

//////////////////////////////////////////////////////
// Parser Instance 0
//////////////////////////////////////////////////////

nasa_log_parser parser0 (

    .clk(clk),
    .rst(rst),

    .ascii_in(ascii0_in),
    .valid_in(valid0_in),
    .ready(ready0),

    .valid_record(valid0_record),

    .ip_out(ip0_out),
    .timestamp_out(timestamp0_out),
    .method_out(method0_out),
    .url_out(url0_out),
    .protocol_out(protocol0_out),
    .status_out(status0_out),
    .bytes_out(bytes0_out)

);

//////////////////////////////////////////////////////
// Parser Instance 1
//////////////////////////////////////////////////////

nasa_log_parser parser1 (

    .clk(clk),
    .rst(rst),

    .ascii_in(ascii1_in),
    .valid_in(valid1_in),
    .ready(ready1),

    .valid_record(valid1_record),

    .ip_out(ip1_out),
    .timestamp_out(timestamp1_out),
    .method_out(method1_out),
    .url_out(url1_out),
    .protocol_out(protocol1_out),
    .status_out(status1_out),
    .bytes_out(bytes1_out)

);

endmodule
