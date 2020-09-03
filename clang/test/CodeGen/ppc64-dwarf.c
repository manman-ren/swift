// RUN: %clang_cc1 -triple powerpc64-unknown-aix -emit-llvm %s -o - | FileCheck %s
// RUN: %clang_cc1 -triple powerpc64-unknown-unknown -emit-llvm %s -o - | FileCheck %s --check-prefixes=CHECK,PPC64
static unsigned char dwarf_reg_size_table[1024];

int test() {
  __builtin_init_dwarf_reg_size_table(dwarf_reg_size_table);

  return __builtin_dwarf_sp_column();
}

// CHECK-LABEL: define signext i32 @test()
// CHECK:      store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 0), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 1), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 2), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 3), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 4), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 5), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 6), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 7), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 8), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 9), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 10), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 11), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 12), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 13), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 14), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 15), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 16), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 17), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 18), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 19), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 20), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 21), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 22), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 23), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 24), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 25), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 26), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 27), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 28), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 29), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 30), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 31), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 32), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 33), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 34), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 35), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 36), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 37), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 38), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 39), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 40), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 41), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 42), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 43), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 44), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 45), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 46), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 47), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 48), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 49), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 50), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 51), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 52), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 53), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 54), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 55), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 56), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 57), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 58), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 59), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 60), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 61), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 62), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 63), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 64), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 65), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 66), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 67), align 1
// CHECK-NEXT: store i8 4, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 68), align 1
// CHECK-NEXT: store i8 4, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 69), align 1
// CHECK-NEXT: store i8 4, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 70), align 1
// CHECK-NEXT: store i8 4, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 71), align 1
// CHECK-NEXT: store i8 4, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 72), align 1
// CHECK-NEXT: store i8 4, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 73), align 1
// CHECK-NEXT: store i8 4, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 74), align 1
// CHECK-NEXT: store i8 4, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 75), align 1
// CHECK-NEXT: store i8 4, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 76), align 1
// CHECK-NEXT: store i8 16, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 77), align 1
// CHECK-NEXT: store i8 16, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 78), align 1
// CHECK-NEXT: store i8 16, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 79), align 1
// CHECK-NEXT: store i8 16, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 80), align 1
// CHECK-NEXT: store i8 16, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 81), align 1
// CHECK-NEXT: store i8 16, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 82), align 1
// CHECK-NEXT: store i8 16, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 83), align 1
// CHECK-NEXT: store i8 16, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 84), align 1
// CHECK-NEXT: store i8 16, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 85), align 1
// CHECK-NEXT: store i8 16, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 86), align 1
// CHECK-NEXT: store i8 16, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 87), align 1
// CHECK-NEXT: store i8 16, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 88), align 1
// CHECK-NEXT: store i8 16, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 89), align 1
// CHECK-NEXT: store i8 16, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 90), align 1
// CHECK-NEXT: store i8 16, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 91), align 1
// CHECK-NEXT: store i8 16, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 92), align 1
// CHECK-NEXT: store i8 16, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 93), align 1
// CHECK-NEXT: store i8 16, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 94), align 1
// CHECK-NEXT: store i8 16, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 95), align 1
// CHECK-NEXT: store i8 16, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 96), align 1
// CHECK-NEXT: store i8 16, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 97), align 1
// CHECK-NEXT: store i8 16, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 98), align 1
// CHECK-NEXT: store i8 16, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 99), align 1
// CHECK-NEXT: store i8 16, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 100), align 1
// CHECK-NEXT: store i8 16, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 101), align 1
// CHECK-NEXT: store i8 16, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 102), align 1
// CHECK-NEXT: store i8 16, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 103), align 1
// CHECK-NEXT: store i8 16, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 104), align 1
// CHECK-NEXT: store i8 16, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 105), align 1
// CHECK-NEXT: store i8 16, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 106), align 1
// CHECK-NEXT: store i8 16, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 107), align 1
// CHECK-NEXT: store i8 16, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 108), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 109), align 1
// CHECK-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 110), align 1
// PPC64-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 111), align 1
// PPC64-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 112), align 1
// PPC64-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 113), align 1
// PPC64-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 114), align 1
// PPC64-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 115), align 1
// PPC64-NEXT: store i8 8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @dwarf_reg_size_table, i64 0, i64 116), align 1
// CHECK-NEXT: ret i32 1
