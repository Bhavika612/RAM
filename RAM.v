module ram_16x8 (
    input clk,
    input rstn,                        
    input we, 
    input re,
    input [3:0] addr,                   // Address input
    input [7:0] data_in,                // Data input
    output reg [7:0] data_out           // Data output
);
    reg [7:0] mem [15:0];               // 16 x 8-bit RAM

    integer i;
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            data_out <= 0;
            for (i = 0; i < 16; i = i + 1)
                mem[i] <= 0;
        end else begin
            if (we)
                mem[addr] <= data_in;
          if(re)
              data_out <= mem[addr];
        end
    end
endmodule


