//===-- RISCVInstrInfoVme.td - RISC-V VME instructions -----------*- tablegen -*-===//

// Matrix tile register operand.
def MTRegOp : RegisterOperand<MT> {
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

def MSETTN : RVInstMSetT<0b00000,
  (outs GPR:$rd), (ins GPR:$rs1),
  "msettn", "$rd, $rs1">;

def MSETTM : RVInstMSetT<0b00001,
  (outs GPR:$rd), (ins GPR:$rs1),
  "msettm", "$rd, $rs1">;

def MSETTK : RVInstMSetT<0b00010,
  (outs GPR:$rd), (ins GPR:$rs1),
  "msettk", "$rd, $rs1">;

def MSETMTYPEI : RVInstMSetMTypei<
  (outs),
  (ins uimm2:$uimm2, uimm5:$uimm5),
  "msetmtypei", "$uimm5, $uimm2">;

} // Matrix Config

// --------------------
// VTLE* (memory load) — rs2 = TSS (GPR holding tile subset specifier)
// --------------------
let hasSideEffects = 0, mayLoad = 1, mayStore = 0 in {

def VTLE8  : RVInstVTLE8 <(outs), (ins GPR:$rs2, GPR:$rs1),
  "vtle8",  "$rs2, (${rs1})">;
def VTLE16 : RVInstVTLE16<(outs), (ins GPR:$rs2, GPR:$rs1),
  "vtle16", "$rs2, (${rs1})">;
def VTLE32 : RVInstVTLE32<(outs), (ins GPR:$rs2, GPR:$rs1),
  "vtle32", "$rs2, (${rs1})">;
def VTLE64 : RVInstVTLE64<(outs), (ins GPR:$rs2, GPR:$rs1),
  "vtle64", "$rs2, (${rs1})">;

} // VTLE

// --------------------
// VTSE* (memory store) — rs2 = TSS (GPR holding tile subset specifier)
// --------------------
let hasSideEffects = 0, mayLoad = 0, mayStore = 1 in {

def VTSE8  : RVInstVTSE8 <(outs), (ins GPR:$rs2, GPR:$rs1),
  "vtse8",  "$rs2, (${rs1})">;
def VTSE16 : RVInstVTSE16<(outs), (ins GPR:$rs2, GPR:$rs1),
  "vtse16", "$rs2, (${rs1})">;
def VTSE32 : RVInstVTSE32<(outs), (ins GPR:$rs2, GPR:$rs1),
  "vtse32", "$rs2, (${rs1})">;
def VTSE64 : RVInstVTSE64<(outs), (ins GPR:$rs2, GPR:$rs1),
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
  0b010000,
  (outs),
  (ins GPR:$rs1, VR:$vs2),  // rs1 = TSS scalar value
  "vtmv.t.v", "$rs1, $vs2">;

} // VTMV

// --------------------
// Matrix arithmetic — rd = MTRegOp tile destination
// --------------------
let hasSideEffects = 1, mayLoad = 0, mayStore = 0 in {

def VTMMS_TVV : RVInstVTMMS_TVV<
  (outs MTRegOp:$rd),
  (ins VR:$vt2, VR:$vt1),
  "vtmms.tvv", "$rd, $vt2, $vt1">;

def VTMMU_TVV : RVInstVTMMU_TVV<
  (outs MTRegOp:$rd),
  (ins VR:$vt2, VR:$vt1),
  "vtmmu.tvv", "$rd, $vt2, $vt1">;

def VTFMM_TVV : RVInstVTFMM_TVV<
  (outs MTRegOp:$rd),
  (ins VR:$vt2, VR:$vt1),
  "vtfmm.tvv", "$rd, $vt2, $vt1">;

def VTFMM_ALT_TVV : RVInstVTFMM_ALT_TVV<
  (outs MTRegOp:$rd),
  (ins VR:$vt2, VR:$vt1),
  "vtfmm.alt.tvv", "$rd, $vt2, $vt1">;

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
  "vtdiscard", "">;

} // tile/context ops
