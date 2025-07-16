class driver;
  
   virtual abp_if vif;
   mailbox #(transaction) mbx;
   transaction datac;
  
   event nextdrv;
 
   function new(mailbox #(transaction) mbx);
      this.mbx = mbx;
   endfunction; 
  
  
  task reset();
    vif.presetn <= 1'b0;
    vif.psel    <= 1'b0;
    vif.penable <= 1'b0;
    vif.pwdata  <= 0;
    vif.paddr   <= 0;
    vif.pwrite  <= 1'b0;
    repeat(5) @(posedge vif.pclk);
    vif.presetn <= 1'b1;
    $display("[DRV] : RESET DONE");
    $display("----------------------------------------------------------------------------");
  endtask
   
  task run();
    forever begin
      
      mbx.get(datac);
      @(posedge vif.pclk);     
      if(datac.pwrite == 1) ///write
        begin
        vif.psel    <= 1'b1;
        vif.penable <= 1'b0;
          vif.pwdata  <= datac.pwdata;
          vif.paddr   <= datac.paddr;
          vif.pwrite  <= 1'b1;
            @(posedge vif.pclk);
            vif.penable <= 1'b1; 
            @(posedge vif.pclk); 
            vif.psel <= 1'b0;
            vif.penable <= 1'b0;
            vif.pwrite <= 1'b0;
            datac.display("DRV");
            ->nextdrv;          
        end
      else if (datac.pwrite == 0) //read
        begin
            vif.psel <= 1'b1;
        vif.penable <= 1'b0;
          vif.pwdata <= 0;
          vif.paddr <= datac.paddr;
          vif.pwrite <= 1'b0;
            @(posedge vif.pclk);
            vif.penable <= 1'b1; 
            @(posedge vif.pclk); 
            vif.psel <= 1'b0;
            vif.penable <= 1'b0;
            vif.pwrite <= 1'b0;
            datac.display("DRV"); 
            ->nextdrv;
        end
      
    end
  endtask
  
  
endclass
