//Luke Summers lsummers@g.hmc.edu
//top level AES modules for hardware and sim, and AES core module

/////////////////////////////////////////////
// aes
//   Top level module with SPI interface and SPI core
/////////////////////////////////////////////

module aes(
           input  logic sck, 
           input  logic sdi,
           output logic sdo,
           input  logic load,
           output logic done);
                    
    logic [127:0] key, plaintext, cyphertext;
    logic clk;
	HSOSC #(.CLKHF_DIV ("0b01")) hf_osc (.CLKHFEN(1'b1), .CLKHFPU(1'b1), .CLKHF(clk));
    aes_spi spi(sck, sdi, sdo, done, key, plaintext, cyphertext);   
    aes_core core(clk, load, key, plaintext, done, cyphertext);
endmodule

module aes_sim(
           input  logic clk,
           input  logic sck, 
           input  logic sdi,
           output logic sdo,
           input  logic load,
           output logic done);
                    
    logic [127:0] key, plaintext, cyphertext;

    aes_spi spi(sck, sdi, sdo, done, key, plaintext, cyphertext);   
    aes_core core(clk, load, key, plaintext, done, cyphertext);
endmodule

/////////////////////////////////////////////
// aes_core
//   top level AES encryption module
//   when load is asserted, takes the current key and plaintext
//   generates cyphertext and asserts done when complete 11 cycles later
// 
//   See FIPS-197 with Nk = 4, Nb = 4, Nr = 10
//
//   The key and message are 128-bit values packed into an array of 16 bytes as
//   shown below
//        [127:120] [95:88] [63:56] [31:24]     S0,0    S0,1    S0,2    S0,3
//        [119:112] [87:80] [55:48] [23:16]     S1,0    S1,1    S1,2    S1,3
//        [111:104] [79:72] [47:40] [15:8]      S2,0    S2,1    S2,2    S2,3
//        [103:96]  [71:64] [39:32] [7:0]       S3,0    S3,1    S3,2    S3,3
//
//   Equivalently, the values are packed into four words as given
//        [127:96]  [95:64] [63:32] [31:0]      w[0]    w[1]    w[2]    w[3]
/////////////////////////////////////////////

module aes_core(input  logic         clk, 
                input  logic         load,
                input  logic [127:0] key, 
                input  logic [127:0] plaintext, 
                output logic         done, 
                output logic [127:0] cyphertext);

	logic [127:0] bSub, t1, t2, t3, t4, aAdd, hold;
	logic [3:0][31:0] w, wOld, wNew;
	logic [31:0] rCon, rConHold;

	//data path
	subBytes sub(clk, bSub, t1);
	shiftRows shift(t1, t2);
	mixcolumns mix(t2, t3);
	addRoundKey add(t4, w, aAdd);

	//key generation
	nextRoundKey expand(clk, wOld, rCon, wNew);

	logic [3:0] round;
	logic [2:0] cycles;
	always_ff @(posedge clk) begin
		if (load) begin
			round <= 0;
			cycles <= 0;
			done <= 0;
		end else begin
			//pre rounds data processing
			if (round == 0) begin
				if (cycles == 0) begin
					w[3] <= key[127:96];
					w[2] <= key[95:64];
					w[1] <= key[63:32];
					w[0] <= key[31:0];
					wOld[3] <= key[127:96];
					wOld[2] <= key[95:64];
					wOld[1] <= key[63:32];
					wOld[0] <= key[31:0];
					rCon <= rConHold;
				end
				t4 <= plaintext;
				if (cycles == 3) begin
					hold <= aAdd;
				end
			end
			//full datapath for round 1-9
			if ((round > 0) & (round < 10)) begin
				if (cycles == 0) begin
					w <= wNew;
					wOld <= wNew;
					rCon <= rConHold;
				end
				bSub <= hold;
				t4 <= t3;
				if (cycles == 3) begin
					hold <= aAdd;
				end
			end
			//skip mix columns on round 10 and assert done after
			if (round == 10) begin
				if (cycles == 0) begin
					w <= wNew;
				end
				bSub <= hold;
				t4 <= t2;
				if (cycles == 3) begin
					cyphertext <= aAdd;
					done <= 1;
				end
			end
		
			//round and cycle tracker
			if (cycles > 2) begin
				cycles <= 0;
				round <= round + 1;
			end else cycles <= cycles + 1;
		end
	end

	//round constants for key expansion
	always_comb
        	case(round)
            		0: rConHold = 32'h01000000;
            		1: rConHold = 32'h02000000;
            		2: rConHold = 32'h04000000;
            		3: rConHold = 32'h08000000;
            		4: rConHold = 32'h10000000;
            		5: rConHold = 32'h20000000;
            		6: rConHold = 32'h40000000;
            		7: rConHold = 32'h80000000;
            		8: rConHold = 32'h1b000000;
            		9: rConHold = 32'h36000000;
            		default: rConHold = 32'h00000000;
        	endcase

endmodule









