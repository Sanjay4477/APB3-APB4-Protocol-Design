module slave # (parameter ADDR_WIDTH=32,parameter DATA_WIDTH=32)
  (input logic PCLK,
   input logic PRESETn,
   input logic PSELx,
   input logic PENABLE,
   input logic PWRITE,
   input logic [DATA_WIDTH-1:0] PWDATA,
   input logic [ADDR_WIDTH:0] PADDR,
   output logic [DATA_WIDTH-1:0] PRDATA,
   output logic PREADY
  );
  
  logic [ADDR_WIDTH-1:0] addr;
  logic [ADDR_WIDTH-1:0] mem[63:0];
  
  assign PRDATA=mem[addr];
  
  always @ (*)
    begin
      
      if (!PRESETn)
        PREADY=0;
      
      else
        begin
          
          if (PSELx && !PENABLE)
            PREADY=0;
          
          else if (PSELx && PENABLE && !PWRITE)
            begin
              
              PREADY=1;
              addr=PADDR;
              
            end
          
          else if (PSELx && PENABLE && PWRITE)
            begin
              
              PREADY=1;
              mem[PADDR[ADDR_WIDTH-1:0]]=PWDATA;
              
            end
          
          else
            PREADY=0;
          
        end
      
    end
  
endmodule
