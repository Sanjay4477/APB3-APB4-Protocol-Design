module top;
    
   abp_if vif();
 
   
   apb_s dut (
   vif.pclk,
   vif.presetn,
   vif.paddr,
   vif.psel,
   vif.penable,
   vif.pwdata,
   vif.pwrite,
   vif.prdata,
   vif.pready,
   vif.pslverr
   );
   
    initial begin
      vif.pclk <= 0;
    end
    
    always #10 vif.pclk <= ~vif.pclk;
    
    environment env;
    
    
    
    initial begin
      env = new(vif);
      env.gen.count = 20;
      env.run();
    end
      
    
    initial begin
      $dumpfile("dump.vcd");
      $dumpvars;
    end
   
    
  endmodule
