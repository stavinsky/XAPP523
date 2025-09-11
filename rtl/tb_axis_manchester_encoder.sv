`timescale 1ns / 1ps

module tb_axis_manchester_encoder;

  // Clock / reset
  reg        aclk = 1'b0;
  reg        aresetn = 1'b0;

  // S_AXIS
  reg  [7:0] s_axis_tdata = 8'h00;
  reg        s_axis_tvalid = 1'b0;
  wire       s_axis_tready;

  // M_AXIS
  wire [7:0] m_axis_tdata;
  wire       m_axis_tvalid;
  reg        m_axis_tready = 1'b0;

  // DUT (rename if your module differs)
  axis_manchester_encoder dut (
      .aclk         (aclk),
      .aresetn      (aresetn),
      .s_axis_tdata (s_axis_tdata),
      .s_axis_tvalid(s_axis_tvalid),
      .s_axis_tready(s_axis_tready),
      .m_axis_tdata (m_axis_tdata),
      .m_axis_tvalid(m_axis_tvalid),
      .m_axis_tready(m_axis_tready)
  );

  // 100 MHz clock
  always #5 aclk = ~aclk;

  // Wave dump (optional)
  initial begin
    $dumpfile("tb_axis_manchester_encoder.vcd");
    $dumpvars(0, tb_axis_manchester_encoder);
  end

  // Reset
  initial begin

  end

  // Timeout
  integer t;
  initial begin : timeout
    for (t = 0; t < 20000; t = t + 1) @(posedge aclk);
    $display("TIMEOUT: Simulation did not complete in time.");
    $stop;
  end


  initial begin
    aresetn       = 1'b0;
    m_axis_tready = 1'b0;
    repeat (10) @(posedge aclk);
    aresetn = 1'b1;
    @(posedge aclk);

    s_axis_tdata  = 8'h0F;
    s_axis_tvalid = 1;
    @(posedge aclk);
    m_axis_tready = 1;

    repeat (10) @(posedge aclk);



    $finish();



  end

endmodule
