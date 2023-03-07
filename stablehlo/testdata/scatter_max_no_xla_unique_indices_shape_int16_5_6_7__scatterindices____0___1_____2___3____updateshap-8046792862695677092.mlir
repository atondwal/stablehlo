// RUN-DISABLED: stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[[0], [1]], [[2], [3]]]> : tensor<2x2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xi16>, tensor<5x2x2x7xi16>)
    %2 = call @expected() : () -> tensor<5x6x7xi16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<i16>, %arg1: tensor<i16>):
      %5 = stablehlo.maximum %arg0, %arg1 : tensor<i16>
      stablehlo.return %5 : tensor<i16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 3], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1], index_vector_dim = 2>, unique_indices = true} : (tensor<5x6x7xi16>, tensor<2x2x1xi32>, tensor<5x2x2x7xi16>) -> tensor<5x6x7xi16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xi16>, tensor<5x6x7xi16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xi16>, tensor<5x2x2x7xi16>) {
    %0 = stablehlo.constant dense<"0x0400020006000000FCFF000000000200FDFF02000000FEFF0000FFFFFCFFFFFFFEFF0100FEFF00000000FDFF0300FCFF0200000003000000FBFFFFFFFFFF0200000000000200010004000200030003000300FFFF020003000400040002000000FEFF0200020000000300FFFF0200FFFFFEFF01000300FEFFFCFF0100020000000200FFFF03000000FDFFFFFF050000000200010004000000FCFFFEFF04000100020005000300FEFF030000000200FCFF0200FEFF0400FEFF01000200000001000300030000000000FFFF0000FDFFFFFF0200FCFFFDFF0000FFFF03000100FFFF020003000200FEFF060003000200FEFF0000FFFF0000FFFF000004000000FDFFFEFF04000000F9FFFDFF0200FBFF00000000000004000000FEFFFEFF000003000200010004000600FEFF00000000FEFFFCFF01000500010000000000FDFF000000000000FBFF020000000300FCFF0100FEFF000001000400FEFFFDFF0000FBFF060006000000FBFFFCFFFFFF050000000200FFFF0000010000000000FFFF020000000000050000000100FCFFFEFFFBFFFCFF05000100FCFF00000600FEFF00000100FEFF"> : tensor<5x6x7xi16>
    %1 = stablehlo.constant dense<"0x0200FFFFFDFFFFFF0000FFFFFFFFFDFF0200FCFFFBFF0100FFFFFFFFFEFF0100FEFF00000000FFFF00000300FBFF0000FEFF04000000FEFF00000300FEFFFBFF0000FCFFFCFF0100000000000500030006000100FFFF030002000000000000000100010002000100000001000000FEFF0000FEFF0000FFFF0200FEFF0300010001000200FDFFFEFFFEFF0000FBFFFEFF010000000000FFFFFDFF000003000300000002000200FFFFFEFFFCFF0300FFFF0500FAFF00000000FEFF0200010001000000FFFF0000020000000000FEFFFFFFFBFF04000000FEFF0000000000000300FBFF0000040003000000FFFF00000000030000000100FAFF02000000FDFF0000020004000300000001000000020000000500FFFF01000800"> : tensor<5x2x2x7xi16>
    return %0, %1 : tensor<5x6x7xi16>, tensor<5x2x2x7xi16>
  }
  func.func private @expected() -> tensor<5x6x7xi16> {
    %0 = stablehlo.constant dense<"0x0400020006000000000000000000020002000200000001000000FFFFFEFF0100FEFF01000000000000000300030000000200040003000000FBFFFFFFFFFF0200000000000200010004000200030003000300FFFF020003000400040002000000FEFF0200020000000500030006000100FFFF030003000000000001000200010002000100030001000000FFFF050000000200010004000000FCFFFEFF04000100020005000300FEFF030000000200FFFF0200FEFF0400010001000200000001000300030000000000010000000000FFFF0200000003000300000003000200FFFF020003000200FEFF060003000200FEFF0000FFFF0000FFFF000004000000FDFF030004000500FAFF00000200FEFF02000100010004000000000002000000030002000100040006000000000000000000000003000500010000000000FDFF000000000000FBFF020000000300FCFF0100FEFF0000040004000000FFFF00000000060006000100FBFF02000000050000000200040003000100010000000200020005000000050008000100FCFFFEFFFBFFFCFF05000100FCFF00000600FEFF00000100FEFF"> : tensor<5x6x7xi16>
    return %0 : tensor<5x6x7xi16>
  }
}

