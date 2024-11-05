/////////////////////////////////////////
// shift rows function
// 0 cycles
/////////////////////////////////////////

module shiftRows(
    input  logic [127:0] state,
    output logic [127:0] newState
);
  //        [127:120] [95:88] [63:56] [31:24]     S0,0    S0,1    S0,2    S0,3
  //        [119:112] [87:80] [55:48] [23:16]     S1,0    S1,1    S1,2    S1,3
  //        [111:104] [79:72] [47:40] [15:8]      S2,0    S2,1    S2,2    S2,3
  //        [103:96]  [71:64] [39:32] [7:0]       S3,0    S3,1    S3,2    S3,3  
  
  //s'00 = s00
  assign newState[127:120] = state[127:120];
  //s'01 = s01
  assign newState[95:88] = state[95:88];
  //s'02 = s02
  assign newState[63:56] = state[63:56];
  //s'03 = s03
  assign newState[31:24] = state[31:24];

  //s'10 = s11
  assign newState[119:112] = state[87:80];
  //s'11 = s12
  assign newState[87:80] = state[55:48];
  //s'12 = s13
  assign newState[55:48] = state[23:16];
  //s'13 = s10
  assign newState[23:16] = state[119:112];

  //s'20 = s22
  assign newState[111:104] = state[47:40];
  //s'21 = s23
  assign newState[79:72] = state[15:8];
  //s'22 = s20
  assign newState[47:40] = state[111:104];
  //s'23 = s21
  assign newState[15:8] = state[79:72];

  //s'30 = s33
  assign newState[103:96] = state[7:0];
  //s'31 = s30
  assign newState[71:64] = state[103:96];
  //s'32 = s31
  assign newState[39:32] = state[71:64];
  //s'33 = s32
  assign newState[7:0] = state[39:32];

endmodule