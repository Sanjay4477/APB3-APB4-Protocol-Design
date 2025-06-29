`include "APB_MASTER.sv";
`include "APB_SLAVE.sv";

module apb_top #(parameter ADDR_WIDTH=32,parameter DATA_WIDTH=32)
  (input logic PCLK,
   input logic PRESETn,
   input logic transfer,
   input logic WRITE_READ,
   input logic [ADDR_WIDTH:0] apb_addr,
   input logic [DATA_WIDTH-1:0] apb_wdata,
   output PSLVERR,
   output logic [DATA_WIDTH-1:0] apb_rdata
);
  
  logic [DATA_WIDTH-1:0] PWDATA,PRDATA;
  logic [ADDR_WIDTH:0] PADDR;
  
  logic PREADY,PENABLE,PSELx;
  
  
  
  master dut0(
    PCLK,
    PRESETn,
    3'b000,
    4'b1111,
    PREADY,
    WRITE_READ,
    tranfer,
    apb_addr,
    apb_wdata,
    PRDATA,
    PADDR,
   	PWDATA,
   	PSELx,
   	PENABLE,
   	PWRITE,
   	apb_rdata,
   	PSLVERR	
  );
  
  slave dut1(
    PCLK,
   	PRESETn,
   	PSELx,
   	PENABLE,
   	PWRITE,
   	PWDATA,
   	PADDR,
    PRDATA,
   	PREADY
  );
  
  
  
endmodule
