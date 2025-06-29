Introduction to AMBA APB (Advanced Peripheral Bus)

The Advanced Peripheral Bus (APB) is part of the ARM® AMBA® (Advanced Microcontroller Bus Architecture) family, designed specifically for low-bandwidth, low-power peripheral communication. APB provides a simple, cost-effective interface between high-performance system buses (e.g., AXI/AHB) and on-chip peripherals such as timers, UARTs, GPIO, and other register-mapped devices.

Key Features

Simple Two-Phase Protocol: APB transfers consist of a SETUP phase followed by an ACCESS phase, minimizing protocol overhead.

Low Pin Count: Uses a small set of control and data signals, reducing silicon area and power consumption.

Low Power: No clock switching during idle cycles; peripherals can gate clocks when not in use.

Backward Compatibility: APB3 and APB4 maintain compatibility with earlier versions, allowing mixed-version systems.

Optional Protection and Strobes (APB4+): Supports byte-enable strobes (PSTRB) and protection hints (PPROT), enabling finer-grain access control and error handling.

Basic Signal Overview

Signal

Direction

Description

PCLK

Input

APB clock

PRESETn

Input

Active-low reset

PADDR

Input

Address bus

PWDATA

Input

Write data bus

PRDATA

Output

Read data bus

PSELx

Input

Peripheral select (one-hot)

PENABLE

Input

Enables the access phase

PWRITE

Input

Transfer direction: write (1) / read (0)

PREADY

Output

Slave indicates ready to complete

PSLVERR

Output

Slave indicates an error

Transfer Phases

Setup Phase (PSELx=1, PENABLE=0):

Master drives PADDR, PWRITE, and PWDATA (for writes).

Bus and slave prepare for the transfer.

Access Phase (PSELx=1, PENABLE=1):

Slave asserts PREADY when data is valid (reads) or write is complete.

Slave can also assert PSLVERR to indicate an error.

Typical Use Cases

Connecting low-speed peripherals (e.g., UART, I2C controllers) to a high-speed interconnect.

Saving power in battery-operated devices by gating peripheral clocks during idle.

Implementing simple register-mapped slave interfaces with minimal logic overhead.
