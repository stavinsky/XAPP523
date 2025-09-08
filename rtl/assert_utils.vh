
`define ASSERT_EQ(actual, expected, message) \
  if ((actual) !== (expected)) begin \
    $display("ASSERT FAILED: %s | Expected: %h, Got: %h at time %0t", \
             message, expected, actual, $time); \
    $fatal; \
  end else begin \
    $display("ASSERT PASSED: %s | Value: %h at time %0t", \
             message, actual, $time); \
  end


