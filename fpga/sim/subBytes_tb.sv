//Luke Summers lsummers@g.hmc.edu
//module for testing subBytes module

module subBytes_tb();
    logic clk;
    logic [127:0] state, newS, newExpec;

    subBytes dut(clk, state, newS);

    always begin
        clk = 0; #5;
        clk = 1; #5;
    end

    initial begin
        state <= 128'h193de3bea0f4e22b9ac68d2ae9f84808;
        newExpec <= 128'hd42711aee0bf98f1b8b45de51e415230;
        #20;
        if (newS == newExpec) $display("Testbench succesfull");
        else $display("Error: newS = %h, expected %h", newS, newExpec);
    end
endmodule