module REG(
    input clk,
    input [3:0] addr,
    input [7:0] data_in,
    input write,
    output reg [7:0] data_out
    );
    
reg [7:0] memory [0:2];

initial
    begin
        memory[0] = 0;
        memory[1] = 0;
        memory[2] = 0;
    end

always @(posedge clk)
    begin
        if(write)
            begin
                $display("wrote in register %b value: %b", addr, data_in);
                memory[addr] <= data_in;
            end
        data_out <= memory[addr];
        $display("registry outputs %b for address %b",memory[addr],addr);
    end
endmodule
