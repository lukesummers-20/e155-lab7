//Luke Summers lsummers@g.hmc.edu
//module for testing key expansion module

module nextRoundKey_tb();
    logic clk;
    logic [31:0] rCon;
    logic [3:0][31:0] oldW, w, w_expected;

    nextRoundKey dut(clk, oldW, rCon, w);

    always begin
        clk = 1; #5;
        clk = 0; #5;
    end

    initial begin
        oldW[3] = 32'h2b7e1516;
        oldW[2] = 32'h28aed2a6;
        oldW[1] = 32'habf71588;
        oldW[0] = 32'h09cf4f3c;
        rCon = 32'h01000000;
        w_expected[3] = 32'ha0fafe17;
        w_expected[2] = 32'h88542cb1;
        w_expected[1] = 32'h23a33939;
        w_expected[0] = 32'h2a6c7605;
        #20;
        if (w == w_expected) $display("Testbench succesfull");
        else $display("Error: newS = %h, expected %h", w, w_expected);
    end

endmodule