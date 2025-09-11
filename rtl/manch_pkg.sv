package manch_pkg;
  function automatic [7:0] encode(input reg [3:0] in);
    begin
      encode[7] = ~in[3];
      encode[6] = in[3];
      encode[5] = ~in[2];
      encode[4] = in[2];
      encode[3] = ~in[1];
      encode[2] = in[1];
      encode[1] = ~in[0];
      encode[0] = in[0];
    end
  endfunction
endpackage
