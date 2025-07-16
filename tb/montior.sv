class monitor;
 
   virtual abp_if vif;
   mailbox #(transaction) mbx;
   transaction tr;
 
  
 
 
    function new(mailbox #(transaction) mbx);
      this.mbx = mbx;     
   endfunction;
  
  task run();
    tr = new();
    forever begin
              @(posedge vif.pclk);
              if(vif.pready)
              begin
              tr.pwdata  = vif.pwdata;
              tr.paddr   = vif.paddr;
            tr.pwrite  = vif.pwrite;
            tr.prdata  = vif.prdata;
            tr.pslverr = vif.pslverr;
            @(posedge vif.pclk);
              tr.display("MON");
              mbx.put(tr);
              end
              end
   endtask
 
 
  
endclass
