# Pipelined_RISC-V_CV30E40P_UVM_Verification

This repository has documents, references and UVM verification code for Pipelined RISC-V  core CV32E40P. A core which is an open-source 32-bit RISC-V processor core designed for embedded systems, featuring a 5-stage pipeline and integrated memory interfaces for efficient instruction fetch and data access.    

## Specs
It supports the RV32IM instruction set architecture.\  
Includes several custom extensions, such as hardware loops, post-increment load/store instructions, enhanced ALU operations, and SIMD instructions.

![Core CV32E40P architecture and details are shown in this figure](/Images/CV32E40P.png)   


For RV32I ISA, there are six core instruction formats (R/I/S/B/U/J), as shown in Figure.  
All are a fixed 32 bits in length and must be aligned on a four-byte boundary in memory.  


![Core CV32E40P architecture and details are shown in this figure](/Images/instr_format.png) 

The complete information and details of the core CV32E40P for all details about instruction formats and extentions are exist in these documents [RISCV_CARD](/docs/RISCV_CARD.pdf) [riscv-spec](/docs/riscv-spec-20191213_0.pdf)

Also, for custom extensions and more details about the core and its implementation, this databook is very important [databook](/Databook/)     


## interfaces   

The OBI protocol that is used by the instruction fetch and LSU as shown in the below figure. But, we should take in our consideration that The CV32E40P instruction fetch interface does not implement the following optional OBI signals: we, be, wdata, auser, wuser, aid, rready, err, ruser, rid and The CV32E40P data interface does not implement the following optional OBI signals: auser, wuser, aid, rready, err, ruser, rid.   

![OBI Protocol Specification](/Images/OBI.png)  


   
For more details about OBI Protocol see this document. [OBI Protocol Specification](/docs/OBI-v1.pdf)   and also go through these specifications [OBI Interface for Instruction Fetch](/Databook/html/instruction_fetch.html/)  [OBI Interface for Data](/Databook/html/load_store_unit.html/)   

## System Verification    
Not all the entire system are target, only supported instruction types and M-Extention with all stages and its effects regardless another extentions supported by this core such as hardware loops, post-increment not our target.   
Also, we target the behavior Load/Store Unit (LSU) and its behavior throughout different types of memory accessingand hazards handling.  

Our goals and targets could have achieved and covered through suitable and reliable UVM Environment which build to meet our verification requirements as shown    


![UVM Environment Architecture](/Images/ENV.png/)  


you can look the entire goals and built enviroment with its explainations and details at this documents [CV32E40P Verification plan](/VPlan/verification_Plan(AutoRecovered).xlsx/)  [UVM Architecture Details ](/docs/RISC-V_Verification_Using_UVM.pdf/)   


## Functional Coverage

The coverage report confirms 100% coverage across group metric. This achievement demonstrates that our covergroups and goals have been thoroughly exercised,   

![Coverage Reports ](/Images/Dashboard.png/)  

![Functional Coverage Reports_1 ](/Images/Type_1.png/)

![Functional Coverage Reports_2 ](/Images/Type_2.png/)   

![Functional Coverage Reports_3 ](/Images/Type_3.png/)   

![Functional Coverage Reports_4 ](/Images/Type_4.png/)      

![Assertions Coverage Reports ](/Images/assertions.png/)  




       