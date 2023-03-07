// RUN-DISABLED: stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[[0], [1]], [[2], [3]]]> : tensor<2x2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xui16>, tensor<5x2x2x7xui16>)
    %2 = call @expected() : () -> tensor<5x6x7xui16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<ui16>, %arg1: tensor<ui16>):
      %5 = stablehlo.maximum %arg0, %arg1 : tensor<ui16>
      stablehlo.return %5 : tensor<ui16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 3], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1], index_vector_dim = 2>, unique_indices = true} : (tensor<5x6x7xui16>, tensor<2x2x1xi32>, tensor<5x2x2x7xui16>) -> tensor<5x6x7xui16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xui16>, tensor<5x6x7xui16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xui16>, tensor<5x2x2x7xui16>) {
    %0 = stablehlo.constant dense<"0x000002000000000000000000030001000500030000000200000001000100030004000100010002000000000003000100000001000100020001000000030007000600010000000100040001000200000003000400000000000100010001000400000006000100010001000200000000000200000001000400000004000100010003000200000001000000020002000200020000000300050000000100030000000400000000000100010001000100010000000000010002000000000000000000000002000500010000000200020000000900040000000500010000000600030001000000030000000000000001000400030003000300030003000000020002000000050001000000040000000200080000000300000002000300010002000000010002000000010003000000020000000400000003000100010000000200000000000100040002000100040002000300000000000600000002000200000002000300000001000100020000000100020000000200000002000300020002000300010002000000020004000100010002000000060002000000030001000400020003000000"> : tensor<5x6x7xui16>
    %1 = stablehlo.constant dense<"0x00000100020002000100000001000000030000000100010003000200020000000200030000000400000000000200030001000200010004000000000006000000010000000200010000000100070004000500010001000500030002000100020000000400030000000100000004000200020002000000000003000200030001000200000001000000050005000200050000000100060000000300050001000500000003000200010000000000000000000000000009000100070001000100030000000000010004000100040001000000050000000200030000000600030002000200050006000100010000000200030001000300010000000000010002000600000001000000020001000300010001000200030006000100"> : tensor<5x2x2x7xui16>
    return %0, %1 : tensor<5x6x7xui16>, tensor<5x2x2x7xui16>
  }
  func.func private @expected() -> tensor<5x6x7xui16> {
    %0 = stablehlo.constant dense<"0x000002000200020001000000030001000500030001000200030002000200030004000300010004000000000003000300010002000100040001000000030007000600010000000100040001000200000003000400000000000600010001000400020006000100010007000400050001000200050003000400010004000100040003000200010001000400020002000200020000000300050000000100030000000400000000000100020002000100010003000200030002000200000001000000050005000500050000000200060000000900050001000500010003000600030001000000030000000000000001000400030003000300030003000000020002000000050001000000090001000700080001000300000002000300040002000400010002000500010003000300020006000400020003000100010000000200000000000100040002000100040002000300020005000600010002000200020003000300030001000100020001000200060000000200000002000300030002000300020003000600020004000100010002000000060002000000030001000400020003000000"> : tensor<5x6x7xui16>
    return %0 : tensor<5x6x7xui16>
  }
}

