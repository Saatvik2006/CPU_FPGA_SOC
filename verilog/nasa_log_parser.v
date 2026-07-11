`timescale 1ns / 1ps

module nasa_log_parser(

    input wire clk,
    input wire rst,

    input wire [7:0] ascii_in,
    input wire valid_in,
    input wire ready,

    output reg valid_record,

    output reg [255 :0] ip_out,
    output reg [255:0] timestamp_out,
    output reg [31:0] method_out,
    output reg [511:0] url_out,
    output reg [63:0] protocol_out,
    output reg [31:0] status_out,
    output reg [31:0] bytes_out

);

    //==================================================
    // State Definitions
    //==================================================

    localparam IDLE           = 4'd0;
    localparam READ_IP        = 4'd1;
    localparam SKIP_IDENT     = 4'd2;
    localparam SKIP_USER      = 4'd3;
    localparam READ_TIMESTAMP = 4'd4;
    localparam READ_METHOD    = 4'd5;
    localparam READ_URL       = 4'd6;
    localparam READ_PROTOCOL  = 4'd7;
    localparam READ_STATUS    = 4'd8;
    localparam READ_BYTES     = 4'd9;
    localparam DONE           = 4'd10;
    localparam ERROR_STATE    = 4'd11;

    //==================================================
    // Registers
    //==================================================

    reg [3:0] state;

    reg [255:0] ip;
    reg [511:0] url;
    reg [255:0] timestamp;

    reg [31:0] method;
    reg [31:0] status;
    reg [31:0] bytes;

    reg [7:0] ip_index;
    reg [7:0] url_index;

    reg [2:0] method_index;
    reg [3:0] status_index;

    reg [7:0] bytes_index;
    reg [7:0] timestamp_index;
    reg timestamp_started;
    reg method_started;
    reg url_started;
    reg protocol_started;
    reg [63:0] protocol;
    reg [3:0] protocol_index;
    
    reg status_started;

    //==================================================
    // Main FSM
    //==================================================

    always @(posedge clk) begin

        if (rst) begin

            state <= IDLE;

            ip <= 0;
            url <= 0;
            timestamp <= 0;
            method <= 0;
            status <= 0;
            bytes <= 0;

            ip_index <= 0;
            url_index <= 0;
            method_index <= 0;
            status_index <= 0;
            bytes_index <= 0;
            timestamp_index <= 0;
            timestamp_started <= 0;
            method_started <= 0;
            url_started <= 0;
            protocol_started <= 0;
            protocol <= 0;
            protocol_index <= 0;
            status_started <= 0;

            valid_record <= 0;

            ip_out <= 0;
            timestamp_out <= 0;
            method_out <= 0;
            url_out <= 0;
            protocol_out <= 0;
            status_out <= 0;
            bytes_out <= 0;

        end

        else begin

            case(state)

            //--------------------------------------------------
            // Wait for beginning of a log line
            //--------------------------------------------------

            IDLE: begin
            
                valid_record <= 0;
            
                ip_index <= 0;
                url_index <= 0;
                method_index <= 0;
                status_index <= 0;
                bytes_index <= 0;
                timestamp_index <= 0;
                timestamp_started <= 0;
                method_started <= 0;
                url_started <= 0;
                protocol_started <= 0;
                protocol_index <= 0;
                status_started <= 0;
            
                if(valid_in) begin
            
                    // Clear previous record
                    ip <= 0;
                    url <= 0;
                    timestamp <= 0;
                    method <= 0;
                    status <= 0;
                    bytes <= 0;
                    protocol <= 0;
            
                    // Store the FIRST character immediately
                    ip[7:0] <= ascii_in;
                    ip_index <= 1;
            
                    // Move to IP parsing
                    state <= READ_IP;
            
                end
            
            end

            //--------------------------------------------------
            // Read IP Address
            //--------------------------------------------------

            READ_IP: begin

                if(valid_in) begin

                    if(ascii_in != 8'h20) begin

                        ip[ip_index*8 +: 8] <= ascii_in;
                        ip_index <= ip_index + 1;

                    end

                    else begin

                        state <= SKIP_IDENT;

                    end

                end

            end

            //--------------------------------------------------

            SKIP_IDENT: begin
            
                if(valid_in) begin
            
                    if(ascii_in == 8'h20) begin
            
                        state <= SKIP_USER;
            
                    end
            
                end
            
            end

            //--------------------------------------------------

            SKIP_USER: begin
            
                if(valid_in) begin
            
                    if(ascii_in == 8'h20) begin
            
                        state <= READ_TIMESTAMP;
            
                    end
            
                end
            
            end

            //--------------------------------------------------

           READ_TIMESTAMP: begin
            
                if(valid_in) begin
            
                    // Ignore the opening '['
                    if(!timestamp_started) begin
            
                        if(ascii_in == "[") begin
            
                            timestamp_started <= 1;
            
                        end
            
                        else begin
            
                            state <= ERROR_STATE;
            
                        end
            
                    end
            
                    // Timestamp finished
                    else if(ascii_in == "]") begin
            
                        state <= READ_METHOD;
            
                    end
            
                    // Store timestamp characters
                    else begin
            
                        timestamp[timestamp_index*8 +: 8] <= ascii_in;
                        timestamp_index <= timestamp_index + 1;
            
                    end
            
                end
            
            end

            //--------------------------------------------------

            READ_METHOD: begin
            
                if(valid_in) begin
            
                    // Ignore opening quote
                    if(!method_started) begin
                    
                        // Ignore spaces between ] and "
                        if(ascii_in == 8'h20) begin
                    
                            // Stay in READ_METHOD
                    
                        end
                    
                        // Opening quote found
                        else if(ascii_in == 8'h22) begin
                    
                            method_started <= 1;
                    
                        end
                    
                        else begin
                    
                            state <= ERROR_STATE;
                    
                        end
                    
                    end
            
                    // Method complete
                    else if(ascii_in == 8'h20) begin
            
                        state <= READ_URL;
            
                    end
            
                    // Store method characters
                    else begin
            
                        method[method_index*8 +: 8] <= ascii_in;
                        method_index <= method_index + 1;
            
                    end
            
                end
            
            end

            //--------------------------------------------------

            READ_URL: begin
            
                if(valid_in) begin
            
                    // Capture the first URL character immediately
                    if(!url_started) begin
            
                        url_started <= 1;
            
                        url[7:0] <= ascii_in;
                        url_index <= 1;
            
                    end
            
                    // URL finished
                    else if(ascii_in == 8'h20) begin
            
                        state <= READ_PROTOCOL;
            
                    end
            
                    // Continue storing URL
                    else begin
            
                        url[url_index*8 +: 8] <= ascii_in;
                        url_index <= url_index + 1;
            
                    end
            
                end
            
            end

            //--------------------------------------------------

            READ_PROTOCOL: begin
            
                if(valid_in) begin
            
                    // Capture the first protocol character
                    if(!protocol_started) begin
            
                        protocol_started <= 1;
            
                        protocol[7:0] <= ascii_in;
                        protocol_index <= 1;
            
                    end
            
                    // End of protocol (closing quote)
                    else if(ascii_in == 8'h22) begin
            
                        state <= READ_STATUS;
            
                    end
            
                    // Continue storing protocol
                    else begin
            
                        protocol[protocol_index*8 +: 8] <= ascii_in;
                        protocol_index <= protocol_index + 1;
            
                    end
            
                end
            
            end
            //--------------------------------------------------

            READ_STATUS: begin
            
                if(valid_in) begin
            
                    if(!status_started) begin
            
                        if(ascii_in == 8'h20) begin
            
                        end
            
                        else begin
            
                            status_started <= 1;
            
                            status[7:0] <= ascii_in;
                            status_index <= 1;
            
                        end
            
                    end
            
                    else if(ascii_in == 8'h20) begin
            
                        state <= READ_BYTES;
            
                    end
            
                    else begin
            
                        status[status_index*8 +: 8] <= ascii_in;
                        status_index <= status_index + 1;
            
                    end
            
                end
            
            end

            //--------------------------------------------------

            READ_BYTES: begin
            
                if(valid_in) begin
            
                    if(ascii_in == 8'h0A || ascii_in == 8'h0D) begin
            
                        state <= DONE;
            
                    end
            
                    else begin
            
                        bytes[bytes_index*8 +: 8] <= ascii_in;
                        bytes_index <= bytes_index + 1;
            
                    end
            
                end
            
            end

            //--------------------------------------------------

            DONE: begin
            
                valid_record <= 1;
                ip_out <= ip;
                timestamp_out <= timestamp;
                method_out <= method;
                url_out <= url;
                protocol_out <= protocol;
                status_out <= status;
                bytes_out <= bytes;
            
                if(ready) begin
            
                    valid_record <= 0;
                    state <= IDLE;
            
                end
            
            end

            //--------------------------------------------------

            ERROR_STATE: begin

                state <= IDLE;

            end

            //--------------------------------------------------

            default: begin

                state <= ERROR_STATE;

            end

            endcase

        end

    end

endmodule
