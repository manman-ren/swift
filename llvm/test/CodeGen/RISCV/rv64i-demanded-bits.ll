; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv64 -mattr=+m -verify-machineinstrs < %s | FileCheck %s

; This test has multiple opportunities for SimplifyDemandedBits after type
; legalization. There are 2 opportunities on the chain feeding the LHS of the
; shl. And one opportunity on the shift amount. We previously weren't managing
; the DAGCombiner worklist correctly and failed to get the RHS.

define i32 @foo(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: foo:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mulw a0, a0, a0
; CHECK-NEXT:    addi a0, a0, 1
; CHECK-NEXT:    mul a0, a0, a0
; CHECK-NEXT:    add a0, a0, a2
; CHECK-NEXT:    addi a0, a0, 1
; CHECK-NEXT:    slli a1, a1, 32
; CHECK-NEXT:    srli a1, a1, 32
; CHECK-NEXT:    sllw a0, a0, a1
; CHECK-NEXT:    ret
  %b = mul i32 %x, %x
  %c = add i32 %b, 1
  %d = mul i32 %c, %c
  %e = add i32 %d, %z
  %f = add i32 %e, 1
  %g = shl i32 %f, %y
  ret i32 %g
}
