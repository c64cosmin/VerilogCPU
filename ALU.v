module ALU(
    input clk,
    input [7:0] a,
    input [7:0] b,
    input [3:0] operation,
    input do_operation,
    output reg [7:0] result
    );
initial
    begin
    end
always @(posedge clk)
    begin
        if(do_operation)
            begin
            case(operation)
                4'b0000:result <= a+b;
                4'b0001:result <= a-b;
                4'b0010:result <= a*b;
                4'b0011:result <= a/b;
                4'b0100:result <= (a==b?1:0);
                4'b0101:result <= (a>b?1:0);
                4'b0110:result <= a&b;
                4'b0111:result <= a|b;
                4'b1000:result <= a^b;
                4'b1001:result <= ~a;
                default:result <= 0;
            endcase
        end
    end
endmodule
