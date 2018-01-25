module SOFT(
    input [11:0] code_address,
    output reg [15:0] instruction
    );
always @(code_address)
    begin
        case(code_address)
            12'b000000000000: instruction <= 16'b1101001000000100;
            12'b000000000001: instruction <= 16'b0010001000000011;
            12'b000000000010: instruction <= 16'b1100001000000000;
            12'b000000000011: instruction <= 16'b1111001011111111;
            12'b000000000100: instruction <= 16'b1010000000000011;
        endcase
    end
endmodule
