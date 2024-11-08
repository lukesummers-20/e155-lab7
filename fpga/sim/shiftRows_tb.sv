//Luke Summers lsummers@g.hmc.edu
//module for testing shiftRows module

module shiftRows_tb();
    logic [127:0] state, newS, newExpec;

    shiftRows dut(state, newS);

    initial begin
        state <= 128'hd42711aee0bf98f1b8b45de51e415230;
        newExpec <= 128'hd4bf5d30e0b452aeb84111f11e2798e5;
        #5;
        if (newS == newExpec) $display("Testbench succesfull");
        else $display("Error: newS = %h, expected %h", newS, newExpec);
    end
endmodule