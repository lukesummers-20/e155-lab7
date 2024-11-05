

module keyExpansion_tb();
    logic clk;
    logic [127:0] key;
    logic [43:0][31:0] w;
    logic [43:0][31:0] wExpec;

    keyExpansion dut(clk, key, w);

    initial begin
        key <= 128'h2b7e151628aed2a6abf7158809cf4f3c;
        wExpec[0] <= 32'h2b7e1516;
        wExpec[1] <= 32'h28aed2a6;
        wExpec[2] <= 32'habf71588;
        wExpec[3] <= 32'h09cf4f3c;
        wExpec[4] <= 32'ha0fafe17;
        wExpec[5] <= 32'h88542cb1;
        wExpec[6] <= 32'h23a33939;
        wExpec[7] <= 32'h2a6c7605;
        wExpec[8] <= 32'hf2c295f2;
        wExpec[9] <= 32'h7a96b943;
        wExpec[10] <= 32'h5935807a;
        wExpec[11] <= 32'h7359f67f;
        wExpec[12] <= 32'h3d80477d;
        wExpec[13] <= 32'h4716fe3e;
        wExpec[14] <= 32'h1e237e44;
        wExpec[15] <= 32'h6d7a883b;
        wExpec[16] <= 32'hef44a541;
        wExpec[17] <= 32'ha8525b7f;
        wExpec[18] <= 32'hb671253b;
        wExpec[19] <= 32'hdb0bad00;
        wExpec[20] <= 32'hd4d1c6f8;
        wExpec[21] <= 32'h7c839d87;
        wExpec[22] <= 32'hcaf2b8bc;
        wExpec[23] <= 32'h11f915bc;
        wExpec[24] <= 32'h6d88a37a;
        wExpec[25] <= 32'h110b3efd;
        wExpec[26] <= 32'hdbf98641;
        wExpec[27] <= 32'hca0093fd;
        wExpec[28] <= 32'h4e54f70e;
        wExpec[29] <= 32'h5f5fc9f3;
        wExpec[30] <= 32'h84a64fb2;
        wExpec[31] <= 32'h4ea6dc4f;
        wExpec[32] <= 32'head27321;
        wExpec[33] <= 32'hb58dbad2;
        wExpec[34] <= 32'h312bf560;
        wExpec[35] <= 32'h7f8d292f;
        wExpec[36] <= 32'hac7766f3;
        wExpec[37] <= 32'h19fadc21;
        wExpec[38] <= 32'h28d12941;
        wExpec[39] <= 32'h575c006e;
        wExpec[40] <= 32'hd014f9a8;
        wExpec[41] <= 32'hc9ee2589;
        wExpec[42] <= 32'he13f0cc8;
        wExpec[43] <= 32'hb6630ca6;
        #100;
        if (w == wExpec) $display("Testbench succesfull");
        else $display("Error: w = %h, expected %h", w, wExpec);
    end

    always begin
        clk = 0; #5;
        clk = 1; #5;
    end

endmodule