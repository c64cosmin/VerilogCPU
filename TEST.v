module TEST;

reg clk;
initial
begin
    $dumpfile("TEST.vcd");
    $dumpvars(0, TEST);
clk=0;
end
always #100
    begin
        clk = !clk;
    end
always @(posedge clk)
    begin
        $display("-----------------------------------------------");
    end
CPU cpu (clk, 0,,,);
endmodule
