; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

declare i32 @llvm.fshl.i32(i32, i32, i32)
declare i33 @llvm.fshr.i33(i33, i33, i33)
declare <2 x i32> @llvm.fshr.v2i32(<2 x i32>, <2 x i32>, <2 x i32>)
declare <2 x i31> @llvm.fshl.v2i31(<2 x i31>, <2 x i31>, <2 x i31>)

; If the shift mask doesn't include any demanded bits, the funnel shift can be eliminated.

define i32 @fshl_mask_simplify1(i32 %x, i32 %y, i32 %sh) {
; CHECK-LABEL: @fshl_mask_simplify1(
; CHECK-NEXT:    ret i32 [[X:%.*]]
;
  %maskedsh = and i32 %sh, 32
  %r = call i32 @llvm.fshl.i32(i32 %x, i32 %y, i32 %maskedsh)
  ret i32 %r
}

define <2 x i32> @fshr_mask_simplify2(<2 x i32> %x, <2 x i32> %y, <2 x i32> %sh) {
; CHECK-LABEL: @fshr_mask_simplify2(
; CHECK-NEXT:    ret <2 x i32> [[Y:%.*]]
;
  %maskedsh = and <2 x i32> %sh, <i32 64, i32 64>
  %r = call <2 x i32> @llvm.fshr.v2i32(<2 x i32> %x, <2 x i32> %y, <2 x i32> %maskedsh)
  ret <2 x i32> %r
}

; Negative test.

define i32 @fshl_mask_simplify3(i32 %x, i32 %y, i32 %sh) {
; CHECK-LABEL: @fshl_mask_simplify3(
; CHECK-NEXT:    [[MASKEDSH:%.*]] = and i32 [[SH:%.*]], 16
; CHECK-NEXT:    [[R:%.*]] = call i32 @llvm.fshl.i32(i32 [[X:%.*]], i32 [[Y:%.*]], i32 [[MASKEDSH]])
; CHECK-NEXT:    ret i32 [[R]]
;
  %maskedsh = and i32 %sh, 16
  %r = call i32 @llvm.fshl.i32(i32 %x, i32 %y, i32 %maskedsh)
  ret i32 %r
}

; Check again with weird bitwidths - the analysis is invalid with non-power-of-2.

define i33 @fshr_mask_simplify1(i33 %x, i33 %y, i33 %sh) {
; CHECK-LABEL: @fshr_mask_simplify1(
; CHECK-NEXT:    [[MASKEDSH:%.*]] = and i33 [[SH:%.*]], 64
; CHECK-NEXT:    [[R:%.*]] = call i33 @llvm.fshr.i33(i33 [[X:%.*]], i33 [[Y:%.*]], i33 [[MASKEDSH]])
; CHECK-NEXT:    ret i33 [[R]]
;
  %maskedsh = and i33 %sh, 64
  %r = call i33 @llvm.fshr.i33(i33 %x, i33 %y, i33 %maskedsh)
  ret i33 %r
}

; Check again with weird bitwidths - the analysis is invalid with non-power-of-2.

define <2 x i31> @fshl_mask_simplify2(<2 x i31> %x, <2 x i31> %y, <2 x i31> %sh) {
; CHECK-LABEL: @fshl_mask_simplify2(
; CHECK-NEXT:    [[MASKEDSH:%.*]] = and <2 x i31> [[SH:%.*]], <i31 32, i31 32>
; CHECK-NEXT:    [[R:%.*]] = call <2 x i31> @llvm.fshl.v2i31(<2 x i31> [[X:%.*]], <2 x i31> [[Y:%.*]], <2 x i31> [[MASKEDSH]])
; CHECK-NEXT:    ret <2 x i31> [[R]]
;
  %maskedsh = and <2 x i31> %sh, <i31 32, i31 32>
  %r = call <2 x i31> @llvm.fshl.v2i31(<2 x i31> %x, <2 x i31> %y, <2 x i31> %maskedsh)
  ret <2 x i31> %r
}

; Check again with weird bitwidths - the analysis is invalid with non-power-of-2.

define i33 @fshr_mask_simplify3(i33 %x, i33 %y, i33 %sh) {
; CHECK-LABEL: @fshr_mask_simplify3(
; CHECK-NEXT:    [[MASKEDSH:%.*]] = and i33 [[SH:%.*]], 32
; CHECK-NEXT:    [[R:%.*]] = call i33 @llvm.fshr.i33(i33 [[X:%.*]], i33 [[Y:%.*]], i33 [[MASKEDSH]])
; CHECK-NEXT:    ret i33 [[R]]
;
  %maskedsh = and i33 %sh, 32
  %r = call i33 @llvm.fshr.i33(i33 %x, i33 %y, i33 %maskedsh)
  ret i33 %r
}

; This mask op is unnecessary.

define i32 @fshl_mask_not_required(i32 %x, i32 %y, i32 %sh) {
; CHECK-LABEL: @fshl_mask_not_required(
; CHECK-NEXT:    [[R:%.*]] = call i32 @llvm.fshl.i32(i32 [[X:%.*]], i32 [[Y:%.*]], i32 [[SH:%.*]])
; CHECK-NEXT:    ret i32 [[R]]
;
  %maskedsh = and i32 %sh, 31
  %r = call i32 @llvm.fshl.i32(i32 %x, i32 %y, i32 %maskedsh)
  ret i32 %r
}

; This mask op can be reduced.

define i32 @fshl_mask_reduce_constant(i32 %x, i32 %y, i32 %sh) {
; CHECK-LABEL: @fshl_mask_reduce_constant(
; CHECK-NEXT:    [[MASKEDSH:%.*]] = and i32 [[SH:%.*]], 1
; CHECK-NEXT:    [[R:%.*]] = call i32 @llvm.fshl.i32(i32 [[X:%.*]], i32 [[Y:%.*]], i32 [[MASKEDSH]])
; CHECK-NEXT:    ret i32 [[R]]
;
  %maskedsh = and i32 %sh, 33
  %r = call i32 @llvm.fshl.i32(i32 %x, i32 %y, i32 %maskedsh)
  ret i32 %r
}

; But this mask op is required.

define i32 @fshl_mask_negative(i32 %x, i32 %y, i32 %sh) {
; CHECK-LABEL: @fshl_mask_negative(
; CHECK-NEXT:    [[MASKEDSH:%.*]] = and i32 [[SH:%.*]], 15
; CHECK-NEXT:    [[R:%.*]] = call i32 @llvm.fshl.i32(i32 [[X:%.*]], i32 [[Y:%.*]], i32 [[MASKEDSH]])
; CHECK-NEXT:    ret i32 [[R]]
;
  %maskedsh = and i32 %sh, 15
  %r = call i32 @llvm.fshl.i32(i32 %x, i32 %y, i32 %maskedsh)
  ret i32 %r
}

; The transform is not limited to mask ops.

define <2 x i32> @fshr_set_but_not_demanded_vec(<2 x i32> %x, <2 x i32> %y, <2 x i32> %sh) {
; CHECK-LABEL: @fshr_set_but_not_demanded_vec(
; CHECK-NEXT:    [[R:%.*]] = call <2 x i32> @llvm.fshr.v2i32(<2 x i32> [[X:%.*]], <2 x i32> [[Y:%.*]], <2 x i32> [[SH:%.*]])
; CHECK-NEXT:    ret <2 x i32> [[R]]
;
  %bogusbits = or <2 x i32> %sh, <i32 32, i32 32>
  %r = call <2 x i32> @llvm.fshr.v2i32(<2 x i32> %x, <2 x i32> %y, <2 x i32> %bogusbits)
  ret <2 x i32> %r
}

; Check again with weird bitwidths - the analysis is invalid with non-power-of-2.

define <2 x i31> @fshl_set_but_not_demanded_vec(<2 x i31> %x, <2 x i31> %y, <2 x i31> %sh) {
; CHECK-LABEL: @fshl_set_but_not_demanded_vec(
; CHECK-NEXT:    [[BOGUSBITS:%.*]] = or <2 x i31> [[SH:%.*]], <i31 32, i31 32>
; CHECK-NEXT:    [[R:%.*]] = call <2 x i31> @llvm.fshl.v2i31(<2 x i31> [[X:%.*]], <2 x i31> [[Y:%.*]], <2 x i31> [[BOGUSBITS]])
; CHECK-NEXT:    ret <2 x i31> [[R]]
;
  %bogusbits = or <2 x i31> %sh, <i31 32, i31 32>
  %r = call <2 x i31> @llvm.fshl.v2i31(<2 x i31> %x, <2 x i31> %y, <2 x i31> %bogusbits)
  ret <2 x i31> %r
}

; Simplify one undef or zero operand and constant shift amount.

define i32 @fshl_op0_undef(i32 %x) {
; CHECK-LABEL: @fshl_op0_undef(
; CHECK-NEXT:    [[R:%.*]] = lshr i32 [[X:%.*]], 25
; CHECK-NEXT:    ret i32 [[R]]
;
  %r = call i32 @llvm.fshl.i32(i32 undef, i32 %x, i32 7)
  ret i32 %r
}

define i32 @fshl_op0_zero(i32 %x) {
; CHECK-LABEL: @fshl_op0_zero(
; CHECK-NEXT:    [[R:%.*]] = lshr i32 [[X:%.*]], 25
; CHECK-NEXT:    ret i32 [[R]]
;
  %r = call i32 @llvm.fshl.i32(i32 0, i32 %x, i32 7)
  ret i32 %r
}

define i33 @fshr_op0_undef(i33 %x) {
; CHECK-LABEL: @fshr_op0_undef(
; CHECK-NEXT:    [[R:%.*]] = lshr i33 [[X:%.*]], 7
; CHECK-NEXT:    ret i33 [[R]]
;
  %r = call i33 @llvm.fshr.i33(i33 undef, i33 %x, i33 7)
  ret i33 %r
}

define i33 @fshr_op0_zero(i33 %x) {
; CHECK-LABEL: @fshr_op0_zero(
; CHECK-NEXT:    [[R:%.*]] = lshr i33 [[X:%.*]], 7
; CHECK-NEXT:    ret i33 [[R]]
;
  %r = call i33 @llvm.fshr.i33(i33 0, i33 %x, i33 7)
  ret i33 %r
}

define i32 @fshl_op1_undef(i32 %x) {
; CHECK-LABEL: @fshl_op1_undef(
; CHECK-NEXT:    [[R:%.*]] = shl i32 [[X:%.*]], 7
; CHECK-NEXT:    ret i32 [[R]]
;
  %r = call i32 @llvm.fshl.i32(i32 %x, i32 undef, i32 7)
  ret i32 %r
}

define i32 @fshl_op1_zero(i32 %x) {
; CHECK-LABEL: @fshl_op1_zero(
; CHECK-NEXT:    [[R:%.*]] = shl i32 [[X:%.*]], 7
; CHECK-NEXT:    ret i32 [[R]]
;
  %r = call i32 @llvm.fshl.i32(i32 %x, i32 0, i32 7)
  ret i32 %r
}

define i33 @fshr_op1_undef(i33 %x) {
; CHECK-LABEL: @fshr_op1_undef(
; CHECK-NEXT:    [[R:%.*]] = shl i33 [[X:%.*]], 26
; CHECK-NEXT:    ret i33 [[R]]
;
  %r = call i33 @llvm.fshr.i33(i33 %x, i33 undef, i33 7)
  ret i33 %r
}

define i33 @fshr_op1_zero(i33 %x) {
; CHECK-LABEL: @fshr_op1_zero(
; CHECK-NEXT:    [[R:%.*]] = shl i33 [[X:%.*]], 26
; CHECK-NEXT:    ret i33 [[R]]
;
  %r = call i33 @llvm.fshr.i33(i33 %x, i33 0, i33 7)
  ret i33 %r
}

define <2 x i31> @fshl_op0_zero_splat_vec(<2 x i31> %x) {
; CHECK-LABEL: @fshl_op0_zero_splat_vec(
; CHECK-NEXT:    [[R:%.*]] = lshr <2 x i31> [[X:%.*]], <i31 24, i31 24>
; CHECK-NEXT:    ret <2 x i31> [[R]]
;
  %r = call <2 x i31> @llvm.fshl.v2i31(<2 x i31> zeroinitializer, <2 x i31> %x, <2 x i31> <i31 7, i31 7>)
  ret <2 x i31> %r
}

define <2 x i31> @fshl_op1_undef_splat_vec(<2 x i31> %x) {
; CHECK-LABEL: @fshl_op1_undef_splat_vec(
; CHECK-NEXT:    [[R:%.*]] = shl <2 x i31> [[X:%.*]], <i31 7, i31 7>
; CHECK-NEXT:    ret <2 x i31> [[R]]
;
  %r = call <2 x i31> @llvm.fshl.v2i31(<2 x i31> %x, <2 x i31> undef, <2 x i31> <i31 7, i31 7>)
  ret <2 x i31> %r
}

define <2 x i32> @fshr_op0_undef_splat_vec(<2 x i32> %x) {
; CHECK-LABEL: @fshr_op0_undef_splat_vec(
; CHECK-NEXT:    [[R:%.*]] = lshr <2 x i32> [[X:%.*]], <i32 7, i32 7>
; CHECK-NEXT:    ret <2 x i32> [[R]]
;
  %r = call <2 x i32> @llvm.fshr.v2i32(<2 x i32> undef, <2 x i32> %x, <2 x i32> <i32 7, i32 7>)
  ret <2 x i32> %r
}

define <2 x i32> @fshr_op1_zero_splat_vec(<2 x i32> %x) {
; CHECK-LABEL: @fshr_op1_zero_splat_vec(
; CHECK-NEXT:    [[R:%.*]] = shl <2 x i32> [[X:%.*]], <i32 25, i32 25>
; CHECK-NEXT:    ret <2 x i32> [[R]]
;
  %r = call <2 x i32> @llvm.fshr.v2i32(<2 x i32> %x, <2 x i32> zeroinitializer, <2 x i32> <i32 7, i32 7>)
  ret <2 x i32> %r
}

define <2 x i31> @fshl_op0_zero_vec(<2 x i31> %x) {
; CHECK-LABEL: @fshl_op0_zero_vec(
; CHECK-NEXT:    [[R:%.*]] = lshr <2 x i31> [[X:%.*]], <i31 30, i31 29>
; CHECK-NEXT:    ret <2 x i31> [[R]]
;
  %r = call <2 x i31> @llvm.fshl.v2i31(<2 x i31> zeroinitializer, <2 x i31> %x, <2 x i31> <i31 -1, i31 33>)
  ret <2 x i31> %r
}

define <2 x i31> @fshl_op1_undef_vec(<2 x i31> %x) {
; CHECK-LABEL: @fshl_op1_undef_vec(
; CHECK-NEXT:    [[R:%.*]] = shl <2 x i31> [[X:%.*]], <i31 1, i31 2>
; CHECK-NEXT:    ret <2 x i31> [[R]]
;
  %r = call <2 x i31> @llvm.fshl.v2i31(<2 x i31> %x, <2 x i31> undef, <2 x i31> <i31 -1, i31 33>)
  ret <2 x i31> %r
}

define <2 x i32> @fshr_op0_undef_vec(<2 x i32> %x) {
; CHECK-LABEL: @fshr_op0_undef_vec(
; CHECK-NEXT:    [[R:%.*]] = lshr <2 x i32> [[X:%.*]], <i32 31, i32 1>
; CHECK-NEXT:    ret <2 x i32> [[R]]
;
  %r = call <2 x i32> @llvm.fshr.v2i32(<2 x i32> undef, <2 x i32> %x, <2 x i32> <i32 -1, i32 33>)
  ret <2 x i32> %r
}

define <2 x i32> @fshr_op1_zero_vec(<2 x i32> %x) {
; CHECK-LABEL: @fshr_op1_zero_vec(
; CHECK-NEXT:    [[R:%.*]] = shl <2 x i32> [[X:%.*]], <i32 1, i32 31>
; CHECK-NEXT:    ret <2 x i32> [[R]]
;
  %r = call <2 x i32> @llvm.fshr.v2i32(<2 x i32> %x, <2 x i32> zeroinitializer, <2 x i32> <i32 -1, i32 33>)
  ret <2 x i32> %r
}

; Only demand bits from one of the operands.

define i32 @fshl_only_op0_demanded(i32 %x, i32 %y) {
; CHECK-LABEL: @fshl_only_op0_demanded(
; CHECK-NEXT:    [[Z:%.*]] = shl i32 [[X:%.*]], 7
; CHECK-NEXT:    [[R:%.*]] = and i32 [[Z]], 128
; CHECK-NEXT:    ret i32 [[R]]
;
  %z = call i32 @llvm.fshl.i32(i32 %x, i32 %y, i32 7)
  %r = and i32 %z, 128
  ret i32 %r
}

define i32 @fshl_only_op1_demanded(i32 %x, i32 %y) {
; CHECK-LABEL: @fshl_only_op1_demanded(
; CHECK-NEXT:    [[Z:%.*]] = lshr i32 [[Y:%.*]], 25
; CHECK-NEXT:    [[R:%.*]] = and i32 [[Z]], 63
; CHECK-NEXT:    ret i32 [[R]]
;
  %z = call i32 @llvm.fshl.i32(i32 %x, i32 %y, i32 7)
  %r = and i32 %z, 63
  ret i32 %r
}

define i33 @fshr_only_op1_demanded(i33 %x, i33 %y) {
; CHECK-LABEL: @fshr_only_op1_demanded(
; CHECK-NEXT:    [[Z:%.*]] = lshr i33 [[Y:%.*]], 7
; CHECK-NEXT:    [[R:%.*]] = and i33 [[Z]], 12392
; CHECK-NEXT:    ret i33 [[R]]
;
  %z = call i33 @llvm.fshr.i33(i33 %x, i33 %y, i33 7)
  %r = and i33 %z, 12392
  ret i33 %r
}

define i33 @fshr_only_op0_demanded(i33 %x, i33 %y) {
; CHECK-LABEL: @fshr_only_op0_demanded(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr i33 [[X:%.*]], 4
; CHECK-NEXT:    [[R:%.*]] = and i33 [[TMP1]], 7
; CHECK-NEXT:    ret i33 [[R]]
;
  %z = call i33 @llvm.fshr.i33(i33 %x, i33 %y, i33 7)
  %r = lshr i33 %z, 30
  ret i33 %r
}

define <2 x i31> @fshl_only_op1_demanded_vec_splat(<2 x i31> %x, <2 x i31> %y) {
; CHECK-LABEL: @fshl_only_op1_demanded_vec_splat(
; CHECK-NEXT:    [[Z:%.*]] = lshr <2 x i31> [[Y:%.*]], <i31 24, i31 24>
; CHECK-NEXT:    [[R:%.*]] = and <2 x i31> [[Z]], <i31 63, i31 31>
; CHECK-NEXT:    ret <2 x i31> [[R]]
;
  %z = call <2 x i31> @llvm.fshl.v2i31(<2 x i31> %x, <2 x i31> %y, <2 x i31> <i31 7, i31 7>)
  %r = and <2 x i31> %z, <i31 63, i31 31>
  ret <2 x i31> %r
}

define i32 @fshl_constant_shift_amount_modulo_bitwidth(i32 %x, i32 %y) {
; CHECK-LABEL: @fshl_constant_shift_amount_modulo_bitwidth(
; CHECK-NEXT:    [[R:%.*]] = call i32 @llvm.fshl.i32(i32 [[X:%.*]], i32 [[Y:%.*]], i32 1)
; CHECK-NEXT:    ret i32 [[R]]
;
  %r = call i32 @llvm.fshl.i32(i32 %x, i32 %y, i32 33)
  ret i32 %r
}

define i33 @fshr_constant_shift_amount_modulo_bitwidth(i33 %x, i33 %y) {
; CHECK-LABEL: @fshr_constant_shift_amount_modulo_bitwidth(
; CHECK-NEXT:    [[R:%.*]] = call i33 @llvm.fshl.i33(i33 [[X:%.*]], i33 [[Y:%.*]], i33 32)
; CHECK-NEXT:    ret i33 [[R]]
;
  %r = call i33 @llvm.fshr.i33(i33 %x, i33 %y, i33 34)
  ret i33 %r
}

@external_global = external global i8

define i33 @fshr_constant_shift_amount_modulo_bitwidth_constexpr(i33 %x, i33 %y) {
; CHECK-LABEL: @fshr_constant_shift_amount_modulo_bitwidth_constexpr(
; CHECK-NEXT:    [[R:%.*]] = call i33 @llvm.fshr.i33(i33 [[X:%.*]], i33 [[Y:%.*]], i33 ptrtoint (i8* @external_global to i33))
; CHECK-NEXT:    ret i33 [[R]]
;
  %shamt = ptrtoint i8* @external_global to i33
  %r = call i33 @llvm.fshr.i33(i33 %x, i33 %y, i33 %shamt)
  ret i33 %r
}

define <2 x i32> @fshr_constant_shift_amount_modulo_bitwidth_vec(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @fshr_constant_shift_amount_modulo_bitwidth_vec(
; CHECK-NEXT:    [[R:%.*]] = call <2 x i32> @llvm.fshl.v2i32(<2 x i32> [[X:%.*]], <2 x i32> [[Y:%.*]], <2 x i32> <i32 30, i32 1>)
; CHECK-NEXT:    ret <2 x i32> [[R]]
;
  %r = call <2 x i32> @llvm.fshr.v2i32(<2 x i32> %x, <2 x i32> %y, <2 x i32> <i32 34, i32 -1>)
  ret <2 x i32> %r
}

define <2 x i31> @fshl_constant_shift_amount_modulo_bitwidth_vec(<2 x i31> %x, <2 x i31> %y) {
; CHECK-LABEL: @fshl_constant_shift_amount_modulo_bitwidth_vec(
; CHECK-NEXT:    [[R:%.*]] = call <2 x i31> @llvm.fshl.v2i31(<2 x i31> [[X:%.*]], <2 x i31> [[Y:%.*]], <2 x i31> <i31 3, i31 1>)
; CHECK-NEXT:    ret <2 x i31> [[R]]
;
  %r = call <2 x i31> @llvm.fshl.v2i31(<2 x i31> %x, <2 x i31> %y, <2 x i31> <i31 34, i31 -1>)
  ret <2 x i31> %r
}

define <2 x i31> @fshl_constant_shift_amount_modulo_bitwidth_vec_const_expr(<2 x i31> %x, <2 x i31> %y) {
; CHECK-LABEL: @fshl_constant_shift_amount_modulo_bitwidth_vec_const_expr(
; CHECK-NEXT:    [[R:%.*]] = call <2 x i31> @llvm.fshl.v2i31(<2 x i31> [[X:%.*]], <2 x i31> [[Y:%.*]], <2 x i31> <i31 34, i31 ptrtoint (i8* @external_global to i31)>)
; CHECK-NEXT:    ret <2 x i31> [[R]]
;
  %shamt = ptrtoint i8* @external_global to i31
  %r = call <2 x i31> @llvm.fshl.v2i31(<2 x i31> %x, <2 x i31> %y, <2 x i31> <i31 34, i31 ptrtoint (i8* @external_global to i31)>)
  ret <2 x i31> %r
}

; TODO: Don't let SimplifyDemandedBits split up a rotate - keep the same operand.

define i32 @rotl_common_demanded(i32 %a0) {
; CHECK-LABEL: @rotl_common_demanded(
; CHECK-NEXT:    [[X:%.*]] = xor i32 [[A0:%.*]], 2
; CHECK-NEXT:    [[R:%.*]] = call i32 @llvm.fshl.i32(i32 [[X]], i32 [[A0]], i32 8)
; CHECK-NEXT:    ret i32 [[R]]
;
  %x = xor i32 %a0, 2
  %r = call i32 @llvm.fshl.i32(i32 %x, i32 %x, i32 8)
  ret i32 %r
}

define i33 @rotr_common_demanded(i33 %a0) {
; CHECK-LABEL: @rotr_common_demanded(
; CHECK-NEXT:    [[X:%.*]] = xor i33 [[A0:%.*]], 2
; CHECK-NEXT:    [[R:%.*]] = call i33 @llvm.fshl.i33(i33 [[X]], i33 [[A0]], i33 25)
; CHECK-NEXT:    ret i33 [[R]]
;
  %x = xor i33 %a0, 2
  %r = call i33 @llvm.fshr.i33(i33 %x, i33 %x, i33 8)
  ret i33 %r
}

; The shift modulo bitwidth is the same for all vector elements.

define <2 x i31> @fshl_only_op1_demanded_vec_nonsplat(<2 x i31> %x, <2 x i31> %y) {
; CHECK-LABEL: @fshl_only_op1_demanded_vec_nonsplat(
; CHECK-NEXT:    [[Z:%.*]] = lshr <2 x i31> [[Y:%.*]], <i31 24, i31 24>
; CHECK-NEXT:    [[R:%.*]] = and <2 x i31> [[Z]], <i31 63, i31 31>
; CHECK-NEXT:    ret <2 x i31> [[R]]
;
  %z = call <2 x i31> @llvm.fshl.v2i31(<2 x i31> %x, <2 x i31> %y, <2 x i31> <i31 7, i31 38>)
  %r = and <2 x i31> %z, <i31 63, i31 31>
  ret <2 x i31> %r
}

define i32 @rotl_constant_shift_amount(i32 %x) {
; CHECK-LABEL: @rotl_constant_shift_amount(
; CHECK-NEXT:    [[R:%.*]] = call i32 @llvm.fshl.i32(i32 [[X:%.*]], i32 [[X]], i32 1)
; CHECK-NEXT:    ret i32 [[R]]
;
  %r = call i32 @llvm.fshl.i32(i32 %x, i32 %x, i32 33)
  ret i32 %r
}

define <2 x i31> @rotl_constant_shift_amount_vec(<2 x i31> %x) {
; CHECK-LABEL: @rotl_constant_shift_amount_vec(
; CHECK-NEXT:    [[R:%.*]] = call <2 x i31> @llvm.fshl.v2i31(<2 x i31> [[X:%.*]], <2 x i31> [[X]], <2 x i31> <i31 1, i31 1>)
; CHECK-NEXT:    ret <2 x i31> [[R]]
;
  %r = call <2 x i31> @llvm.fshl.v2i31(<2 x i31> %x, <2 x i31> %x, <2 x i31> <i31 32, i31 -1>)
  ret <2 x i31> %r
}

define i33 @rotr_constant_shift_amount(i33 %x) {
; CHECK-LABEL: @rotr_constant_shift_amount(
; CHECK-NEXT:    [[R:%.*]] = call i33 @llvm.fshl.i33(i33 [[X:%.*]], i33 [[X]], i33 32)
; CHECK-NEXT:    ret i33 [[R]]
;
  %r = call i33 @llvm.fshr.i33(i33 %x, i33 %x, i33 34)
  ret i33 %r
}

define <2 x i32> @rotr_constant_shift_amount_vec(<2 x i32> %x) {
; CHECK-LABEL: @rotr_constant_shift_amount_vec(
; CHECK-NEXT:    [[R:%.*]] = call <2 x i32> @llvm.fshl.v2i32(<2 x i32> [[X:%.*]], <2 x i32> [[X]], <2 x i32> <i32 31, i32 1>)
; CHECK-NEXT:    ret <2 x i32> [[R]]
;
  %r = call <2 x i32> @llvm.fshr.v2i32(<2 x i32> %x, <2 x i32> %x, <2 x i32> <i32 33, i32 -1>)
  ret <2 x i32> %r
}

; Demand bits from both operands -- cannot simplify.

define i32 @fshl_both_ops_demanded(i32 %x, i32 %y) {
; CHECK-LABEL: @fshl_both_ops_demanded(
; CHECK-NEXT:    [[Z:%.*]] = call i32 @llvm.fshl.i32(i32 [[X:%.*]], i32 [[Y:%.*]], i32 7)
; CHECK-NEXT:    [[R:%.*]] = and i32 [[Z]], 192
; CHECK-NEXT:    ret i32 [[R]]
;
  %z = call i32 @llvm.fshl.i32(i32 %x, i32 %y, i32 7)
  %r = and i32 %z, 192
  ret i32 %r
}

define i33 @fshr_both_ops_demanded(i33 %x, i33 %y) {
; CHECK-LABEL: @fshr_both_ops_demanded(
; CHECK-NEXT:    [[Z:%.*]] = call i33 @llvm.fshl.i33(i33 [[X:%.*]], i33 [[Y:%.*]], i33 7)
; CHECK-NEXT:    [[R:%.*]] = and i33 [[Z]], 192
; CHECK-NEXT:    ret i33 [[R]]
;
  %z = call i33 @llvm.fshr.i33(i33 %x, i33 %y, i33 26)
  %r = and i33 %z, 192
  ret i33 %r
}

; Both operands are demanded, but there are known bits.

define i32 @fshl_known_bits(i32 %x, i32 %y) {
; CHECK-LABEL: @fshl_known_bits(
; CHECK-NEXT:    ret i32 128
;
  %x2 = or i32 %x, 1   ; lo bit set
  %y2 = lshr i32 %y, 1 ; hi bit clear
  %z = call i32 @llvm.fshl.i32(i32 %x2, i32 %y2, i32 7)
  %r = and i32 %z, 192
  ret i32 %r
}

define i33 @fshr_known_bits(i33 %x, i33 %y) {
; CHECK-LABEL: @fshr_known_bits(
; CHECK-NEXT:    ret i33 128
;
  %x2 = or i33 %x, 1 ; lo bit set
  %y2 = lshr i33 %y, 1 ; hi bit set
  %z = call i33 @llvm.fshr.i33(i33 %x2, i33 %y2, i33 26)
  %r = and i33 %z, 192
  ret i33 %r
}

; This case fails to simplify due to multiple uses.

define i33 @fshr_multi_use(i33 %a) {
; CHECK-LABEL: @fshr_multi_use(
; CHECK-NEXT:    [[B:%.*]] = call i33 @llvm.fshl.i33(i33 [[A:%.*]], i33 [[A]], i33 32)
; CHECK-NEXT:    [[C:%.*]] = lshr i33 [[B]], 23
; CHECK-NEXT:    [[D:%.*]] = xor i33 [[C]], [[B]]
; CHECK-NEXT:    [[E:%.*]] = and i33 [[D]], 31
; CHECK-NEXT:    ret i33 [[E]]
;
  %b = tail call i33 @llvm.fshr.i33(i33 %a, i33 %a, i33 1)
  %c = lshr i33 %b, 23
  %d = xor i33 %c, %b
  %e = and i33 %d, 31
  ret i33 %e
}

; This demonstrates the same simplification working if the fshr intrinsic
; is expanded into shifts and or.

define i33 @expanded_fshr_multi_use(i33 %a) {
; CHECK-LABEL: @expanded_fshr_multi_use(
; CHECK-NEXT:    [[B:%.*]] = call i33 @llvm.fshl.i33(i33 [[A:%.*]], i33 [[A]], i33 32)
; CHECK-NEXT:    [[C:%.*]] = lshr i33 [[B]], 23
; CHECK-NEXT:    [[D:%.*]] = xor i33 [[C]], [[B]]
; CHECK-NEXT:    [[E:%.*]] = and i33 [[D]], 31
; CHECK-NEXT:    ret i33 [[E]]
;
  %tmp = lshr i33 %a, 1
  %tmp2 = shl i33 %a, 32
  %b = or i33 %tmp, %tmp2
  %c = lshr i33 %b, 23
  %d = xor i33 %c, %b
  %e = and i33 %d, 31
  ret i33 %e
}

declare i16 @llvm.fshl.i16(i16, i16, i16)
declare i16 @llvm.fshr.i16(i16, i16, i16)
declare <3 x i16> @llvm.fshl.v3i16(<3 x i16>, <3 x i16>, <3 x i16>)

; Special-case: rotate a 16-bit value left/right by 8-bits is bswap.

define i16 @fshl_bswap(i16 %x) {
; CHECK-LABEL: @fshl_bswap(
; CHECK-NEXT:    [[R:%.*]] = call i16 @llvm.bswap.i16(i16 [[X:%.*]])
; CHECK-NEXT:    ret i16 [[R]]
;
  %r = call i16 @llvm.fshl.i16(i16 %x, i16 %x, i16 8)
  ret i16 %r
}

define i16 @fshr_bswap(i16 %x) {
; CHECK-LABEL: @fshr_bswap(
; CHECK-NEXT:    [[R:%.*]] = call i16 @llvm.bswap.i16(i16 [[X:%.*]])
; CHECK-NEXT:    ret i16 [[R]]
;
  %r = call i16 @llvm.fshr.i16(i16 %x, i16 %x, i16 8)
  ret i16 %r
}

define <3 x i16> @fshl_bswap_vector(<3 x i16> %x) {
; CHECK-LABEL: @fshl_bswap_vector(
; CHECK-NEXT:    [[R:%.*]] = call <3 x i16> @llvm.bswap.v3i16(<3 x i16> [[X:%.*]])
; CHECK-NEXT:    ret <3 x i16> [[R]]
;
  %r = call <3 x i16> @llvm.fshl.v3i16(<3 x i16> %x, <3 x i16> %x, <3 x i16> <i16 8, i16 8, i16 8>)
  ret <3 x i16> %r
}

; Negative test

define i16 @fshl_bswap_wrong_op(i16 %x, i16 %y) {
; CHECK-LABEL: @fshl_bswap_wrong_op(
; CHECK-NEXT:    [[R:%.*]] = call i16 @llvm.fshl.i16(i16 [[X:%.*]], i16 [[Y:%.*]], i16 8)
; CHECK-NEXT:    ret i16 [[R]]
;
  %r = call i16 @llvm.fshl.i16(i16 %x, i16 %y, i16 8)
  ret i16 %r
}

; Negative test

define i16 @fshr_bswap_wrong_amount(i16 %x) {
; CHECK-LABEL: @fshr_bswap_wrong_amount(
; CHECK-NEXT:    [[R:%.*]] = call i16 @llvm.fshl.i16(i16 [[X:%.*]], i16 [[X]], i16 12)
; CHECK-NEXT:    ret i16 [[R]]
;
  %r = call i16 @llvm.fshr.i16(i16 %x, i16 %x, i16 4)
  ret i16 %r
}

; Negative test

define i32 @fshl_bswap_wrong_width(i32 %x) {
; CHECK-LABEL: @fshl_bswap_wrong_width(
; CHECK-NEXT:    [[R:%.*]] = call i32 @llvm.fshl.i32(i32 [[X:%.*]], i32 [[X]], i32 8)
; CHECK-NEXT:    ret i32 [[R]]
;
  %r = call i32 @llvm.fshl.i32(i32 %x, i32 %x, i32 8)
  ret i32 %r
}

define i32 @fshl_mask_args_same1(i32 %a) {
; CHECK-LABEL: @fshl_mask_args_same1(
; CHECK-NEXT:    [[TMP2:%.*]] = lshr i32 [[A:%.*]], 16
; CHECK-NEXT:    ret i32 [[TMP2]]
;
  %tmp1 = and i32 %a, 4294901760 ; 0xffff0000
  %tmp2 = call i32 @llvm.fshl.i32(i32 %tmp1, i32 %tmp1, i32 16)
  ret i32 %tmp2
}

define i32 @fshl_mask_args_same2(i32 %a) {
; CHECK-LABEL: @fshl_mask_args_same2(
; CHECK-NEXT:    [[TMP1:%.*]] = shl i32 [[A:%.*]], 8
; CHECK-NEXT:    [[TMP2:%.*]] = and i32 [[TMP1]], 65280
; CHECK-NEXT:    ret i32 [[TMP2]]
;
  %tmp1 = and i32 %a, 255
  %tmp2 = call i32 @llvm.fshl.i32(i32 %tmp1, i32 %tmp1, i32 8)
  ret i32 %tmp2
}

define i32 @fshl_mask_args_same3(i32 %a) {
; CHECK-LABEL: @fshl_mask_args_same3(
; CHECK-NEXT:    [[TMP2:%.*]] = shl i32 [[A:%.*]], 24
; CHECK-NEXT:    ret i32 [[TMP2]]
;
  %tmp1 = and i32 %a, 255
  %tmp2 = call i32 @llvm.fshl.i32(i32 %tmp1, i32 %tmp1, i32 24)
  ret i32 %tmp2
}

define i32 @fshl_mask_args_different(i32 %a) {
; CHECK-LABEL: @fshl_mask_args_different(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr i32 [[A:%.*]], 15
; CHECK-NEXT:    [[TMP3:%.*]] = and i32 [[TMP1]], 130560
; CHECK-NEXT:    ret i32 [[TMP3]]
;
  %tmp2 = and i32 %a, 4294901760 ; 0xfffff00f
  %tmp1 = and i32 %a, 4278190080 ; 0xff00f00f
  %tmp3 = call i32 @llvm.fshl.i32(i32 %tmp2, i32 %tmp1, i32 17)
  ret i32 %tmp3
}

define <2 x i31> @fshr_mask_args_same_vector(<2 x i31> %a) {
; CHECK-LABEL: @fshr_mask_args_same_vector(
; CHECK-NEXT:    [[TMP3:%.*]] = shl <2 x i31> [[A:%.*]], <i31 10, i31 10>
; CHECK-NEXT:    ret <2 x i31> [[TMP3]]
;
  %tmp1 = and <2 x i31> %a, <i31 1000, i31 1000>
  %tmp2 = and <2 x i31> %a, <i31 6442450943, i31 6442450943>
  %tmp3 = call <2 x i31> @llvm.fshl.v2i31(<2 x i31> %tmp2, <2 x i31> %tmp1, <2 x i31> <i31 10, i31 10>)
  ret <2 x i31> %tmp3
}

define <2 x i32> @fshr_mask_args_same_vector2(<2 x i32> %a, <2 x i32> %b) {
; CHECK-LABEL: @fshr_mask_args_same_vector2(
; CHECK-NEXT:    [[TMP1:%.*]] = and <2 x i32> [[A:%.*]], <i32 1000000, i32 100000>
; CHECK-NEXT:    [[TMP3:%.*]] = lshr exact <2 x i32> [[TMP1]], <i32 3, i32 3>
; CHECK-NEXT:    ret <2 x i32> [[TMP3]]
;
  %tmp1 = and <2 x i32> %a, <i32 1000000, i32 100000>
  %tmp2 = and <2 x i32> %a, <i32 6442450943, i32 6442450943>
  %tmp3 = call <2 x i32> @llvm.fshr.v2i32(<2 x i32> %tmp1, <2 x i32> %tmp1, <2 x i32> <i32 3, i32 3>)
  ret <2 x i32> %tmp3
}

define <2 x i31> @fshr_mask_args_same_vector3_different_but_still_prunable(<2 x i31> %a) {
; CHECK-LABEL: @fshr_mask_args_same_vector3_different_but_still_prunable(
; CHECK-NEXT:    [[TMP1:%.*]] = and <2 x i31> [[A:%.*]], <i31 1000, i31 1000>
; CHECK-NEXT:    [[TMP3:%.*]] = call <2 x i31> @llvm.fshl.v2i31(<2 x i31> [[A]], <2 x i31> [[TMP1]], <2 x i31> <i31 10, i31 3>)
; CHECK-NEXT:    ret <2 x i31> [[TMP3]]
;
  %tmp1 = and <2 x i31> %a, <i31 1000, i31 1000>
  %tmp2 = and <2 x i31> %a, <i31 6442450943, i31 6442450943>
  %tmp3 = call <2 x i31> @llvm.fshl.v2i31(<2 x i31> %tmp2, <2 x i31> %tmp1, <2 x i31> <i31 10, i31 3>)
  ret <2 x i31> %tmp3
}
