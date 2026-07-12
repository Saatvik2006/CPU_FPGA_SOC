`timescale 1ns / 1ps

module quad_nasa_log_parser(

    input wire clk,
    input wire rst,

    //==========================
    // Parser 0
    //==========================

    input wire [7:0] ascii0_in,
    input wire valid0_in,
    input wire ready0,

    output wire valid0_record,

    output wire [255:0] ip0_out,
    output wire [255:0] timestamp0_out,
    output wire [31:0] method0_out,
    output wire [511:0] url0_out,
    output wire [63:0] protocol0_out,
    output wire [31:0] status0_out,
    output wire [31:0] bytes0_out,

    //==========================
    // Parser 1
    //==========================

    input wire [7:0] ascii1_in,
    input wire valid1_in,
    input wire ready1,

    output wire valid1_record,

    output wire [255:0] ip1_out,
    output wire [255:0] timestamp1_out,
    output wire [31:0] method1_out,
    output wire [511:0] url1_out,
    output wire [63:0] protocol1_out,
    output wire [31:0] status1_out,
    output wire [31:0] bytes1_out,

    //==========================
    // Parser 2
    //==========================

    input wire [7:0] ascii2_in,
    input wire valid2_in,
    input wire ready2,

    output wire valid2_record,

    output wire [255:0] ip2_out,
    output wire [255:0] timestamp2_out,
    output wire [31:0] method2_out,
    output wire [511:0] url2_out,
    output wire [63:0] protocol2_out,
    output wire [31:0] status2_out,
    output wire [31:0] bytes2_out,

    //==========================
    // Parser 3
    //==========================

    input wire [7:0] ascii3_in,
    input wire valid3_in,
    input wire ready3,

    output wire valid3_record,

    output wire [255:0] ip3_out,
    output wire [255:0] timestamp3_out,
    output wire [31:0] method3_out,
    output wire [511:0] url3_out,
    output wire [63:0] protocol3_out,
    output wire [31:0] status3_out,
    output wire [31:0] bytes3_out

);

//==================================================
// Parser 0
//==================================================

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

//==================================================
// Parser 1
//==================================================

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

//==================================================
// Parser 2
//==================================================

nasa_log_parser parser2 (

    .clk(clk),
    .rst(rst),

    .ascii_in(ascii2_in),
    .valid_in(valid2_in),
    .ready(ready2),

    .valid_record(valid2_record),

    .ip_out(ip2_out),
    .timestamp_out(timestamp2_out),
    .method_out(method2_out),
    .url_out(url2_out),
    .protocol_out(protocol2_out),
    .status_out(status2_out),
    .bytes_out(bytes2_out)
);

//==================================================
// Parser 3
//==================================================

nasa_log_parser parser3 (

    .clk(clk),
    .rst(rst),

    .ascii_in(ascii3_in),
    .valid_in(valid3_in),
    .ready(ready3),

    .valid_record(valid3_record),

    .ip_out(ip3_out),
    .timestamp_out(timestamp3_out),
    .method_out(method3_out),
    .url_out(url3_out),
    .protocol_out(protocol3_out),
    .status_out(status3_out),
    .bytes_out(bytes3_out)
);

endmodule
