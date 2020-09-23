; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-amd-amdpal -mcpu=gfx900 -mattr=+unaligned-access-mode -verify-machineinstrs < %s | FileCheck -check-prefixes=GCN,GFX9 %s
; RUN: llc -global-isel -mtriple=amdgcn-amd-amdpal -mcpu=hawaii -mattr=+unaligned-access-mode -verify-machineinstrs < %s | FileCheck -check-prefixes=GCN,GFX7 %s

; Unaligned DS access in available from GFX9 onwards.
; LDS alignment enforcement is controlled by a configuration register:
; SH_MEM_CONFIG.alignment_mode

define <4 x i32> @load_lds_v4i32_align1(<4 x i32> addrspace(3)* %ptr) {
; GFX9-LABEL: load_lds_v4i32_align1:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    ds_read_b128 v[0:3], v0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-LABEL: load_lds_v4i32_align1:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    s_mov_b32 m0, -1
; GFX7-NEXT:    s_movk_i32 s4, 0xff
; GFX7-NEXT:    ds_read_u8 v1, v0
; GFX7-NEXT:    ds_read_u8 v2, v0 offset:1
; GFX7-NEXT:    ds_read_u8 v4, v0 offset:2
; GFX7-NEXT:    ds_read_u8 v5, v0 offset:3
; GFX7-NEXT:    ds_read_u8 v6, v0 offset:4
; GFX7-NEXT:    ds_read_u8 v7, v0 offset:5
; GFX7-NEXT:    ds_read_u8 v8, v0 offset:6
; GFX7-NEXT:    ds_read_u8 v9, v0 offset:7
; GFX7-NEXT:    s_waitcnt lgkmcnt(6)
; GFX7-NEXT:    v_and_b32_e32 v2, s4, v2
; GFX7-NEXT:    v_and_b32_e32 v1, s4, v1
; GFX7-NEXT:    v_lshlrev_b32_e32 v2, 8, v2
; GFX7-NEXT:    v_or_b32_e32 v1, v1, v2
; GFX7-NEXT:    s_waitcnt lgkmcnt(5)
; GFX7-NEXT:    v_and_b32_e32 v2, s4, v4
; GFX7-NEXT:    v_lshlrev_b32_e32 v2, 16, v2
; GFX7-NEXT:    v_or_b32_e32 v1, v1, v2
; GFX7-NEXT:    s_waitcnt lgkmcnt(4)
; GFX7-NEXT:    v_and_b32_e32 v2, s4, v5
; GFX7-NEXT:    v_lshlrev_b32_e32 v2, 24, v2
; GFX7-NEXT:    v_mov_b32_e32 v3, 0xff
; GFX7-NEXT:    v_or_b32_e32 v4, v1, v2
; GFX7-NEXT:    s_waitcnt lgkmcnt(2)
; GFX7-NEXT:    v_and_b32_e32 v2, v7, v3
; GFX7-NEXT:    v_and_b32_e32 v1, s4, v6
; GFX7-NEXT:    v_lshlrev_b32_e32 v2, 8, v2
; GFX7-NEXT:    v_or_b32_e32 v1, v1, v2
; GFX7-NEXT:    s_waitcnt lgkmcnt(1)
; GFX7-NEXT:    v_and_b32_e32 v2, v8, v3
; GFX7-NEXT:    v_lshlrev_b32_e32 v2, 16, v2
; GFX7-NEXT:    v_or_b32_e32 v1, v1, v2
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    v_and_b32_e32 v2, v9, v3
; GFX7-NEXT:    v_lshlrev_b32_e32 v2, 24, v2
; GFX7-NEXT:    v_or_b32_e32 v1, v1, v2
; GFX7-NEXT:    ds_read_u8 v2, v0 offset:8
; GFX7-NEXT:    ds_read_u8 v5, v0 offset:9
; GFX7-NEXT:    ds_read_u8 v6, v0 offset:10
; GFX7-NEXT:    ds_read_u8 v7, v0 offset:11
; GFX7-NEXT:    ds_read_u8 v8, v0 offset:12
; GFX7-NEXT:    ds_read_u8 v9, v0 offset:13
; GFX7-NEXT:    ds_read_u8 v10, v0 offset:14
; GFX7-NEXT:    ds_read_u8 v0, v0 offset:15
; GFX7-NEXT:    s_waitcnt lgkmcnt(6)
; GFX7-NEXT:    v_and_b32_e32 v5, v5, v3
; GFX7-NEXT:    v_and_b32_e32 v2, v2, v3
; GFX7-NEXT:    v_lshlrev_b32_e32 v5, 8, v5
; GFX7-NEXT:    v_or_b32_e32 v2, v2, v5
; GFX7-NEXT:    s_waitcnt lgkmcnt(5)
; GFX7-NEXT:    v_and_b32_e32 v5, v6, v3
; GFX7-NEXT:    v_lshlrev_b32_e32 v5, 16, v5
; GFX7-NEXT:    v_or_b32_e32 v2, v2, v5
; GFX7-NEXT:    s_waitcnt lgkmcnt(4)
; GFX7-NEXT:    v_and_b32_e32 v5, v7, v3
; GFX7-NEXT:    s_waitcnt lgkmcnt(2)
; GFX7-NEXT:    v_and_b32_e32 v6, v9, v3
; GFX7-NEXT:    v_lshlrev_b32_e32 v5, 24, v5
; GFX7-NEXT:    v_or_b32_e32 v2, v2, v5
; GFX7-NEXT:    v_and_b32_e32 v5, v8, v3
; GFX7-NEXT:    v_lshlrev_b32_e32 v6, 8, v6
; GFX7-NEXT:    v_or_b32_e32 v5, v5, v6
; GFX7-NEXT:    s_waitcnt lgkmcnt(1)
; GFX7-NEXT:    v_and_b32_e32 v6, v10, v3
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    v_and_b32_e32 v0, v0, v3
; GFX7-NEXT:    v_lshlrev_b32_e32 v6, 16, v6
; GFX7-NEXT:    v_or_b32_e32 v5, v5, v6
; GFX7-NEXT:    v_lshlrev_b32_e32 v0, 24, v0
; GFX7-NEXT:    v_or_b32_e32 v3, v5, v0
; GFX7-NEXT:    v_mov_b32_e32 v0, v4
; GFX7-NEXT:    s_setpc_b64 s[30:31]
  %load = load <4 x i32>, <4 x i32> addrspace(3)* %ptr, align 1
  ret <4 x i32> %load
}

define <3 x i32> @load_lds_v3i32_align1(<3 x i32> addrspace(3)* %ptr) {
; GFX9-LABEL: load_lds_v3i32_align1:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    ds_read_b96 v[0:2], v0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-LABEL: load_lds_v3i32_align1:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    s_mov_b32 m0, -1
; GFX7-NEXT:    v_mov_b32_e32 v2, v0
; GFX7-NEXT:    s_movk_i32 s4, 0xff
; GFX7-NEXT:    ds_read_u8 v0, v0
; GFX7-NEXT:    ds_read_u8 v1, v2 offset:1
; GFX7-NEXT:    ds_read_u8 v4, v2 offset:2
; GFX7-NEXT:    ds_read_u8 v5, v2 offset:3
; GFX7-NEXT:    ds_read_u8 v6, v2 offset:4
; GFX7-NEXT:    ds_read_u8 v7, v2 offset:5
; GFX7-NEXT:    ds_read_u8 v8, v2 offset:6
; GFX7-NEXT:    ds_read_u8 v9, v2 offset:7
; GFX7-NEXT:    s_waitcnt lgkmcnt(6)
; GFX7-NEXT:    v_and_b32_e32 v1, s4, v1
; GFX7-NEXT:    v_and_b32_e32 v0, s4, v0
; GFX7-NEXT:    v_lshlrev_b32_e32 v1, 8, v1
; GFX7-NEXT:    v_or_b32_e32 v0, v0, v1
; GFX7-NEXT:    s_waitcnt lgkmcnt(5)
; GFX7-NEXT:    v_and_b32_e32 v1, s4, v4
; GFX7-NEXT:    v_lshlrev_b32_e32 v1, 16, v1
; GFX7-NEXT:    v_mov_b32_e32 v3, 0xff
; GFX7-NEXT:    v_or_b32_e32 v0, v0, v1
; GFX7-NEXT:    s_waitcnt lgkmcnt(4)
; GFX7-NEXT:    v_and_b32_e32 v1, s4, v5
; GFX7-NEXT:    s_waitcnt lgkmcnt(2)
; GFX7-NEXT:    v_and_b32_e32 v4, v7, v3
; GFX7-NEXT:    v_lshlrev_b32_e32 v1, 24, v1
; GFX7-NEXT:    v_or_b32_e32 v0, v0, v1
; GFX7-NEXT:    v_and_b32_e32 v1, s4, v6
; GFX7-NEXT:    v_lshlrev_b32_e32 v4, 8, v4
; GFX7-NEXT:    v_or_b32_e32 v1, v1, v4
; GFX7-NEXT:    s_waitcnt lgkmcnt(1)
; GFX7-NEXT:    v_and_b32_e32 v4, v8, v3
; GFX7-NEXT:    v_lshlrev_b32_e32 v4, 16, v4
; GFX7-NEXT:    v_or_b32_e32 v1, v1, v4
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    v_and_b32_e32 v4, v9, v3
; GFX7-NEXT:    v_lshlrev_b32_e32 v4, 24, v4
; GFX7-NEXT:    v_or_b32_e32 v1, v1, v4
; GFX7-NEXT:    ds_read_u8 v4, v2 offset:8
; GFX7-NEXT:    ds_read_u8 v5, v2 offset:9
; GFX7-NEXT:    ds_read_u8 v6, v2 offset:10
; GFX7-NEXT:    ds_read_u8 v2, v2 offset:11
; GFX7-NEXT:    s_waitcnt lgkmcnt(3)
; GFX7-NEXT:    v_and_b32_e32 v4, v4, v3
; GFX7-NEXT:    s_waitcnt lgkmcnt(2)
; GFX7-NEXT:    v_and_b32_e32 v5, v5, v3
; GFX7-NEXT:    v_lshlrev_b32_e32 v5, 8, v5
; GFX7-NEXT:    v_or_b32_e32 v4, v4, v5
; GFX7-NEXT:    s_waitcnt lgkmcnt(1)
; GFX7-NEXT:    v_and_b32_e32 v5, v6, v3
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    v_and_b32_e32 v2, v2, v3
; GFX7-NEXT:    v_lshlrev_b32_e32 v5, 16, v5
; GFX7-NEXT:    v_or_b32_e32 v4, v4, v5
; GFX7-NEXT:    v_lshlrev_b32_e32 v2, 24, v2
; GFX7-NEXT:    v_or_b32_e32 v2, v4, v2
; GFX7-NEXT:    s_setpc_b64 s[30:31]
  %load = load <3 x i32>, <3 x i32> addrspace(3)* %ptr, align 1
  ret <3 x i32> %load
}

define void @store_lds_v4i32_align1(<4 x i32> addrspace(3)* %out, <4 x i32> %x) {
; GFX9-LABEL: store_lds_v4i32_align1:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    ds_write_b128 v0, v[1:4]
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-LABEL: store_lds_v4i32_align1:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    s_mov_b32 m0, -1
; GFX7-NEXT:    v_lshrrev_b32_e32 v5, 8, v1
; GFX7-NEXT:    v_lshrrev_b32_e32 v6, 16, v1
; GFX7-NEXT:    v_lshrrev_b32_e32 v7, 24, v1
; GFX7-NEXT:    ds_write_b8 v0, v1
; GFX7-NEXT:    ds_write_b8 v0, v5 offset:1
; GFX7-NEXT:    ds_write_b8 v0, v6 offset:2
; GFX7-NEXT:    ds_write_b8 v0, v7 offset:3
; GFX7-NEXT:    v_lshrrev_b32_e32 v1, 8, v2
; GFX7-NEXT:    v_lshrrev_b32_e32 v5, 16, v2
; GFX7-NEXT:    v_lshrrev_b32_e32 v6, 24, v2
; GFX7-NEXT:    ds_write_b8 v0, v2 offset:4
; GFX7-NEXT:    ds_write_b8 v0, v1 offset:5
; GFX7-NEXT:    ds_write_b8 v0, v5 offset:6
; GFX7-NEXT:    ds_write_b8 v0, v6 offset:7
; GFX7-NEXT:    v_lshrrev_b32_e32 v1, 8, v3
; GFX7-NEXT:    v_lshrrev_b32_e32 v2, 16, v3
; GFX7-NEXT:    v_lshrrev_b32_e32 v5, 24, v3
; GFX7-NEXT:    ds_write_b8 v0, v3 offset:8
; GFX7-NEXT:    ds_write_b8 v0, v1 offset:9
; GFX7-NEXT:    ds_write_b8 v0, v2 offset:10
; GFX7-NEXT:    ds_write_b8 v0, v5 offset:11
; GFX7-NEXT:    v_lshrrev_b32_e32 v1, 8, v4
; GFX7-NEXT:    v_lshrrev_b32_e32 v2, 16, v4
; GFX7-NEXT:    v_lshrrev_b32_e32 v3, 24, v4
; GFX7-NEXT:    ds_write_b8 v0, v4 offset:12
; GFX7-NEXT:    ds_write_b8 v0, v1 offset:13
; GFX7-NEXT:    ds_write_b8 v0, v2 offset:14
; GFX7-NEXT:    ds_write_b8 v0, v3 offset:15
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    s_setpc_b64 s[30:31]
  store <4 x i32> %x, <4 x i32> addrspace(3)* %out, align 1
  ret void
}

define void @store_lds_v3i32_align1(<3 x i32> addrspace(3)* %out, <3 x i32> %x) {
; GFX9-LABEL: store_lds_v3i32_align1:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    ds_write_b96 v0, v[1:3]
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-LABEL: store_lds_v3i32_align1:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    v_lshrrev_b32_e32 v4, 8, v1
; GFX7-NEXT:    s_mov_b32 m0, -1
; GFX7-NEXT:    v_lshrrev_b32_e32 v5, 16, v1
; GFX7-NEXT:    v_lshrrev_b32_e32 v6, 24, v1
; GFX7-NEXT:    ds_write_b8 v0, v1
; GFX7-NEXT:    ds_write_b8 v0, v4 offset:1
; GFX7-NEXT:    ds_write_b8 v0, v5 offset:2
; GFX7-NEXT:    ds_write_b8 v0, v6 offset:3
; GFX7-NEXT:    v_lshrrev_b32_e32 v1, 8, v2
; GFX7-NEXT:    v_lshrrev_b32_e32 v4, 16, v2
; GFX7-NEXT:    v_lshrrev_b32_e32 v5, 24, v2
; GFX7-NEXT:    ds_write_b8 v0, v2 offset:4
; GFX7-NEXT:    ds_write_b8 v0, v1 offset:5
; GFX7-NEXT:    ds_write_b8 v0, v4 offset:6
; GFX7-NEXT:    ds_write_b8 v0, v5 offset:7
; GFX7-NEXT:    v_lshrrev_b32_e32 v1, 8, v3
; GFX7-NEXT:    v_lshrrev_b32_e32 v2, 16, v3
; GFX7-NEXT:    v_lshrrev_b32_e32 v4, 24, v3
; GFX7-NEXT:    ds_write_b8 v0, v3 offset:8
; GFX7-NEXT:    ds_write_b8 v0, v1 offset:9
; GFX7-NEXT:    ds_write_b8 v0, v2 offset:10
; GFX7-NEXT:    ds_write_b8 v0, v4 offset:11
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    s_setpc_b64 s[30:31]
  store <3 x i32> %x, <3 x i32> addrspace(3)* %out, align 1
  ret void
}
