module riscv_zkn
#(
    `include "riscv_defines.v"
    parameter NOTHING = 0
)(
    input             clk,
    input  [31:0]     operand_a_i,
    input  [31:0]     operand_b_i,
    input  [1:0]      imm_i,
    input  [K_OP_WIDTH-1:0]     operator_i,
    
    output reg [31:0] result_o
);

    wire [7:0] sub1 = (imm_i == 2'b00) ? operand_b_i[7:0]   :
                        (imm_i == 2'b01) ? operand_b_i[15:8]  :
                        (imm_i == 2'b10) ? operand_b_i[23:16] :
                        (imm_i == 2'b11) ? operand_b_i[31:24] : 8'h00;
    wire [7:0]  sub2;

    sbox just_a_box(.byte_i(sub1), .byte_o(sub2));

    wire [7:0]   blank = (operator_i == K_ESMI) ? sub2 : 8'b0;
    wire [7:0]   gf2 = (operator_i == K_ESMI) ? ((sub2[7]) ? (sub2 << 1 ^ 8'h1b) : sub2 << 1) : sub2;
    wire [7:0]   gf3 = (operator_i == K_ESMI) ? gf2 ^ sub2 : 8'b0;

  always @(*) begin
    case (imm_i)
        2'b00:  result_o = {gf3, blank, blank, gf2} ^ operand_a_i;
        2'b01:  result_o = {blank, blank, gf2, gf3} ^ operand_a_i;
        2'b10:  result_o = {blank, gf2, gf3, blank} ^ operand_a_i;
        2'b11:  result_o = {gf2, gf3, blank, blank} ^ operand_a_i;
        default: result_o = 8'h00;
    endcase
  end


endmodule
