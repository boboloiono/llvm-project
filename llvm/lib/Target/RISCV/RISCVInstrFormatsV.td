 [
                OutReg      (0, Range(8,  4)),   # rd[4:0] — tile specifier in rd[4:1]
            ]   //===-- RISCVInstrFormatsV.td - RISCV V Instruction Formats --*- tablegen -*-=//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
//  This file describes the RISC-V V extension instruction formats.
//
//===----------------------------------------------------------------------===//

class RISCVVFormat<bits<3> val> {
  bits<3> Value = val;
}
def OPIVV : RISCVVFormat<0b000>;
def OPFVV : RISCVVFormat<0b001>;
def OPMVV : RISCVVFormat<0b010>;
def OPIVI : RISCVVFormat<0b011>;
def OPIVX : RISCVVFormat<0b100>;
def OPFVF : RISCVVFormat<0b101>;
def OPMVX : RISCVVFormat<0b110>;

class RISCVMOP<bits<2> val> {
  bits<2> Value = val;
}
def MOPLDUnitStride   : RISCVMOP<0b00>;
def MOPLDIndexedUnord : RISCVMOP<0b01>;
def MOPLDStrided      : RISCVMOP<0b10>;
def MOPLDIndexedOrder : RISCVMOP<0b11>;

def MOPSTUnitStride   : RISCVMOP<0b00>;
def MOPSTIndexedUnord : RISCVMOP<0b01>;
def MOPSTStrided      : RISCVMOP<0b10>;
def MOPSTIndexedOrder : RISCVMOP<0b11>;

class RISCVLSUMOP<bits<5> val> {
  bits<5> Value = val;
}
def LUMOPUnitStride  : RISCVLSUMOP<0b00000>;
def LUMOPUnitStrideMask : RISCVLSUMOP<0b01011>;
def LUMOPUnitStrideWholeReg : RISCVLSUMOP<0b01000>;
def LUMOPUnitStrideFF: RISCVLSUMOP<0b10000>;
def SUMOPUnitStride  : RISCVLSUMOP<0b00000>;
def SUMOPUnitStrideMask : RISCVLSUMOP<0b01011>;
def SUMOPUnitStrideWholeReg : RISCVLSUMOP<0b01000>;

class RISCVWidth<bits<4> val> {
  bits<4> Value = val;
}
def LSWidth8     : RISCVWidth<0b0000>;
def LSWidth16    : RISCVWidth<0b0101>;
def LSWidth32    : RISCVWidth<0b0110>;
def LSWidth64    : RISCVWidth<0b0111>;

class RVInstSetiVLi<dag outs, dag ins, string opcodestr, string argstr>
    : RVInst<outs, ins, opcodestr, argstr, [], InstFormatI> {
  bits<5> uimm;
  bits<5> rd;
  bits<10> vtypei;

  let Inst{31} = 1;
  let Inst{30} = 1;
  let Inst{29-20} = vtypei{9-0};
  let Inst{19-15} = uimm;
  let Inst{14-12} = 0b111;
  let Inst{11-7} = rd;
  let Opcode = OPC_OP_V.Value;

  let Defs = [VTYPE, VL];
}

class RVInstSetVLi<dag outs, dag ins, string opcodestr, string argstr>
    : RVInst<outs, ins, opcodestr, argstr, [], InstFormatI> {
  bits<5> rs1;
  bits<5> rd;
  bits<11> vtypei;

  let Inst{31} = 0;
  let Inst{30-20} = vtypei;
  let Inst{19-15} = rs1;
  let Inst{14-12} = 0b111;
  let Inst{11-7} = rd;
  let Opcode = OPC_OP_V.Value;

  let Defs = [VTYPE, VL];
}

class RVInstSetVL<dag outs, dag ins, string opcodestr, string argstr>
    : RVInst<outs, ins, opcodestr, argstr, [], InstFormatR> {
  bits<5> rs2;
  bits<5> rs1;
  bits<5> rd;

  let Inst{31} = 1;
  let Inst{30-25} = 0b000000;
  let Inst{24-20} = rs2;
  let Inst{19-15} = rs1;
  let Inst{14-12} = 0b111;
  let Inst{11-7} = rd;
  let Opcode = OPC_OP_V.Value;

  let Defs = [VTYPE, VL];
}

class RVInstVV<bits<6> funct6, RISCVVFormat opv, dag outs, dag ins,
               string opcodestr, string argstr>
    : RVInst<outs, ins, opcodestr, argstr, [], InstFormatR> {
  bits<5> vs2;
  bits<5> vs1;
  bits<5> vd;
  bit vm;

  let Inst{31-26} = funct6;
  let Inst{25} = vm;
  let Inst{24-20} = vs2;
  let Inst{19-15} = vs1;
  let Inst{14-12} = opv.Value;
  let Inst{11-7} = vd;
  let Opcode = OPC_OP_V.Value;

  let Uses = [VTYPE, VL];
  let RVVConstraint = VMConstraint;
}

class RVInstVX<bits<6> funct6, RISCVVFormat opv, dag outs, dag ins,
                string opcodestr, string argstr>
    : RVInst<outs, ins, opcodestr, argstr, [], InstFormatR> {
  bits<5> vs2;
  bits<5> rs1;
  bits<5> vd;
  bit vm;

  let Inst{31-26} = funct6;
  let Inst{25} = vm;
  let Inst{24-20} = vs2;
  let Inst{19-15} = rs1;
  let Inst{14-12} = opv.Value;
  let Inst{11-7} = vd;
  let Opcode = OPC_OP_V.Value;

  let Uses = [VTYPE, VL];
  let RVVConstraint = VMConstraint;
}

class RVInstV2<bits<6> funct6, bits<5> vs2, RISCVVFormat opv, dag outs, dag ins,
                string opcodestr, string argstr>
    : RVInst<outs, ins, opcodestr, argstr, [], InstFormatR> {
  bits<5> rs1;
  bits<5> vd;
  bit vm;

  let Inst{31-26} = funct6;
  let Inst{25} = vm;
  let Inst{24-20} = vs2;
  let Inst{19-15} = rs1;
  let Inst{14-12} = opv.Value;
  let Inst{11-7} = vd;
  let Opcode = OPC_OP_V.Value;

  let Uses = [VTYPE, VL];
  let RVVConstraint = VMConstraint;
}

class RVInstIVI<bits<6> funct6, dag outs, dag ins, string opcodestr,
                string argstr>
    : RVInst<outs, ins, opcodestr, argstr, [], InstFormatR> {
  bits<5> vs2;
  bits<5> imm;
  bits<5> vd;
  bit vm;

  let Inst{31-26} = funct6;
  let Inst{25} = vm;
  let Inst{24-20} = vs2;
  let Inst{19-15} = imm;
  let Inst{14-12} = 0b011;
  let Inst{11-7} = vd;
  let Opcode = OPC_OP_V.Value;

  let Uses = [VTYPE, VL];
  let RVVConstraint = VMConstraint;
}

class RVInstV<bits<6> funct6, bits<5> vs1, RISCVVFormat opv, dag outs,
              dag ins, string opcodestr, string argstr>
    : RVInst<outs, ins, opcodestr, argstr, [], InstFormatR> {
  bits<5> vs2;
  bits<5> vd;
  bit vm;

  let Inst{31-26} = funct6;
  let Inst{25} = vm;
  let Inst{24-20} = vs2;
  let Inst{19-15} = vs1;
  let Inst{14-12} = opv.Value;
  let Inst{11-7} = vd;
  let Opcode = OPC_OP_V.Value;

  let Uses = [VTYPE, VL];
  let RVVConstraint = VMConstraint;
}

class RVInstVLU<bits<3> nf, bit mew, RISCVLSUMOP lumop,
                bits<3> width, dag outs, dag ins, string opcodestr,
                string argstr>
    : RVInst<outs, ins, opcodestr, argstr, [], InstFormatR> {
  bits<5> rs1;
  bits<5> vd;
  bit vm;

  let Inst{31-29} = nf;
  let Inst{28} = mew;
  let Inst{27-26} = MOPLDUnitStride.Value;
  let Inst{25} = vm;
  let Inst{24-20} = lumop.Value;
  let Inst{19-15} = rs1;
  let Inst{14-12} = width;
  let Inst{11-7} = vd;
  let Opcode = OPC_LOAD_FP.Value;

  let Uses = [VTYPE, VL];
  let RVVConstraint = VMConstraint;
}

class RVInstVLS<bits<3> nf, bit mew, bits<3> width,
                dag outs, dag ins, string opcodestr, string argstr>
    : RVInst<outs, ins, opcodestr, argstr, [], InstFormatR> {
  bits<5> rs2;
  bits<5> rs1;
  bits<5> vd;
  bit vm;

  let Inst{31-29} = nf;
  let Inst{28} = mew;
  let Inst{27-26} = MOPLDStrided.Value;
  let Inst{25} = vm;
  let Inst{24-20} = rs2;
  let Inst{19-15} = rs1;
  let Inst{14-12} = width;
  let Inst{11-7} = vd;
  let Opcode = OPC_LOAD_FP.Value;

  let Uses = [VTYPE, VL];
  let RVVConstraint = VMConstraint;
}

class RVInstVLX<bits<3> nf, bit mew, RISCVMOP mop, bits<3> width,
                dag outs, dag ins, string opcodestr, string argstr>
    : RVInst<outs, ins, opcodestr, argstr, [], InstFormatR> {
  bits<5> vs2;
  bits<5> rs1;
  bits<5> vd;
  bit vm;

  let Inst{31-29} = nf;
  let Inst{28} = mew;
  let Inst{27-26} = mop.Value;
  let Inst{25} = vm;
  let Inst{24-20} = vs2;
  let Inst{19-15} = rs1;
  let Inst{14-12} = width;
  let Inst{11-7} = vd;
  let Opcode = OPC_LOAD_FP.Value;

  let Uses = [VTYPE, VL];
  let RVVConstraint = VMConstraint;
}

class RVInstVSU<bits<3> nf, bit mew, RISCVLSUMOP sumop,
                bits<3> width, dag outs, dag ins, string opcodestr,
                string argstr>
    : RVInst<outs, ins, opcodestr, argstr, [], InstFormatR> {
  bits<5> rs1;
  bits<5> vs3;
  bit vm;

  let Inst{31-29} = nf;
  let Inst{28} = mew;
  let Inst{27-26} = MOPSTUnitStride.Value;
  let Inst{25} = vm;
  let Inst{24-20} = sumop.Value;
  let Inst{19-15} = rs1;
  let Inst{14-12} = width;
  let Inst{11-7} = vs3;
  let Opcode = OPC_STORE_FP.Value;

  let Uses = [VTYPE, VL];
}

class RVInstVSS<bits<3> nf, bit mew, bits<3> width,
                dag outs, dag ins, string opcodestr, string argstr>
    : RVInst<outs, ins, opcodestr, argstr, [], InstFormatR> {
  bits<5> rs2;
  bits<5> rs1;
  bits<5> vs3;
  bit vm;

  let Inst{31-29} = nf;
  let Inst{28} = mew;
  let Inst{27-26} = MOPSTStrided.Value;
  let Inst{25} = vm;
  let Inst{24-20} = rs2;
  let Inst{19-15} = rs1;
  let Inst{14-12} = width;
  let Inst{11-7} = vs3;
  let Opcode = OPC_STORE_FP.Value;

  let Uses = [VTYPE, VL];
}

class RVInstVSX<bits<3> nf, bit mew, RISCVMOP mop, bits<3> width,
                dag outs, dag ins, string opcodestr, string argstr>
    : RVInst<outs, ins, opcodestr, argstr, [], InstFormatR> {
  bits<5> vs2;
  bits<5> rs1;
  bits<5> vs3;
  bit vm;

  let Inst{31-29} = nf;
  let Inst{28} = mew;
  let Inst{27-26} = mop.Value;
  let Inst{25} = vm;
  let Inst{24-20} = vs2;
  let Inst{19-15} = rs1;
  let Inst{14-12} = width;
  let Inst{11-7} = vs3;
  let Opcode = OPC_STORE_FP.Value;

  let Uses = [VTYPE, VL];
}

//===----------------------------------------------------------------------===//
// Matrix Configuration Instructions
//===----------------------------------------------------------------------===//

class RVInstVME<dag outs, dag ins, string opcodestr, string argstr>
    : RVInst<outs, ins, opcodestr, argstr, [], InstFormatR> {
  let Predicates = [HasVInstructions, HasStdExtVme];
}

// msetmtype
class RVInstMSetMType<dag outs, dag ins, string opcodestr, string argstr>
    : RVInstVME<outs, ins, opcodestr, argstr> {
  bits<5> rs2;
  bits<5> rs1;

  let Inst{31-25} = 0b1000001;
  let Inst{24-20} = rs2;
  let Inst{19-15} = rs1;
  let Inst{14-12} = 0b111;
  let Inst{11-7}  = 0b00000;
  let Opcode = OPC_OP_V.Value;

  let Defs = [VTYPE, VL];
  let Uses = [VTYPE, VL];
}

// msettn / msettm / msettk
class RVInstMSetT<bits<5> subop,
                  dag outs, dag ins, string opcodestr, string argstr>
    : RVInstVME<outs, ins, opcodestr, argstr> {
  bits<5> rs1;
  bits<5> rd;

  let Inst{31}    = 1;
  let Inst{30-25} = 0b000010;
  let Inst{24-20} = subop;
  let Inst{19-15} = rs1;
  let Inst{14-12} = 0b111;
  let Inst{11-7}  = rd;
  let Opcode = OPC_OP_V.Value;

  let Defs = [VTYPE, VL];
  let Uses = [VTYPE, VL];
}

// msetmtypei
class RVInstMSetMTypei<dag outs, dag ins, string opcodestr, string argstr>
    : RVInst<outs, ins, opcodestr, argstr, [], InstFormatI> {
      let Predicates = [HasVInstructions, HasStdExtVme];
  bits<2> uimm2;
  bits<5> uimm5;

  let Inst{31-25} = 0b1000010;
  let Inst{24-23} = uimm2;
  let Inst{22-20} = 0b011;
  let Inst{19-15} = uimm5;
  let Inst{14-12} = 0b111;
  let Inst{11-7}  = 0b00000;
  let Opcode = OPC_OP_V.Value;

  let Defs = [VTYPE, VL];
  let Uses = [VTYPE, VL];
}


//===----------------------------------------------------------------------===//
// Matrix Arithmetic Instructions
//===----------------------------------------------------------------------===//

class RVInstVMETVV<bits<3> funct3, bits<1> variant,
                   dag outs, dag ins, string opcodestr, string argstr>
    : RVInstVME<outs, ins, opcodestr, argstr> {
  bits<5> vs2;
  bits<5> vs1;
  bits<4> rd;

  let Inst{31-26} = 0b111100;
  let Inst{25}    = 1;
  let Inst{24-20} = vs2;
  let Inst{19-15} = vs1;
  let Inst{14-12} = funct3;
  let Inst{11-8}  = rd;
  let Inst{7}     = variant;
  let Opcode = OPC_OP_VE.Value;

  let Uses = [VTYPE, VL];
}

// Convenience classes for the four arithmetic encodings.
class RVInstVTFMM_TVV<dag outs, dag ins, string opcodestr, string argstr>
    : RVInstVMETVV<0b001, 0b0, outs, ins, opcodestr, argstr>;

class RVInstVTFMM_ALT_TVV<dag outs, dag ins, string opcodestr, string argstr>
    : RVInstVMETVV<0b001, 0b1, outs, ins, opcodestr, argstr>;

class RVInstVTMMU_TVV<dag outs, dag ins, string opcodestr, string argstr>
    : RVInstVMETVV<0b000, 0b0, outs, ins, opcodestr, argstr>;

class RVInstVTMMS_TVV<dag outs, dag ins, string opcodestr, string argstr>
    : RVInstVMETVV<0b000, 0b1, outs, ins, opcodestr, argstr>;

//===----------------------------------------------------------------------===//
// Load / Store Tile Subset to Memory
//===----------------------------------------------------------------------===//


// vtle*
class RVInstVTLE<bits<3> nf_or_eew,
                 dag outs, dag ins, string opcodestr, string argstr>
    : RVInstVME<outs, ins, opcodestr, argstr> {
  bits<5> rs2;
  bits<5> rs1;

  let Inst{31-29} = nf_or_eew;
  let Inst{28}    = 1;
  let Inst{27-26} = 0b00;
  let Inst{25}    = 1;
  let Inst{24-20} = rs2;
  let Inst{19-15} = rs1;
  let Inst{14-12} = 0b011;
  let Inst{11-7}  = 0b00000;
  let Opcode = OPC_LOAD_FP.Value;

  let Uses = [VTYPE, VL];
}

// vtse*
class RVInstVTSE<bits<3> nf_or_eew,
                 dag outs, dag ins, string opcodestr, string argstr>
    : RVInstVME<outs, ins, opcodestr, argstr> {
  bits<5> rs2;
  bits<5> rs1;

  let Inst{31-29} = nf_or_eew;
  let Inst{28}    = 1;
  let Inst{27-26} = 0b00;
  let Inst{25}    = 1;
  let Inst{24-20} = rs2;
  let Inst{19-15} = rs1;
  let Inst{14-12} = 0b011;
  let Inst{11-7}  = 0b00000;
  let Opcode = OPC_STORE_FP.Value;

  let Uses = [VTYPE, VL];
}

// Convenience classes for EEW-style encodings.
// If your implementation wants different top-bit values, adjust these here.
class RVInstVTLE8<dag outs, dag ins, string opcodestr, string argstr>
    : RVInstVTLE<0b000, outs, ins, opcodestr, argstr>;
class RVInstVTLE16<dag outs, dag ins, string opcodestr, string argstr>
    : RVInstVTLE<0b001, outs, ins, opcodestr, argstr>;
class RVInstVTLE32<dag outs, dag ins, string opcodestr, string argstr>
    : RVInstVTLE<0b010, outs, ins, opcodestr, argstr>;
class RVInstVTLE64<dag outs, dag ins, string opcodestr, string argstr>
    : RVInstVTLE<0b011, outs, ins, opcodestr, argstr>;

class RVInstVTSE8<dag outs, dag ins, string opcodestr, string argstr>
    : RVInstVTSE<0b000, outs, ins, opcodestr, argstr>;
class RVInstVTSE16<dag outs, dag ins, string opcodestr, string argstr>
    : RVInstVTSE<0b001, outs, ins, opcodestr, argstr>;
class RVInstVTSE32<dag outs, dag ins, string opcodestr, string argstr>
    : RVInstVTSE<0b010, outs, ins, opcodestr, argstr>;
class RVInstVTSE64<dag outs, dag ins, string opcodestr, string argstr>
    : RVInstVTSE<0b011, outs, ins, opcodestr, argstr>;


//===----------------------------------------------------------------------===//
// Move Tile Subset between Tile State and Vector Registers
//===----------------------------------------------------------------------===//

// vtmv.v.t
class RVInstVTMV_V_T<bits<6> funct6, dag outs, dag ins, string opcodestr, string argstr>
    : RVInstVME<outs, ins, opcodestr, argstr> {
  bits<5> rs1;
  bits<5> vd;

  let Inst{31-26} = funct6;
  let Inst{25}    = 1;
  let Inst{24-20} = 0b11111;
  let Inst{19-15} = rs1;
  let Inst{14-12} = 0b110;
  let Inst{11-7}  = vd;
  let Opcode = OPC_OP_V.Value;

  let Uses = [VTYPE, VL];
}

// vtmv.t.v
class RVInstVTMV_T_V<bits<6> funct6, dag outs, dag ins, string opcodestr, string argstr>
    : RVInstVME<outs, ins, opcodestr, argstr> {
  bits<5> vs2;
  bits<5> rs1;

  let Inst{31-26} = funct6;
  let Inst{25}    = 1;
  let Inst{24-20} = vs2;
  let Inst{19-15} = rs1;
  let Inst{14-12} = 0b110;
  let Inst{11-7}  = 0b00000;
  let Opcode = OPC_OP_V.Value;

  let Uses = [VTYPE, VL];
}

//===----------------------------------------------------------------------===//
// Matrix Tile-Zero Instruction
//===----------------------------------------------------------------------===//

// vtzero
class RVInstVTZero<dag outs, dag ins, string opcodestr, string argstr>
    : RVInstVME<outs, ins, opcodestr, argstr> {
  bits<4> rd;

  let Inst{31-26} = 0b010000;
  let Inst{25}    = 1;
  let Inst{24-20} = 0b11110;
  let Inst{19-15} = 0b00000;
  let Inst{14-12} = 0b110;
  let Inst{11-8}  = rd;
  let Inst{7}     = 0;
  let Opcode = OPC_OP_V.Value;

  let Uses = [VTYPE, VL];
}

//===----------------------------------------------------------------------===//
// Zvt Context Discard Instruction
//===----------------------------------------------------------------------===//

// vtdiscard
class RVInstVTDiscard<dag outs, dag ins, string opcodestr, string argstr>
    : RVInstVME<outs, ins, opcodestr, argstr> {
  let Inst{31-26} = 0b010000;
  let Inst{25}    = 1;
  let Inst{24-20} = 0b11100;
  let Inst{19-15} = 0b00000;
  let Inst{14-12} = 0b110;
  let Inst{11-7}  = 0b00000;
  let Opcode = OPC_OP_V.Value;

  let Uses = [VTYPE, VL];
}

