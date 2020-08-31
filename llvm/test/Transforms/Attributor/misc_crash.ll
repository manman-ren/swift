; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --scrub-attributes --check-attributes
; RUN: opt -attributor -enable-new-pm=0 -S %s | FileCheck %s
; RUN: opt -passes=attributor -S %s | FileCheck %s

@var1 = internal global [1 x i32] undef
@var2 = internal global i32 0

define i32 addrspace(1)* @foo(i32 addrspace(4)* %arg) {
; CHECK: Function Attrs: nofree nosync nounwind readnone willreturn
; CHECK-LABEL: define {{[^@]+}}@foo
; CHECK-SAME: (i32 addrspace(4)* nofree readnone [[ARG:%.*]])
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = addrspacecast i32 addrspace(4)* [[ARG]] to i32 addrspace(1)*
; CHECK-NEXT:    ret i32 addrspace(1)* [[TMP0]]
;
entry:
  %0 = addrspacecast i32 addrspace(4)* %arg to i32 addrspace(1)*
  ret i32 addrspace(1)* %0
}

define i32* @func1() {
; CHECK: Function Attrs: nofree nosync nounwind readnone willreturn
; CHECK-LABEL: define {{[^@]+}}@func1()
; CHECK-NEXT:    [[PTR:%.*]] = call i32* @func1a()
; CHECK-NEXT:    ret i32* [[PTR]]
;
  %ptr = call i32* @func1a([1 x i32]* @var1)
  ret i32* %ptr
}

; UTC_ARGS: --disable
; CHECK-LABEL: define internal noundef nonnull align 4 dereferenceable(4) i32* @func1a()
; CHECK-NEXT: ret i32* getelementptr inbounds ([1 x i32], [1 x i32]* @var1, i32 0, i32 0)
define internal i32* @func1a([1 x i32]* %arg) {
  %ptr = getelementptr inbounds [1 x i32], [1 x i32]* %arg, i64 0, i64 0
  ret i32* %ptr
}
; UTC_ARGS: --enable

define internal void @func2a(i32* %0) {
; CHECK: Function Attrs: nofree nosync nounwind willreturn writeonly
; CHECK-LABEL: define {{[^@]+}}@func2a
; CHECK-SAME: (i32* nocapture nofree nonnull writeonly align 4 dereferenceable(4) [[TMP0:%.*]])
; CHECK-NEXT:    store i32 0, i32* @var2, align 4
; CHECK-NEXT:    ret void
;
  store i32 0, i32* %0
  ret void
}

define i32 @func2() {
; CHECK-LABEL: define {{[^@]+}}@func2()
; CHECK-NEXT:    [[TMP1:%.*]] = tail call i32 (i32*, ...) bitcast (void (i32*)* @func2a to i32 (i32*, ...)*)(i32* noundef nonnull align 4 dereferenceable(4) @var2)
; CHECK-NEXT:    [[TMP2:%.*]] = load i32, i32* @var2, align 4
; CHECK-NEXT:    ret i32 [[TMP2]]
;
  %1 = tail call i32 (i32*, ...) bitcast (void (i32*)* @func2a to i32 (i32*, ...)*)(i32* @var2)
  %2 = load i32, i32* @var2
  ret i32 %2
}

define i32 @func3(i1 %false) {
; CHECK-LABEL: define {{[^@]+}}@func3
; CHECK-SAME: (i1 [[FALSE:%.*]])
; CHECK-NEXT:    [[TMP1:%.*]] = tail call i32 (i32*, ...) bitcast (void (i32*)* @func2a to i32 (i32*, ...)*)(i32* noundef nonnull align 4 dereferenceable(4) @var2)
; CHECK-NEXT:    br i1 [[FALSE]], label [[USE_BB:%.*]], label [[RET_BB:%.*]]
; CHECK:       use_bb:
; CHECK-NEXT:    ret i32 [[TMP1]]
; CHECK:       ret_bb:
; CHECK-NEXT:    [[TMP2:%.*]] = load i32, i32* @var2, align 4
; CHECK-NEXT:    ret i32 [[TMP2]]
;
  %1 = tail call i32 (i32*, ...) bitcast (void (i32*)* @func2a to i32 (i32*, ...)*)(i32* @var2)
  br i1 %false, label %use_bb, label %ret_bb
use_bb:
  ret i32 %1
ret_bb:
  %2 = load i32, i32* @var2
  ret i32 %2
}

define void @func4() {
; CHECK-LABEL: define {{[^@]+}}@func4()
; CHECK-NEXT:    call void @func5()
; CHECK-NEXT:    ret void
;
  call void @func5(i32 0)
  ret void
}

define internal void @func5(i32 %0) {
; CHECK-LABEL: define {{[^@]+}}@func5()
; CHECK-NEXT:    [[TMP:%.*]] = alloca i8*, align 8
; CHECK-NEXT:    br label [[BLOCK:%.*]]
; CHECK:       block:
; CHECK-NEXT:    store i8* blockaddress(@func5, [[BLOCK]]), i8** [[TMP]], align 8
; CHECK-NEXT:    [[ADDR:%.*]] = load i8*, i8** [[TMP]], align 8
; CHECK-NEXT:    call void @func6(i8* [[ADDR]])
; CHECK-NEXT:    ret void
;
  %tmp = alloca i8*
  br label %block

block:
  store i8* blockaddress(@func5, %block), i8** %tmp
  %addr = load i8*, i8** %tmp
  call void @func6(i8* %addr)
  ret void
}

; CHECK-LABEL: declare {{[^@]+}}@func6
; CHECK-SAME: (i8*)
declare void @func6(i8*)
