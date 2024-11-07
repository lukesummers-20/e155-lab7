//////////
// rotword
// 0 cycle
/////////
module rotWord(
  input  logic [31:0] word,
  output logic [31:0] rot
);
  assign rot[31:24] = word[23:16];
  assign rot[23:16] = word[15:8];
  assign rot[15:8] = word[7:0];
  assign rot[7:0] = word[31:24];

endmodule

/////////
// subword
// one cycle
/////////
module subWord(
    input  logic clk,
    input  logic [31:0] word,
    output logic [31:0] sub
);
  sbox_sync b0(word[31:24], clk, sub[31:24]);
  sbox_sync b1(word[23:16], clk, sub[23:16]);
  sbox_sync b2(word[15:8], clk, sub[15:8]);
  sbox_sync b3(word[7:0], clk, sub[7:0]);

endmodule

module nextRoundKey(
    input  logic clk,
    input  logic [3:0][31:0] oldW,
    input  logic [31:0] rCon,
    output logic [3:0][31:0] w
);
  logic[31:0] wRot, wSub, wHold;
  rotWord r(oldW[0], wRot);
  subWord s(clk, wRot, wSub);
  assign w[3] = (wSub ^ rCon) ^ oldW[3];
  assign w[2] = w[3] ^ oldW[2];
  assign w[1] = w[2] ^ oldW[1];
  assign w[0] = w[1] ^ oldW[0];

endmodule
