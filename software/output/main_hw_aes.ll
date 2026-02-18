; ModuleID = 'main_hw_aes.c'
source_filename = "main_hw_aes.c"
target datalayout = "e-m:e-p:32:32-i64:64-n32-S128"
target triple = "riscv32-unknown-unknown-elf"

@rcon = internal constant [10 x i8] c"\01\02\04\08\10 @\80\1B6", align 1
@__const.main.plaintext = private unnamed_addr constant [16 x i8] c"Hello, World!000", align 1
@__const.main.key = private unnamed_addr constant [16 x i8] c"cese4040password", align 1
@__const.main.expected_output = private unnamed_addr constant [4 x i32] [i32 -73070316, i32 1900803103, i32 774220478, i32 -1426520049], align 4

; Function Attrs: nounwind
define dso_local void @merge_plaintext_into_state(ptr noundef %0, ptr noundef %1) #0 {
  %3 = alloca ptr, align 4
  %4 = alloca ptr, align 4
  %5 = alloca i32, align 4
  store ptr %0, ptr %3, align 4, !tbaa !6
  store ptr %1, ptr %4, align 4, !tbaa !11
  call void @llvm.lifetime.start.p0(i64 4, ptr %5) #4
  store i32 0, ptr %5, align 4, !tbaa !13
  br label %6

6:                                                ; preds = %19, %2
  %7 = load i32, ptr %5, align 4, !tbaa !13
  %8 = icmp slt i32 %7, 4
  br i1 %8, label %10, label %9

9:                                                ; preds = %6
  call void @llvm.lifetime.end.p0(i64 4, ptr %5) #4
  br label %22

10:                                               ; preds = %6
  %11 = load ptr, ptr %3, align 4, !tbaa !6
  %12 = load i32, ptr %5, align 4, !tbaa !13
  %13 = mul nsw i32 4, %12
  %14 = getelementptr inbounds i8, ptr %11, i32 %13
  %15 = call i32 @load32_le(ptr noundef %14)
  %16 = load ptr, ptr %4, align 4, !tbaa !11
  %17 = load i32, ptr %5, align 4, !tbaa !13
  %18 = getelementptr inbounds i32, ptr %16, i32 %17
  store i32 %15, ptr %18, align 4, !tbaa !13
  br label %19

19:                                               ; preds = %10
  %20 = load i32, ptr %5, align 4, !tbaa !13
  %21 = add nsw i32 %20, 1
  store i32 %21, ptr %5, align 4, !tbaa !13
  br label %6, !llvm.loop !15

22:                                               ; preds = %9
  ret void
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: inlinehint nounwind
define internal i32 @load32_le(ptr noundef %0) #2 {
  %2 = alloca ptr, align 4
  store ptr %0, ptr %2, align 4, !tbaa !6
  %3 = load ptr, ptr %2, align 4, !tbaa !6
  %4 = getelementptr inbounds i8, ptr %3, i32 0
  %5 = load i8, ptr %4, align 1, !tbaa !17
  %6 = zext i8 %5 to i32
  %7 = load ptr, ptr %2, align 4, !tbaa !6
  %8 = getelementptr inbounds i8, ptr %7, i32 1
  %9 = load i8, ptr %8, align 1, !tbaa !17
  %10 = zext i8 %9 to i32
  %11 = shl i32 %10, 8
  %12 = or i32 %6, %11
  %13 = load ptr, ptr %2, align 4, !tbaa !6
  %14 = getelementptr inbounds i8, ptr %13, i32 2
  %15 = load i8, ptr %14, align 1, !tbaa !17
  %16 = zext i8 %15 to i32
  %17 = shl i32 %16, 16
  %18 = or i32 %12, %17
  %19 = load ptr, ptr %2, align 4, !tbaa !6
  %20 = getelementptr inbounds i8, ptr %19, i32 3
  %21 = load i8, ptr %20, align 1, !tbaa !17
  %22 = zext i8 %21 to i32
  %23 = shl i32 %22, 24
  %24 = or i32 %18, %23
  ret i32 %24
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: nounwind
define dso_local void @expand_key_hweq(ptr noundef %0, ptr noundef %1) #0 {
  %3 = alloca ptr, align 4
  %4 = alloca ptr, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  store ptr %0, ptr %3, align 4, !tbaa !6
  store ptr %1, ptr %4, align 4, !tbaa !11
  call void @llvm.lifetime.start.p0(i64 4, ptr %5) #4
  store i32 0, ptr %5, align 4, !tbaa !13
  br label %11

11:                                               ; preds = %24, %2
  %12 = load i32, ptr %5, align 4, !tbaa !13
  %13 = icmp slt i32 %12, 4
  br i1 %13, label %15, label %14

14:                                               ; preds = %11
  call void @llvm.lifetime.end.p0(i64 4, ptr %5) #4
  br label %27

15:                                               ; preds = %11
  %16 = load ptr, ptr %3, align 4, !tbaa !6
  %17 = load i32, ptr %5, align 4, !tbaa !13
  %18 = mul nsw i32 4, %17
  %19 = getelementptr inbounds i8, ptr %16, i32 %18
  %20 = call i32 @load32_le(ptr noundef %19)
  %21 = load ptr, ptr %4, align 4, !tbaa !11
  %22 = load i32, ptr %5, align 4, !tbaa !13
  %23 = getelementptr inbounds i32, ptr %21, i32 %22
  store i32 %20, ptr %23, align 4, !tbaa !13
  br label %24

24:                                               ; preds = %15
  %25 = load i32, ptr %5, align 4, !tbaa !13
  %26 = add nsw i32 %25, 1
  store i32 %26, ptr %5, align 4, !tbaa !13
  br label %11, !llvm.loop !18

27:                                               ; preds = %14
  call void @llvm.lifetime.start.p0(i64 4, ptr %6) #4
  store i32 1, ptr %6, align 4, !tbaa !13
  br label %28

28:                                               ; preds = %118, %27
  %29 = load i32, ptr %6, align 4, !tbaa !13
  %30 = icmp slt i32 %29, 11
  br i1 %30, label %32, label %31

31:                                               ; preds = %28
  call void @llvm.lifetime.end.p0(i64 4, ptr %6) #4
  br label %121

32:                                               ; preds = %28
  call void @llvm.lifetime.start.p0(i64 4, ptr %7) #4
  %33 = load i32, ptr %6, align 4, !tbaa !13
  %34 = shl i32 %33, 2
  store i32 %34, ptr %7, align 4, !tbaa !13
  call void @llvm.lifetime.start.p0(i64 4, ptr %8) #4
  %35 = load ptr, ptr %4, align 4, !tbaa !11
  %36 = load i32, ptr %7, align 4, !tbaa !13
  %37 = sub nsw i32 %36, 1
  %38 = getelementptr inbounds i32, ptr %35, i32 %37
  %39 = load i32, ptr %38, align 4, !tbaa !13
  store i32 %39, ptr %8, align 4, !tbaa !13
  call void @llvm.lifetime.start.p0(i64 4, ptr %9) #4
  %40 = load i32, ptr %8, align 4, !tbaa !13
  %41 = lshr i32 %40, 8
  %42 = load i32, ptr %8, align 4, !tbaa !13
  %43 = shl i32 %42, 24
  %44 = or i32 %41, %43
  store i32 %44, ptr %9, align 4, !tbaa !13
  call void @llvm.lifetime.start.p0(i64 4, ptr %10) #4
  %45 = load ptr, ptr %4, align 4, !tbaa !11
  %46 = load i32, ptr %7, align 4, !tbaa !13
  %47 = sub nsw i32 %46, 4
  %48 = getelementptr inbounds i32, ptr %45, i32 %47
  %49 = load i32, ptr %48, align 4, !tbaa !13
  %50 = load i32, ptr %6, align 4, !tbaa !13
  %51 = sub nsw i32 %50, 1
  %52 = getelementptr inbounds [10 x i8], ptr @rcon, i32 0, i32 %51
  %53 = load i8, ptr %52, align 1, !tbaa !17
  %54 = zext i8 %53 to i32
  %55 = xor i32 %49, %54
  store i32 %55, ptr %10, align 4, !tbaa !13
  %56 = load i32, ptr %10, align 4, !tbaa !13
  %57 = load i32, ptr %9, align 4, !tbaa !13
  %58 = call i32 asm sideeffect "aes32esi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %57, i32 0, i32 %56) #4, !srcloc !19
  store i32 %58, ptr %10, align 4, !tbaa !13
  %59 = load i32, ptr %10, align 4, !tbaa !13
  %60 = load i32, ptr %9, align 4, !tbaa !13
  %61 = call i32 asm sideeffect "aes32esi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %60, i32 1, i32 %59) #4, !srcloc !20
  store i32 %61, ptr %10, align 4, !tbaa !13
  %62 = load i32, ptr %10, align 4, !tbaa !13
  %63 = load i32, ptr %9, align 4, !tbaa !13
  %64 = call i32 asm sideeffect "aes32esi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %63, i32 2, i32 %62) #4, !srcloc !21
  store i32 %64, ptr %10, align 4, !tbaa !13
  %65 = load i32, ptr %10, align 4, !tbaa !13
  %66 = load i32, ptr %9, align 4, !tbaa !13
  %67 = call i32 asm sideeffect "aes32esi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %66, i32 3, i32 %65) #4, !srcloc !22
  store i32 %67, ptr %10, align 4, !tbaa !13
  %68 = load i32, ptr %10, align 4, !tbaa !13
  %69 = load ptr, ptr %4, align 4, !tbaa !11
  %70 = load i32, ptr %7, align 4, !tbaa !13
  %71 = add nsw i32 %70, 0
  %72 = getelementptr inbounds i32, ptr %69, i32 %71
  store i32 %68, ptr %72, align 4, !tbaa !13
  %73 = load ptr, ptr %4, align 4, !tbaa !11
  %74 = load i32, ptr %7, align 4, !tbaa !13
  %75 = add nsw i32 %74, 0
  %76 = getelementptr inbounds i32, ptr %73, i32 %75
  %77 = load i32, ptr %76, align 4, !tbaa !13
  %78 = load ptr, ptr %4, align 4, !tbaa !11
  %79 = load i32, ptr %7, align 4, !tbaa !13
  %80 = sub nsw i32 %79, 3
  %81 = getelementptr inbounds i32, ptr %78, i32 %80
  %82 = load i32, ptr %81, align 4, !tbaa !13
  %83 = xor i32 %77, %82
  %84 = load ptr, ptr %4, align 4, !tbaa !11
  %85 = load i32, ptr %7, align 4, !tbaa !13
  %86 = add nsw i32 %85, 1
  %87 = getelementptr inbounds i32, ptr %84, i32 %86
  store i32 %83, ptr %87, align 4, !tbaa !13
  %88 = load ptr, ptr %4, align 4, !tbaa !11
  %89 = load i32, ptr %7, align 4, !tbaa !13
  %90 = add nsw i32 %89, 1
  %91 = getelementptr inbounds i32, ptr %88, i32 %90
  %92 = load i32, ptr %91, align 4, !tbaa !13
  %93 = load ptr, ptr %4, align 4, !tbaa !11
  %94 = load i32, ptr %7, align 4, !tbaa !13
  %95 = sub nsw i32 %94, 2
  %96 = getelementptr inbounds i32, ptr %93, i32 %95
  %97 = load i32, ptr %96, align 4, !tbaa !13
  %98 = xor i32 %92, %97
  %99 = load ptr, ptr %4, align 4, !tbaa !11
  %100 = load i32, ptr %7, align 4, !tbaa !13
  %101 = add nsw i32 %100, 2
  %102 = getelementptr inbounds i32, ptr %99, i32 %101
  store i32 %98, ptr %102, align 4, !tbaa !13
  %103 = load ptr, ptr %4, align 4, !tbaa !11
  %104 = load i32, ptr %7, align 4, !tbaa !13
  %105 = add nsw i32 %104, 2
  %106 = getelementptr inbounds i32, ptr %103, i32 %105
  %107 = load i32, ptr %106, align 4, !tbaa !13
  %108 = load ptr, ptr %4, align 4, !tbaa !11
  %109 = load i32, ptr %7, align 4, !tbaa !13
  %110 = sub nsw i32 %109, 1
  %111 = getelementptr inbounds i32, ptr %108, i32 %110
  %112 = load i32, ptr %111, align 4, !tbaa !13
  %113 = xor i32 %107, %112
  %114 = load ptr, ptr %4, align 4, !tbaa !11
  %115 = load i32, ptr %7, align 4, !tbaa !13
  %116 = add nsw i32 %115, 3
  %117 = getelementptr inbounds i32, ptr %114, i32 %116
  store i32 %113, ptr %117, align 4, !tbaa !13
  call void @llvm.lifetime.end.p0(i64 4, ptr %10) #4
  call void @llvm.lifetime.end.p0(i64 4, ptr %9) #4
  call void @llvm.lifetime.end.p0(i64 4, ptr %8) #4
  call void @llvm.lifetime.end.p0(i64 4, ptr %7) #4
  br label %118

118:                                              ; preds = %32
  %119 = load i32, ptr %6, align 4, !tbaa !13
  %120 = add nsw i32 %119, 1
  store i32 %120, ptr %6, align 4, !tbaa !13
  br label %28, !llvm.loop !23

121:                                              ; preds = %31
  ret void
}

; Function Attrs: nounwind
define dso_local void @aes128_ecb_encrypt(ptr noundef %0, i32 noundef %1, ptr noundef %2) #0 {
  %4 = alloca ptr, align 4
  %5 = alloca i32, align 4
  %6 = alloca ptr, align 4
  %7 = alloca [44 x i32], align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca ptr, align 4
  %12 = alloca i32, align 4
  %13 = alloca ptr, align 4
  %14 = alloca i32, align 4
  store ptr %0, ptr %4, align 4, !tbaa !11
  store i32 %1, ptr %5, align 4, !tbaa !13
  store ptr %2, ptr %6, align 4, !tbaa !6
  %15 = load i32, ptr %5, align 4, !tbaa !13
  %16 = urem i32 %15, 16
  %17 = icmp ne i32 %16, 0
  br i1 %17, label %18, label %19

18:                                               ; preds = %3
  br label %195

19:                                               ; preds = %3
  call void @llvm.lifetime.start.p0(i64 176, ptr %7) #4
  %20 = load ptr, ptr %6, align 4, !tbaa !6
  %21 = getelementptr inbounds [44 x i32], ptr %7, i32 0, i32 0
  call void @expand_key_hweq(ptr noundef %20, ptr noundef %21)
  call void @llvm.lifetime.start.p0(i64 4, ptr %8) #4
  store i32 0, ptr %8, align 4, !tbaa !13
  br label %22

22:                                               ; preds = %35, %19
  %23 = load i32, ptr %8, align 4, !tbaa !13
  %24 = icmp slt i32 %23, 4
  br i1 %24, label %26, label %25

25:                                               ; preds = %22
  call void @llvm.lifetime.end.p0(i64 4, ptr %8) #4
  br label %38

26:                                               ; preds = %22
  %27 = load i32, ptr %8, align 4, !tbaa !13
  %28 = getelementptr inbounds [44 x i32], ptr %7, i32 0, i32 %27
  %29 = load i32, ptr %28, align 4, !tbaa !13
  %30 = load ptr, ptr %4, align 4, !tbaa !11
  %31 = load i32, ptr %8, align 4, !tbaa !13
  %32 = getelementptr inbounds i32, ptr %30, i32 %31
  %33 = load i32, ptr %32, align 4, !tbaa !13
  %34 = xor i32 %33, %29
  store i32 %34, ptr %32, align 4, !tbaa !13
  br label %35

35:                                               ; preds = %26
  %36 = load i32, ptr %8, align 4, !tbaa !13
  %37 = add nsw i32 %36, 1
  store i32 %37, ptr %8, align 4, !tbaa !13
  br label %22, !llvm.loop !24

38:                                               ; preds = %25
  call void @llvm.lifetime.start.p0(i64 4, ptr %9) #4
  store i32 1, ptr %9, align 4, !tbaa !13
  br label %39

39:                                               ; preds = %119, %38
  %40 = load i32, ptr %9, align 4, !tbaa !13
  %41 = icmp slt i32 %40, 10
  br i1 %41, label %43, label %42

42:                                               ; preds = %39
  store i32 5, ptr %10, align 4
  call void @llvm.lifetime.end.p0(i64 4, ptr %9) #4
  br label %122

43:                                               ; preds = %39
  call void @llvm.lifetime.start.p0(i64 4, ptr %11) #4
  %44 = getelementptr inbounds [44 x i32], ptr %7, i32 0, i32 0
  %45 = load i32, ptr %9, align 4, !tbaa !13
  %46 = shl i32 %45, 2
  %47 = getelementptr inbounds i32, ptr %44, i32 %46
  store ptr %47, ptr %11, align 4, !tbaa !11
  call void @llvm.lifetime.start.p0(i64 4, ptr %12) #4
  store i32 0, ptr %12, align 4, !tbaa !13
  br label %48

48:                                               ; preds = %95, %43
  %49 = load i32, ptr %12, align 4, !tbaa !13
  %50 = icmp slt i32 %49, 4
  br i1 %50, label %52, label %51

51:                                               ; preds = %48
  store i32 8, ptr %10, align 4
  call void @llvm.lifetime.end.p0(i64 4, ptr %12) #4
  br label %98

52:                                               ; preds = %48
  %53 = load ptr, ptr %11, align 4, !tbaa !11
  %54 = getelementptr inbounds i32, ptr %53, i32 0
  %55 = load i32, ptr %54, align 4, !tbaa !13
  %56 = load ptr, ptr %4, align 4, !tbaa !11
  %57 = load i32, ptr %12, align 4, !tbaa !13
  %58 = getelementptr inbounds i32, ptr %56, i32 %57
  %59 = load i32, ptr %58, align 4, !tbaa !13
  %60 = load i32, ptr %12, align 4, !tbaa !13
  %61 = call i32 asm sideeffect "aes32esmi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %59, i32 %60, i32 %55) #4, !srcloc !25
  store i32 %61, ptr %54, align 4, !tbaa !13
  %62 = load ptr, ptr %11, align 4, !tbaa !11
  %63 = getelementptr inbounds i32, ptr %62, i32 1
  %64 = load i32, ptr %63, align 4, !tbaa !13
  %65 = load ptr, ptr %4, align 4, !tbaa !11
  %66 = load i32, ptr %12, align 4, !tbaa !13
  %67 = add nsw i32 1, %66
  %68 = and i32 %67, 3
  %69 = getelementptr inbounds i32, ptr %65, i32 %68
  %70 = load i32, ptr %69, align 4, !tbaa !13
  %71 = load i32, ptr %12, align 4, !tbaa !13
  %72 = call i32 asm sideeffect "aes32esmi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %70, i32 %71, i32 %64) #4, !srcloc !26
  store i32 %72, ptr %63, align 4, !tbaa !13
  %73 = load ptr, ptr %11, align 4, !tbaa !11
  %74 = getelementptr inbounds i32, ptr %73, i32 2
  %75 = load i32, ptr %74, align 4, !tbaa !13
  %76 = load ptr, ptr %4, align 4, !tbaa !11
  %77 = load i32, ptr %12, align 4, !tbaa !13
  %78 = add nsw i32 2, %77
  %79 = and i32 %78, 3
  %80 = getelementptr inbounds i32, ptr %76, i32 %79
  %81 = load i32, ptr %80, align 4, !tbaa !13
  %82 = load i32, ptr %12, align 4, !tbaa !13
  %83 = call i32 asm sideeffect "aes32esmi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %81, i32 %82, i32 %75) #4, !srcloc !27
  store i32 %83, ptr %74, align 4, !tbaa !13
  %84 = load ptr, ptr %11, align 4, !tbaa !11
  %85 = getelementptr inbounds i32, ptr %84, i32 3
  %86 = load i32, ptr %85, align 4, !tbaa !13
  %87 = load ptr, ptr %4, align 4, !tbaa !11
  %88 = load i32, ptr %12, align 4, !tbaa !13
  %89 = add nsw i32 3, %88
  %90 = and i32 %89, 3
  %91 = getelementptr inbounds i32, ptr %87, i32 %90
  %92 = load i32, ptr %91, align 4, !tbaa !13
  %93 = load i32, ptr %12, align 4, !tbaa !13
  %94 = call i32 asm sideeffect "aes32esmi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %92, i32 %93, i32 %86) #4, !srcloc !28
  store i32 %94, ptr %85, align 4, !tbaa !13
  br label %95

95:                                               ; preds = %52
  %96 = load i32, ptr %12, align 4, !tbaa !13
  %97 = add nsw i32 %96, 1
  store i32 %97, ptr %12, align 4, !tbaa !13
  br label %48, !llvm.loop !29

98:                                               ; preds = %51
  %99 = load ptr, ptr %11, align 4, !tbaa !11
  %100 = getelementptr inbounds i32, ptr %99, i32 0
  %101 = load i32, ptr %100, align 4, !tbaa !13
  %102 = load ptr, ptr %4, align 4, !tbaa !11
  %103 = getelementptr inbounds i32, ptr %102, i32 0
  store i32 %101, ptr %103, align 4, !tbaa !13
  %104 = load ptr, ptr %11, align 4, !tbaa !11
  %105 = getelementptr inbounds i32, ptr %104, i32 1
  %106 = load i32, ptr %105, align 4, !tbaa !13
  %107 = load ptr, ptr %4, align 4, !tbaa !11
  %108 = getelementptr inbounds i32, ptr %107, i32 1
  store i32 %106, ptr %108, align 4, !tbaa !13
  %109 = load ptr, ptr %11, align 4, !tbaa !11
  %110 = getelementptr inbounds i32, ptr %109, i32 2
  %111 = load i32, ptr %110, align 4, !tbaa !13
  %112 = load ptr, ptr %4, align 4, !tbaa !11
  %113 = getelementptr inbounds i32, ptr %112, i32 2
  store i32 %111, ptr %113, align 4, !tbaa !13
  %114 = load ptr, ptr %11, align 4, !tbaa !11
  %115 = getelementptr inbounds i32, ptr %114, i32 3
  %116 = load i32, ptr %115, align 4, !tbaa !13
  %117 = load ptr, ptr %4, align 4, !tbaa !11
  %118 = getelementptr inbounds i32, ptr %117, i32 3
  store i32 %116, ptr %118, align 4, !tbaa !13
  call void @llvm.lifetime.end.p0(i64 4, ptr %11) #4
  br label %119

119:                                              ; preds = %98
  %120 = load i32, ptr %9, align 4, !tbaa !13
  %121 = add nsw i32 %120, 1
  store i32 %121, ptr %9, align 4, !tbaa !13
  br label %39, !llvm.loop !31

122:                                              ; preds = %42
  call void @llvm.lifetime.start.p0(i64 4, ptr %13) #4
  %123 = getelementptr inbounds [44 x i32], ptr %7, i32 0, i32 40
  store ptr %123, ptr %13, align 4, !tbaa !11
  call void @llvm.lifetime.start.p0(i64 4, ptr %14) #4
  store i32 0, ptr %14, align 4, !tbaa !13
  br label %124

124:                                              ; preds = %171, %122
  %125 = load i32, ptr %14, align 4, !tbaa !13
  %126 = icmp slt i32 %125, 4
  br i1 %126, label %128, label %127

127:                                              ; preds = %124
  store i32 11, ptr %10, align 4
  call void @llvm.lifetime.end.p0(i64 4, ptr %14) #4
  br label %174

128:                                              ; preds = %124
  %129 = load ptr, ptr %13, align 4, !tbaa !11
  %130 = getelementptr inbounds i32, ptr %129, i32 0
  %131 = load i32, ptr %130, align 4, !tbaa !13
  %132 = load ptr, ptr %4, align 4, !tbaa !11
  %133 = load i32, ptr %14, align 4, !tbaa !13
  %134 = getelementptr inbounds i32, ptr %132, i32 %133
  %135 = load i32, ptr %134, align 4, !tbaa !13
  %136 = load i32, ptr %14, align 4, !tbaa !13
  %137 = call i32 asm sideeffect "aes32esi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %135, i32 %136, i32 %131) #4, !srcloc !32
  store i32 %137, ptr %130, align 4, !tbaa !13
  %138 = load ptr, ptr %13, align 4, !tbaa !11
  %139 = getelementptr inbounds i32, ptr %138, i32 1
  %140 = load i32, ptr %139, align 4, !tbaa !13
  %141 = load ptr, ptr %4, align 4, !tbaa !11
  %142 = load i32, ptr %14, align 4, !tbaa !13
  %143 = add nsw i32 1, %142
  %144 = and i32 %143, 3
  %145 = getelementptr inbounds i32, ptr %141, i32 %144
  %146 = load i32, ptr %145, align 4, !tbaa !13
  %147 = load i32, ptr %14, align 4, !tbaa !13
  %148 = call i32 asm sideeffect "aes32esi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %146, i32 %147, i32 %140) #4, !srcloc !33
  store i32 %148, ptr %139, align 4, !tbaa !13
  %149 = load ptr, ptr %13, align 4, !tbaa !11
  %150 = getelementptr inbounds i32, ptr %149, i32 2
  %151 = load i32, ptr %150, align 4, !tbaa !13
  %152 = load ptr, ptr %4, align 4, !tbaa !11
  %153 = load i32, ptr %14, align 4, !tbaa !13
  %154 = add nsw i32 2, %153
  %155 = and i32 %154, 3
  %156 = getelementptr inbounds i32, ptr %152, i32 %155
  %157 = load i32, ptr %156, align 4, !tbaa !13
  %158 = load i32, ptr %14, align 4, !tbaa !13
  %159 = call i32 asm sideeffect "aes32esi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %157, i32 %158, i32 %151) #4, !srcloc !34
  store i32 %159, ptr %150, align 4, !tbaa !13
  %160 = load ptr, ptr %13, align 4, !tbaa !11
  %161 = getelementptr inbounds i32, ptr %160, i32 3
  %162 = load i32, ptr %161, align 4, !tbaa !13
  %163 = load ptr, ptr %4, align 4, !tbaa !11
  %164 = load i32, ptr %14, align 4, !tbaa !13
  %165 = add nsw i32 3, %164
  %166 = and i32 %165, 3
  %167 = getelementptr inbounds i32, ptr %163, i32 %166
  %168 = load i32, ptr %167, align 4, !tbaa !13
  %169 = load i32, ptr %14, align 4, !tbaa !13
  %170 = call i32 asm sideeffect "aes32esi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %168, i32 %169, i32 %162) #4, !srcloc !35
  store i32 %170, ptr %161, align 4, !tbaa !13
  br label %171

171:                                              ; preds = %128
  %172 = load i32, ptr %14, align 4, !tbaa !13
  %173 = add nsw i32 %172, 1
  store i32 %173, ptr %14, align 4, !tbaa !13
  br label %124, !llvm.loop !36

174:                                              ; preds = %127
  %175 = load ptr, ptr %13, align 4, !tbaa !11
  %176 = getelementptr inbounds i32, ptr %175, i32 0
  %177 = load i32, ptr %176, align 4, !tbaa !13
  %178 = load ptr, ptr %4, align 4, !tbaa !11
  %179 = getelementptr inbounds i32, ptr %178, i32 0
  store i32 %177, ptr %179, align 4, !tbaa !13
  %180 = load ptr, ptr %13, align 4, !tbaa !11
  %181 = getelementptr inbounds i32, ptr %180, i32 1
  %182 = load i32, ptr %181, align 4, !tbaa !13
  %183 = load ptr, ptr %4, align 4, !tbaa !11
  %184 = getelementptr inbounds i32, ptr %183, i32 1
  store i32 %182, ptr %184, align 4, !tbaa !13
  %185 = load ptr, ptr %13, align 4, !tbaa !11
  %186 = getelementptr inbounds i32, ptr %185, i32 2
  %187 = load i32, ptr %186, align 4, !tbaa !13
  %188 = load ptr, ptr %4, align 4, !tbaa !11
  %189 = getelementptr inbounds i32, ptr %188, i32 2
  store i32 %187, ptr %189, align 4, !tbaa !13
  %190 = load ptr, ptr %13, align 4, !tbaa !11
  %191 = getelementptr inbounds i32, ptr %190, i32 3
  %192 = load i32, ptr %191, align 4, !tbaa !13
  %193 = load ptr, ptr %4, align 4, !tbaa !11
  %194 = getelementptr inbounds i32, ptr %193, i32 3
  store i32 %192, ptr %194, align 4, !tbaa !13
  call void @llvm.lifetime.end.p0(i64 4, ptr %13) #4
  call void @llvm.lifetime.end.p0(i64 176, ptr %7) #4
  br label %195

195:                                              ; preds = %174, %18
  ret void
}

; Function Attrs: nounwind
define dso_local void @write_to_address(i32 noundef %0, i32 noundef %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 %0, ptr %3, align 4, !tbaa !13
  store i32 %1, ptr %4, align 4, !tbaa !13
  %5 = load i32, ptr %4, align 4, !tbaa !13
  %6 = load i32, ptr %3, align 4, !tbaa !13
  %7 = inttoptr i32 %6 to ptr
  store volatile i32 %5, ptr %7, align 4, !tbaa !13
  ret void
}

; Function Attrs: nounwind
define dso_local void @write_v_to_address(i32 noundef %0, ptr noundef %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca ptr, align 4
  %5 = alloca i32, align 4
  store i32 %0, ptr %3, align 4, !tbaa !13
  store ptr %1, ptr %4, align 4, !tbaa !11
  call void @llvm.lifetime.start.p0(i64 4, ptr %5) #4
  store i32 0, ptr %5, align 4, !tbaa !13
  br label %6

6:                                                ; preds = %19, %2
  %7 = load i32, ptr %5, align 4, !tbaa !13
  %8 = icmp slt i32 %7, 4
  br i1 %8, label %10, label %9

9:                                                ; preds = %6
  call void @llvm.lifetime.end.p0(i64 4, ptr %5) #4
  br label %22

10:                                               ; preds = %6
  %11 = load i32, ptr %3, align 4, !tbaa !13
  %12 = load i32, ptr %5, align 4, !tbaa !13
  %13 = mul nsw i32 %12, 4
  %14 = add i32 %11, %13
  %15 = load ptr, ptr %4, align 4, !tbaa !11
  %16 = load i32, ptr %5, align 4, !tbaa !13
  %17 = getelementptr inbounds i32, ptr %15, i32 %16
  %18 = load i32, ptr %17, align 4, !tbaa !13
  call void @write_to_address(i32 noundef %14, i32 noundef %18)
  br label %19

19:                                               ; preds = %10
  %20 = load i32, ptr %5, align 4, !tbaa !13
  %21 = add nsw i32 %20, 1
  store i32 %21, ptr %5, align 4, !tbaa !13
  br label %6, !llvm.loop !37

22:                                               ; preds = %9
  ret void
}

; Function Attrs: nounwind
define dso_local i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca [16 x i8], align 1
  %3 = alloca [4 x i32], align 4
  %4 = alloca [16 x i8], align 1
  %5 = alloca [4 x i32], align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  call void @llvm.lifetime.start.p0(i64 16, ptr %2) #4
  call void @llvm.memcpy.p0.p0.i32(ptr align 1 %2, ptr align 1 @__const.main.plaintext, i32 16, i1 false)
  call void @llvm.lifetime.start.p0(i64 16, ptr %3) #4
  %11 = getelementptr inbounds [16 x i8], ptr %2, i32 0, i32 0
  %12 = getelementptr inbounds [4 x i32], ptr %3, i32 0, i32 0
  call void @merge_plaintext_into_state(ptr noundef %11, ptr noundef %12)
  call void @llvm.lifetime.start.p0(i64 16, ptr %4) #4
  call void @llvm.memcpy.p0.p0.i32(ptr align 1 %4, ptr align 1 @__const.main.key, i32 16, i1 false)
  call void @llvm.lifetime.start.p0(i64 16, ptr %5) #4
  call void @llvm.memcpy.p0.p0.i32(ptr align 4 %5, ptr align 4 @__const.main.expected_output, i32 16, i1 false)
  call void @llvm.lifetime.start.p0(i64 4, ptr %6) #4
  store i32 16, ptr %6, align 4, !tbaa !13
  call void @llvm.lifetime.start.p0(i64 4, ptr %7) #4
  call void @llvm.lifetime.start.p0(i64 4, ptr %8) #4
  %13 = getelementptr inbounds [4 x i32], ptr %3, i32 0, i32 0
  %14 = load i32, ptr %6, align 4, !tbaa !13
  %15 = getelementptr inbounds [16 x i8], ptr %4, i32 0, i32 0
  call void @aes128_ecb_encrypt(ptr noundef %13, i32 noundef %14, ptr noundef %15)
  store i32 1056816, ptr %7, align 4, !tbaa !13
  %16 = load i32, ptr %7, align 4, !tbaa !13
  %17 = getelementptr inbounds [4 x i32], ptr %5, i32 0, i32 0
  call void @write_v_to_address(i32 noundef %16, ptr noundef %17)
  store i32 1056832, ptr %7, align 4, !tbaa !13
  %18 = load i32, ptr %7, align 4, !tbaa !13
  %19 = getelementptr inbounds [4 x i32], ptr %3, i32 0, i32 0
  call void @write_v_to_address(i32 noundef %18, ptr noundef %19)
  store i32 1056772, ptr %7, align 4, !tbaa !13
  store i32 -889275714, ptr %8, align 4, !tbaa !13
  call void @llvm.lifetime.start.p0(i64 4, ptr %9) #4
  store i32 0, ptr %9, align 4, !tbaa !13
  br label %20

20:                                               ; preds = %38, %0
  %21 = load i32, ptr %9, align 4, !tbaa !13
  %22 = icmp slt i32 %21, 4
  br i1 %22, label %24, label %23

23:                                               ; preds = %20
  store i32 2, ptr %10, align 4
  br label %41

24:                                               ; preds = %20
  %25 = load i32, ptr %7, align 4, !tbaa !13
  %26 = load i32, ptr %9, align 4, !tbaa !13
  %27 = getelementptr inbounds [4 x i32], ptr %3, i32 0, i32 %26
  %28 = load i32, ptr %27, align 4, !tbaa !13
  call void @write_to_address(i32 noundef %25, i32 noundef %28)
  %29 = load i32, ptr %9, align 4, !tbaa !13
  %30 = getelementptr inbounds [4 x i32], ptr %3, i32 0, i32 %29
  %31 = load i32, ptr %30, align 4, !tbaa !13
  %32 = load i32, ptr %9, align 4, !tbaa !13
  %33 = getelementptr inbounds [4 x i32], ptr %5, i32 0, i32 %32
  %34 = load i32, ptr %33, align 4, !tbaa !13
  %35 = icmp ne i32 %31, %34
  br i1 %35, label %36, label %37

36:                                               ; preds = %24
  store i32 -1163220309, ptr %8, align 4, !tbaa !13
  store i32 2, ptr %10, align 4
  br label %41

37:                                               ; preds = %24
  br label %38

38:                                               ; preds = %37
  %39 = load i32, ptr %9, align 4, !tbaa !13
  %40 = add nsw i32 %39, 1
  store i32 %40, ptr %9, align 4, !tbaa !13
  br label %20, !llvm.loop !38

41:                                               ; preds = %36, %23
  call void @llvm.lifetime.end.p0(i64 4, ptr %9) #4
  br label %42

42:                                               ; preds = %41
  %43 = getelementptr inbounds [4 x i32], ptr %3, i32 0, i32 0
  %44 = load i32, ptr %43, align 4, !tbaa !13
  call void @write_to_address(i32 noundef 1107304512, i32 noundef %44)
  %45 = getelementptr inbounds [4 x i32], ptr %3, i32 0, i32 1
  %46 = load i32, ptr %45, align 4, !tbaa !13
  call void @write_to_address(i32 noundef 1107304516, i32 noundef %46)
  %47 = getelementptr inbounds [4 x i32], ptr %3, i32 0, i32 2
  %48 = load i32, ptr %47, align 4, !tbaa !13
  call void @write_to_address(i32 noundef 1107304520, i32 noundef %48)
  %49 = getelementptr inbounds [4 x i32], ptr %3, i32 0, i32 3
  %50 = load i32, ptr %49, align 4, !tbaa !13
  call void @write_to_address(i32 noundef 1107304524, i32 noundef %50)
  %51 = load i32, ptr %7, align 4, !tbaa !13
  %52 = load i32, ptr %8, align 4, !tbaa !13
  call void @write_to_address(i32 noundef %51, i32 noundef %52)
  store i32 1056768, ptr %7, align 4, !tbaa !13
  store i32 -559038737, ptr %8, align 4, !tbaa !13
  %53 = load i32, ptr %7, align 4, !tbaa !13
  %54 = load i32, ptr %8, align 4, !tbaa !13
  call void @write_to_address(i32 noundef %53, i32 noundef %54)
  store i32 0, ptr %1, align 4
  store i32 1, ptr %10, align 4
  call void @llvm.lifetime.end.p0(i64 4, ptr %8) #4
  call void @llvm.lifetime.end.p0(i64 4, ptr %7) #4
  call void @llvm.lifetime.end.p0(i64 4, ptr %6) #4
  call void @llvm.lifetime.end.p0(i64 16, ptr %5) #4
  call void @llvm.lifetime.end.p0(i64 16, ptr %4) #4
  call void @llvm.lifetime.end.p0(i64 16, ptr %3) #4
  call void @llvm.lifetime.end.p0(i64 16, ptr %2) #4
  %55 = load i32, ptr %1, align 4
  ret i32 %55
}

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i32(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i32, i1 immarg) #3

attributes #0 = { nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic-rv32" "target-features"="+32bit,+a,+c,+d,+f,+m,+relax,+zaamo,+zalrsc,+zca,+zcd,+zcf,+zicsr,+zifencei,+zkne,+zmmul,-b,-e,-experimental-p,-experimental-smctr,-experimental-ssctr,-experimental-svukte,-experimental-xqccmp,-experimental-xqcia,-experimental-xqciac,-experimental-xqcibi,-experimental-xqcibm,-experimental-xqcicli,-experimental-xqcicm,-experimental-xqcics,-experimental-xqcicsr,-experimental-xqciint,-experimental-xqciio,-experimental-xqcilb,-experimental-xqcili,-experimental-xqcilia,-experimental-xqcilo,-experimental-xqcilsm,-experimental-xqcisim,-experimental-xqcisls,-experimental-xqcisync,-experimental-xrivosvisni,-experimental-xrivosvizip,-experimental-zalasr,-experimental-zicfilp,-experimental-zicfiss,-experimental-zvbc32e,-experimental-zvkgs,-experimental-zvqdotq,-h,-sdext,-sdtrig,-sha,-shcounterenw,-shgatpa,-shtvala,-shvsatpa,-shvstvala,-shvstvecd,-smaia,-smcdeleg,-smcsrind,-smdbltrp,-smepmp,-smmpm,-smnpm,-smrnmi,-smstateen,-ssaia,-ssccfg,-ssccptr,-sscofpmf,-sscounterenw,-sscsrind,-ssdbltrp,-ssnpm,-sspm,-ssqosid,-ssstateen,-ssstrict,-sstc,-sstvala,-sstvecd,-ssu64xl,-supm,-svade,-svadu,-svbare,-svinval,-svnapot,-svpbmt,-svvptc,-v,-xcvalu,-xcvbi,-xcvbitmanip,-xcvelw,-xcvmac,-xcvmem,-xcvsimd,-xmipscmov,-xmipslsp,-xsfcease,-xsfvcp,-xsfvfnrclipxfqf,-xsfvfwmaccqqq,-xsfvqmaccdod,-xsfvqmaccqoq,-xsifivecdiscarddlone,-xsifivecflushdlone,-xtheadba,-xtheadbb,-xtheadbs,-xtheadcmo,-xtheadcondmov,-xtheadfmemidx,-xtheadmac,-xtheadmemidx,-xtheadmempair,-xtheadsync,-xtheadvdot,-xventanacondops,-xwchc,-za128rs,-za64rs,-zabha,-zacas,-zama16b,-zawrs,-zba,-zbb,-zbc,-zbkb,-zbkc,-zbkx,-zbs,-zcb,-zce,-zclsd,-zcmop,-zcmp,-zcmt,-zdinx,-zfa,-zfbfmin,-zfh,-zfhmin,-zfinx,-zhinx,-zhinxmin,-zic64b,-zicbom,-zicbop,-zicboz,-ziccamoa,-ziccif,-zicclsm,-ziccrse,-zicntr,-zicond,-zihintntl,-zihintpause,-zihpm,-zilsd,-zimop,-zk,-zkn,-zknd,-zknh,-zkr,-zks,-zksed,-zksh,-zkt,-ztso,-zvbb,-zvbc,-zve32f,-zve32x,-zve64d,-zve64f,-zve64x,-zvfbfmin,-zvfbfwma,-zvfh,-zvfhmin,-zvkb,-zvkg,-zvkn,-zvknc,-zvkned,-zvkng,-zvknha,-zvknhb,-zvks,-zvksc,-zvksed,-zvksg,-zvksh,-zvkt,-zvl1024b,-zvl128b,-zvl16384b,-zvl2048b,-zvl256b,-zvl32768b,-zvl32b,-zvl4096b,-zvl512b,-zvl64b,-zvl65536b,-zvl8192b" }
attributes #1 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { inlinehint nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic-rv32" "target-features"="+32bit,+a,+c,+d,+f,+m,+relax,+zaamo,+zalrsc,+zca,+zcd,+zcf,+zicsr,+zifencei,+zkne,+zmmul,-b,-e,-experimental-p,-experimental-smctr,-experimental-ssctr,-experimental-svukte,-experimental-xqccmp,-experimental-xqcia,-experimental-xqciac,-experimental-xqcibi,-experimental-xqcibm,-experimental-xqcicli,-experimental-xqcicm,-experimental-xqcics,-experimental-xqcicsr,-experimental-xqciint,-experimental-xqciio,-experimental-xqcilb,-experimental-xqcili,-experimental-xqcilia,-experimental-xqcilo,-experimental-xqcilsm,-experimental-xqcisim,-experimental-xqcisls,-experimental-xqcisync,-experimental-xrivosvisni,-experimental-xrivosvizip,-experimental-zalasr,-experimental-zicfilp,-experimental-zicfiss,-experimental-zvbc32e,-experimental-zvkgs,-experimental-zvqdotq,-h,-sdext,-sdtrig,-sha,-shcounterenw,-shgatpa,-shtvala,-shvsatpa,-shvstvala,-shvstvecd,-smaia,-smcdeleg,-smcsrind,-smdbltrp,-smepmp,-smmpm,-smnpm,-smrnmi,-smstateen,-ssaia,-ssccfg,-ssccptr,-sscofpmf,-sscounterenw,-sscsrind,-ssdbltrp,-ssnpm,-sspm,-ssqosid,-ssstateen,-ssstrict,-sstc,-sstvala,-sstvecd,-ssu64xl,-supm,-svade,-svadu,-svbare,-svinval,-svnapot,-svpbmt,-svvptc,-v,-xcvalu,-xcvbi,-xcvbitmanip,-xcvelw,-xcvmac,-xcvmem,-xcvsimd,-xmipscmov,-xmipslsp,-xsfcease,-xsfvcp,-xsfvfnrclipxfqf,-xsfvfwmaccqqq,-xsfvqmaccdod,-xsfvqmaccqoq,-xsifivecdiscarddlone,-xsifivecflushdlone,-xtheadba,-xtheadbb,-xtheadbs,-xtheadcmo,-xtheadcondmov,-xtheadfmemidx,-xtheadmac,-xtheadmemidx,-xtheadmempair,-xtheadsync,-xtheadvdot,-xventanacondops,-xwchc,-za128rs,-za64rs,-zabha,-zacas,-zama16b,-zawrs,-zba,-zbb,-zbc,-zbkb,-zbkc,-zbkx,-zbs,-zcb,-zce,-zclsd,-zcmop,-zcmp,-zcmt,-zdinx,-zfa,-zfbfmin,-zfh,-zfhmin,-zfinx,-zhinx,-zhinxmin,-zic64b,-zicbom,-zicbop,-zicboz,-ziccamoa,-ziccif,-zicclsm,-ziccrse,-zicntr,-zicond,-zihintntl,-zihintpause,-zihpm,-zilsd,-zimop,-zk,-zkn,-zknd,-zknh,-zkr,-zks,-zksed,-zksh,-zkt,-ztso,-zvbb,-zvbc,-zve32f,-zve32x,-zve64d,-zve64f,-zve64x,-zvfbfmin,-zvfbfwma,-zvfh,-zvfhmin,-zvkb,-zvkg,-zvkn,-zvknc,-zvkned,-zvkng,-zvknha,-zvknhb,-zvks,-zvksc,-zvksed,-zvksg,-zvksh,-zvkt,-zvl1024b,-zvl128b,-zvl16384b,-zvl2048b,-zvl256b,-zvl32768b,-zvl32b,-zvl4096b,-zvl512b,-zvl64b,-zvl65536b,-zvl8192b" }
attributes #3 = { nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #4 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"target-abi", !"ilp32"}
!2 = !{i32 6, !"riscv-isa", !3}
!3 = !{!"rv32i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zifencei2p0_zmmul1p0_zaamo1p0_zalrsc1p0_zca1p0_zcd1p0_zcf1p0_zkne1p0"}
!4 = !{i32 8, !"SmallDataLimit", i32 0}
!5 = !{!"clang version 21.0.0git (https://github.com/llvm/llvm-project.git f351172d4a840dfbf533319b62925747a10b762f)"}
!6 = !{!7, !7, i64 0}
!7 = !{!"p1 omnipotent char", !8, i64 0}
!8 = !{!"any pointer", !9, i64 0}
!9 = !{!"omnipotent char", !10, i64 0}
!10 = !{!"Simple C/C++ TBAA"}
!11 = !{!12, !12, i64 0}
!12 = !{!"p1 int", !8, i64 0}
!13 = !{!14, !14, i64 0}
!14 = !{!"int", !9, i64 0}
!15 = distinct !{!15, !16}
!16 = !{!"llvm.loop.mustprogress"}
!17 = !{!9, !9, i64 0}
!18 = distinct !{!18, !16}
!19 = !{i64 2147691066}
!20 = !{i64 2147691236}
!21 = !{i64 2147691406}
!22 = !{i64 2147691576}
!23 = distinct !{!23, !16}
!24 = distinct !{!24, !16}
!25 = !{i64 2147691746}
!26 = !{i64 2147691927}
!27 = !{i64 2147692118}
!28 = !{i64 2147692309}
!29 = distinct !{!29, !16, !30}
!30 = !{!"llvm.loop.unroll.full"}
!31 = distinct !{!31, !16}
!32 = !{i64 2147692500}
!33 = !{i64 2147692680}
!34 = !{i64 2147692870}
!35 = !{i64 2147693060}
!36 = distinct !{!36, !16, !30}
!37 = distinct !{!37, !16}
!38 = distinct !{!38, !16}
