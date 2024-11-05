/////////////
// addroundkey
/////////////
module addRoundKey(
    input  logic [127:0] state,
    input  logic [3:0][31:0] w,
    output logic [127:0] newState
);
//        [127:120] [95:88] [63:56] [31:24]     S0,0    S0,1    S0,2    S0,3
//        [119:112] [87:80] [55:48] [23:16]     S1,0    S1,1    S1,2    S1,3
//        [111:104] [79:72] [47:40] [15:8]      S2,0    S2,1    S2,2    S2,3
//        [103:96]  [71:64] [39:32] [7:0]       S3,0    S3,1    S3,2    S3,3
  assign newState[127:96] = state[127:96] ^ w[0];//[127:96];
  assign newState[95:64] = state[95:64] ^ w[1];//[95:64];
  assign newState[63:32] = state[63:32] ^ w[2];//[63:32];
  assign newState[31:0] = state[31:0] ^ w[3];//[31:0];

endmodule