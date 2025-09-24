# Custom-8-bit-RISC-like-CPU-on-FPGA
## Introduction
這個專案從零開始構建了一個具備基本運算、資料存取與分支跳轉能力的 8 位元 CPU。整體架構參考了 MIPS 的設計理念，採用了 Load/Store 架構，並實現了一個簡潔而高效的指令集。

## Key Features
* **架構**: 8-bit RISC-like 架構
* **指令集 (ISA)**: 客製化指令集，包含 12 條指令，涵蓋算術、邏輯、記憶體存取與分支控制四大類。
* **硬體描述語言**: 使用 Verilog 進行設計與實現。
* **驗證平台**: 在 Xilinx Vivado 環境下進行模擬與驗證，並成功部署於 Arty A7-35t 開發版。

## CPU Architecture
本 CPU 的 Datapath 主要由以下幾個關鍵模組組成：
* **Program Counter, PC**: 負責指向下一個要執行的指令位址。
* **Instruction Memory**: 儲存 CPU 要執行的指令。
* **Register File**:  8 位元的通用暫存器。
* **ALU**: 負責執行算術 (加、減) 與邏輯 (AND, OR, NOT) 運算。
* **Data Memory**: 負責儲存與讀取資料。
* **Control Unit**: 根據指令的 opcode 解碼並產生對應的控制信號。

<img width="541" height="298" alt="image" src="https://github.com/user-attachments/assets/be3b75ef-84a0-46cb-ad73-5bba4323f962" />

## Instruction Set Architecture

指令長度為 8 bits，並參考 MIPS 設計了 R-Type, I-Type, J-Type 三種指令格式。

<img width="352" height="388" alt="image" src="https://github.com/user-attachments/assets/5d1d01d8-a94e-4647-be9b-e25b56c891f0" />


## File Structure

* `/VLSI_8bit_CPU` - Vivado 專案的主資料夾。
    * `/VLSI_8bit_CPU.srcs/sources_1/` - **RTL 原始碼**
        * `CPU.v`: CPU 頂層模組。
        * `ALU.v`: 算術邏輯單元。
        * `Control.v`: 控制單元。
        * `[請繼續說明你的重要 .v 檔案...]`
    * `/VLSI_8bit_CPU.srcs/constrs_1/` - **FPGA 腳位約束檔 (.xdc)**。
    * `/VLSI_8bit_CPU.srcs/sim_1/` - **Testbench 模擬測試檔**。
* `str2binASCII.py` - 產生測資
* `.gitignore` - 用於忽略 Vivado 產生的暫存檔。

## Tools Used

* **設計與模擬**: Xilinx Vivado
* **硬體描述語言**: Verilog
* **FPGA 開發版**: Arty A7-35t
