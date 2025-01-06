
# WiMax PHY Layer Simulation Project

This project provides a comprehensive implementation and simulation of the Physical Layer (PHY) for a WiMax communication system. The design incorporates key features such as Pseudo-Random Bit Sequence (PRBS) generation, Forward Error Correction (FEC), interleaving, modulation, and clock management, enabling end-to-end testing and performance validation.

## Project Components

### Core Modules
1. **PRBS (Pseudo-Random Bit Sequence):**
   - Implements a PRBS generator for signal randomization.
   - Includes a dedicated testbench (`prbs_tb.sv`) for validation.

2. **Forward Error Correction (FEC):**
   - Implements error detection and correction mechanisms.
   - Tested using `fec_tb.sv` to ensure data integrity under noisy conditions.

3. **Interleaver:**
   - Implements data interleaving to reduce the effect of burst errors.
   - Verified using `Interleaver_tb.sv`.

4. **Modulator:**
   - Handles QPSK modulation for signal transmission.
   - Includes a testbench (`Modulator_tb.sv`) to validate functionality.

### Integration and Top-Level Design
- **PRBS-FEC Integration (`prbsfec.sv`):**
  - Combines PRBS and FEC modules for cohesive testing.
- **Top Module (`Top.sv`):**
  - Integrates all system components for full PHY layer functionality.
  - Testbench `Top_tb.sv` verifies the system's end-to-end performance.

### Supporting Files
- **Constants Package (`constants_pkg.sv`):**
  - Defines global constants for consistent configurations across modules.
- **Clock and Memory Modules:**
  - `PLL.v` and `PLL_0002.v` manage clock signals.
  - `DPR.v`, `DPR_bb.v`, and `RAM2P.v` handle memory operations.
- **Dynamic Parallel Registers (`DPR_inst.v`):**
  - Provides hardware instantiation for the dynamic parallel register module.

### Simulation and Automation
- **Simulation Scripts:**
  - `prbsrun.do`, `prfcrun.do`, and `run.do` automate simulation tasks.
  - `wave.do` configures waveform visualization for debugging.

### Specialized WiMax Features
- **WiMax Module (`WiMax.sv`):**
  - Implements configurations and logic specific to WiMax PHY standards, including channel coding and modulation.

## Features
- RTL implementation of key WiMax PHY layer components.
- Modular design for easy testing and integration.
- Comprehensive testbenches to validate individual modules and the entire system.
- Automated simulation scripts for efficient testing workflows.
- Support for QPSK modulation and FEC mechanisms.

## Getting Started

1. **Prerequisites:**
   - Verilog simulation tools (e.g., ModelSim, Quartus, Vivado).
   - Knowledge of WiMax standards and digital communication principles.

2. **Simulation Steps:**
   - Run the provided simulation scripts (`*.do`) for automated testing.
   - View results using the waveform script (`wave.do`).

3. **Customizations:**
   - Modify `constants_pkg.sv` to adjust parameters such as modulation type or FEC configurations.

## Future Enhancements
- Support for higher-order modulation schemes (e.g., 16-QAM, 64-QAM).
- Hardware validation on FPGA platforms.
- Inclusion of additional WiMax PHY features like synchronization and channel estimation.
