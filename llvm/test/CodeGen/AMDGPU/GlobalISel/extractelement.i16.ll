; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=gfx900 -verify-machineinstrs < %s | FileCheck -check-prefixes=GCN,GFX9 %s
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=fiji -verify-machineinstrs < %s | FileCheck -check-prefixes=GCN,GFX8 %s
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=hawaii -verify-machineinstrs < %s | FileCheck -check-prefixes=GCN,GFX7 %s

define amdgpu_ps i16 @extractelement_sgpr_v4i16_sgpr_idx(<4 x i16> addrspace(4)* inreg %ptr, i32 inreg %idx) {
; GCN-LABEL: extractelement_sgpr_v4i16_sgpr_idx:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dwordx2 s[0:1], s[2:3], 0x0
; GCN-NEXT:    s_lshr_b32 s2, s4, 1
; GCN-NEXT:    s_cmp_eq_u32 s2, 1
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_cselect_b32 s0, s1, s0
; GCN-NEXT:    s_and_b32 s1, s4, 1
; GCN-NEXT:    s_lshl_b32 s1, s1, 4
; GCN-NEXT:    s_lshr_b32 s0, s0, s1
; GCN-NEXT:    ; return to shader part epilog
  %vector = load <4 x i16>, <4 x i16> addrspace(4)* %ptr
  %element = extractelement <4 x i16> %vector, i32 %idx
  ret i16 %element
}

define amdgpu_ps i16 @extractelement_vgpr_v4i16_sgpr_idx(<4 x i16> addrspace(1)* %ptr, i32 inreg %idx) {
; GFX9-LABEL: extractelement_vgpr_v4i16_sgpr_idx:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    global_load_dwordx2 v[0:1], v[0:1], off
; GFX9-NEXT:    s_lshr_b32 s0, s2, 1
; GFX9-NEXT:    v_cmp_eq_u32_e64 vcc, s0, 1
; GFX9-NEXT:    s_and_b32 s1, s2, 1
; GFX9-NEXT:    s_lshl_b32 s0, s1, 4
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_cndmask_b32_e32 v0, v0, v1, vcc
; GFX9-NEXT:    v_lshrrev_b32_e32 v0, s0, v0
; GFX9-NEXT:    v_readfirstlane_b32 s0, v0
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX8-LABEL: extractelement_vgpr_v4i16_sgpr_idx:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    flat_load_dwordx2 v[0:1], v[0:1]
; GFX8-NEXT:    s_lshr_b32 s0, s2, 1
; GFX8-NEXT:    v_cmp_eq_u32_e64 vcc, s0, 1
; GFX8-NEXT:    s_and_b32 s1, s2, 1
; GFX8-NEXT:    s_lshl_b32 s0, s1, 4
; GFX8-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_cndmask_b32_e32 v0, v0, v1, vcc
; GFX8-NEXT:    v_lshrrev_b32_e32 v0, s0, v0
; GFX8-NEXT:    v_readfirstlane_b32 s0, v0
; GFX8-NEXT:    ; return to shader part epilog
;
; GFX7-LABEL: extractelement_vgpr_v4i16_sgpr_idx:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    flat_load_dwordx2 v[0:1], v[0:1]
; GFX7-NEXT:    s_lshr_b32 s0, s2, 1
; GFX7-NEXT:    v_cmp_eq_u32_e64 vcc, s0, 1
; GFX7-NEXT:    s_and_b32 s1, s2, 1
; GFX7-NEXT:    s_lshl_b32 s0, s1, 4
; GFX7-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX7-NEXT:    v_cndmask_b32_e32 v0, v0, v1, vcc
; GFX7-NEXT:    v_lshrrev_b32_e32 v0, s0, v0
; GFX7-NEXT:    v_readfirstlane_b32 s0, v0
; GFX7-NEXT:    ; return to shader part epilog
  %vector = load <4 x i16>, <4 x i16> addrspace(1)* %ptr
  %element = extractelement <4 x i16> %vector, i32 %idx
  ret i16 %element
}

define i16 @extractelement_vgpr_v4i16_vgpr_idx(<4 x i16> addrspace(1)* %ptr, i32 %idx) {
; GFX9-LABEL: extractelement_vgpr_v4i16_vgpr_idx:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    global_load_dwordx2 v[0:1], v[0:1], off
; GFX9-NEXT:    v_lshrrev_b32_e32 v3, 1, v2
; GFX9-NEXT:    v_cmp_eq_u32_e32 vcc, 1, v3
; GFX9-NEXT:    v_and_b32_e32 v2, 1, v2
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_cndmask_b32_e32 v0, v0, v1, vcc
; GFX9-NEXT:    v_lshlrev_b32_e32 v1, 4, v2
; GFX9-NEXT:    v_lshrrev_b32_e32 v0, v1, v0
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: extractelement_vgpr_v4i16_vgpr_idx:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    flat_load_dwordx2 v[0:1], v[0:1]
; GFX8-NEXT:    v_lshrrev_b32_e32 v3, 1, v2
; GFX8-NEXT:    v_cmp_eq_u32_e32 vcc, 1, v3
; GFX8-NEXT:    v_and_b32_e32 v2, 1, v2
; GFX8-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_cndmask_b32_e32 v0, v0, v1, vcc
; GFX8-NEXT:    v_lshlrev_b32_e32 v1, 4, v2
; GFX8-NEXT:    v_lshrrev_b32_e32 v0, v1, v0
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-LABEL: extractelement_vgpr_v4i16_vgpr_idx:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    flat_load_dwordx2 v[0:1], v[0:1]
; GFX7-NEXT:    v_lshrrev_b32_e32 v3, 1, v2
; GFX7-NEXT:    v_cmp_eq_u32_e32 vcc, 1, v3
; GFX7-NEXT:    v_and_b32_e32 v2, 1, v2
; GFX7-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX7-NEXT:    v_cndmask_b32_e32 v0, v0, v1, vcc
; GFX7-NEXT:    v_lshlrev_b32_e32 v1, 4, v2
; GFX7-NEXT:    v_lshrrev_b32_e32 v0, v1, v0
; GFX7-NEXT:    s_setpc_b64 s[30:31]
  %vector = load <4 x i16>, <4 x i16> addrspace(1)* %ptr
  %element = extractelement <4 x i16> %vector, i32 %idx
  ret i16 %element
}

define amdgpu_ps i16 @extractelement_sgpr_v4i16_vgpr_idx(<4 x i16> addrspace(4)* inreg %ptr, i32 %idx) {
; GCN-LABEL: extractelement_sgpr_v4i16_vgpr_idx:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dwordx2 s[0:1], s[2:3], 0x0
; GCN-NEXT:    v_lshrrev_b32_e32 v1, 1, v0
; GCN-NEXT:    v_and_b32_e32 v0, 1, v0
; GCN-NEXT:    v_cmp_eq_u32_e32 vcc, 1, v1
; GCN-NEXT:    v_lshlrev_b32_e32 v0, 4, v0
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    v_mov_b32_e32 v2, s0
; GCN-NEXT:    v_mov_b32_e32 v3, s1
; GCN-NEXT:    v_cndmask_b32_e32 v1, v2, v3, vcc
; GCN-NEXT:    v_lshrrev_b32_e32 v0, v0, v1
; GCN-NEXT:    v_readfirstlane_b32 s0, v0
; GCN-NEXT:    ; return to shader part epilog
  %vector = load <4 x i16>, <4 x i16> addrspace(4)* %ptr
  %element = extractelement <4 x i16> %vector, i32 %idx
  ret i16 %element
}

define amdgpu_ps i16 @extractelement_sgpr_v4i16_idx0(<4 x i16> addrspace(4)* inreg %ptr) {
; GCN-LABEL: extractelement_sgpr_v4i16_idx0:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dwordx2 s[0:1], s[2:3], 0x0
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    ; return to shader part epilog
  %vector = load <4 x i16>, <4 x i16> addrspace(4)* %ptr
  %element = extractelement <4 x i16> %vector, i32 0
  ret i16 %element
}

define amdgpu_ps i16 @extractelement_sgpr_v4i16_idx1(<4 x i16> addrspace(4)* inreg %ptr) {
; GCN-LABEL: extractelement_sgpr_v4i16_idx1:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dwordx2 s[0:1], s[2:3], 0x0
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_lshr_b32 s0, s0, 16
; GCN-NEXT:    ; return to shader part epilog
  %vector = load <4 x i16>, <4 x i16> addrspace(4)* %ptr
  %element = extractelement <4 x i16> %vector, i32 1
  ret i16 %element
}

define amdgpu_ps i16 @extractelement_sgpr_v4i16_idx2(<4 x i16> addrspace(4)* inreg %ptr) {
; GCN-LABEL: extractelement_sgpr_v4i16_idx2:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dwordx2 s[0:1], s[2:3], 0x0
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_mov_b32 s0, s1
; GCN-NEXT:    ; return to shader part epilog
  %vector = load <4 x i16>, <4 x i16> addrspace(4)* %ptr
  %element = extractelement <4 x i16> %vector, i32 2
  ret i16 %element
}

define amdgpu_ps i16 @extractelement_sgpr_v4i16_idx3(<4 x i16> addrspace(4)* inreg %ptr) {
; GCN-LABEL: extractelement_sgpr_v4i16_idx3:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dwordx2 s[0:1], s[2:3], 0x0
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_lshr_b32 s0, s1, 16
; GCN-NEXT:    ; return to shader part epilog
  %vector = load <4 x i16>, <4 x i16> addrspace(4)* %ptr
  %element = extractelement <4 x i16> %vector, i32 3
  ret i16 %element
}

define i16 @extractelement_vgpr_v4i16_idx0(<4 x i16> addrspace(1)* %ptr) {
; GFX9-LABEL: extractelement_vgpr_v4i16_idx0:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    global_load_dwordx2 v[0:1], v[0:1], off
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: extractelement_vgpr_v4i16_idx0:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    flat_load_dwordx2 v[0:1], v[0:1]
; GFX8-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-LABEL: extractelement_vgpr_v4i16_idx0:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    flat_load_dwordx2 v[0:1], v[0:1]
; GFX7-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX7-NEXT:    s_setpc_b64 s[30:31]
  %vector = load <4 x i16>, <4 x i16> addrspace(1)* %ptr
  %element = extractelement <4 x i16> %vector, i32 0
  ret i16 %element
}

define i16 @extractelement_vgpr_v4i16_idx1(<4 x i16> addrspace(1)* %ptr) {
; GFX9-LABEL: extractelement_vgpr_v4i16_idx1:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    global_load_dwordx2 v[0:1], v[0:1], off
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_lshrrev_b32_e32 v0, 16, v0
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: extractelement_vgpr_v4i16_idx1:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    flat_load_dwordx2 v[0:1], v[0:1]
; GFX8-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_lshrrev_b32_e32 v0, 16, v0
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-LABEL: extractelement_vgpr_v4i16_idx1:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    flat_load_dwordx2 v[0:1], v[0:1]
; GFX7-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX7-NEXT:    v_lshrrev_b32_e32 v0, 16, v0
; GFX7-NEXT:    s_setpc_b64 s[30:31]
  %vector = load <4 x i16>, <4 x i16> addrspace(1)* %ptr
  %element = extractelement <4 x i16> %vector, i32 1
  ret i16 %element
}

define i16 @extractelement_vgpr_v4i16_idx2(<4 x i16> addrspace(1)* %ptr) {
; GFX9-LABEL: extractelement_vgpr_v4i16_idx2:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    global_load_dwordx2 v[0:1], v[0:1], off
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_mov_b32_e32 v0, v1
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: extractelement_vgpr_v4i16_idx2:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    flat_load_dwordx2 v[0:1], v[0:1]
; GFX8-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_mov_b32_e32 v0, v1
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-LABEL: extractelement_vgpr_v4i16_idx2:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    flat_load_dwordx2 v[0:1], v[0:1]
; GFX7-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX7-NEXT:    v_mov_b32_e32 v0, v1
; GFX7-NEXT:    s_setpc_b64 s[30:31]
  %vector = load <4 x i16>, <4 x i16> addrspace(1)* %ptr
  %element = extractelement <4 x i16> %vector, i32 2
  ret i16 %element
}

define i16 @extractelement_vgpr_v4i16_idx3(<4 x i16> addrspace(1)* %ptr) {
; GFX9-LABEL: extractelement_vgpr_v4i16_idx3:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    global_load_dwordx2 v[0:1], v[0:1], off
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_lshrrev_b32_e32 v0, 16, v1
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: extractelement_vgpr_v4i16_idx3:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    flat_load_dwordx2 v[0:1], v[0:1]
; GFX8-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_lshrrev_b32_e32 v0, 16, v1
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-LABEL: extractelement_vgpr_v4i16_idx3:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    flat_load_dwordx2 v[0:1], v[0:1]
; GFX7-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX7-NEXT:    v_lshrrev_b32_e32 v0, 16, v1
; GFX7-NEXT:    s_setpc_b64 s[30:31]
  %vector = load <4 x i16>, <4 x i16> addrspace(1)* %ptr
  %element = extractelement <4 x i16> %vector, i32 3
  ret i16 %element
}

define amdgpu_ps i16 @extractelement_sgpr_v8i16_sgpr_idx(<8 x i16> addrspace(4)* inreg %ptr, i32 inreg %idx) {
; GCN-LABEL: extractelement_sgpr_v8i16_sgpr_idx:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dwordx4 s[0:3], s[2:3], 0x0
; GCN-NEXT:    s_lshr_b32 s5, s4, 1
; GCN-NEXT:    s_cmp_eq_u32 s5, 1
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_cselect_b32 s0, s1, s0
; GCN-NEXT:    s_cmp_eq_u32 s5, 2
; GCN-NEXT:    s_cselect_b32 s0, s2, s0
; GCN-NEXT:    s_cmp_eq_u32 s5, 3
; GCN-NEXT:    s_cselect_b32 s0, s3, s0
; GCN-NEXT:    s_and_b32 s1, s4, 1
; GCN-NEXT:    s_lshl_b32 s1, s1, 4
; GCN-NEXT:    s_lshr_b32 s0, s0, s1
; GCN-NEXT:    ; return to shader part epilog
  %vector = load <8 x i16>, <8 x i16> addrspace(4)* %ptr
  %element = extractelement <8 x i16> %vector, i32 %idx
  ret i16 %element
}

define amdgpu_ps i16 @extractelement_vgpr_v8i16_sgpr_idx(<8 x i16> addrspace(1)* %ptr, i32 inreg %idx) {
; GFX9-LABEL: extractelement_vgpr_v8i16_sgpr_idx:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    global_load_dwordx4 v[0:3], v[0:1], off
; GFX9-NEXT:    s_lshr_b32 s0, s2, 1
; GFX9-NEXT:    v_cmp_eq_u32_e64 vcc, s0, 1
; GFX9-NEXT:    s_and_b32 s1, s2, 1
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_cndmask_b32_e32 v0, v0, v1, vcc
; GFX9-NEXT:    v_cmp_eq_u32_e64 vcc, s0, 2
; GFX9-NEXT:    v_cndmask_b32_e32 v0, v0, v2, vcc
; GFX9-NEXT:    v_cmp_eq_u32_e64 vcc, s0, 3
; GFX9-NEXT:    v_cndmask_b32_e32 v0, v0, v3, vcc
; GFX9-NEXT:    s_lshl_b32 s0, s1, 4
; GFX9-NEXT:    v_lshrrev_b32_e32 v0, s0, v0
; GFX9-NEXT:    v_readfirstlane_b32 s0, v0
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX8-LABEL: extractelement_vgpr_v8i16_sgpr_idx:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    flat_load_dwordx4 v[0:3], v[0:1]
; GFX8-NEXT:    s_lshr_b32 s0, s2, 1
; GFX8-NEXT:    v_cmp_eq_u32_e64 vcc, s0, 1
; GFX8-NEXT:    s_and_b32 s1, s2, 1
; GFX8-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_cndmask_b32_e32 v0, v0, v1, vcc
; GFX8-NEXT:    v_cmp_eq_u32_e64 vcc, s0, 2
; GFX8-NEXT:    v_cndmask_b32_e32 v0, v0, v2, vcc
; GFX8-NEXT:    v_cmp_eq_u32_e64 vcc, s0, 3
; GFX8-NEXT:    v_cndmask_b32_e32 v0, v0, v3, vcc
; GFX8-NEXT:    s_lshl_b32 s0, s1, 4
; GFX8-NEXT:    v_lshrrev_b32_e32 v0, s0, v0
; GFX8-NEXT:    v_readfirstlane_b32 s0, v0
; GFX8-NEXT:    ; return to shader part epilog
;
; GFX7-LABEL: extractelement_vgpr_v8i16_sgpr_idx:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_mov_b32 s6, 0
; GFX7-NEXT:    s_mov_b32 s7, 0xf000
; GFX7-NEXT:    s_mov_b64 s[4:5], 0
; GFX7-NEXT:    buffer_load_dwordx4 v[0:3], v[0:1], s[4:7], 0 addr64
; GFX7-NEXT:    s_lshr_b32 s0, s2, 1
; GFX7-NEXT:    v_cmp_eq_u32_e64 vcc, s0, 1
; GFX7-NEXT:    s_and_b32 s1, s2, 1
; GFX7-NEXT:    s_waitcnt vmcnt(0)
; GFX7-NEXT:    v_cndmask_b32_e32 v0, v0, v1, vcc
; GFX7-NEXT:    v_cmp_eq_u32_e64 vcc, s0, 2
; GFX7-NEXT:    v_cndmask_b32_e32 v0, v0, v2, vcc
; GFX7-NEXT:    v_cmp_eq_u32_e64 vcc, s0, 3
; GFX7-NEXT:    v_cndmask_b32_e32 v0, v0, v3, vcc
; GFX7-NEXT:    s_lshl_b32 s0, s1, 4
; GFX7-NEXT:    v_lshrrev_b32_e32 v0, s0, v0
; GFX7-NEXT:    v_readfirstlane_b32 s0, v0
; GFX7-NEXT:    ; return to shader part epilog
  %vector = load <8 x i16>, <8 x i16> addrspace(1)* %ptr
  %element = extractelement <8 x i16> %vector, i32 %idx
  ret i16 %element
}

define i16 @extractelement_vgpr_v8i16_vgpr_idx(<8 x i16> addrspace(1)* %ptr, i32 %idx) {
; GFX9-LABEL: extractelement_vgpr_v8i16_vgpr_idx:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    global_load_dwordx4 v[3:6], v[0:1], off
; GFX9-NEXT:    v_lshrrev_b32_e32 v0, 1, v2
; GFX9-NEXT:    v_cmp_eq_u32_e32 vcc, 1, v0
; GFX9-NEXT:    v_and_b32_e32 v1, 1, v2
; GFX9-NEXT:    v_lshlrev_b32_e32 v1, 4, v1
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_cndmask_b32_e32 v2, v3, v4, vcc
; GFX9-NEXT:    v_cmp_eq_u32_e32 vcc, 2, v0
; GFX9-NEXT:    v_cndmask_b32_e32 v2, v2, v5, vcc
; GFX9-NEXT:    v_cmp_eq_u32_e32 vcc, 3, v0
; GFX9-NEXT:    v_cndmask_b32_e32 v0, v2, v6, vcc
; GFX9-NEXT:    v_lshrrev_b32_e32 v0, v1, v0
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: extractelement_vgpr_v8i16_vgpr_idx:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    flat_load_dwordx4 v[3:6], v[0:1]
; GFX8-NEXT:    v_lshrrev_b32_e32 v0, 1, v2
; GFX8-NEXT:    v_cmp_eq_u32_e32 vcc, 1, v0
; GFX8-NEXT:    v_and_b32_e32 v1, 1, v2
; GFX8-NEXT:    v_lshlrev_b32_e32 v1, 4, v1
; GFX8-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_cndmask_b32_e32 v2, v3, v4, vcc
; GFX8-NEXT:    v_cmp_eq_u32_e32 vcc, 2, v0
; GFX8-NEXT:    v_cndmask_b32_e32 v2, v2, v5, vcc
; GFX8-NEXT:    v_cmp_eq_u32_e32 vcc, 3, v0
; GFX8-NEXT:    v_cndmask_b32_e32 v0, v2, v6, vcc
; GFX8-NEXT:    v_lshrrev_b32_e32 v0, v1, v0
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-LABEL: extractelement_vgpr_v8i16_vgpr_idx:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    s_mov_b32 s6, 0
; GFX7-NEXT:    s_mov_b32 s7, 0xf000
; GFX7-NEXT:    s_mov_b64 s[4:5], 0
; GFX7-NEXT:    buffer_load_dwordx4 v[3:6], v[0:1], s[4:7], 0 addr64
; GFX7-NEXT:    v_lshrrev_b32_e32 v0, 1, v2
; GFX7-NEXT:    v_cmp_eq_u32_e32 vcc, 1, v0
; GFX7-NEXT:    v_and_b32_e32 v1, 1, v2
; GFX7-NEXT:    v_lshlrev_b32_e32 v1, 4, v1
; GFX7-NEXT:    s_waitcnt vmcnt(0)
; GFX7-NEXT:    v_cndmask_b32_e32 v2, v3, v4, vcc
; GFX7-NEXT:    v_cmp_eq_u32_e32 vcc, 2, v0
; GFX7-NEXT:    v_cndmask_b32_e32 v2, v2, v5, vcc
; GFX7-NEXT:    v_cmp_eq_u32_e32 vcc, 3, v0
; GFX7-NEXT:    v_cndmask_b32_e32 v0, v2, v6, vcc
; GFX7-NEXT:    v_lshrrev_b32_e32 v0, v1, v0
; GFX7-NEXT:    s_setpc_b64 s[30:31]
  %vector = load <8 x i16>, <8 x i16> addrspace(1)* %ptr
  %element = extractelement <8 x i16> %vector, i32 %idx
  ret i16 %element
}

define amdgpu_ps i16 @extractelement_sgpr_v8i16_vgpr_idx(<8 x i16> addrspace(4)* inreg %ptr, i32 %idx) {
; GCN-LABEL: extractelement_sgpr_v8i16_vgpr_idx:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dwordx4 s[0:3], s[2:3], 0x0
; GCN-NEXT:    v_lshrrev_b32_e32 v1, 1, v0
; GCN-NEXT:    v_cmp_eq_u32_e32 vcc, 1, v1
; GCN-NEXT:    v_and_b32_e32 v0, 1, v0
; GCN-NEXT:    v_lshlrev_b32_e32 v0, 4, v0
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    v_mov_b32_e32 v2, s0
; GCN-NEXT:    v_mov_b32_e32 v3, s1
; GCN-NEXT:    v_cndmask_b32_e32 v2, v2, v3, vcc
; GCN-NEXT:    v_mov_b32_e32 v4, s2
; GCN-NEXT:    v_cmp_eq_u32_e32 vcc, 2, v1
; GCN-NEXT:    v_cndmask_b32_e32 v2, v2, v4, vcc
; GCN-NEXT:    v_mov_b32_e32 v5, s3
; GCN-NEXT:    v_cmp_eq_u32_e32 vcc, 3, v1
; GCN-NEXT:    v_cndmask_b32_e32 v1, v2, v5, vcc
; GCN-NEXT:    v_lshrrev_b32_e32 v0, v0, v1
; GCN-NEXT:    v_readfirstlane_b32 s0, v0
; GCN-NEXT:    ; return to shader part epilog
  %vector = load <8 x i16>, <8 x i16> addrspace(4)* %ptr
  %element = extractelement <8 x i16> %vector, i32 %idx
  ret i16 %element
}

define amdgpu_ps i16 @extractelement_sgpr_v8i16_idx0(<8 x i16> addrspace(4)* inreg %ptr) {
; GCN-LABEL: extractelement_sgpr_v8i16_idx0:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dwordx4 s[0:3], s[2:3], 0x0
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    ; return to shader part epilog
  %vector = load <8 x i16>, <8 x i16> addrspace(4)* %ptr
  %element = extractelement <8 x i16> %vector, i32 0
  ret i16 %element
}

define amdgpu_ps i16 @extractelement_sgpr_v8i16_idx1(<8 x i16> addrspace(4)* inreg %ptr) {
; GCN-LABEL: extractelement_sgpr_v8i16_idx1:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dwordx4 s[0:3], s[2:3], 0x0
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_lshr_b32 s0, s0, 16
; GCN-NEXT:    ; return to shader part epilog
  %vector = load <8 x i16>, <8 x i16> addrspace(4)* %ptr
  %element = extractelement <8 x i16> %vector, i32 1
  ret i16 %element
}

define amdgpu_ps i16 @extractelement_sgpr_v8i16_idx2(<8 x i16> addrspace(4)* inreg %ptr) {
; GCN-LABEL: extractelement_sgpr_v8i16_idx2:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dwordx4 s[0:3], s[2:3], 0x0
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_mov_b32 s0, s1
; GCN-NEXT:    ; return to shader part epilog
  %vector = load <8 x i16>, <8 x i16> addrspace(4)* %ptr
  %element = extractelement <8 x i16> %vector, i32 2
  ret i16 %element
}

define amdgpu_ps i16 @extractelement_sgpr_v8i16_idx3(<8 x i16> addrspace(4)* inreg %ptr) {
; GCN-LABEL: extractelement_sgpr_v8i16_idx3:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dwordx4 s[0:3], s[2:3], 0x0
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_lshr_b32 s0, s1, 16
; GCN-NEXT:    ; return to shader part epilog
  %vector = load <8 x i16>, <8 x i16> addrspace(4)* %ptr
  %element = extractelement <8 x i16> %vector, i32 3
  ret i16 %element
}

define amdgpu_ps i16 @extractelement_sgpr_v8i16_idx4(<8 x i16> addrspace(4)* inreg %ptr) {
; GCN-LABEL: extractelement_sgpr_v8i16_idx4:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dwordx4 s[0:3], s[2:3], 0x0
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_mov_b32 s0, s2
; GCN-NEXT:    ; return to shader part epilog
  %vector = load <8 x i16>, <8 x i16> addrspace(4)* %ptr
  %element = extractelement <8 x i16> %vector, i32 4
  ret i16 %element
}

define amdgpu_ps i16 @extractelement_sgpr_v8i16_idx5(<8 x i16> addrspace(4)* inreg %ptr) {
; GCN-LABEL: extractelement_sgpr_v8i16_idx5:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dwordx4 s[0:3], s[2:3], 0x0
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_lshr_b32 s0, s2, 16
; GCN-NEXT:    ; return to shader part epilog
  %vector = load <8 x i16>, <8 x i16> addrspace(4)* %ptr
  %element = extractelement <8 x i16> %vector, i32 5
  ret i16 %element
}

define amdgpu_ps i16 @extractelement_sgpr_v8i16_idx6(<8 x i16> addrspace(4)* inreg %ptr) {
; GCN-LABEL: extractelement_sgpr_v8i16_idx6:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dwordx4 s[0:3], s[2:3], 0x0
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_mov_b32 s0, s3
; GCN-NEXT:    ; return to shader part epilog
  %vector = load <8 x i16>, <8 x i16> addrspace(4)* %ptr
  %element = extractelement <8 x i16> %vector, i32 6
  ret i16 %element
}

define amdgpu_ps i16 @extractelement_sgpr_v8i16_idx7(<8 x i16> addrspace(4)* inreg %ptr) {
; GCN-LABEL: extractelement_sgpr_v8i16_idx7:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dwordx4 s[0:3], s[2:3], 0x0
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_lshr_b32 s0, s3, 16
; GCN-NEXT:    ; return to shader part epilog
  %vector = load <8 x i16>, <8 x i16> addrspace(4)* %ptr
  %element = extractelement <8 x i16> %vector, i32 7
  ret i16 %element
}

define i16 @extractelement_vgpr_v8i16_idx0(<8 x i16> addrspace(1)* %ptr) {
; GFX9-LABEL: extractelement_vgpr_v8i16_idx0:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    global_load_dwordx4 v[0:3], v[0:1], off
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: extractelement_vgpr_v8i16_idx0:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    flat_load_dwordx4 v[0:3], v[0:1]
; GFX8-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-LABEL: extractelement_vgpr_v8i16_idx0:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    s_mov_b32 s6, 0
; GFX7-NEXT:    s_mov_b32 s7, 0xf000
; GFX7-NEXT:    s_mov_b64 s[4:5], 0
; GFX7-NEXT:    buffer_load_dwordx4 v[0:3], v[0:1], s[4:7], 0 addr64
; GFX7-NEXT:    s_waitcnt vmcnt(0)
; GFX7-NEXT:    s_setpc_b64 s[30:31]
  %vector = load <8 x i16>, <8 x i16> addrspace(1)* %ptr
  %element = extractelement <8 x i16> %vector, i32 0
  ret i16 %element
}

define i16 @extractelement_vgpr_v8i16_idx1(<8 x i16> addrspace(1)* %ptr) {
; GFX9-LABEL: extractelement_vgpr_v8i16_idx1:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    global_load_dwordx4 v[0:3], v[0:1], off
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_lshrrev_b32_e32 v0, 16, v0
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: extractelement_vgpr_v8i16_idx1:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    flat_load_dwordx4 v[0:3], v[0:1]
; GFX8-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_lshrrev_b32_e32 v0, 16, v0
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-LABEL: extractelement_vgpr_v8i16_idx1:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    s_mov_b32 s6, 0
; GFX7-NEXT:    s_mov_b32 s7, 0xf000
; GFX7-NEXT:    s_mov_b64 s[4:5], 0
; GFX7-NEXT:    buffer_load_dwordx4 v[0:3], v[0:1], s[4:7], 0 addr64
; GFX7-NEXT:    s_waitcnt vmcnt(0)
; GFX7-NEXT:    v_lshrrev_b32_e32 v0, 16, v0
; GFX7-NEXT:    s_setpc_b64 s[30:31]
  %vector = load <8 x i16>, <8 x i16> addrspace(1)* %ptr
  %element = extractelement <8 x i16> %vector, i32 1
  ret i16 %element
}

define i16 @extractelement_vgpr_v8i16_idx2(<8 x i16> addrspace(1)* %ptr) {
; GFX9-LABEL: extractelement_vgpr_v8i16_idx2:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    global_load_dwordx4 v[0:3], v[0:1], off
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_mov_b32_e32 v0, v1
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: extractelement_vgpr_v8i16_idx2:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    flat_load_dwordx4 v[0:3], v[0:1]
; GFX8-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_mov_b32_e32 v0, v1
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-LABEL: extractelement_vgpr_v8i16_idx2:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    s_mov_b32 s6, 0
; GFX7-NEXT:    s_mov_b32 s7, 0xf000
; GFX7-NEXT:    s_mov_b64 s[4:5], 0
; GFX7-NEXT:    buffer_load_dwordx4 v[0:3], v[0:1], s[4:7], 0 addr64
; GFX7-NEXT:    s_waitcnt vmcnt(0)
; GFX7-NEXT:    v_mov_b32_e32 v0, v1
; GFX7-NEXT:    s_setpc_b64 s[30:31]
  %vector = load <8 x i16>, <8 x i16> addrspace(1)* %ptr
  %element = extractelement <8 x i16> %vector, i32 2
  ret i16 %element
}

define i16 @extractelement_vgpr_v8i16_idx3(<8 x i16> addrspace(1)* %ptr) {
; GFX9-LABEL: extractelement_vgpr_v8i16_idx3:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    global_load_dwordx4 v[0:3], v[0:1], off
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_lshrrev_b32_e32 v0, 16, v1
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: extractelement_vgpr_v8i16_idx3:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    flat_load_dwordx4 v[0:3], v[0:1]
; GFX8-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_lshrrev_b32_e32 v0, 16, v1
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-LABEL: extractelement_vgpr_v8i16_idx3:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    s_mov_b32 s6, 0
; GFX7-NEXT:    s_mov_b32 s7, 0xf000
; GFX7-NEXT:    s_mov_b64 s[4:5], 0
; GFX7-NEXT:    buffer_load_dwordx4 v[0:3], v[0:1], s[4:7], 0 addr64
; GFX7-NEXT:    s_waitcnt vmcnt(0)
; GFX7-NEXT:    v_lshrrev_b32_e32 v0, 16, v1
; GFX7-NEXT:    s_setpc_b64 s[30:31]
  %vector = load <8 x i16>, <8 x i16> addrspace(1)* %ptr
  %element = extractelement <8 x i16> %vector, i32 3
  ret i16 %element
}

define i16 @extractelement_vgpr_v8i16_idx4(<8 x i16> addrspace(1)* %ptr) {
; GFX9-LABEL: extractelement_vgpr_v8i16_idx4:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    global_load_dwordx4 v[0:3], v[0:1], off
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_mov_b32_e32 v0, v2
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: extractelement_vgpr_v8i16_idx4:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    flat_load_dwordx4 v[0:3], v[0:1]
; GFX8-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_mov_b32_e32 v0, v2
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-LABEL: extractelement_vgpr_v8i16_idx4:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    s_mov_b32 s6, 0
; GFX7-NEXT:    s_mov_b32 s7, 0xf000
; GFX7-NEXT:    s_mov_b64 s[4:5], 0
; GFX7-NEXT:    buffer_load_dwordx4 v[0:3], v[0:1], s[4:7], 0 addr64
; GFX7-NEXT:    s_waitcnt vmcnt(0)
; GFX7-NEXT:    v_mov_b32_e32 v0, v2
; GFX7-NEXT:    s_setpc_b64 s[30:31]
  %vector = load <8 x i16>, <8 x i16> addrspace(1)* %ptr
  %element = extractelement <8 x i16> %vector, i32 4
  ret i16 %element
}

define i16 @extractelement_vgpr_v8i16_idx5(<8 x i16> addrspace(1)* %ptr) {
; GFX9-LABEL: extractelement_vgpr_v8i16_idx5:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    global_load_dwordx4 v[0:3], v[0:1], off
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_lshrrev_b32_e32 v0, 16, v2
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: extractelement_vgpr_v8i16_idx5:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    flat_load_dwordx4 v[0:3], v[0:1]
; GFX8-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_lshrrev_b32_e32 v0, 16, v2
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-LABEL: extractelement_vgpr_v8i16_idx5:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    s_mov_b32 s6, 0
; GFX7-NEXT:    s_mov_b32 s7, 0xf000
; GFX7-NEXT:    s_mov_b64 s[4:5], 0
; GFX7-NEXT:    buffer_load_dwordx4 v[0:3], v[0:1], s[4:7], 0 addr64
; GFX7-NEXT:    s_waitcnt vmcnt(0)
; GFX7-NEXT:    v_lshrrev_b32_e32 v0, 16, v2
; GFX7-NEXT:    s_setpc_b64 s[30:31]
  %vector = load <8 x i16>, <8 x i16> addrspace(1)* %ptr
  %element = extractelement <8 x i16> %vector, i32 5
  ret i16 %element
}

define i16 @extractelement_vgpr_v8i16_idx6(<8 x i16> addrspace(1)* %ptr) {
; GFX9-LABEL: extractelement_vgpr_v8i16_idx6:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    global_load_dwordx4 v[0:3], v[0:1], off
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_mov_b32_e32 v0, v3
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: extractelement_vgpr_v8i16_idx6:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    flat_load_dwordx4 v[0:3], v[0:1]
; GFX8-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_mov_b32_e32 v0, v3
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-LABEL: extractelement_vgpr_v8i16_idx6:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    s_mov_b32 s6, 0
; GFX7-NEXT:    s_mov_b32 s7, 0xf000
; GFX7-NEXT:    s_mov_b64 s[4:5], 0
; GFX7-NEXT:    buffer_load_dwordx4 v[0:3], v[0:1], s[4:7], 0 addr64
; GFX7-NEXT:    s_waitcnt vmcnt(0)
; GFX7-NEXT:    v_mov_b32_e32 v0, v3
; GFX7-NEXT:    s_setpc_b64 s[30:31]
  %vector = load <8 x i16>, <8 x i16> addrspace(1)* %ptr
  %element = extractelement <8 x i16> %vector, i32 6
  ret i16 %element
}

define i16 @extractelement_vgpr_v8i16_idx7(<8 x i16> addrspace(1)* %ptr) {
; GFX9-LABEL: extractelement_vgpr_v8i16_idx7:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    global_load_dwordx4 v[0:3], v[0:1], off
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_lshrrev_b32_e32 v0, 16, v3
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: extractelement_vgpr_v8i16_idx7:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    flat_load_dwordx4 v[0:3], v[0:1]
; GFX8-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_lshrrev_b32_e32 v0, 16, v3
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-LABEL: extractelement_vgpr_v8i16_idx7:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    s_mov_b32 s6, 0
; GFX7-NEXT:    s_mov_b32 s7, 0xf000
; GFX7-NEXT:    s_mov_b64 s[4:5], 0
; GFX7-NEXT:    buffer_load_dwordx4 v[0:3], v[0:1], s[4:7], 0 addr64
; GFX7-NEXT:    s_waitcnt vmcnt(0)
; GFX7-NEXT:    v_lshrrev_b32_e32 v0, 16, v3
; GFX7-NEXT:    s_setpc_b64 s[30:31]
  %vector = load <8 x i16>, <8 x i16> addrspace(1)* %ptr
  %element = extractelement <8 x i16> %vector, i32 7
  ret i16 %element
}
