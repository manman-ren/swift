; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; Test 32-bit rotates left.
;
; RUN: llc < %s -mtriple=s390x-linux-gnu | FileCheck %s

; Check the low end of the RLLG range.
define i64 @f1(i64 %a) {
; CHECK-LABEL: f1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    rllg %r2, %r2, 1
; CHECK-NEXT:    br %r14
  %parta = shl i64 %a, 1
  %partb = lshr i64 %a, 63
  %or = or i64 %parta, %partb
  ret i64 %or
}

; Check the high end of the defined RLLG range.
define i64 @f2(i64 %a) {
; CHECK-LABEL: f2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    rllg %r2, %r2, 63
; CHECK-NEXT:    br %r14
  %parta = shl i64 %a, 63
  %partb = lshr i64 %a, 1
  %or = or i64 %parta, %partb
  ret i64 %or
}

; We don't generate shifts by out-of-range values.
define i64 @f3(i64 %a) {
; CHECK-LABEL: f3:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lghi %r2, -1
; CHECK-NEXT:    br %r14
  %parta = shl i64 %a, 64
  %partb = lshr i64 %a, 0
  %or = or i64 %parta, %partb
  ret i64 %or
}

; Check variable shifts.
define i64 @f4(i64 %a, i64 %amt) {
; CHECK-LABEL: f4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    rllg %r2, %r2, 0(%r3)
; CHECK-NEXT:    br %r14
  %amtb = sub i64 64, %amt
  %parta = shl i64 %a, %amt
  %partb = lshr i64 %a, %amtb
  %or = or i64 %parta, %partb
  ret i64 %or
}

; Check shift amounts that have a constant term.
define i64 @f5(i64 %a, i64 %amt) {
; CHECK-LABEL: f5:
; CHECK:       # %bb.0:
; CHECK-NEXT:    rllg %r2, %r2, 10(%r3)
; CHECK-NEXT:    br %r14
  %add = add i64 %amt, 10
  %sub = sub i64 64, %add
  %parta = shl i64 %a, %add
  %partb = lshr i64 %a, %sub
  %or = or i64 %parta, %partb
  ret i64 %or
}

; ...and again with a sign-extended 32-bit shift amount.
define i64 @f6(i64 %a, i32 %amt) {
; CHECK-LABEL: f6:
; CHECK:       # %bb.0:
; CHECK-NEXT:    rllg %r2, %r2, 10(%r3)
; CHECK-NEXT:    br %r14
  %add = add i32 %amt, 10
  %sub = sub i32 64, %add
  %addext = sext i32 %add to i64
  %subext = sext i32 %sub to i64
  %parta = shl i64 %a, %addext
  %partb = lshr i64 %a, %subext
  %or = or i64 %parta, %partb
  ret i64 %or
}

; ...and now with a zero-extended 32-bit shift amount.
define i64 @f7(i64 %a, i32 %amt) {
; CHECK-LABEL: f7:
; CHECK:       # %bb.0:
; CHECK-NEXT:    rllg %r2, %r2, 10(%r3)
; CHECK-NEXT:    br %r14
  %add = add i32 %amt, 10
  %sub = sub i32 64, %add
  %addext = zext i32 %add to i64
  %subext = zext i32 %sub to i64
  %parta = shl i64 %a, %addext
  %partb = lshr i64 %a, %subext
  %or = or i64 %parta, %partb
  ret i64 %or
}

; Check shift amounts that have the largest in-range constant term, and then
; mask the amount.
define i64 @f8(i64 %a, i64 %amt) {
; CHECK-LABEL: f8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    rllg %r2, %r2, -1(%r3)
; CHECK-NEXT:    br %r14
  %add = add i64 %amt, 524287
  %sub = sub i64 64, %add
  %parta = shl i64 %a, %add
  %partb = lshr i64 %a, %sub
  %or = or i64 %parta, %partb
  ret i64 %or
}

; Check the next value up, which without masking must use a separate
; addition.
define i64 @f9(i64 %a, i64 %amt) {
; CHECK-LABEL: f9:
; CHECK:       # %bb.0:
; CHECK-NEXT:    afi %r3, 524288
; CHECK-NEXT:    rllg %r2, %r2, 0(%r3)
; CHECK-NEXT:    br %r14
  %add = add i64 %amt, 524288
  %sub = sub i64 64, %add
  %parta = shl i64 %a, %add
  %partb = lshr i64 %a, %sub
  %or = or i64 %parta, %partb
  ret i64 %or
}

; Check cases where 1 is subtracted from the shift amount.
define i64 @f10(i64 %a, i64 %amt) {
; CHECK-LABEL: f10:
; CHECK:       # %bb.0:
; CHECK-NEXT:    rllg %r2, %r2, -1(%r3)
; CHECK-NEXT:    br %r14
  %suba = sub i64 %amt, 1
  %subb = sub i64 64, %suba
  %parta = shl i64 %a, %suba
  %partb = lshr i64 %a, %subb
  %or = or i64 %parta, %partb
  ret i64 %or
}

; Check the lowest value that can be subtracted from the shift amount.
; Again, we could mask the shift amount instead.
define i64 @f11(i64 %a, i64 %amt) {
; CHECK-LABEL: f11:
; CHECK:       # %bb.0:
; CHECK-NEXT:    rllg %r2, %r2, -524288(%r3)
; CHECK-NEXT:    br %r14
  %suba = sub i64 %amt, 524288
  %subb = sub i64 64, %suba
  %parta = shl i64 %a, %suba
  %partb = lshr i64 %a, %subb
  %or = or i64 %parta, %partb
  ret i64 %or
}

; Check the next value down, masking the amount removes the addition.
define i64 @f12(i64 %a, i64 %amt) {
; CHECK-LABEL: f12:
; CHECK:       # %bb.0:
; CHECK-NEXT:    rllg %r2, %r2, -1(%r3)
; CHECK-NEXT:    br %r14
  %suba = sub i64 %amt, 524289
  %subb = sub i64 64, %suba
  %parta = shl i64 %a, %suba
  %partb = lshr i64 %a, %subb
  %or = or i64 %parta, %partb
  ret i64 %or
}

; Check that we don't try to generate "indexed" shifts.
define i64 @f13(i64 %a, i64 %b, i64 %c) {
; CHECK-LABEL: f13:
; CHECK:       # %bb.0:
; CHECK-NEXT:    agr %r3, %r4
; CHECK-NEXT:    rllg %r2, %r2, 0(%r3)
; CHECK-NEXT:    br %r14
  %add = add i64 %b, %c
  %sub = sub i64 64, %add
  %parta = shl i64 %a, %add
  %partb = lshr i64 %a, %sub
  %or = or i64 %parta, %partb
  ret i64 %or
}

; Check that the shift amount uses an address register.  It cannot be in %r0.
define i64 @f14(i64 %a, i64 *%ptr) {
; CHECK-LABEL: f14:
; CHECK:       # %bb.0:
; CHECK-NEXT:    l %r1, 4(%r3)
; CHECK-NEXT:    rllg %r2, %r2, 0(%r1)
; CHECK-NEXT:    br %r14
  %amt = load i64, i64 *%ptr
  %amtb = sub i64 64, %amt
  %parta = shl i64 %a, %amt
  %partb = lshr i64 %a, %amtb
  %or = or i64 %parta, %partb
  ret i64 %or
}
