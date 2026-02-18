; ModuleID = 'output/main_hw_aes.ll'
source_filename = "main_hw_aes.c"
target datalayout = "e-m:e-p:32:32-i64:64-n32-S128"
target triple = "riscv32-unknown-unknown-elf"

@rcon = internal constant [10 x i8] c"\01\02\04\08\10 @\80\1B6", align 1
@__const.main.plaintext = private unnamed_addr constant [16 x i8] c"Hello, World!000", align 1
@__const.main.key = private unnamed_addr constant [16 x i8] c"cese4040password", align 1
@__const.main.expected_output = private unnamed_addr constant [4 x i32] [i32 -73070316, i32 1900803103, i32 774220478, i32 -1426520049], align 4

; Function Attrs: nounwind
define dso_local void @merge_plaintext_into_state(ptr noundef %0, ptr noundef %1) #0 {
  br label %3

3:                                                ; preds = %2
  br label %5

4:                                                ; preds = %22
  br label %28

5:                                                ; preds = %3
  %6 = call i32 @load32_le(ptr noundef %0)
  store i32 %6, ptr %1, align 4, !tbaa !6
  br label %7

7:                                                ; preds = %5
  br label %8

8:                                                ; preds = %7
  %9 = getelementptr inbounds i8, ptr %0, i32 4
  %10 = call i32 @load32_le(ptr noundef %9)
  %11 = getelementptr inbounds i32, ptr %1, i32 1
  store i32 %10, ptr %11, align 4, !tbaa !6
  br label %12

12:                                               ; preds = %8
  br label %13

13:                                               ; preds = %12
  %14 = getelementptr inbounds i8, ptr %0, i32 8
  %15 = call i32 @load32_le(ptr noundef %14)
  %16 = getelementptr inbounds i32, ptr %1, i32 2
  store i32 %15, ptr %16, align 4, !tbaa !6
  br label %17

17:                                               ; preds = %13
  br label %18

18:                                               ; preds = %17
  %19 = getelementptr inbounds i8, ptr %0, i32 12
  %20 = call i32 @load32_le(ptr noundef %19)
  %21 = getelementptr inbounds i32, ptr %1, i32 3
  store i32 %20, ptr %21, align 4, !tbaa !6
  br label %22

22:                                               ; preds = %18
  br i1 false, label %23, label %4

23:                                               ; preds = %22
  %24 = getelementptr inbounds i8, ptr %0, i32 16
  %25 = call i32 @load32_le(ptr noundef %24)
  %26 = getelementptr inbounds i32, ptr %1, i32 4
  store i32 %25, ptr %26, align 4, !tbaa !6
  br label %27

27:                                               ; preds = %23
  unreachable

28:                                               ; preds = %4
  ret void
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: inlinehint nounwind
define internal i32 @load32_le(ptr noundef %0) #2 {
  %2 = getelementptr inbounds i8, ptr %0, i32 0
  %3 = load i8, ptr %2, align 1, !tbaa !10
  %4 = zext i8 %3 to i32
  %5 = getelementptr inbounds i8, ptr %0, i32 1
  %6 = load i8, ptr %5, align 1, !tbaa !10
  %7 = zext i8 %6 to i32
  %8 = shl i32 %7, 8
  %9 = or i32 %4, %8
  %10 = getelementptr inbounds i8, ptr %0, i32 2
  %11 = load i8, ptr %10, align 1, !tbaa !10
  %12 = zext i8 %11 to i32
  %13 = shl i32 %12, 16
  %14 = or i32 %9, %13
  %15 = getelementptr inbounds i8, ptr %0, i32 3
  %16 = load i8, ptr %15, align 1, !tbaa !10
  %17 = zext i8 %16 to i32
  %18 = shl i32 %17, 24
  %19 = or i32 %14, %18
  ret i32 %19
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: nounwind
define dso_local void @expand_key_hweq(ptr noundef %0, ptr noundef %1) #0 {
  br label %3

3:                                                ; preds = %2
  br label %5

4:                                                ; preds = %22
  br label %28

5:                                                ; preds = %3
  %6 = call i32 @load32_le(ptr noundef %0)
  store i32 %6, ptr %1, align 4, !tbaa !6
  br label %7

7:                                                ; preds = %5
  br label %8

8:                                                ; preds = %7
  %9 = getelementptr inbounds i8, ptr %0, i32 4
  %10 = call i32 @load32_le(ptr noundef %9)
  %11 = getelementptr inbounds i32, ptr %1, i32 1
  store i32 %10, ptr %11, align 4, !tbaa !6
  br label %12

12:                                               ; preds = %8
  br label %13

13:                                               ; preds = %12
  %14 = getelementptr inbounds i8, ptr %0, i32 8
  %15 = call i32 @load32_le(ptr noundef %14)
  %16 = getelementptr inbounds i32, ptr %1, i32 2
  store i32 %15, ptr %16, align 4, !tbaa !6
  br label %17

17:                                               ; preds = %13
  br label %18

18:                                               ; preds = %17
  %19 = getelementptr inbounds i8, ptr %0, i32 12
  %20 = call i32 @load32_le(ptr noundef %19)
  %21 = getelementptr inbounds i32, ptr %1, i32 3
  store i32 %20, ptr %21, align 4, !tbaa !6
  br label %22

22:                                               ; preds = %18
  br i1 false, label %23, label %4

23:                                               ; preds = %22
  %24 = getelementptr inbounds i8, ptr %0, i32 16
  %25 = call i32 @load32_le(ptr noundef %24)
  %26 = getelementptr inbounds i32, ptr %1, i32 4
  store i32 %25, ptr %26, align 4, !tbaa !6
  br label %27

27:                                               ; preds = %23
  unreachable

28:                                               ; preds = %4
  br label %29

29:                                               ; preds = %78, %28
  %.0 = phi i32 [ 1, %28 ], [ %79, %78 ]
  %exitcond2 = icmp ne i32 %.0, 11
  br i1 %exitcond2, label %31, label %30

30:                                               ; preds = %29
  br label %80

31:                                               ; preds = %29
  %32 = shl i32 %.0, 2
  %33 = sub nuw nsw i32 %32, 1
  %34 = getelementptr inbounds i32, ptr %1, i32 %33
  %35 = load i32, ptr %34, align 4, !tbaa !6
  %36 = lshr i32 %35, 8
  %37 = shl i32 %35, 24
  %38 = or i32 %36, %37
  %39 = sub nuw nsw i32 %32, 4
  %40 = getelementptr inbounds i32, ptr %1, i32 %39
  %41 = load i32, ptr %40, align 4, !tbaa !6
  %42 = sub nuw nsw i32 %.0, 1
  %43 = getelementptr inbounds [10 x i8], ptr @rcon, i32 0, i32 %42
  %44 = load i8, ptr %43, align 1, !tbaa !10
  %45 = zext i8 %44 to i32
  %46 = xor i32 %41, %45
  %47 = call i32 asm sideeffect "aes32esi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %38, i32 0, i32 %46) #4, !srcloc !11
  %48 = call i32 asm sideeffect "aes32esi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %38, i32 1, i32 %47) #4, !srcloc !12
  %49 = call i32 asm sideeffect "aes32esi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %38, i32 2, i32 %48) #4, !srcloc !13
  %50 = call i32 asm sideeffect "aes32esi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %38, i32 3, i32 %49) #4, !srcloc !14
  %51 = getelementptr inbounds i32, ptr %1, i32 %32
  store i32 %50, ptr %51, align 4, !tbaa !6
  %52 = getelementptr inbounds i32, ptr %1, i32 %32
  %53 = load i32, ptr %52, align 4, !tbaa !6
  %54 = sub nuw nsw i32 %32, 3
  %55 = getelementptr inbounds i32, ptr %1, i32 %54
  %56 = load i32, ptr %55, align 4, !tbaa !6
  %57 = xor i32 %53, %56
  %58 = add nuw nsw i32 %32, 1
  %59 = getelementptr inbounds i32, ptr %1, i32 %58
  store i32 %57, ptr %59, align 4, !tbaa !6
  %60 = add nuw nsw i32 %32, 1
  %61 = getelementptr inbounds i32, ptr %1, i32 %60
  %62 = load i32, ptr %61, align 4, !tbaa !6
  %63 = sub nuw nsw i32 %32, 2
  %64 = getelementptr inbounds i32, ptr %1, i32 %63
  %65 = load i32, ptr %64, align 4, !tbaa !6
  %66 = xor i32 %62, %65
  %67 = add nuw nsw i32 %32, 2
  %68 = getelementptr inbounds i32, ptr %1, i32 %67
  store i32 %66, ptr %68, align 4, !tbaa !6
  %69 = add nuw nsw i32 %32, 2
  %70 = getelementptr inbounds i32, ptr %1, i32 %69
  %71 = load i32, ptr %70, align 4, !tbaa !6
  %72 = sub nuw nsw i32 %32, 1
  %73 = getelementptr inbounds i32, ptr %1, i32 %72
  %74 = load i32, ptr %73, align 4, !tbaa !6
  %75 = xor i32 %71, %74
  %76 = add nuw nsw i32 %32, 3
  %77 = getelementptr inbounds i32, ptr %1, i32 %76
  store i32 %75, ptr %77, align 4, !tbaa !6
  br label %78

78:                                               ; preds = %31
  %79 = add nuw nsw i32 %.0, 1
  br label %29, !llvm.loop !15

80:                                               ; preds = %30
  ret void
}

; Function Attrs: nounwind
define dso_local void @aes128_ecb_encrypt(ptr noundef %0, i32 noundef %1, ptr noundef %2) #0 {
  %4 = alloca [44 x i32], align 4
  %5 = urem i32 %1, 16
  %6 = icmp ne i32 %5, 0
  br i1 %6, label %7, label %8

7:                                                ; preds = %3
  br label %287

8:                                                ; preds = %3
  call void @llvm.lifetime.start.p0(i64 176, ptr %4) #4
  %9 = getelementptr inbounds [44 x i32], ptr %4, i32 0, i32 0
  call void @expand_key_hweq(ptr noundef %2, ptr noundef %9)
  br label %10

10:                                               ; preds = %8
  br label %12

11:                                               ; preds = %37
  br label %45

12:                                               ; preds = %10
  %13 = load i32, ptr %4, align 4, !tbaa !6
  %14 = load i32, ptr %0, align 4, !tbaa !6
  %15 = xor i32 %14, %13
  store i32 %15, ptr %0, align 4, !tbaa !6
  br label %16

16:                                               ; preds = %12
  br label %17

17:                                               ; preds = %16
  %18 = getelementptr inbounds [44 x i32], ptr %4, i32 0, i32 1
  %19 = load i32, ptr %18, align 4, !tbaa !6
  %20 = getelementptr inbounds i32, ptr %0, i32 1
  %21 = load i32, ptr %20, align 4, !tbaa !6
  %22 = xor i32 %21, %19
  store i32 %22, ptr %20, align 4, !tbaa !6
  br label %23

23:                                               ; preds = %17
  br label %24

24:                                               ; preds = %23
  %25 = getelementptr inbounds [44 x i32], ptr %4, i32 0, i32 2
  %26 = load i32, ptr %25, align 4, !tbaa !6
  %27 = getelementptr inbounds i32, ptr %0, i32 2
  %28 = load i32, ptr %27, align 4, !tbaa !6
  %29 = xor i32 %28, %26
  store i32 %29, ptr %27, align 4, !tbaa !6
  br label %30

30:                                               ; preds = %24
  br label %31

31:                                               ; preds = %30
  %32 = getelementptr inbounds [44 x i32], ptr %4, i32 0, i32 3
  %33 = load i32, ptr %32, align 4, !tbaa !6
  %34 = getelementptr inbounds i32, ptr %0, i32 3
  %35 = load i32, ptr %34, align 4, !tbaa !6
  %36 = xor i32 %35, %33
  store i32 %36, ptr %34, align 4, !tbaa !6
  br label %37

37:                                               ; preds = %31
  br i1 false, label %38, label %11

38:                                               ; preds = %37
  %39 = getelementptr inbounds [44 x i32], ptr %4, i32 0, i32 4
  %40 = load i32, ptr %39, align 4, !tbaa !6
  %41 = getelementptr inbounds i32, ptr %0, i32 4
  %42 = load i32, ptr %41, align 4, !tbaa !6
  %43 = xor i32 %42, %40
  store i32 %43, ptr %41, align 4, !tbaa !6
  br label %44

44:                                               ; preds = %38
  unreachable

45:                                               ; preds = %11
  br label %46

46:                                               ; preds = %167, %45
  %.03 = phi i32 [ 1, %45 ], [ %168, %167 ]
  %exitcond5 = icmp ne i32 %.03, 10
  br i1 %exitcond5, label %48, label %47

47:                                               ; preds = %46
  br label %169

48:                                               ; preds = %46
  %49 = getelementptr inbounds [44 x i32], ptr %4, i32 0, i32 0
  %50 = shl i32 %.03, 2
  %51 = getelementptr inbounds i32, ptr %49, i32 %50
  br label %52

52:                                               ; preds = %48
  br label %54

53:                                               ; preds = %133
  br label %155

54:                                               ; preds = %52
  %55 = load i32, ptr %51, align 4, !tbaa !6
  %56 = load i32, ptr %0, align 4, !tbaa !6
  %57 = call i32 asm sideeffect "aes32esmi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %56, i32 0, i32 %55) #4, !srcloc !17
  store i32 %57, ptr %51, align 4, !tbaa !6
  %58 = getelementptr inbounds i32, ptr %51, i32 1
  %59 = load i32, ptr %58, align 4, !tbaa !6
  %60 = getelementptr inbounds i32, ptr %0, i32 1
  %61 = load i32, ptr %60, align 4, !tbaa !6
  %62 = call i32 asm sideeffect "aes32esmi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %61, i32 0, i32 %59) #4, !srcloc !18
  store i32 %62, ptr %58, align 4, !tbaa !6
  %63 = getelementptr inbounds i32, ptr %51, i32 2
  %64 = load i32, ptr %63, align 4, !tbaa !6
  %65 = getelementptr inbounds i32, ptr %0, i32 2
  %66 = load i32, ptr %65, align 4, !tbaa !6
  %67 = call i32 asm sideeffect "aes32esmi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %66, i32 0, i32 %64) #4, !srcloc !19
  store i32 %67, ptr %63, align 4, !tbaa !6
  %68 = getelementptr inbounds i32, ptr %51, i32 3
  %69 = load i32, ptr %68, align 4, !tbaa !6
  %70 = getelementptr inbounds i32, ptr %0, i32 3
  %71 = load i32, ptr %70, align 4, !tbaa !6
  %72 = call i32 asm sideeffect "aes32esmi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %71, i32 0, i32 %69) #4, !srcloc !20
  store i32 %72, ptr %68, align 4, !tbaa !6
  br label %73

73:                                               ; preds = %54
  br label %74

74:                                               ; preds = %73
  %75 = load i32, ptr %51, align 4, !tbaa !6
  %76 = getelementptr inbounds i32, ptr %0, i32 1
  %77 = load i32, ptr %76, align 4, !tbaa !6
  %78 = call i32 asm sideeffect "aes32esmi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %77, i32 1, i32 %75) #4, !srcloc !17
  store i32 %78, ptr %51, align 4, !tbaa !6
  %79 = getelementptr inbounds i32, ptr %51, i32 1
  %80 = load i32, ptr %79, align 4, !tbaa !6
  %81 = getelementptr inbounds i32, ptr %0, i32 2
  %82 = load i32, ptr %81, align 4, !tbaa !6
  %83 = call i32 asm sideeffect "aes32esmi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %82, i32 1, i32 %80) #4, !srcloc !18
  store i32 %83, ptr %79, align 4, !tbaa !6
  %84 = getelementptr inbounds i32, ptr %51, i32 2
  %85 = load i32, ptr %84, align 4, !tbaa !6
  %86 = getelementptr inbounds i32, ptr %0, i32 3
  %87 = load i32, ptr %86, align 4, !tbaa !6
  %88 = call i32 asm sideeffect "aes32esmi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %87, i32 1, i32 %85) #4, !srcloc !19
  store i32 %88, ptr %84, align 4, !tbaa !6
  %89 = getelementptr inbounds i32, ptr %51, i32 3
  %90 = load i32, ptr %89, align 4, !tbaa !6
  %91 = load i32, ptr %0, align 4, !tbaa !6
  %92 = call i32 asm sideeffect "aes32esmi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %91, i32 1, i32 %90) #4, !srcloc !20
  store i32 %92, ptr %89, align 4, !tbaa !6
  br label %93

93:                                               ; preds = %74
  br label %94

94:                                               ; preds = %93
  %95 = load i32, ptr %51, align 4, !tbaa !6
  %96 = getelementptr inbounds i32, ptr %0, i32 2
  %97 = load i32, ptr %96, align 4, !tbaa !6
  %98 = call i32 asm sideeffect "aes32esmi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %97, i32 2, i32 %95) #4, !srcloc !17
  store i32 %98, ptr %51, align 4, !tbaa !6
  %99 = getelementptr inbounds i32, ptr %51, i32 1
  %100 = load i32, ptr %99, align 4, !tbaa !6
  %101 = getelementptr inbounds i32, ptr %0, i32 3
  %102 = load i32, ptr %101, align 4, !tbaa !6
  %103 = call i32 asm sideeffect "aes32esmi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %102, i32 2, i32 %100) #4, !srcloc !18
  store i32 %103, ptr %99, align 4, !tbaa !6
  %104 = getelementptr inbounds i32, ptr %51, i32 2
  %105 = load i32, ptr %104, align 4, !tbaa !6
  %106 = load i32, ptr %0, align 4, !tbaa !6
  %107 = call i32 asm sideeffect "aes32esmi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %106, i32 2, i32 %105) #4, !srcloc !19
  store i32 %107, ptr %104, align 4, !tbaa !6
  %108 = getelementptr inbounds i32, ptr %51, i32 3
  %109 = load i32, ptr %108, align 4, !tbaa !6
  %110 = getelementptr inbounds i32, ptr %0, i32 1
  %111 = load i32, ptr %110, align 4, !tbaa !6
  %112 = call i32 asm sideeffect "aes32esmi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %111, i32 2, i32 %109) #4, !srcloc !20
  store i32 %112, ptr %108, align 4, !tbaa !6
  br label %113

113:                                              ; preds = %94
  br label %114

114:                                              ; preds = %113
  %115 = load i32, ptr %51, align 4, !tbaa !6
  %116 = getelementptr inbounds i32, ptr %0, i32 3
  %117 = load i32, ptr %116, align 4, !tbaa !6
  %118 = call i32 asm sideeffect "aes32esmi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %117, i32 3, i32 %115) #4, !srcloc !17
  store i32 %118, ptr %51, align 4, !tbaa !6
  %119 = getelementptr inbounds i32, ptr %51, i32 1
  %120 = load i32, ptr %119, align 4, !tbaa !6
  %121 = load i32, ptr %0, align 4, !tbaa !6
  %122 = call i32 asm sideeffect "aes32esmi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %121, i32 3, i32 %120) #4, !srcloc !18
  store i32 %122, ptr %119, align 4, !tbaa !6
  %123 = getelementptr inbounds i32, ptr %51, i32 2
  %124 = load i32, ptr %123, align 4, !tbaa !6
  %125 = getelementptr inbounds i32, ptr %0, i32 1
  %126 = load i32, ptr %125, align 4, !tbaa !6
  %127 = call i32 asm sideeffect "aes32esmi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %126, i32 3, i32 %124) #4, !srcloc !19
  store i32 %127, ptr %123, align 4, !tbaa !6
  %128 = getelementptr inbounds i32, ptr %51, i32 3
  %129 = load i32, ptr %128, align 4, !tbaa !6
  %130 = getelementptr inbounds i32, ptr %0, i32 2
  %131 = load i32, ptr %130, align 4, !tbaa !6
  %132 = call i32 asm sideeffect "aes32esmi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %131, i32 3, i32 %129) #4, !srcloc !20
  store i32 %132, ptr %128, align 4, !tbaa !6
  br label %133

133:                                              ; preds = %114
  br i1 false, label %134, label %53

134:                                              ; preds = %133
  %.lcssa = phi ptr [ %51, %133 ]
  %135 = load i32, ptr %.lcssa, align 4, !tbaa !6
  %136 = getelementptr inbounds i32, ptr %0, i32 4
  %137 = load i32, ptr %136, align 4, !tbaa !6
  %138 = call i32 asm sideeffect "aes32esmi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %137, i32 4, i32 %135) #4, !srcloc !17
  store i32 %138, ptr %.lcssa, align 4, !tbaa !6
  %139 = getelementptr inbounds i32, ptr %.lcssa, i32 1
  %140 = load i32, ptr %139, align 4, !tbaa !6
  %141 = getelementptr inbounds i32, ptr %0, i32 1
  %142 = load i32, ptr %141, align 4, !tbaa !6
  %143 = call i32 asm sideeffect "aes32esmi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %142, i32 4, i32 %140) #4, !srcloc !18
  store i32 %143, ptr %139, align 4, !tbaa !6
  %144 = getelementptr inbounds i32, ptr %.lcssa, i32 2
  %145 = load i32, ptr %144, align 4, !tbaa !6
  %146 = getelementptr inbounds i32, ptr %0, i32 2
  %147 = load i32, ptr %146, align 4, !tbaa !6
  %148 = call i32 asm sideeffect "aes32esmi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %147, i32 4, i32 %145) #4, !srcloc !19
  store i32 %148, ptr %144, align 4, !tbaa !6
  %149 = getelementptr inbounds i32, ptr %.lcssa, i32 3
  %150 = load i32, ptr %149, align 4, !tbaa !6
  %151 = getelementptr inbounds i32, ptr %0, i32 3
  %152 = load i32, ptr %151, align 4, !tbaa !6
  %153 = call i32 asm sideeffect "aes32esmi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %152, i32 4, i32 %150) #4, !srcloc !20
  store i32 %153, ptr %149, align 4, !tbaa !6
  br label %154

154:                                              ; preds = %134
  unreachable

155:                                              ; preds = %53
  %156 = load i32, ptr %51, align 4, !tbaa !6
  %157 = getelementptr inbounds i32, ptr %0, i32 0
  store i32 %156, ptr %157, align 4, !tbaa !6
  %158 = getelementptr inbounds i32, ptr %51, i32 1
  %159 = load i32, ptr %158, align 4, !tbaa !6
  %160 = getelementptr inbounds i32, ptr %0, i32 1
  store i32 %159, ptr %160, align 4, !tbaa !6
  %161 = getelementptr inbounds i32, ptr %51, i32 2
  %162 = load i32, ptr %161, align 4, !tbaa !6
  %163 = getelementptr inbounds i32, ptr %0, i32 2
  store i32 %162, ptr %163, align 4, !tbaa !6
  %164 = getelementptr inbounds i32, ptr %51, i32 3
  %165 = load i32, ptr %164, align 4, !tbaa !6
  %166 = getelementptr inbounds i32, ptr %0, i32 3
  store i32 %165, ptr %166, align 4, !tbaa !6
  br label %167

167:                                              ; preds = %155
  %168 = add nuw nsw i32 %.03, 1
  br label %46, !llvm.loop !21

169:                                              ; preds = %47
  %170 = getelementptr inbounds [44 x i32], ptr %4, i32 0, i32 40
  br label %171

171:                                              ; preds = %169
  br label %173

172:                                              ; preds = %252
  br label %274

173:                                              ; preds = %171
  %174 = load i32, ptr %170, align 4, !tbaa !6
  %175 = load i32, ptr %0, align 4, !tbaa !6
  %176 = call i32 asm sideeffect "aes32esi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %175, i32 0, i32 %174) #4, !srcloc !22
  store i32 %176, ptr %170, align 4, !tbaa !6
  %177 = getelementptr inbounds i32, ptr %170, i32 1
  %178 = load i32, ptr %177, align 4, !tbaa !6
  %179 = getelementptr inbounds i32, ptr %0, i32 1
  %180 = load i32, ptr %179, align 4, !tbaa !6
  %181 = call i32 asm sideeffect "aes32esi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %180, i32 0, i32 %178) #4, !srcloc !23
  store i32 %181, ptr %177, align 4, !tbaa !6
  %182 = getelementptr inbounds i32, ptr %170, i32 2
  %183 = load i32, ptr %182, align 4, !tbaa !6
  %184 = getelementptr inbounds i32, ptr %0, i32 2
  %185 = load i32, ptr %184, align 4, !tbaa !6
  %186 = call i32 asm sideeffect "aes32esi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %185, i32 0, i32 %183) #4, !srcloc !24
  store i32 %186, ptr %182, align 4, !tbaa !6
  %187 = getelementptr inbounds i32, ptr %170, i32 3
  %188 = load i32, ptr %187, align 4, !tbaa !6
  %189 = getelementptr inbounds i32, ptr %0, i32 3
  %190 = load i32, ptr %189, align 4, !tbaa !6
  %191 = call i32 asm sideeffect "aes32esi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %190, i32 0, i32 %188) #4, !srcloc !25
  store i32 %191, ptr %187, align 4, !tbaa !6
  br label %192

192:                                              ; preds = %173
  br label %193

193:                                              ; preds = %192
  %194 = load i32, ptr %170, align 4, !tbaa !6
  %195 = getelementptr inbounds i32, ptr %0, i32 1
  %196 = load i32, ptr %195, align 4, !tbaa !6
  %197 = call i32 asm sideeffect "aes32esi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %196, i32 1, i32 %194) #4, !srcloc !22
  store i32 %197, ptr %170, align 4, !tbaa !6
  %198 = getelementptr inbounds i32, ptr %170, i32 1
  %199 = load i32, ptr %198, align 4, !tbaa !6
  %200 = getelementptr inbounds i32, ptr %0, i32 2
  %201 = load i32, ptr %200, align 4, !tbaa !6
  %202 = call i32 asm sideeffect "aes32esi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %201, i32 1, i32 %199) #4, !srcloc !23
  store i32 %202, ptr %198, align 4, !tbaa !6
  %203 = getelementptr inbounds i32, ptr %170, i32 2
  %204 = load i32, ptr %203, align 4, !tbaa !6
  %205 = getelementptr inbounds i32, ptr %0, i32 3
  %206 = load i32, ptr %205, align 4, !tbaa !6
  %207 = call i32 asm sideeffect "aes32esi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %206, i32 1, i32 %204) #4, !srcloc !24
  store i32 %207, ptr %203, align 4, !tbaa !6
  %208 = getelementptr inbounds i32, ptr %170, i32 3
  %209 = load i32, ptr %208, align 4, !tbaa !6
  %210 = load i32, ptr %0, align 4, !tbaa !6
  %211 = call i32 asm sideeffect "aes32esi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %210, i32 1, i32 %209) #4, !srcloc !25
  store i32 %211, ptr %208, align 4, !tbaa !6
  br label %212

212:                                              ; preds = %193
  br label %213

213:                                              ; preds = %212
  %214 = load i32, ptr %170, align 4, !tbaa !6
  %215 = getelementptr inbounds i32, ptr %0, i32 2
  %216 = load i32, ptr %215, align 4, !tbaa !6
  %217 = call i32 asm sideeffect "aes32esi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %216, i32 2, i32 %214) #4, !srcloc !22
  store i32 %217, ptr %170, align 4, !tbaa !6
  %218 = getelementptr inbounds i32, ptr %170, i32 1
  %219 = load i32, ptr %218, align 4, !tbaa !6
  %220 = getelementptr inbounds i32, ptr %0, i32 3
  %221 = load i32, ptr %220, align 4, !tbaa !6
  %222 = call i32 asm sideeffect "aes32esi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %221, i32 2, i32 %219) #4, !srcloc !23
  store i32 %222, ptr %218, align 4, !tbaa !6
  %223 = getelementptr inbounds i32, ptr %170, i32 2
  %224 = load i32, ptr %223, align 4, !tbaa !6
  %225 = load i32, ptr %0, align 4, !tbaa !6
  %226 = call i32 asm sideeffect "aes32esi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %225, i32 2, i32 %224) #4, !srcloc !24
  store i32 %226, ptr %223, align 4, !tbaa !6
  %227 = getelementptr inbounds i32, ptr %170, i32 3
  %228 = load i32, ptr %227, align 4, !tbaa !6
  %229 = getelementptr inbounds i32, ptr %0, i32 1
  %230 = load i32, ptr %229, align 4, !tbaa !6
  %231 = call i32 asm sideeffect "aes32esi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %230, i32 2, i32 %228) #4, !srcloc !25
  store i32 %231, ptr %227, align 4, !tbaa !6
  br label %232

232:                                              ; preds = %213
  br label %233

233:                                              ; preds = %232
  %234 = load i32, ptr %170, align 4, !tbaa !6
  %235 = getelementptr inbounds i32, ptr %0, i32 3
  %236 = load i32, ptr %235, align 4, !tbaa !6
  %237 = call i32 asm sideeffect "aes32esi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %236, i32 3, i32 %234) #4, !srcloc !22
  store i32 %237, ptr %170, align 4, !tbaa !6
  %238 = getelementptr inbounds i32, ptr %170, i32 1
  %239 = load i32, ptr %238, align 4, !tbaa !6
  %240 = load i32, ptr %0, align 4, !tbaa !6
  %241 = call i32 asm sideeffect "aes32esi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %240, i32 3, i32 %239) #4, !srcloc !23
  store i32 %241, ptr %238, align 4, !tbaa !6
  %242 = getelementptr inbounds i32, ptr %170, i32 2
  %243 = load i32, ptr %242, align 4, !tbaa !6
  %244 = getelementptr inbounds i32, ptr %0, i32 1
  %245 = load i32, ptr %244, align 4, !tbaa !6
  %246 = call i32 asm sideeffect "aes32esi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %245, i32 3, i32 %243) #4, !srcloc !24
  store i32 %246, ptr %242, align 4, !tbaa !6
  %247 = getelementptr inbounds i32, ptr %170, i32 3
  %248 = load i32, ptr %247, align 4, !tbaa !6
  %249 = getelementptr inbounds i32, ptr %0, i32 2
  %250 = load i32, ptr %249, align 4, !tbaa !6
  %251 = call i32 asm sideeffect "aes32esi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %250, i32 3, i32 %248) #4, !srcloc !25
  store i32 %251, ptr %247, align 4, !tbaa !6
  br label %252

252:                                              ; preds = %233
  br i1 false, label %253, label %172

253:                                              ; preds = %252
  %254 = load i32, ptr %170, align 4, !tbaa !6
  %255 = getelementptr inbounds i32, ptr %0, i32 4
  %256 = load i32, ptr %255, align 4, !tbaa !6
  %257 = call i32 asm sideeffect "aes32esi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %256, i32 4, i32 %254) #4, !srcloc !22
  store i32 %257, ptr %170, align 4, !tbaa !6
  %258 = getelementptr inbounds i32, ptr %170, i32 1
  %259 = load i32, ptr %258, align 4, !tbaa !6
  %260 = getelementptr inbounds i32, ptr %0, i32 1
  %261 = load i32, ptr %260, align 4, !tbaa !6
  %262 = call i32 asm sideeffect "aes32esi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %261, i32 4, i32 %259) #4, !srcloc !23
  store i32 %262, ptr %258, align 4, !tbaa !6
  %263 = getelementptr inbounds i32, ptr %170, i32 2
  %264 = load i32, ptr %263, align 4, !tbaa !6
  %265 = getelementptr inbounds i32, ptr %0, i32 2
  %266 = load i32, ptr %265, align 4, !tbaa !6
  %267 = call i32 asm sideeffect "aes32esi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %266, i32 4, i32 %264) #4, !srcloc !24
  store i32 %267, ptr %263, align 4, !tbaa !6
  %268 = getelementptr inbounds i32, ptr %170, i32 3
  %269 = load i32, ptr %268, align 4, !tbaa !6
  %270 = getelementptr inbounds i32, ptr %0, i32 3
  %271 = load i32, ptr %270, align 4, !tbaa !6
  %272 = call i32 asm sideeffect "aes32esi $0, $0, $1, $2\0A", "=r,r,I,0"(i32 %271, i32 4, i32 %269) #4, !srcloc !25
  store i32 %272, ptr %268, align 4, !tbaa !6
  br label %273

273:                                              ; preds = %253
  unreachable

274:                                              ; preds = %172
  %275 = getelementptr inbounds i32, ptr %170, i32 0
  %276 = load i32, ptr %275, align 4, !tbaa !6
  %277 = getelementptr inbounds i32, ptr %0, i32 0
  store i32 %276, ptr %277, align 4, !tbaa !6
  %278 = getelementptr inbounds i32, ptr %170, i32 1
  %279 = load i32, ptr %278, align 4, !tbaa !6
  %280 = getelementptr inbounds i32, ptr %0, i32 1
  store i32 %279, ptr %280, align 4, !tbaa !6
  %281 = getelementptr inbounds i32, ptr %170, i32 2
  %282 = load i32, ptr %281, align 4, !tbaa !6
  %283 = getelementptr inbounds i32, ptr %0, i32 2
  store i32 %282, ptr %283, align 4, !tbaa !6
  %284 = getelementptr inbounds i32, ptr %170, i32 3
  %285 = load i32, ptr %284, align 4, !tbaa !6
  %286 = getelementptr inbounds i32, ptr %0, i32 3
  store i32 %285, ptr %286, align 4, !tbaa !6
  call void @llvm.lifetime.end.p0(i64 176, ptr %4) #4
  br label %287

287:                                              ; preds = %274, %7
  ret void
}

; Function Attrs: nounwind
define dso_local void @write_to_address(i32 noundef %0, i32 noundef %1) #0 {
  %3 = inttoptr i32 %0 to ptr
  store volatile i32 %1, ptr %3, align 4, !tbaa !6
  ret void
}

; Function Attrs: nounwind
define dso_local void @write_v_to_address(i32 noundef %0, ptr noundef %1) #0 {
  br label %3

3:                                                ; preds = %2
  br label %5

4:                                                ; preds = %22
  br label %28

5:                                                ; preds = %3
  %6 = load i32, ptr %1, align 4, !tbaa !6
  call void @write_to_address(i32 noundef %0, i32 noundef %6)
  br label %7

7:                                                ; preds = %5
  br label %8

8:                                                ; preds = %7
  %9 = add i32 %0, 4
  %10 = getelementptr inbounds i32, ptr %1, i32 1
  %11 = load i32, ptr %10, align 4, !tbaa !6
  call void @write_to_address(i32 noundef %9, i32 noundef %11)
  br label %12

12:                                               ; preds = %8
  br label %13

13:                                               ; preds = %12
  %14 = add i32 %0, 8
  %15 = getelementptr inbounds i32, ptr %1, i32 2
  %16 = load i32, ptr %15, align 4, !tbaa !6
  call void @write_to_address(i32 noundef %14, i32 noundef %16)
  br label %17

17:                                               ; preds = %13
  br label %18

18:                                               ; preds = %17
  %19 = add i32 %0, 12
  %20 = getelementptr inbounds i32, ptr %1, i32 3
  %21 = load i32, ptr %20, align 4, !tbaa !6
  call void @write_to_address(i32 noundef %19, i32 noundef %21)
  br label %22

22:                                               ; preds = %18
  br i1 false, label %23, label %4

23:                                               ; preds = %22
  %24 = add i32 %0, 16
  %25 = getelementptr inbounds i32, ptr %1, i32 4
  %26 = load i32, ptr %25, align 4, !tbaa !6
  call void @write_to_address(i32 noundef %24, i32 noundef %26)
  br label %27

27:                                               ; preds = %23
  unreachable

28:                                               ; preds = %4
  ret void
}

; Function Attrs: nounwind
define dso_local i32 @main() #0 {
  %1 = alloca [16 x i8], align 1
  %2 = alloca [4 x i32], align 4
  %3 = alloca [16 x i8], align 1
  %4 = alloca [4 x i32], align 4
  call void @llvm.lifetime.start.p0(i64 16, ptr %1) #4
  call void @llvm.memcpy.p0.p0.i32(ptr align 1 %1, ptr align 1 @__const.main.plaintext, i32 16, i1 false)
  call void @llvm.lifetime.start.p0(i64 16, ptr %2) #4
  %5 = getelementptr inbounds [16 x i8], ptr %1, i32 0, i32 0
  %6 = getelementptr inbounds [4 x i32], ptr %2, i32 0, i32 0
  call void @merge_plaintext_into_state(ptr noundef %5, ptr noundef %6)
  call void @llvm.lifetime.start.p0(i64 16, ptr %3) #4
  call void @llvm.memcpy.p0.p0.i32(ptr align 1 %3, ptr align 1 @__const.main.key, i32 16, i1 false)
  call void @llvm.lifetime.start.p0(i64 16, ptr %4) #4
  call void @llvm.memcpy.p0.p0.i32(ptr align 4 %4, ptr align 4 @__const.main.expected_output, i32 16, i1 false)
  %7 = getelementptr inbounds [4 x i32], ptr %2, i32 0, i32 0
  %8 = getelementptr inbounds [16 x i8], ptr %3, i32 0, i32 0
  call void @aes128_ecb_encrypt(ptr noundef %7, i32 noundef 16, ptr noundef %8)
  %9 = getelementptr inbounds [4 x i32], ptr %4, i32 0, i32 0
  call void @write_v_to_address(i32 noundef 1056816, ptr noundef %9)
  %10 = getelementptr inbounds [4 x i32], ptr %2, i32 0, i32 0
  call void @write_v_to_address(i32 noundef 1056832, ptr noundef %10)
  br label %11

11:                                               ; preds = %0
  br label %13

12:                                               ; preds = %50
  br label %61

13:                                               ; preds = %11
  %14 = load i32, ptr %2, align 4, !tbaa !6
  call void @write_to_address(i32 noundef 1056772, i32 noundef %14)
  %15 = load i32, ptr %2, align 4, !tbaa !6
  %16 = load i32, ptr %4, align 4, !tbaa !6
  %17 = icmp ne i32 %15, %16
  br i1 %17, label %18, label %19

18:                                               ; preds = %51, %41, %31, %21, %13
  br label %61

19:                                               ; preds = %13
  br label %20

20:                                               ; preds = %19
  br label %21

21:                                               ; preds = %20
  %22 = getelementptr inbounds [4 x i32], ptr %2, i32 0, i32 1
  %23 = load i32, ptr %22, align 4, !tbaa !6
  call void @write_to_address(i32 noundef 1056772, i32 noundef %23)
  %24 = getelementptr inbounds [4 x i32], ptr %2, i32 0, i32 1
  %25 = load i32, ptr %24, align 4, !tbaa !6
  %26 = getelementptr inbounds [4 x i32], ptr %4, i32 0, i32 1
  %27 = load i32, ptr %26, align 4, !tbaa !6
  %28 = icmp ne i32 %25, %27
  br i1 %28, label %18, label %29

29:                                               ; preds = %21
  br label %30

30:                                               ; preds = %29
  br label %31

31:                                               ; preds = %30
  %32 = getelementptr inbounds [4 x i32], ptr %2, i32 0, i32 2
  %33 = load i32, ptr %32, align 4, !tbaa !6
  call void @write_to_address(i32 noundef 1056772, i32 noundef %33)
  %34 = getelementptr inbounds [4 x i32], ptr %2, i32 0, i32 2
  %35 = load i32, ptr %34, align 4, !tbaa !6
  %36 = getelementptr inbounds [4 x i32], ptr %4, i32 0, i32 2
  %37 = load i32, ptr %36, align 4, !tbaa !6
  %38 = icmp ne i32 %35, %37
  br i1 %38, label %18, label %39

39:                                               ; preds = %31
  br label %40

40:                                               ; preds = %39
  br label %41

41:                                               ; preds = %40
  %42 = getelementptr inbounds [4 x i32], ptr %2, i32 0, i32 3
  %43 = load i32, ptr %42, align 4, !tbaa !6
  call void @write_to_address(i32 noundef 1056772, i32 noundef %43)
  %44 = getelementptr inbounds [4 x i32], ptr %2, i32 0, i32 3
  %45 = load i32, ptr %44, align 4, !tbaa !6
  %46 = getelementptr inbounds [4 x i32], ptr %4, i32 0, i32 3
  %47 = load i32, ptr %46, align 4, !tbaa !6
  %48 = icmp ne i32 %45, %47
  br i1 %48, label %18, label %49

49:                                               ; preds = %41
  br label %50

50:                                               ; preds = %49
  br i1 false, label %51, label %12

51:                                               ; preds = %50
  %52 = getelementptr inbounds [4 x i32], ptr %2, i32 0, i32 4
  %53 = load i32, ptr %52, align 4, !tbaa !6
  call void @write_to_address(i32 noundef 1056772, i32 noundef %53)
  %54 = getelementptr inbounds [4 x i32], ptr %2, i32 0, i32 4
  %55 = load i32, ptr %54, align 4, !tbaa !6
  %56 = getelementptr inbounds [4 x i32], ptr %4, i32 0, i32 4
  %57 = load i32, ptr %56, align 4, !tbaa !6
  %58 = icmp ne i32 %55, %57
  br i1 %58, label %18, label %59

59:                                               ; preds = %51
  br label %60

60:                                               ; preds = %59
  unreachable

61:                                               ; preds = %18, %12
  %.0 = phi i32 [ -1163220309, %18 ], [ -889275714, %12 ]
  br label %62

62:                                               ; preds = %61
  %63 = getelementptr inbounds [4 x i32], ptr %2, i32 0, i32 0
  %64 = load i32, ptr %63, align 4, !tbaa !6
  call void @write_to_address(i32 noundef 1107304512, i32 noundef %64)
  %65 = getelementptr inbounds [4 x i32], ptr %2, i32 0, i32 1
  %66 = load i32, ptr %65, align 4, !tbaa !6
  call void @write_to_address(i32 noundef 1107304516, i32 noundef %66)
  %67 = getelementptr inbounds [4 x i32], ptr %2, i32 0, i32 2
  %68 = load i32, ptr %67, align 4, !tbaa !6
  call void @write_to_address(i32 noundef 1107304520, i32 noundef %68)
  %69 = getelementptr inbounds [4 x i32], ptr %2, i32 0, i32 3
  %70 = load i32, ptr %69, align 4, !tbaa !6
  call void @write_to_address(i32 noundef 1107304524, i32 noundef %70)
  call void @write_to_address(i32 noundef 1056772, i32 noundef %.0)
  call void @write_to_address(i32 noundef 1056768, i32 noundef -559038737)
  call void @llvm.lifetime.end.p0(i64 16, ptr %4) #4
  call void @llvm.lifetime.end.p0(i64 16, ptr %3) #4
  call void @llvm.lifetime.end.p0(i64 16, ptr %2) #4
  call void @llvm.lifetime.end.p0(i64 16, ptr %1) #4
  ret i32 0
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
!7 = !{!"int", !8, i64 0}
!8 = !{!"omnipotent char", !9, i64 0}
!9 = !{!"Simple C/C++ TBAA"}
!10 = !{!8, !8, i64 0}
!11 = !{i64 2147691066}
!12 = !{i64 2147691236}
!13 = !{i64 2147691406}
!14 = !{i64 2147691576}
!15 = distinct !{!15, !16}
!16 = !{!"llvm.loop.mustprogress"}
!17 = !{i64 2147691746}
!18 = !{i64 2147691927}
!19 = !{i64 2147692118}
!20 = !{i64 2147692309}
!21 = distinct !{!21, !16}
!22 = !{i64 2147692500}
!23 = !{i64 2147692680}
!24 = !{i64 2147692870}
!25 = !{i64 2147693060}
