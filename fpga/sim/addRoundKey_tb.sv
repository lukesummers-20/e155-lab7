//Luke Summers lsummers@g.hmc.edu
//module for testing addRoundKey module

module addRoundKey_tb();
    logic [127:0] state, newS, newExpec;
    logic [3:0][31:0] w;

    addRoundKey dut(state, w, newS);

    initial begin
        state <= 128'h3243f6a8885a308d313198a2e0370734;
        w[0] <= 32'h2b7e1516;
        w[1] <= 32'h28aed2a6;
        w[2] <= 32'habf71588;
	w[3] <= 32'h09cf4f3c;
        //w <= 128'h2b7e151628aed2a6abf7158809cf4f3c;
        newExpec <= 128'h193de3bea0f4e22b9ac68d2ae9f84808;
        #5;
        if (newS == newExpec) $display("Testbench succesfull");
        else $display("Error: newS = %h, expected %h", newS, newExpec);
    end

endmodule