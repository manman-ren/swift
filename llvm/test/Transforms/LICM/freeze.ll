; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -licm -S < %s | FileCheck %s

define void @hoist(i1 %a) {
; CHECK-LABEL: @hoist(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[B:%.*]] = freeze i1 [[A:%.*]]
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    call void @use(i1 [[B]])
; CHECK-NEXT:    br label [[LOOP]]
;
entry:
  br label %loop
loop:
  %b = freeze i1 %a
  call void @use(i1 %b)
  br label %loop
}

define i1 @sink(i1 %a) {
; CHECK-LABEL: @sink(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[C:%.*]] = call i1 @cond()
; CHECK-NEXT:    br i1 [[C]], label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    [[FR_LE:%.*]] = freeze i1 [[A:%.*]]
; CHECK-NEXT:    ret i1 [[FR_LE]]
;
entry:
  br label %loop
loop:
  %fr = freeze i1 %a
  %c = call i1 @cond()
  br i1 %c, label %loop, label %exit
exit:
  ret i1 %fr
}

declare i1 @cond()
declare void @use(i1)
