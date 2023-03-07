// RUN-DISABLED: stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x20xui16>
    %1 = call @expected() : () -> tensor<20x20xui16>
    %2 = stablehlo.constant dense<0> : tensor<ui16>
    %3 = stablehlo.broadcast_in_dim %2, dims = [] : (tensor<ui16>) -> tensor<20x20xui16>
    %4 = stablehlo.compare  EQ, %0, %3,  UNSIGNED : (tensor<20x20xui16>, tensor<20x20xui16>) -> tensor<20x20xi1>
    %5 = stablehlo.constant dense<0> : tensor<ui16>
    %6 = stablehlo.broadcast_in_dim %5, dims = [] : (tensor<ui16>) -> tensor<20x20xui16>
    %7 = stablehlo.constant dense<1> : tensor<ui16>
    %8 = stablehlo.broadcast_in_dim %7, dims = [] : (tensor<ui16>) -> tensor<20x20xui16>
    %9 = stablehlo.select %4, %6, %8 : tensor<20x20xi1>, tensor<20x20xui16>
    %10 = stablehlo.custom_call @check.eq(%9, %1) : (tensor<20x20xui16>, tensor<20x20xui16>) -> tensor<i1>
    return %10 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x20xui16> {
    %0 = stablehlo.constant dense<"0x0000070004000000010001000100020001000000020001000400020002000300020001000000030005000400040001000100010001000200000002000000000003000400020002000000020000000600040004000000010001000000000002000000030003000400020004000600010000000000010003000200040002000200000005000100000007000000000000000200020004000200010002000000030005000200010003000100040000000100020005000100060004000100020001000200050003000000030000000000030000000100020001000300020000000000020000000100020003000200040001000300000002000000000000000500040004000500050000000300010004000100020006000000000006000000040004000000020000000000000000000200000001000500000005000200030000000200010004000500010001000000060000000100000002000300010002000000010000000100010003000100030002000400020002000100000001000200030004000100000001000300030000000200040001000200010002000100030002000100000003000200020000000200050003000100010000000800000002000400030003000100020001000000000005000100030003000200030001000400030002000500030002000400010000000000010002000000050005000200000000000100030004000400010000000000000002000400020002000200040008000000010000000200020002000300000009000200030005000200020003000100000000000200020001000400030002000600000001000100030001000100080002000000020000000300040002000000020001000200010003000100000002000500020006000000000001000200010001000000010004000200010003000300010001000100000000000400050000000100000003000400030002000000010000000200000002000300010002000300020000000200000002000000020000000400020003000000070003000100000000000400010003000500010002000200000000000300010004000100000000000000040002000200010005000000030000000000"> : tensor<20x20xui16>
    return %0 : tensor<20x20xui16>
  }
  func.func private @expected() -> tensor<20x20xui16> {
    %0 = stablehlo.constant dense<"0x0000010001000000010001000100010001000000010001000100010001000100010001000000010001000100010001000100010001000100000001000000000001000100010001000000010000000100010001000000010001000000000001000000010001000100010001000100010000000000010001000100010001000100000001000100000001000000000000000100010001000100010001000000010001000100010001000100010000000100010001000100010001000100010001000100010001000000010000000000010000000100010001000100010000000000010000000100010001000100010001000100000001000000000000000100010001000100010000000100010001000100010001000000000001000000010001000000010000000000000000000100000001000100000001000100010000000100010001000100010001000000010000000100000001000100010001000000010000000100010001000100010001000100010001000100000001000100010001000100000001000100010000000100010001000100010001000100010001000100000001000100010000000100010001000100010000000100000001000100010001000100010001000000000001000100010001000100010001000100010001000100010001000100010000000000010001000000010001000100000000000100010001000100010000000000000001000100010001000100010001000000010000000100010001000100000001000100010001000100010001000100000000000100010001000100010001000100000001000100010001000100010001000000010000000100010001000000010001000100010001000100000001000100010001000000000001000100010001000000010001000100010001000100010001000100000000000100010000000100000001000100010001000000010000000100000001000100010001000100010000000100000001000000010000000100010001000000010001000100000000000100010001000100010001000100000000000100010001000100000000000000010001000100010001000000010000000000"> : tensor<20x20xui16>
    return %0 : tensor<20x20xui16>
  }
}
