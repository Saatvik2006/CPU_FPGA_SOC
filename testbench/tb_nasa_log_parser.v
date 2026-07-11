`timescale 1ns / 1ps

module tb_nasa_log_parser;

    reg clk;
    reg rst;

    reg [7:0] ascii_in;
    reg valid_in;
    reg ready;

    wire valid_record;

    nasa_log_parser uut (

        .clk(clk),
        .rst(rst),

        .ascii_in(ascii_in),
        .valid_in(valid_in),

        .valid_record(valid_record),
        .ready(ready)

    );

    //--------------------------------------------------

    always #5 clk = ~clk;

    //--------------------------------------------------

    task send_char;

        input [7:0] c;

        begin

            ascii_in = c;
            valid_in = 1;

            #10;
            $display("%c  state=%0d", c, uut.state);

        end

    endtask

    //--------------------------------------------------

    initial begin

        clk = 0;
        rst = 1;
		ready = 0;
        ascii_in = 0;
        valid_in = 0;

        #20;

        rst = 0;

       send_char("1");
        send_char("9");
        send_char("9");
        send_char(".");
        send_char("7");
        send_char("2");
        send_char(".");
        send_char("8");
        send_char("1");
        send_char(".");
        send_char("5");
        send_char("5");
        
        send_char(" ");
        send_char("-");
        send_char(" ");
        send_char("-");
        send_char(" ");
        send_char("[");

        send_char("0");
        send_char("1");
        send_char("/");
        send_char("J");
        send_char("u");
        send_char("l");
        send_char("/");
        send_char("1");
        send_char("9");
        send_char("9");
        send_char("5");
        send_char(":");
        send_char("0");
        send_char("0");
        send_char(":");
        send_char("0");
        send_char("0");
        send_char(":");
        send_char("0");
        send_char("1");
        send_char(" ");
        send_char("-");
        send_char("0");
        send_char("4");
        send_char("0");
        send_char("0");
        
        send_char("]");
        send_char("\"");
        
        send_char("G");
        send_char("E");
        send_char("T");
        
        send_char(" ");
        send_char("/");
        send_char("h");
        send_char("i");
        send_char("s");
        send_char("t");
        send_char("o");
        send_char("r");
        send_char("y");
        send_char("/");
        send_char("a");
        send_char("p");
        send_char("o");
        send_char("l");
        send_char("l");
        send_char("o");
        send_char("/");
        
        send_char(" ");

        send_char("H");
        send_char("T");
        send_char("T");
        send_char("P");
        send_char("/");
        send_char("1");
        send_char(".");
        send_char("0");
        
        send_char("\"");
        
        send_char(" ");
        
        send_char("2");
        send_char("0");
        send_char("0");
        
        send_char(" ");
        
        send_char("6");
        send_char("2");
        send_char("4");
        send_char("5");
        
        send_char(8'h0A);

        #20;

        valid_in = 0;

        #20;

        $display("\nExtracted IP:");

        $display("%c%c%c%c%c%c%c%c%c%c%c%c",
            uut.ip[7:0],
            uut.ip[15:8],
            uut.ip[23:16],
            uut.ip[31:24],
            uut.ip[39:32],
            uut.ip[47:40],
            uut.ip[55:48],
            uut.ip[63:56],
            uut.ip[71:64],
            uut.ip[79:72],
            uut.ip[87:80],
            uut.ip[95:88]
        );

        $display("Current State = %0d", uut.state);

        $display("\nMethod:");
        
        $display("%c%c%c",
            uut.method[7:0],
            uut.method[15:8],
            uut.method[23:16]
        );
        
        $display("Current State = %0d", uut.state);

        $display("\nURL:");
        
        $display("%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c",
            uut.url[7:0],
            uut.url[15:8],
            uut.url[23:16],
            uut.url[31:24],
            uut.url[39:32],
            uut.url[47:40],
            uut.url[55:48],
            uut.url[63:56],
            uut.url[71:64],
            uut.url[79:72],
            uut.url[87:80],
            uut.url[95:88],
            uut.url[103:96],
            uut.url[111:104],
            uut.url[119:112],
            uut.url[127:120]
        );
        
        $display("Current State = %0d", uut.state);

        $display("\nProtocol:");
        
        $display("%c%c%c%c%c%c%c%c",
            uut.protocol[7:0],
            uut.protocol[15:8],
            uut.protocol[23:16],
            uut.protocol[31:24],
            uut.protocol[39:32],
            uut.protocol[47:40],
            uut.protocol[55:48],
            uut.protocol[63:56]
        );
        $display("protocol_index = %0d", uut.protocol_index);
        
        $display("\nStatus:");
        
        $display("%c%c%c",
            uut.status[7:0],
            uut.status[15:8],
            uut.status[23:16]
        );
        
        $display("\nBytes:");
        
        $display("%c%c%c%c",
            uut.bytes[7:0],
            uut.bytes[15:8],
            uut.bytes[23:16],
            uut.bytes[31:24]
        );
        
        $display("\nValid Record = %0d", uut.valid_record);
        
        $display("Current State = %0d", uut.state);
        
        $display("\nTimestamp:");
        
        $display("%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c",
            uut.timestamp[7:0],
            uut.timestamp[15:8],
            uut.timestamp[23:16],
            uut.timestamp[31:24],
            uut.timestamp[39:32],
            uut.timestamp[47:40],
            uut.timestamp[55:48],
            uut.timestamp[63:56],
            uut.timestamp[71:64],
            uut.timestamp[79:72],
            uut.timestamp[87:80],
            uut.timestamp[95:88],
            uut.timestamp[103:96],
            uut.timestamp[111:104],
            uut.timestamp[119:112],
            uut.timestamp[127:120],
            uut.timestamp[135:128],
            uut.timestamp[143:136],
            uut.timestamp[151:144],
            uut.timestamp[159:152],
            uut.timestamp[167:160],
            uut.timestamp[175:168],
            uut.timestamp[183:176],
            uut.timestamp[191:184],
            uut.timestamp[199:192],
            uut.timestamp[207:200],
            uut.timestamp[215:208]
        );

		ready = 1;
		#10;
		ready = 0;
		
        $finish;

    end

endmodule
