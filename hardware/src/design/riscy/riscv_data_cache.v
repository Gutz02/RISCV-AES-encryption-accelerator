
module riscv_data_cache #(
    parameter NR_ENTRIES = 32,
    parameter OFFSET = 2
) (
  input   clk,
  input   rst_n,
  input wire         idata_req_o,
  input wire [31:0]  idata_addr_o,
  input wire         idata_we_o,
  input wire [3:0]   idata_be_o,
  input wire [31:0]  idata_wdata_o,

  output reg          odata_req_o,

  input  wire         idata_gnt_i,
  input  wire         idata_rvalid_i,
  input  wire         idata_err_i,
  input  wire [31:0]  idata_rdata_i,


  output  wire         odata_gnt_i,
  output  wire         odata_rvalid_i,
  output  wire         odata_err_i,
  output  wire [31:0]  odata_rdata_i
);


  assign odata_gnt_i    = idata_gnt_i | gnt_cache; 
  assign odata_rvalid_i = hit_q ? 1'b1       :idata_rvalid_i;
  assign odata_err_i    = hit_q ? 1'b0       :idata_err_i;
  assign odata_rdata_i  = hit_q ? hit_data_q :idata_rdata_i;

  localparam INDEX_SZ = $clog2(NR_ENTRIES);
  initial 
  begin
    $display("Size of index %d including a 0", INDEX_SZ);
  end
  
  wire [INDEX_SZ-1:0] index = idata_addr_o[INDEX_SZ-1+OFFSET:OFFSET];
  wire [31-INDEX_SZ-OFFSET:0] tag = idata_addr_o[31:INDEX_SZ+OFFSET];
  
  reg [31:0] data_d[0:NR_ENTRIES-1], data_q[0:NR_ENTRIES-1];
  reg [31-INDEX_SZ-OFFSET:0] tag_d[0:NR_ENTRIES-1], tag_q[0:NR_ENTRIES-1];
  reg valid_d[0:NR_ENTRIES-1], valid_q[0:NR_ENTRIES-1];
  reg hit_d, hit_q;
  reg [31:0] hit_data_d, hit_data_q;
  reg gnt_cache;
  reg miss;

  integer i;
  always @(*)
  begin
    for (i=0;i<NR_ENTRIES;i=i+1) begin
        data_d[i]  = data_q[i];
        tag_d[i]   = tag_q[i];
        valid_d[i] = valid_q[i];
    end
    hit_d = hit_q;
    hit_data_d = hit_data_q;
    gnt_cache = 1'b0;
    odata_req_o = idata_req_o;
    miss = 1'b0;
 
    if(idata_req_o)
    begin
        hit_d = 1'b0;
        if(idata_we_o)
        begin
            if (idata_be_o[0]) data_d[index][7:0]   = idata_wdata_o[7:0];
            if (idata_be_o[1]) data_d[index][15:8]  = idata_wdata_o[15:8];
            if (idata_be_o[2]) data_d[index][23:16] = idata_wdata_o[23:16];
            if (idata_be_o[3]) data_d[index][31:24] = idata_wdata_o[31:24];
            valid_d[index] = 1'b1;
            tag_d[index] = tag;
        end
        else if(valid_d[index] && tag_d[index] == tag) 
        begin 
            odata_req_o = 1'b0;
            gnt_cache = 1'b1;
            hit_d = 1'b1;
            hit_data_d = data_d[index];
        end
        else
        begin
            miss = 1'b1;
        end
    end
  end

  always @(posedge clk, negedge rst_n)
  begin
    if(rst_n == 1'b0)
    begin
        for (i=0;i<NR_ENTRIES;i=i+1) begin
            valid_q[i] <= 1'b0;
            data_q[i]  <= 0;
            tag_q[i]   <= 0;
        end
        hit_q <= 1'b0;
        hit_data_q <= 0;
    end else
    begin
        for (i=0;i<NR_ENTRIES;i=i+1) begin
            data_q[i]  <= data_d[i];
            tag_q[i]   <= tag_d[i];
            valid_q[i] <= valid_d[i];
        end
        hit_q <= hit_d;
        hit_data_q <= hit_data_d;
    end
  end
endmodule
