module CPU(
    input clk,
    input rst,
    input [7:0] switch,
    input [4:0] buttons,
    output reg [7:0] leds
    );
    ALU arithmetic (clk,
                    registry_read,
                    word,
                    operation,
                    do_operation,
                    alu_out);
    CU control_unit (clk,
                     rst,
                     instruction,
                     alu_out,
                     registry_addr,
                     ,
                     operation,
                     do_operation,
                     word,
                     ,
                     jump_code_addr,
                     must_jump,
                     ,
                     ,
                     memory_write_enable,
                     ,
                     registry_write_enable);
    REG registry (clk,
                  registry_addr,
                  registry_write,
                  registry_write_enable,
                  registry_read);
    RAM memory (clk,
                memory_addr,
                memory_write,
                memory_write_enable,
                memory_read,
                leds_reg);
    SOFT software (code_addr,instruction);
        
    wire [15:0] instruction;
    reg [11:0] code_addr;
    reg [11:0] next_code_addr;
    wire [11:0] jump_code_addr;
    wire must_jump;

    wire [7:0] alu_out;
    wire [3:0] operation;
    wire do_operation;
    
    wire [7:0] word;
    
    wire [7:0] leds_reg;
    reg [7:0] memory_addr;
    reg [7:0] memory_write;
    wire [7:0] memory_read;
    wire memory_write_enable;
    
    wire [3:0] registry_addr;
    reg [7:0] registry_write;
    wire registry_write_enable;
    wire [7:0] registry_read;

    reg [3:0] sync_counter;

    initial
        begin
            code_addr <= 0;
            next_code_addr <= 0;
            sync_counter <= 15;
            memory_write <= 0;
        end
    
    always @(sync_counter)
        begin
            if(sync_counter == 0)
                begin
                    leds <= leds_reg;
                    code_addr <= next_code_addr;
                    if(must_jump)
                        begin
                            next_code_addr <= jump_code_addr;
                        end
                    else
                        begin
                            next_code_addr <= code_addr+1;
                        end
                end
        end
    always @(posedge clk)
        begin
            if(sync_counter == 0)
                begin
                    sync_counter <= 15;
                    $display("++++++++++++++++++++++++++++++++++++++++++++++");
                end
            else
                begin
                    sync_counter <= sync_counter - 1;
                end
            if(!rst)
                begin
                    case(instruction[15:12])
                        4'b1100:registry_write <= word;
                        4'b1101:registry_write <= word;
                        4'b1110:
                            begin
                                registry_write <= memory_read;
                                memory_addr <= word;
                            end
                        4'b1111:
                            begin
                                memory_write <= registry_read;
                                memory_addr <= word;
                            end
                    endcase
                    $display("instruction: %b", instruction);
                    $display("code address: %b", code_addr);
                end
        end
endmodule
