// RUN-DISABLED: stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[0, 1], [2, 3]]> : tensor<2x2xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xi32>, tensor<2x7xi32>)
    %2 = call @expected() : () -> tensor<5x6x7xi32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<i32>, %arg1: tensor<i32>):
      stablehlo.return %arg1 : tensor<i32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [1], inserted_window_dims = [0, 1], scatter_dims_to_operand_dims = [0, 1], index_vector_dim = 1>, unique_indices = true} : (tensor<5x6x7xi32>, tensor<2x2xi32>, tensor<2x7xi32>) -> tensor<5x6x7xi32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xi32>, tensor<5x6x7xi32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xi32>, tensor<2x7xi32>) {
    %0 = stablehlo.constant dense<"0xFFFFFFFF00000000000000000000000000000000040000000200000000000000FCFFFFFF0200000000000000FBFFFFFF02000000FFFFFFFFFCFFFFFFFFFFFFFF03000000000000000100000000000000FEFFFFFFFBFFFFFFFDFFFFFF0000000000000000FFFFFFFF01000000FDFFFFFF0000000005000000FBFFFFFFFFFFFFFF0200000001000000FCFFFFFF000000000100000002000000FBFFFFFFFCFFFFFFFFFFFFFF0100000000000000FEFFFFFF000000000100000002000000FBFFFFFF0400000000000000FCFFFFFFFEFFFFFFFEFFFFFF0000000000000000FCFFFFFFFBFFFFFF01000000FFFFFFFF010000000600000001000000030000000000000002000000FFFFFFFF00000000FFFFFFFFFEFFFFFF0100000001000000020000000200000000000000020000000000000004000000FFFFFFFF0000000002000000FCFFFFFF0300000001000000FBFFFFFF0000000000000000FCFFFFFFFAFFFFFF030000000300000001000000F9FFFFFF01000000000000000100000000000000FDFFFFFFF9FFFFFF07000000FEFFFFFFFFFFFFFF000000000000000006000000030000000400000001000000000000000000000000000000FDFFFFFF00000000FFFFFFFF020000000000000002000000FFFFFFFFFFFFFFFF00000000000000000000000002000000FFFFFFFFFDFFFFFFFEFFFFFFFFFFFFFF000000000000000001000000FDFFFFFF030000000000000000000000FDFFFFFF0000000001000000FFFFFFFF000000000300000003000000FFFFFFFFFEFFFFFFFEFFFFFF00000000F8FFFFFF01000000000000000000000000000000FEFFFFFF05000000020000000200000003000000FEFFFFFF04000000FEFFFFFFFCFFFFFF00000000FDFFFFFF0000000000000000FEFFFFFFFBFFFFFF0000000002000000FEFFFFFF00000000FFFFFFFFFFFFFFFF00000000FEFFFFFFFBFFFFFFFEFFFFFFFFFFFFFFFBFFFFFF01000000FFFFFFFFFEFFFFFF01000000010000000100000000000000000000000200000004000000FEFFFFFF0200000000000000FDFFFFFF02000000010000000000000000000000020000000000000001000000FEFFFFFF000000000100000004000000FEFFFFFFFFFFFFFF0000000001000000FEFFFFFFFDFFFFFF00000000FAFFFFFF08000000"> : tensor<5x6x7xi32>
    %1 = stablehlo.constant dense<[[-5, -2, -1, 2, -2, 0, -1], [0, -3, 6, -1, 0, 1, 0]]> : tensor<2x7xi32>
    return %0, %1 : tensor<5x6x7xi32>, tensor<2x7xi32>
  }
  func.func private @expected() -> tensor<5x6x7xi32> {
    %0 = stablehlo.constant dense<"0xFFFFFFFF000000000000000000000000000000000400000002000000FBFFFFFFFEFFFFFFFFFFFFFF02000000FEFFFFFF00000000FFFFFFFFFCFFFFFFFFFFFFFF03000000000000000100000000000000FEFFFFFFFBFFFFFFFDFFFFFF0000000000000000FFFFFFFF01000000FDFFFFFF0000000005000000FBFFFFFFFFFFFFFF0200000001000000FCFFFFFF000000000100000002000000FBFFFFFFFCFFFFFFFFFFFFFF0100000000000000FEFFFFFF000000000100000002000000FBFFFFFF0400000000000000FCFFFFFFFEFFFFFFFEFFFFFF0000000000000000FCFFFFFFFBFFFFFF01000000FFFFFFFF010000000600000001000000030000000000000002000000FFFFFFFF00000000FFFFFFFFFEFFFFFF0100000001000000020000000200000000000000020000000000000004000000FFFFFFFF0000000002000000FCFFFFFF0300000001000000FBFFFFFF0000000000000000FCFFFFFFFAFFFFFF030000000300000001000000F9FFFFFF01000000000000000100000000000000FDFFFFFFF9FFFFFF07000000FEFFFFFFFFFFFFFF0000000000000000060000000300000000000000FDFFFFFF06000000FFFFFFFF000000000100000000000000FFFFFFFF020000000000000002000000FFFFFFFFFFFFFFFF00000000000000000000000002000000FFFFFFFFFDFFFFFFFEFFFFFFFFFFFFFF000000000000000001000000FDFFFFFF030000000000000000000000FDFFFFFF0000000001000000FFFFFFFF000000000300000003000000FFFFFFFFFEFFFFFFFEFFFFFF00000000F8FFFFFF01000000000000000000000000000000FEFFFFFF05000000020000000200000003000000FEFFFFFF04000000FEFFFFFFFCFFFFFF00000000FDFFFFFF0000000000000000FEFFFFFFFBFFFFFF0000000002000000FEFFFFFF00000000FFFFFFFFFFFFFFFF00000000FEFFFFFFFBFFFFFFFEFFFFFFFFFFFFFFFBFFFFFF01000000FFFFFFFFFEFFFFFF01000000010000000100000000000000000000000200000004000000FEFFFFFF0200000000000000FDFFFFFF02000000010000000000000000000000020000000000000001000000FEFFFFFF000000000100000004000000FEFFFFFFFFFFFFFF0000000001000000FEFFFFFFFDFFFFFF00000000FAFFFFFF08000000"> : tensor<5x6x7xi32>
    return %0 : tensor<5x6x7xi32>
  }
}

