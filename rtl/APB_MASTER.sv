/*

Signals given out by master- PADDR,PWDATA,PSELx,PENABLE,PWRITE,PSLVERR
Signals received by master from slave - PREADY,PRDATA,
Signal given to master by system- PCLK,PRESETn,PPROT,PSTRB,WRITE_READ,apb_addr,apb_wdata,apb_rdata

*/

module master #(parameter ADDR_WIDTH=32,parameter DATA_WIDTH=32)
  (input  logic                   PCLK,
   input  logic                   PRESETn,
   input  logic [2:0]             PPROT,
   input  logic [3:0]             PSTRB,
   input  logic                   PREADY,
   input  logic                   WRITE_READ,
   input  logic                   transfer,
   input  logic [ADDR_WIDTH:0]    apb_addr,
   input  logic [DATA_WIDTH-1:0]  apb_wdata,
   input  logic [DATA_WIDTH-1:0]  PRDATA,
   output logic [ADDR_WIDTH:0]    PADDR,
   output logic [DATA_WIDTH-1:0]  PWDATA,
   output logic                   PSELx,
   output logic                   PENABLE,
   output logic                   PWRITE,
   output logic [DATA_WIDTH-1:0]  apb_rdata,
   output logic                   PSLVERR
  );
  
  
  //Different states of master during communication
  localparam IDLE=2'b00;
  localparam SETUP=2'b01;
  localparam ACCESS=2'b10;
  
  logic [1:0] state,next_state;
  
  reg error,setup_error,invalid_addr,invalid_wdata,invalid_rdata;
  
  //Reset checking block with posedge clk
  always_ff @ (posedge PCLK or negedge PRESETn)
    begin
      
      if (!PRESETn)
        state<=IDLE;
      
      else
        state<=next_state;
      
    end
  
  always @(state,transfer,PREADY)
    
    begin
      
      PWDATA=0;
      PADDR=0;
      
      if (!PRESETn)
        next_state=IDLE;
      
      else
        begin
          
          case (state)
            
            IDLE:
              begin
                
                PENABLE=0;
                
                if (!transfer)
                  next_state=IDLE;
                else
                  next_state=SETUP;
                
              end
            
            SETUP:
              begin
                
                PENABLE=0;
                
                if (WRITE_READ)
                  begin
                    
                    PADDR=apb_addr;
                    PWDATA=apb_wdata;
                    
                  end
                
                else
                  begin
                    
                    PADDR=apb_addr;
                    
                  end
                
                if (transfer && !PSLVERR)
                  next_state=ACCESS;
                
                else
                  next_state=IDLE;
                
              end
            
            ACCESS:
              begin
                
                if (PSELx)
                  begin
                    
                    PENABLE=1;
                    
                    if (transfer && !PSLVERR)
                      begin
                        
                        if (PREADY)
                          begin
                            
                            if (WRITE_READ)
                              begin
                                
                                next_state=SETUP;
                                
                              end
                            
                            else
                              begin
                                
                                next_state=SETUP;
                                apb_rdata=PRDATA;
                                
                              end
                            
                          end
                        
                        else
                          begin
                            
                            next_state=ACCESS;
                            
                          end
                        
                      end
                    
                    else
                      begin
                        
                        next_state=IDLE;
                        
                      end
                    
                  end
                
              end
            
            default: next_state=IDLE;
            
          endcase
          
        end
      
    end
  
  assign PSELx=PADDR[ADDR_WIDTH];
  
  
  always @ (*)
    begin
      
      if (!PRESETn)
        begin
          
          setup_error=0;
          invalid_addr=0;
          invalid_wdata=0;
          invalid_rdata=0;
          
        end
      
      else
        begin
          
          if (state==IDLE && next_state==ACCESS)
            setup_error=1;
          else
            setup_error=0;
          
          if (apb_wdata==={DATA_WIDTH{1'bx}} && WRITE_READ && (state==SETUP || state==ACCESS))
            invalid_wdata=1;
          else
            invalid_wdata=0;
          
          if (apb_addr==={(ADDR_WIDTH+1){1'bx}} && (state==SETUP || state==ACCESS))
            invalid_addr=1;
          else
            invalid_addr=0;
          
          if (apb_rdata==={DATA_WIDTH{1'bx}} && !WRITE_READ && (state==SETUP || state==ACCESS))
            invalid_rdata=1;
          else
            invalid_rdata=0;
          
          begin
            if (state==SETUP)
              begin
                
                if (PWRITE)
                  begin
                    
                    if (PADDR==apb_addr && PWDATA==apb_wdata)
                      setup_error=0;
                    else
                      setup_error=1;
                    
                  end
                
                else
                  begin
                    
                    if (PADDR==apb_addr)
                      setup_error=0;
                    else
                      setup_error=1;
                    
                  end
                
              end
            
            else setup_error=0;
          
          end
          
        end
      
      error=setup_error || invalid_wdata || invalid_addr || invalid_rdata;
      
    end
  
  assign PSLVERR=error;
  
endmodule
