; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu | FileCheck %s

define i1 @foo(i64* %0) {
; CHECK-LABEL: foo:
; CHECK:       # %bb.0: # %top
; CHECK-NEXT:    movq (%rdi), %rax
; CHECK-NEXT:    andq $-2147483648, %rax # imm = 0x80000000
; CHECK-NEXT:    sete %al
; CHECK-NEXT:    retq
top:
  %1 = load i64, i64* %0, !range !0
  %2 = icmp ult i64 %1, 2147483648
  ret i1 %2
}

!0 = !{i64 0, i64 10000000000}
