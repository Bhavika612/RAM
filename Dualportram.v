module dualportram #(
  parameter ADDR_WIDTH = 4,
  parameter DATA_WIDTH = 8
)(
  input wire                     i_clk,
  input wire                     i_rst,
  input wire                     i_valid,
  input wire                     i_wr_en,
  input wire                     i_rd_en,
  input wire                     CS,   //chip select
  input wire [ADDR_WIDTH-1:0]    i_wraddr,
  input wire [ADDR_WIDTH-1:0]    i_raddr,
  input wire [DATA_WIDTH-1:0]    i_wdata,
  output reg [DATA_WIDTH-1:0]    o_rdata,
  output reg                     o_ready
);

  // Memory declaration
  reg [DATA_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1];

  always @(posedge i_clk or negedge i_rst) begin
    if (!i_rst) begin
      o_rdata <= 0;
      o_ready <= 0;
    end else begin
      if (i_valid && CS) begin
        o_ready <= 1;
        if (i_wr_en)
          mem[i_wraddr] <= i_wdata;
        if (i_rd_en)
          o_rdata <= mem[i_raddr];
      end else begin
        o_ready <= 0;
      end
    end
  end

endmodule
