//===-- RISCVInstrInfoVme.td - RISC-V VME instructions --------*- tablegen -*-===//
//
// Custom Zvt / Vector Matrix Extension
//
//===----------------------------------------------------------------------===//

include "RISCVInstrFormatsV.td"

// Matrix tile register operand.
def MTRegOp : RegisterOperand<MT> {
  let DecoderMethod = "DecodeMTRegisterClass";
}

// -------------------------------------------------------------------------
// Matrix Config
// -------------------------------------------------------------------------

def MSETMTYPE : RVInstMSetMType<
  (outs),
  (ins GPR:$rs2, GPR:$rs1),
  "msetmtype",
  "$rs1, $rs2">;

def MSETTN : RVInstMSetT<
  0b00000,
  (outs GPR:$rd),
  (ins GPR:$rs1),
  "msettn",
  "$rd, $rs1">;

def MSETTM : RVInstMSetT<
  0b00001,
  (outs GPR:$rd),
  (ins GPR:$rs1),
  "msettm",
  "$rd, $rs1">;

def MSETTK : RVInstMSetT<
  0b00010,
  (outs GPR:$rd),
  (ins GPR:$rs1),
  "msettk",
  "$rd, $rs1">;

// TODO: Add MTypeTOp5??
def MSETMTYPEI : RVInstMSetMTypeI<
    (outs),
    (ins VSewIOp2:$vsewi, MTypeIOp5:$mtypei),
    "msetmtypei",
    "$mtypei, $vsewi"
  >;

// -------------------------------------------------------------------------
// Load
// -------------------------------------------------------------------------

def VTLE8 : RVInstVTLE8<
  (outs VR:$vd),
  (ins GPR:$rs2, GPR:$rs1),
  "vtle8",
  "$rs2, (${rs1})">;

def VTLE16 : RVInstVTLE16<
  (outs VR:$vd),
  (ins GPR:$rs2, GPR:$rs1),
  "vtle16",
  "$rs2, (${rs1})">;

def VTLE32 : RVInstVTLE32<
  (outs VR:$vd),
  (ins GPR:$rs2, GPR:$rs1),
  "vtle32",
  "$rs2, (${rs1})">;

def VTLE64 : RVInstVTLE64<
  (outs VR:$vd),
  (ins GPR:$rs2, GPR:$rs1),
  "vtle64",
  "$rs2, (${rs1})">;


// -------------------------------------------------------------------------
// Store
// -------------------------------------------------------------------------

def VTSE8 : RVInstVTSE8<
  (outs VR:$vd),
  (ins GPR:$rs2, GPR:$rs1),
  "vtse8",
  "$rs2, (${rs1})">;

def VTSE16 : RVInstVTSE16<
  (outs VR:$vd),
  (ins GPR:$rs2, GPR:$rs1),
  "vtse16",
  "$rs2, (${rs1})">;

def VTSE32 : RVInstVTSE32<
  (outs VR:$vd),
  (ins GPR:$rs2, GPR:$rs1),
  "vtse32",
  "$rs2, (${rs1})">;

def VTSE64 : RVInstVTSE64<
  (outs VR:$vd),
  (ins GPR:$rs2, GPR:$rs1),
  "vtse64",
  "$rs2, (${rs1})">;

// -------------------------------------------------------------------------
// MOVE
// -------------------------------------------------------------------------

def VTMV_V_T : RVInstVTMV_V_T<
    (outs VR:$vd),
    (ins GPR:$rs1),
    "vtmv.v.t",
    "$vd, $rs1"
  >;

def VTMV_T_V : RVInstVTMV_T_V<
    (outs),
    (ins GPR:$rs1, VR:$vs2),
    "vtmv.t.v",
    "$rs1, $vs2"
  >;

// -------------------------------------------------------------------------
// INT Mul
// -------------------------------------------------------------------------

def VTMMS_TVV : RVInstVTMMS_TVV<
    (outs MTRegOp:$rd),
    (ins VR:$vs2, VR:$vs1),
    "vtmms.tvv",
    "$rd, $vs2, $vs1"
  >;

def VTMMU_TVV : RVInstVTMMU_TVV<
    (outs MTRegOp:$rd),
    (ins VR:$vs2, VR:$vs1),
    "vtmmu.tvv",
    "$rd, $vs2, $vs1"
  >;

// -------------------------------------------------------------------------
// FP Mul
// -------------------------------------------------------------------------

def VTFMM_TVV : RVInstVTFMM_TVV<
    (outs MTRegOp:$rd),
    (ins VR:$vs2, VR:$vs1),
    "vtfmm.tvv",
    "$rd, $vs2, $vs1"
  >;

def VTFMM_ALT_TVV : RVInstVTFMM_ALT_TVV<
    (outs MTRegOp:$rd),
    (ins VR:$vs2, VR:$vs1),
    "vtfmm.alt.tvv",
    "$rd, $vs2, $vs1"
  >;

// -------------------------------------------------------------------------
// Zero
// -------------------------------------------------------------------------

def VTZERO : RVInstVTZero<
    (outs MTRegOp:$rd),
    (ins),
    "vtzero",
    "$rd"
  >;

// -------------------------------------------------------------------------
// Discard
// -------------------------------------------------------------------------

def VTZERO : RVInstVTZero<
    (outs),
    (ins),
    "vtzero",
    ""
  >;