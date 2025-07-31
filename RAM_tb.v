module ram_16x8_tb;

  // Parameters
  parameter ADDR_WIDTH = 4;
  parameter DATA_WIDTH = 8;

  // Inputs
  reg clk, rstn, we, re;
  reg [ADDR_WIDTH-1:0] addr;
  reg [DATA_WIDTH-1:0] data_in;

  // Output
  wire [DATA_WIDTH-1:0] data_out;

  // Instantiate the DUT
  ram_16x8 dut (
    .clk(clk),
    .rstn(rstn),
    .we(we),
    .re(re),
    .addr(addr),
    .data_in(data_in),
    .data_out(data_out)
  );

  // Clock Generation
  initial clk = 0;
  always #5 clk = ~clk;

  // Reset task
  task reset_dut;
   begin
     $display("\n RESET START");
     rstn = 0;
     we = 0; re = 0; addr = 0; data_in = 0;
     @(posedge clk);
     rstn = 1;
     @(posedge clk);
     $display("RESET COMPLETE \n");
   end
  endtask

  // Task: Write to RAM
  task write_to_ram(
      input [ADDR_WIDTH-1:0] waddr, 
      input [DATA_WIDTH-1:0] wdata);
    begin
      @(negedge clk);
      addr = waddr;
      data_in = wdata;
      we = 1;
      re = 0;
      @(negedge clk);
      we = 0;
      $display("[WRITE] Addr = %0d, Data = %h", waddr, wdata);
    end
  endtask

  // Task: Read from RAM
  task read_from_ram(
      input [ADDR_WIDTH-1:0] raddr);
    begin
      @(negedge clk);
      addr = raddr;
      we = 0;
      re = 1;
      @(negedge clk);
      re = 0;
      $display("[READ] Addr = %0d, Data = %h", raddr, data_out);
    end
  endtask

  // Task: Simultaneous Read and Write
  task sim_rd_wr(
      input [ADDR_WIDTH-1:0] rw_addr, 
      input [DATA_WIDTH-1:0] wdata);
    begin
      @(negedge clk);
      addr = rw_addr;
      data_in = wdata;
      we = 1;
      re = 1;
      @(negedge clk);
      we = 0; re = 0;
      $display("[SIMUL R/W] Addr = %0d | Wrote = %h | Read = %h", rw_addr, wdata, data_out);
    end
  endtask

  // Task: Random Writes and Reads
  task random_write_read;
    integer i;
    reg [ADDR_WIDTH-1:0] rand_addr;
    reg [DATA_WIDTH-1:0] rand_data;
    begin
      for (i = 0; i < 5; i = i + 1) begin
        rand_addr = $random % 16;
        rand_data = $random;
        write_to_ram(rand_addr, rand_data);
        read_from_ram(rand_addr);
        $display("[RANDOM TEST] Iteration %0d | Addr = %0d | Expected = %h | Read = %h", i, rand_addr, rand_data, data_out);
      end
    end
  endtask

  // Main test flow
  initial begin
    reset_dut();

    if ($test$plusargs("random_test")) begin
      $display("\n>>> Running RANDOM WRITE & READ test <<<");
      random_write_read();
    end

    if ($test$plusargs("write_data")) begin
      $display("\n>>> Running WRITE test <<<");
      write_to_ram(4'd2, 8'hAA);
    end

    if ($test$plusargs("read_data")) begin
      $display("\n>>> Running READ test <<<");
      read_from_ram(4'd2);
    end

    if ($test$plusargs("simul_rw")) begin
      $display("\n>>> Running SIMULTANEOUS READ/WRITE test <<<");
      sim_rd_wr(4'd5, 8'hFF);
      sim_rd_wr(4'd10, 8'h33);
    end

    $finish;
  end

endmodule

