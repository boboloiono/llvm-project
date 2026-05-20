.text

# ---- base: rdhi3 = 0 (mt0), vs2=v8, vs1=v16 ----

vtmmu.tvv mt0, v8, v16
# CHECK: vtmmu.tvv mt0, v8, v16
# CHECK: encoding: [0x77,0x00,0x88,0xf2]
# DIS: vtmmu.tvv

vtmms.tvv mt0, v8, v16
# CHECK: vtmms.tvv mt0, v8, v16
# CHECK: encoding: [0xf7,0x00,0x88,0xf2]
# DIS: vtmms.tvv

vtfmm.tvv mt0, v8, v16
# CHECK: vtfmm.tvv mt0, v8, v16
# CHECK: encoding: [0x77,0x10,0x88,0xf2]
# DIS: vtfmm.tvv

vtfmm.alt.tvv mt0, v8, v16
# CHECK: vtfmm.alt.tvv mt0, v8, v16
# CHECK: encoding: [0xf7,0x10,0x88,0xf2]
# DIS: vtfmm.alt.tvv


# ---- rdhi3 variation (mt4 -> bit[11:9] = 1) ----

vtmmu.tvv mt4, v8, v16
# CHECK: vtmmu.tvv mt4, v8, v16
# CHECK: encoding: [0x77,0x02,0x88,0xf2]
# DIS: vtmmu.tvv