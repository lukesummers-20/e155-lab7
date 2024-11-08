//Luke Summers lsummers@g.hmc.edu
//module for subBytes portion of AES algorithm

//////////////////////////////////
// sub bytes
//////////////////////////////////
module subBytes(
  input logic clk,
  input  logic [127:0] state,
  output logic [127:0] newState
);
  //s'00
  sbox_sync s00(state[127:120], clk, newState[127:120]);
  //s'01
  sbox_sync s01(state[95:88], clk, newState[95:88]);
  //s'02
  sbox_sync s02(state[63:56], clk, newState[63:56]);
  //s'03
  sbox_sync s03(state[31:24], clk, newState[31:24]);

  //s'10
  sbox_sync s10(state[119:112], clk, newState[119:112]);
  //s'11
  sbox_sync s11(state[87:80], clk, newState[87:80]);
  //s'12
  sbox_sync s12(state[55:48], clk, newState[55:48]);
  //s'13
  sbox_sync s13(state[23:16], clk, newState[23:16]);

  //s'20
  sbox_sync s20(state[111:104], clk, newState[111:104]);
  //s'21
  sbox_sync s21(state[79:72], clk, newState[79:72]);
  //s'22
  sbox_sync s22(state[47:40], clk, newState[47:40]);
  //s'23
  sbox_sync s23(state[15:8], clk, newState[15:8]);

  //s'30
  sbox_sync s30(state[103:96], clk, newState[103:96]);
  //s'31
  sbox_sync s31(state[71:64], clk, newState[71:64]);
  //s'32
  sbox_sync s32(state[39:32], clk, newState[39:32]);
  //s'33
  sbox_sync s33(state[7:0], clk, newState[7:0]);

endmodule