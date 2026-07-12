`timescale 1ns / 1ps

module hexa_nasa_log_parser(

    input wire clk,
    input wire rst,

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
    output wire [31:0] bytes3_out,

    input wire [7:0] ascii4_in,
    input wire valid4_in,
    input wire ready4,

    output wire valid4_record,

    output wire [255:0] ip4_out,
    output wire [255:0] timestamp4_out,
    output wire [31:0] method4_out,
    output wire [511:0] url4_out,
    output wire [63:0] protocol4_out,
    output wire [31:0] status4_out,
    output wire [31:0] bytes4_out,

    input wire [7:0] ascii5_in,
    input wire valid5_in,
    input wire ready5,

    output wire valid5_record,

    output wire [255:0] ip5_out,
    output wire [255:0] timestamp5_out,
    output wire [31:0] method5_out,
    output wire [511:0] url5_out,
    output wire [63:0] protocol5_out,
    output wire [31:0] status5_out,
    output wire [31:0] bytes5_out,

    input wire [7:0] ascii6_in,
    input wire valid6_in,
    input wire ready6,

    output wire valid6_record,

    output wire [255:0] ip6_out,
    output wire [255:0] timestamp6_out,
    output wire [31:0] method6_out,
    output wire [511:0] url6_out,
    output wire [63:0] protocol6_out,
    output wire [31:0] status6_out,
    output wire [31:0] bytes6_out,

    input wire [7:0] ascii7_in,
    input wire valid7_in,
    input wire ready7,

    output wire valid7_record,

    output wire [255:0] ip7_out,
    output wire [255:0] timestamp7_out,
    output wire [31:0] method7_out,
    output wire [511:0] url7_out,
    output wire [63:0] protocol7_out,
    output wire [31:0] status7_out,
    output wire [31:0] bytes7_out,

    input wire [7:0] ascii8_in,
    input wire valid8_in,
    input wire ready8,

    output wire valid8_record,

    output wire [255:0] ip8_out,
    output wire [255:0] timestamp8_out,
    output wire [31:0] method8_out,
    output wire [511:0] url8_out,
    output wire [63:0] protocol8_out,
    output wire [31:0] status8_out,
    output wire [31:0] bytes8_out,

    input wire [7:0] ascii9_in,
    input wire valid9_in,
    input wire ready9,

    output wire valid9_record,

    output wire [255:0] ip9_out,
    output wire [255:0] timestamp9_out,
    output wire [31:0] method9_out,
    output wire [511:0] url9_out,
    output wire [63:0] protocol9_out,
    output wire [31:0] status9_out,
    output wire [31:0] bytes9_out,

    input wire [7:0] ascii10_in,
    input wire valid10_in,
    input wire ready10,

    output wire valid10_record,

    output wire [255:0] ip10_out,
    output wire [255:0] timestamp10_out,
    output wire [31:0] method10_out,
    output wire [511:0] url10_out,
    output wire [63:0] protocol10_out,
    output wire [31:0] status10_out,
    output wire [31:0] bytes10_out,

    input wire [7:0] ascii11_in,
    input wire valid11_in,
    input wire ready11,

    output wire valid11_record,

    output wire [255:0] ip11_out,
    output wire [255:0] timestamp11_out,
    output wire [31:0] method11_out,
    output wire [511:0] url11_out,
    output wire [63:0] protocol11_out,
    output wire [31:0] status11_out,
    output wire [31:0] bytes11_out,

    input wire [7:0] ascii12_in,
    input wire valid12_in,
    input wire ready12,

    output wire valid12_record,

    output wire [255:0] ip12_out,
    output wire [255:0] timestamp12_out,
    output wire [31:0] method12_out,
    output wire [511:0] url12_out,
    output wire [63:0] protocol12_out,
    output wire [31:0] status12_out,
    output wire [31:0] bytes12_out,

    input wire [7:0] ascii13_in,
    input wire valid13_in,
    input wire ready13,

    output wire valid13_record,

    output wire [255:0] ip13_out,
    output wire [255:0] timestamp13_out,
    output wire [31:0] method13_out,
    output wire [511:0] url13_out,
    output wire [63:0] protocol13_out,
    output wire [31:0] status13_out,
    output wire [31:0] bytes13_out,

    input wire [7:0] ascii14_in,
    input wire valid14_in,
    input wire ready14,

    output wire valid14_record,

    output wire [255:0] ip14_out,
    output wire [255:0] timestamp14_out,
    output wire [31:0] method14_out,
    output wire [511:0] url14_out,
    output wire [63:0] protocol14_out,
    output wire [31:0] status14_out,
    output wire [31:0] bytes14_out,

    input wire [7:0] ascii15_in,
    input wire valid15_in,
    input wire ready15,

    output wire valid15_record,

    output wire [255:0] ip15_out,
    output wire [255:0] timestamp15_out,
    output wire [31:0] method15_out,
    output wire [511:0] url15_out,
    output wire [63:0] protocol15_out,
    output wire [31:0] status15_out,
    output wire [31:0] bytes15_out

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

//==================================================
// Parser 4
//==================================================

nasa_log_parser parser4 (

    .clk(clk),
    .rst(rst),

    .ascii_in(ascii4_in),
    .valid_in(valid4_in),
    .ready(ready4),

    .valid_record(valid4_record),

    .ip_out(ip4_out),
    .timestamp_out(timestamp4_out),
    .method_out(method4_out),
    .url_out(url4_out),
    .protocol_out(protocol4_out),
    .status_out(status4_out),
    .bytes_out(bytes4_out)
);

//==================================================
// Parser 5
//==================================================

nasa_log_parser parser5 (

    .clk(clk),
    .rst(rst),

    .ascii_in(ascii5_in),
    .valid_in(valid5_in),
    .ready(ready5),

    .valid_record(valid5_record),

    .ip_out(ip5_out),
    .timestamp_out(timestamp5_out),
    .method_out(method5_out),
    .url_out(url5_out),
    .protocol_out(protocol5_out),
    .status_out(status5_out),
    .bytes_out(bytes5_out)
);

//==================================================
// Parser 6
//==================================================

nasa_log_parser parser6 (

    .clk(clk),
    .rst(rst),

    .ascii_in(ascii6_in),
    .valid_in(valid6_in),
    .ready(ready6),

    .valid_record(valid6_record),

    .ip_out(ip6_out),
    .timestamp_out(timestamp6_out),
    .method_out(method6_out),
    .url_out(url6_out),
    .protocol_out(protocol6_out),
    .status_out(status6_out),
    .bytes_out(bytes6_out)
);

//==================================================
// Parser 7
//==================================================

nasa_log_parser parser7 (

    .clk(clk),
    .rst(rst),

    .ascii_in(ascii7_in),
    .valid_in(valid7_in),
    .ready(ready7),

    .valid_record(valid7_record),

    .ip_out(ip7_out),
    .timestamp_out(timestamp7_out),
    .method_out(method7_out),
    .url_out(url7_out),
    .protocol_out(protocol7_out),
    .status_out(status7_out),
    .bytes_out(bytes7_out)
);

//==================================================
// Parser 8
//==================================================

nasa_log_parser parser8 (

    .clk(clk),
    .rst(rst),

    .ascii_in(ascii8_in),
    .valid_in(valid8_in),
    .ready(ready8),

    .valid_record(valid8_record),

    .ip_out(ip8_out),
    .timestamp_out(timestamp8_out),
    .method_out(method8_out),
    .url_out(url8_out),
    .protocol_out(protocol8_out),
    .status_out(status8_out),
    .bytes_out(bytes8_out)
);

//==================================================
// Parser 9
//==================================================

nasa_log_parser parser9 (

    .clk(clk),
    .rst(rst),

    .ascii_in(ascii9_in),
    .valid_in(valid9_in),
    .ready(ready9),

    .valid_record(valid9_record),

    .ip_out(ip9_out),
    .timestamp_out(timestamp9_out),
    .method_out(method9_out),
    .url_out(url9_out),
    .protocol_out(protocol9_out),
    .status_out(status9_out),
    .bytes_out(bytes9_out)
);

//==================================================
// Parser 10
//==================================================

nasa_log_parser parser10 (

    .clk(clk),
    .rst(rst),

    .ascii_in(ascii10_in),
    .valid_in(valid10_in),
    .ready(ready10),

    .valid_record(valid10_record),

    .ip_out(ip10_out),
    .timestamp_out(timestamp10_out),
    .method_out(method10_out),
    .url_out(url10_out),
    .protocol_out(protocol10_out),
    .status_out(status10_out),
    .bytes_out(bytes10_out)
);

//==================================================
// Parser 11
//==================================================

nasa_log_parser parser11 (

    .clk(clk),
    .rst(rst),

    .ascii_in(ascii11_in),
    .valid_in(valid11_in),
    .ready(ready11),

    .valid_record(valid11_record),

    .ip_out(ip11_out),
    .timestamp_out(timestamp11_out),
    .method_out(method11_out),
    .url_out(url11_out),
    .protocol_out(protocol11_out),
    .status_out(status11_out),
    .bytes_out(bytes11_out)
);

//==================================================
// Parser 12
//==================================================

nasa_log_parser parser12 (

    .clk(clk),
    .rst(rst),

    .ascii_in(ascii12_in),
    .valid_in(valid12_in),
    .ready(ready12),

    .valid_record(valid12_record),

    .ip_out(ip12_out),
    .timestamp_out(timestamp12_out),
    .method_out(method12_out),
    .url_out(url12_out),
    .protocol_out(protocol12_out),
    .status_out(status12_out),
    .bytes_out(bytes12_out)
);

//==================================================
// Parser 13
//==================================================

nasa_log_parser parser13 (

    .clk(clk),
    .rst(rst),

    .ascii_in(ascii13_in),
    .valid_in(valid13_in),
    .ready(ready13),

    .valid_record(valid13_record),

    .ip_out(ip13_out),
    .timestamp_out(timestamp13_out),
    .method_out(method13_out),
    .url_out(url13_out),
    .protocol_out(protocol13_out),
    .status_out(status13_out),
    .bytes_out(bytes13_out)
);

//==================================================
// Parser 14
//==================================================

nasa_log_parser parser14 (

    .clk(clk),
    .rst(rst),

    .ascii_in(ascii14_in),
    .valid_in(valid14_in),
    .ready(ready14),

    .valid_record(valid14_record),

    .ip_out(ip14_out),
    .timestamp_out(timestamp14_out),
    .method_out(method14_out),
    .url_out(url14_out),
    .protocol_out(protocol14_out),
    .status_out(status14_out),
    .bytes_out(bytes14_out)
);

//==================================================
// Parser 15
//==================================================

nasa_log_parser parser15 (

    .clk(clk),
    .rst(rst),

    .ascii_in(ascii15_in),
    .valid_in(valid15_in),
    .ready(ready15),

    .valid_record(valid15_record),

    .ip_out(ip15_out),
    .timestamp_out(timestamp15_out),
    .method_out(method15_out),
    .url_out(url15_out),
    .protocol_out(protocol15_out),
    .status_out(status15_out),
    .bytes_out(bytes15_out)
);

endmodule
