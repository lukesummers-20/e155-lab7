//Luke Summers lsummers@g.hmc.edu
//module for addRoundKey portion of AES algorithm

/////////////
// addroundkey
/////////////
module addRoundKey(
    input  logic [127:0] state,
    input  logic [3:0][31:0] w,
    output logic [127:0] newState
);

  assign newState[127:96] = state[127:96] ^ w[3];
  assign newState[95:64] = state[95:64] ^ w[2];
  assign newState[63:32] = state[63:32] ^ w[1];
  assign newState[31:0] = state[31:0] ^ w[0];

endmodule