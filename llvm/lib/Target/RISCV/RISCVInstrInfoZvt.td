//===-- RISCVInstrInfoZvt.td - RISC-V Zvt instructions -----------*- tablegen -*-===//

def zvt_uimm1 : Operand<XLenVT>, ImmLeaf<XLenVT, [{
  return isUInt<1>(Imm);
}]> {
  let ParserMatchClass = UImmAsmOperand<1>;
  let DecoderMethod = "decodeUImmOperand<1>";
}

// Matrix tile register operand.
def MTRegOp : RegisterOperand<MT> {
  let DecoderMethod = "DecodeMTRegisterClass";
}

// Matrix arithmetic encodes mtd[3:1]; mtd[0] is fixed to zero.
def MTEvenRegOp : RegisterOperand<MTEven> {
  let DecoderMethod = "DecodeMTRegisterClass";
}

// --------------------
// Matrix Config
// --------------------
let hasSideEffects = 1, mayLoad = 0, mayStore = 0 in {

def MSETMTYPE : RVInstMSetMType<
  (outs),
  (ins GPR:$rs2, GPR:$rs1),
  "msetmtype", "$rs1, $rs2">;

def MSETTN : RVInstMSetT<0b000,
  (outs GPR:$rd), (ins GPR:$rs1),
  "msettn", "$rd, $rs1"> {
  let Defs = [VL];
  let Uses = [VTYPE];
}

def MSETTM : RVInstMSetT<0b001,
  (outs GPR:$rd), (ins GPR:$rs1),
  "msettm", "$rd, $rs1"> {
  let Uses = [VTYPE];
}

def MSETTK : RVInstMSetT<0b010,
  (outs GPR:$rd), (ins GPR:$rs1),
  "msettk", "$rd, $rs1"> {
  let Uses = [VTYPE];
}

def MSETMTYPEI : RVInstMSetMTypei<
  (outs),
  (ins uimm2:$mtwiden, uimm2:$vsew, zvt_uimm1:$altfmt),
  "msetmtypei", "$mtwiden, $vsew, $altfmt">;

} // Matrix Config

// --------------------
// VTLE* (memory load) — rs2 = TSS (GPR holding tile subset specifier)
// --------------------
let hasSideEffects = 0, mayLoad = 1, mayStore = 0 in {

def VTLE8  : RVInstVTLE<0b000, (outs), (ins GPR:$rs2, GPR:$rs1),
  "vtle8",  "$rs2, (${rs1})">;
def VTLE16 : RVInstVTLE<0b001, (outs), (ins GPR:$rs2, GPR:$rs1),
  "vtle16", "$rs2, (${rs1})">;
def VTLE32 : RVInstVTLE<0b010, (outs), (ins GPR:$rs2, GPR:$rs1),
  "vtle32", "$rs2, (${rs1})">;
def VTLE64 : RVInstVTLE<0b011, (outs), (ins GPR:$rs2, GPR:$rs1),
  "vtle64", "$rs2, (${rs1})">;

} // VTLE

// --------------------
// VTSE* (memory store) — rs2 = TSS (GPR holding tile subset specifier)
// --------------------
let hasSideEffects = 0, mayLoad = 0, mayStore = 1 in {

def VTSE8  : RVInstVTSE<0b000, (outs), (ins GPR:$rs2, GPR:$rs1),
  "vtse8",  "$rs2, (${rs1})">;
def VTSE16 : RVInstVTSE<0b001, (outs), (ins GPR:$rs2, GPR:$rs1),
  "vtse16", "$rs2, (${rs1})">;
def VTSE32 : RVInstVTSE<0b010, (outs), (ins GPR:$rs2, GPR:$rs1),
  "vtse32", "$rs2, (${rs1})">;
def VTSE64 : RVInstVTSE<0b011, (outs), (ins GPR:$rs2, GPR:$rs1),
  "vtse64", "$rs2, (${rs1})">;

} // VTSE

// --------------------
// VTMV — rs1 = TSS (GPR holding tile subset specifier)
// --------------------
let hasSideEffects = 1, mayLoad = 0, mayStore = 0 in {

def VTMV_V_T : RVInstVTMV_V_T<
  0b010000,
  (outs VR:$vd),
  (ins GPR:$rs1),   // rs1 = TSS scalar value
  "vtmv.v.t", "$vd, $rs1">;

def VTMV_T_V : RVInstVTMV_T_V<
  0b010111,
  (outs),
  (ins GPR:$rs1, VR:$vs2),  // rs1 = TSS scalar value
  "vtmv.t.v", "$rs1, $vs2">;

} // VTMV

// --------------------
// Matrix arithmetic — rd = MTRegOp tile destination
// --------------------
let hasSideEffects = 1, mayLoad = 0, mayStore = 0 in {

def VTMMS_TVV : RVInstVMETVV<0b000, 0b1,
  (outs MTEvenRegOp:$rd),
  (ins VR:$vs2, VR:$vs1),
  "vtmms.tvv", "$rd, $vs2, $vs1">;

def VTMMU_TVV : RVInstVMETVV<0b000, 0b0,
  (outs MTEvenRegOp:$rd),
  (ins VR:$vs2, VR:$vs1),
  "vtmmu.tvv", "$rd, $vs2, $vs1">;

def VTFMM_TVV : RVInstVMETVV<0b001, 0b0,
  (outs MTEvenRegOp:$rd),
  (ins VR:$vs2, VR:$vs1),
  "vtfmm.tvv", "$rd, $vs2, $vs1">;

def VTFMM_ALT_TVV : RVInstVMETVV<0b001, 0b1,
  (outs MTEvenRegOp:$rd),
  (ins VR:$vs2, VR:$vs1),
  "vtfmm.alt.tvv", "$rd, $vs2, $vs1">;

} // arithmetic

// --------------------
// Tile/context ops — rd = MTRegOp tile specifier (input, not output)
// --------------------
let hasSideEffects = 1, mayLoad = 0, mayStore = 0 in {

// vtzero: rd specifies WHICH tile to zero — it is an INPUT tile register
// The instruction does not write a scalar result, it modifies tile state
def VTZERO : RVInstVTZero<
  (outs),
  (ins MTRegOp:$rd),
  "vtzero", "$rd">;

def VTDISCARD : RVInstVTDiscard<
  (outs),
  (ins),
  "vtdiscard", ""> {
  let Uses = [VTYPE];
}

} // tile/context ops
