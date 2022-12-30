# Five stages pipeline processsor

### Performance

##### All instructions are executed in 5 cycles except :

- _LDM_: takes 1 additional cycle (LDM, stall)
- _CALL_ : takes 4 additional cycle (PUSH flags, PUSH pc, JMP, stall, stall)
- _RET_: takes 3 additional cycle (POP PC, POP Flags, stall, stall)
- _RTI_: takes 3 additional cycle (POP PC, POP Flags, stall, stall)
- _INT_: takes 8 additional cycle (POP PC, POP Flags, stall, stall)

### Handling Hazards

- _Data hazards_ : Handled by Full forwarding
- _Load use case_ : Handled by stalling for one cycle
- _POP Rdst - JMP Rdst_ : Handled by stalling for one cycle
- _POP Rdst - CALL Rdst_ : Handled by stalling for one cycle
- _POP Rdst - STD Rsrc, Rdst_ : Handled by stalling for one cycle
- _POP Rdst - ALU Rsrc, Rdst_ : Handled by stalling for one cycle
- _POP Rdst - OUT Rdst_ : Handled by stalling for one cycle
- _INT - CALL_ : Handled by enabling the write to PC while preparing to go to ISR (Not handled if the INT came before fetching Push PC)
- _INT - JMP_ : Handled by enabling the write to PC while preparing to go to ISR (Not handled if the INT came at the end of the second NOP of the JMP)
- _INT - RET_ : Handled by enabling the write to PC while preparing to go to ISR
- _INT - RTI_ : Handled by enabling the write to PC while preparing to go to ISR

### Assembler

- Go to **_assembler_** directory
- Open command prompt
- write `python3 assemblerGui.py`
- now you can write you Assembly code

### Instruction set

- **NOP** : PC ← PC + 1
- **SETC** : C ←1
- **CLRC** : C ←0
- **NOT** : Rdst NOT value stored in register Rdst
- **INC** : Rdst Increment value stored in Rdst
- **DEC** : Rdst Decrement value stored in Rdst
- **OUT** : Rdst OUT.PORT ← R[ Rdst ]
- **IN Rdst** : R[ Rdst ] ←IN.PORT Two Operands
- **MOV** : Rsrc, Rdst Move value from register Rsrc to register Rdst
- **ADD** : Rsrc, Rdst Add the values stored in registers Rsrc, Rdst and store the result in Rdst
- **SUB** : Rsrc, Rdst Subtract the values stored in registers Rsrc, Rdst and store the result in Rdst
- **AND** : Rsrc, Rdst AND the values stored in registers Rsrc, Rdst and store the result in Rdst
- **OR** : Rsrc, Rdst OR the values stored in registers Rsrc, Rdst and store the result in Rdst
- **SHL** : Rsrc, Imm Shift left Rsrc by #Imm bits and store result in same register
- **SHR** : Rsrc, Imm Shift right Rsrc by #Imm bits and store result in same register

- **PUSH** : Rdst X[SP--] ← R[ Rdst ];
- **POP** : Rdst R[ Rdst ] ← X[++SP];
- **LDM** : Rdst, Imm Load immediate value (15 bit) to register RdstR[ Rdst ] ← Imm<15:0>
- **LDD** : Rsrc, Rdst R[ Rdst ] ← M[Rsrc];
- **STD** : Rsrc, Rdst M[Rdst] ←R[Rsrc];

- **JZ** : Rdst Jump if zero
- **JN** : Rdst Jump if negative
- **JC** : Rdst Jump if negative
- **JMP** : Rdst Jump PC ←R[ Rdst ]
- **CALL** : Rdst (X[SP] ← PC + 1; sp-2; PC ← R[ Rdst ])
- **RET** : sp+2, PC ←X[SP]
- **RTI** : sp+2; PC ← X[SP]; Flags restored Input Signals

- **Reset** : PC ←25h //memory location of the first instruction
- **Interrupt** : X[Sp]←PC; sp-2;PC ← 0; Flags preserved

### CPU Complete Design

![Design](https://user-images.githubusercontent.com/82395903/209969151-4953b7fb-503e-4c08-8fbe-04904af3de3d.png)
