`timescale 1ns/1ns


module test # (parameter ADDR_WIDTH=32,parameter DATA_WIDTH=32);
  
  logic PCLK,PRESETn,transfer,WRITE_READ;
  logic [ADDR_WIDTH:0] apb_addr;
  logic [DATA_WIDTH-1:0] apb_wdata;
  logic [DATA_WIDTH-1:0] apb_rdata;
  logic PSLVERR;
  logic [DATA_WIDTH-1:0] data,expected;
  
  logic [DATA_WIDTH-1:0] mem[0:15];
  
  apb_top dut(
    PCLK,
    PRESETn,
    transfer,
    WRITE_READ,
    apb_addr,
    apb_wdata,
    PSLVERR,
    apb_rdata
  );
  
  int i,j;
  
  initial begin
    
    PCLK=0;
    PRESETn=1;
    
  end
  
  always #5 PCLK=~PCLK;
  
  initial begin
    
    PRESETn=0;
    transfer=1;
    WRITE_READ=1;
    
    @(posedge PCLK) PRESETn=1;
    
    
    repeat(2) @ (posedge PCLK);
    @ (negedge PCLK) write;
    
    @ (posedge PCLK);
    apb_addr=9'd500;
    apb_wdata=9'd9;
    
    repeat(2) @(posedge PCLK);    apb_addr = 9'd22; apb_wdata = 9'd35;
    
    repeat(2) @(posedge PCLK);
    @(posedge PCLK)     WRITE_READ =0; PRESETn<=0;
               @(posedge PCLK)     PRESETn = 1;
    
     repeat(3) @(posedge PCLK)     transfer = 1;  
    
    repeat(2) @ (posedge PCLK) read;
    
    repeat(3) @ (posedge PCLK);
    apb_addr=9'd22;
    
    repeat(4) @ (posedge PCLK);
    
    $finish;
    
  end
    
  
  task write();
    begin
      
      transfer=1;
      for (i=0;i<8;i++)
        begin
          
          data=i;
          apb_wdata=2*i;
          apb_addr={1'b0,data};
          
        end
      
    end
  endtask
  
  task read();
    begin
      
      for (i=0;i<8;i++)
        repeat(2) @ (negedge PCLK)
          begin
            
            data=i;
            apb_addr={1'b0,data};
            
          end
      
    end
  endtask
  
  initial begin
    
    $dumpfile("dump.vcd");
    $dumpvars;
    
  end
  
  
  
endmodule
