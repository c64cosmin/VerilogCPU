module CU(
    input clk,
    input rst,
    input [15:0] instruction,
    input [7:0] alu_result,
    output reg [3:0] reg_a,
    output reg [3:0] reg_b,
    output reg [3:0] operation,
    output reg do_operation,
    output reg [7:0] word,
    output reg [1:0] screen,
    output reg [11:0] jump_addr,
    output reg must_jump,
    output reg [8:0] video_addr,
    output reg flag,
    output reg write_ram,
    output reg read_ram,
    output reg load_value
    );
initial
    begin
        reg_a <= 0;
        reg_b <= 0;
        operation <= 0;
        do_operation <= 0;
        word <= 0;
        screen <= 0;
        jump_addr <= 0;
        must_jump <= 0;
        video_addr <= 0;
        flag <= 0;
        write_ram <= 0;
        read_ram <= 0;
        load_value <= 0;
    end
always @(rst)
    begin
        if(rst)
            begin
               reg_a <= 0;
               reg_b <= 0;
               operation <= 0;
               do_operation <= 0;
               word <= 0;
               screen <= 0;
               jump_addr <= 0;
               must_jump <= 0;
               video_addr <= 0;
               flag <= 0;
               write_ram <= 0;
               read_ram <= 0;
               load_value <= 0;
            end
    end

always @(posedge clk)
    begin
        if(!rst)
            begin
                $display("CU evaluates %b", instruction[15:12]);
                case(instruction[15:12])
                4'b0000,
                4'b0001,
                4'b0010,
                4'b0011,
                4'b0100,
                4'b0101,
                4'b0110,
                4'b0111,
                4'b1000,
                4'b1001://ADD SUB MUL DIV CMPE CMPG AND OR XOR NOT xxxxREG_VALUE___
                    begin
                        reg_a <= instruction[11:8];
                        reg_b <= 0;
                        word <= instruction[7:0];
                        write_ram <= 0;
                        read_ram <= 0;
                        load_value <= 0;
                        flag <= 0;
                        screen <= 0;
                        video_addr <= 0;
                        must_jump <= 0;
                        operation <= instruction[15:12];
                        do_operation <= 1;
                        $display("Arithmetic for registry %b, value: %b", instruction[11:8], instruction[7:0]);
                    end
                4'b1010://JMP xxxxADDR________
                    begin
                        reg_a <= 0;
                        reg_b <= 0;
                        word <= 0;
                        write_ram <= 0;
                        read_ram <= 0;
                        load_value <= 0;
                        jump_addr <= instruction[11:0];
                        must_jump <= 1;
                        operation <= 0;
                        do_operation <= 0;
                        $display("JMP address %b", instruction[11:0]);
                    end
                4'b1011://DRW xxxxREGWDATA____
                    begin
                        reg_a <= instruction[11:9];
                        reg_b <= 0;
                        word <= instruction[7:0];
                        write_ram <= 0;
                        read_ram <= 0;
                        load_value <= 1;
                        flag <= instruction[8];
                        must_jump <= 0;
                        operation <= 0;
                        do_operation <= 0;
                    end
                4'b1100://MOV xxxxREG_________ ALU copy
                    begin
                        reg_a <= instruction[11:8];
                        reg_b <= 0;
                        word <= alu_result;
                        write_ram <= 0;
                        read_ram <= 0;
                        load_value <= 1;
                        flag <= 0;
                        screen <= 0;
                        video_addr <= 0;
                        must_jump <= 0;
                        operation <= 0;
                        do_operation <= 0;
                    end
                4'b1101://MOV xxxxREG_VALUE___
                    begin
                        reg_a <= instruction[11:8];
                        reg_b <= 0;
                        word <= instruction[7:0];
                        write_ram <= 0;
                        read_ram <= 0;
                        load_value <= 1;
                        flag <= 0;
                        screen <= 0;
                        video_addr <= 0;
                        must_jump <= 0;
                        operation <= 0;
                        do_operation <= 0;
                        $display("MOV value %b into registry %b", instruction[7:0], instruction[11:8]);
                    end
                4'b1110://MOV REG<-RAM xxxxREG_ADDR____
                    begin
                        reg_a <= instruction[11:8];
                        reg_b <= 0;
                        word <= instruction[7:0];
                        write_ram <= 0;
                        read_ram <= 1;
                        load_value <= 1;
                        flag <= 0;
                        screen <= 0;
                        video_addr <= 0;
                        must_jump <= 0;
                        operation <= 0;
                        do_operation <= 0;
                    end
                4'b1111://MOV REG->RAM xxxxREG_ADDR____
                    begin
                        reg_a <= instruction[11:8];
                        reg_b <= 0;
                        word <= instruction[7:0];
                        write_ram <= 1;
                        read_ram <= 0;
                        load_value <= 0;
                        flag <= 0;
                        screen <= 0;
                        video_addr <= 0;
                        must_jump <= 0;
                        operation <= 0;
                        do_operation <= 0;
                    end
                default:
                    begin
                    end
                endcase
            end
    end
endmodule
