module dualportramtb;

  // Parameters
  parameter ADDR_WIDTH = 4;
  parameter DATA_WIDTH = 8;
  parameter MEM_DEPTH = 1 << ADDR_WIDTH;

  // Inputs
  reg i_clk, i_rst, i_valid, i_wr_en, i_rd_en, CS;
  reg [ADDR_WIDTH-1:0] i_wraddr, i_raddr;
  reg [DATA_WIDTH-1:0] i_wdata;

  // Outputs
  wire [DATA_WIDTH-1:0] o_rdata;
  wire o_ready;

  // Instantiate DUT
  dualportram #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
  ) uut (
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_valid(i_valid),
    .i_wr_en(i_wr_en),
    .i_rd_en(i_rd_en),
    .CS(CS),
    .i_wraddr(i_wraddr),
    .i_raddr(i_raddr),
    .i_wdata(i_wdata),
    .o_rdata(o_rdata),
    .o_ready(o_ready)
  );

  // Clock generation
  initial i_clk = 0;
  always #5 i_clk = ~i_clk;

  // ----------------------- TASKS -----------------------

  task reset_dut;
    begin
      i_rst = 0;
      i_valid = 0; i_wr_en = 0; i_rd_en = 0; CS = 0;
      i_wraddr = 0; i_raddr = 0; i_wdata = 0;
      #10;
      i_rst = 1;
      #10;
    end
  endtask

  task write_to_addr(input [ADDR_WIDTH-1:0] addr, input [DATA_WIDTH-1:0] data);
    begin
      i_valid = 1; CS = 1;
      i_wr_en = 1; i_rd_en = 0;
      i_wraddr = addr;
      i_wdata = data;
      #10;
    end
  endtask

  task read_from_addr(input [ADDR_WIDTH-1:0] addr);
    begin
      i_valid = 1; CS = 1;
      i_wr_en = 0; i_rd_en = 1;
      i_raddr = addr;
      #10;
    end
  endtask

  // ----------------------- MAIN -----------------------

  initial begin
    $dumpfile("dualportram.vcd");
    $dumpvars(0, dualportramtb);

    // TEST 1: Reset
    $display("TEST 1: Reset DUT");
    reset_dut();   

    // TEST 2: Write and Read Same Address
    $display("TEST 2: Write 0xA5 to address 4, then read it");
    write_to_addr(4'd4, 8'hA5);
    read_from_addr(4'd4);
   

    // TEST 3: Simultaneous Write and Read (diff address)
    $display("TEST 3: Write 0x3C to addr 5 and read from addr 4 simultaneously");
    i_valid = 1; CS = 1;
    i_wr_en = 1; i_rd_en = 1;
    i_wraddr = 4'd5; i_wdata = 8'h3C;
    i_raddr = 4'd4; // Should still return A5
    

    // TEST 4: Write with i_valid = 0 (should not write)
    $display("TEST 4: Attempt write to addr 6 with i_valid = 0");
    i_valid = 0; CS = 1; i_wr_en = 1;
    i_wraddr = 4'd6; i_wdata = 8'hFF;
    #10;

    // Now read from addr 6 to see if data changed (should be 0)
    read_from_addr(4'd6);

    $finish;
  end

endmodule
