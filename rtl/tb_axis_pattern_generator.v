`timescale 1ns / 1ps

module tb_axis_pattern_generator;

  // Clock / reset
  reg        aclk = 1'b0;
  reg        aresetn = 1'b0;

  // AXIS
  wire [7:0] m_axis_tdata;
  wire       m_axis_tvalid;
  reg        m_axis_tready = 1'b0;

  axis_pattern_generator #() dut (
      .aclk         (aclk),
      .aresetn      (aresetn),
      .m_axis_tdata (m_axis_tdata),
      .m_axis_tvalid(m_axis_tvalid),
      .m_axis_tready(m_axis_tready)
  );

  // 100 MHz clock
  always #5 aclk = ~aclk;

  localparam integer N = 9;
  reg [7:0] expected[0:N-1];
  initial begin
    expected[0] = 8'hAA;
    expected[1] = 8'hAA;
    expected[2] = 8'hD5;
    expected[3] = 8'hAA;
    expected[4] = 8'hBB;
    expected[5] = 8'hCC;
    expected[6] = 8'hDD;
    expected[7] = 8'hEE;
    expected[8] = 8'hFF;
  end

  integer exp_idx;
  integer beats_seen;
  localparam integer FRAMES_TO_CHECK = 4;
  integer TOTAL_BEATS;

  wire fire = m_axis_tvalid & m_axis_tready;

  initial begin
    TOTAL_BEATS = FRAMES_TO_CHECK * N;
    $dumpfile("tb_axis_pattern_generator.vcd");
    $dumpvars(0, tb_axis_pattern_generator);

    aresetn = 1'b0;
    repeat (10) @(posedge aclk);
    aresetn = 1'b1;
  end

  integer cyc;
  always @(posedge aclk) begin
    if (!aresetn) begin
      cyc           <= 0;
      m_axis_tready <= 1'b0;
    end else begin
      cyc <= cyc + 1;
      if ((cyc % 7) != 0) m_axis_tready <= 1'b1;
      else m_axis_tready <= 1'b0;
    end
  end

  reg failed;
  initial failed = 1'b0;

  always @(posedge aclk) begin
    if (!aresetn) begin
      exp_idx    <= 0;
      beats_seen <= 0;
    end else if (fire) begin
      $display("%0t ns  DATA=0x%02h  (exp 0x%02h)  idx=%0d", $time, m_axis_tdata,
               expected[exp_idx], exp_idx);

      if (m_axis_tdata !== expected[exp_idx]) begin
        $display("ERROR: Mismatch at beat %0d: got 0x%02h expected 0x%02h", beats_seen,
                 m_axis_tdata, expected[exp_idx]);
        failed <= 1'b1;
        $stop;
      end

      if (exp_idx == N - 1) exp_idx <= 0;
      else exp_idx <= exp_idx + 1;

      beats_seen <= beats_seen + 1;

      if (beats_seen + 1 == TOTAL_BEATS) begin
        if (!failed)
          $display(
              "PASS: Saw %0d frames (%0d bytes) matching the expected pattern.",
              FRAMES_TO_CHECK,
              TOTAL_BEATS
          );
        $finish;
      end
    end
  end

  integer i;
  initial begin
    for (i = 0; i < 5000; i = i + 1) begin
      @(posedge aclk);
    end
    $display("TIMEOUT: Simulation did not complete in time.");
    $stop;
  end

endmodule
