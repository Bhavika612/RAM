# RAM
A Basic parameterized RAM verilog implementation.

This repository contains Verilog implementations and testbenches for:

- ✅ **Single-Port RAM**
- ✅ **Dual-Port RAM**


##  Single-Port RAM

###  Description

A simple single-port RAM supporting read and write operations on the same port. Useful for small embedded memory use-cases.

###  Features

- Parameterized address and data width
- Controlled via clock and enable signals

###  Testbench: `RAM_tb.v`

The testbench supports multiple runtime options using `$test$plusargs`, allowing flexible and scenario-driven simulation.

####  Supported Test Modes (via `+args`):
| Argument         | Description                                 |
|------------------|---------------------------------------------|
| `+random_test`   | Performs random read/write transactions     |
| `+write_data`    | Sequentially writes data to memory          |
| `+read_data`     | Sequentially reads data from memory         |
| `+simul_rw`      | Simultaneous read/write operations to test edge cases |

##  Dual-Port RAM

### Description

A dual-port RAM allowing **concurrent** access from two independent ports (Port A and Port B). Each port can read or write without interfering with the other.

###  Features

- Independent address/data/control for both ports
- Parameterized size

###  Testbench: `DualPortRam_tb.v`

The testbench is structured using  tasks to improve modularity and reusability. Tasks handle:
