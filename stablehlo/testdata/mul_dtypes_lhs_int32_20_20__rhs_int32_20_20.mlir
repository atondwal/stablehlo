// RUN: stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<20x20xi32>, tensor<20x20xi32>)
    %1 = call @expected() : () -> tensor<20x20xi32>
    %2 = stablehlo.multiply %0#0, %0#1 : tensor<20x20xi32>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xi32>, tensor<20x20xi32>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<20x20xi32>, tensor<20x20xi32>) {
    %0 = stablehlo.constant dense<"0x0000000002000000010000000100000000000000FFFFFFFF00000000FEFFFFFF03000000000000000100000000000000FDFFFFFFFEFFFFFF0300000004000000FCFFFFFFFEFFFFFFFFFFFFFF0000000003000000FFFFFFFFFEFFFFFF00000000FDFFFFFF04000000FBFFFFFF05000000030000000000000000000000FFFFFFFFFFFFFFFF000000000400000002000000FFFFFFFF02000000000000000000000002000000FEFFFFFF00000000FDFFFFFFFFFFFFFFFFFFFFFF0900000000000000FBFFFFFFFEFFFFFF00000000FEFFFFFF000000000100000001000000FEFFFFFF02000000000000000100000000000000FFFFFFFFFCFFFFFF000000000100000003000000FEFFFFFFFDFFFFFF06000000FDFFFFFFFDFFFFFF01000000FFFFFFFF01000000FFFFFFFF00000000FDFFFFFF060000000300000004000000010000000200000000000000FEFFFFFFFBFFFFFF0000000002000000FEFFFFFF01000000FDFFFFFF0000000000000000FFFFFFFFFBFFFFFFFEFFFFFFFEFFFFFF0100000000000000FBFFFFFFFDFFFFFF0300000002000000010000000000000003000000FDFFFFFFFDFFFFFF0100000003000000FCFFFFFFFFFFFFFFFCFFFFFFFDFFFFFF000000000000000000000000FDFFFFFFFFFFFFFF030000000300000003000000010000000200000003000000FBFFFFFF0100000000000000FBFFFFFFFCFFFFFF0400000002000000FFFFFFFFFCFFFFFF0000000000000000FAFFFFFF010000000300000002000000FDFFFFFF0000000000000000FEFFFFFF0100000000000000FFFFFFFF00000000FEFFFFFF00000000FFFFFFFF0000000002000000FFFFFFFF01000000FFFFFFFFFDFFFFFFFEFFFFFFFDFFFFFFFDFFFFFFFFFFFFFF000000000200000001000000FEFFFFFFFFFFFFFF00000000FFFFFFFF00000000FBFFFFFFFEFFFFFF04000000FFFFFFFF0000000001000000FFFFFFFFFEFFFFFF000000000500000002000000FFFFFFFFFDFFFFFF0200000002000000FEFFFFFF01000000FDFFFFFF000000000100000000000000FCFFFFFF040000000200000005000000FEFFFFFFFDFFFFFFFCFFFFFF03000000FFFFFFFFFCFFFFFF00000000040000000400000001000000FDFFFFFF00000000FBFFFFFF02000000000000000500000001000000FFFFFFFF00000000FCFFFFFF040000000000000000000000FDFFFFFF03000000FFFFFFFF0000000001000000FEFFFFFFFFFFFFFFFCFFFFFF0200000001000000FDFFFFFF00000000FBFFFFFF00000000030000000000000000000000FFFFFFFF020000000000000002000000FEFFFFFFFDFFFFFFFDFFFFFFFDFFFFFF00000000FCFFFFFFFEFFFFFFFDFFFFFFFFFFFFFF0300000002000000FFFFFFFFFCFFFFFF060000000200000003000000FDFFFFFFFFFFFFFF00000000FFFFFFFF0300000003000000FEFFFFFF0300000002000000FEFFFFFF0000000001000000FCFFFFFF03000000FEFFFFFF00000000FFFFFFFFFDFFFFFF00000000FFFFFFFF00000000FFFFFFFFFEFFFFFF0200000002000000FEFFFFFF050000000100000003000000050000000000000001000000030000000200000004000000FDFFFFFFFFFFFFFF01000000FEFFFFFFFFFFFFFF00000000FDFFFFFF00000000FEFFFFFFFCFFFFFFFFFFFFFF010000000100000002000000010000000100000002000000050000000300000000000000FEFFFFFF010000000000000000000000000000000000000001000000FDFFFFFFFEFFFFFFFEFFFFFFFBFFFFFFFFFFFFFFFFFFFFFF0100000000000000050000000200000000000000010000000000000000000000FCFFFFFF01000000010000000000000000000000FFFFFFFF020000000100000000000000020000000000000000000000FEFFFFFF01000000000000000000000003000000FFFFFFFF0100000001000000FEFFFFFF02000000010000000200000002000000FDFFFFFFFFFFFFFF00000000000000000000000000000000FDFFFFFF0000000000000000FCFFFFFF0000000001000000040000000000000003000000FAFFFFFF03000000FEFFFFFF000000000600000000000000FEFFFFFF02000000FDFFFFFFFEFFFFFF00000000FFFFFFFF01000000030000000000000000000000FFFFFFFFFDFFFFFFFCFFFFFF0400000000000000000000000200000005000000FFFFFFFF05000000FCFFFFFF00000000FDFFFFFFFFFFFFFFFEFFFFFF04000000"> : tensor<20x20xi32>
    %1 = stablehlo.constant dense<"0x0100000003000000FEFFFFFF0500000001000000FCFFFFFFFFFFFFFF00000000000000000600000000000000FEFFFFFF000000000300000000000000FDFFFFFF00000000000000000100000000000000010000000000000001000000FBFFFFFFFFFFFFFF0000000003000000000000000100000000000000FFFFFFFFFCFFFFFFFCFFFFFF01000000000000000200000004000000FAFFFFFF0000000001000000FDFFFFFFFFFFFFFFFAFFFFFF00000000FEFFFFFF010000000000000000000000FFFFFFFF00000000FDFFFFFF00000000FFFFFFFF00000000030000000300000003000000020000000000000002000000FEFFFFFF03000000FFFFFFFF0300000007000000FFFFFFFF00000000FAFFFFFF0000000001000000FBFFFFFFFDFFFFFFFFFFFFFF0400000000000000030000000000000001000000000000000400000000000000FFFFFFFF0000000000000000FEFFFFFF04000000030000000200000002000000010000000200000002000000FAFFFFFF01000000FCFFFFFF02000000FEFFFFFF0200000005000000050000000000000001000000FEFFFFFFFBFFFFFF04000000FFFFFFFFFAFFFFFFFEFFFFFF01000000FEFFFFFFFBFFFFFF01000000FCFFFFFF0400000000000000030000000100000001000000FEFFFFFFFEFFFFFF010000000500000001000000FCFFFFFF0500000001000000000000000200000005000000FCFFFFFF00000000FDFFFFFF050000000100000001000000020000000400000000000000FDFFFFFF01000000FEFFFFFF02000000FDFFFFFFFFFFFFFFFFFFFFFF0200000000000000FBFFFFFF030000000500000000000000FDFFFFFFFDFFFFFF0200000003000000020000000200000001000000FEFFFFFFFDFFFFFF0100000002000000FEFFFFFFFFFFFFFFFFFFFFFF010000000300000000000000020000000000000000000000FEFFFFFFFAFFFFFFFAFFFFFFFFFFFFFF01000000FCFFFFFF0100000007000000FFFFFFFFFDFFFFFF000000000000000000000000FEFFFFFF00000000FEFFFFFFFDFFFFFFFDFFFFFF01000000FEFFFFFFFCFFFFFF01000000FFFFFFFFFDFFFFFF01000000FFFFFFFF000000000000000000000000FDFFFFFF01000000FDFFFFFFFFFFFFFF02000000FFFFFFFFFDFFFFFF0000000000000000040000000200000004000000FCFFFFFF0100000004000000FDFFFFFFFFFFFFFF00000000000000000000000003000000000000000100000000000000FCFFFFFFFEFFFFFF01000000010000000000000000000000000000000400000004000000FEFFFFFF0000000003000000F9FFFFFF000000000000000004000000FFFFFFFF0000000000000000FDFFFFFF0000000002000000FFFFFFFF010000000000000001000000FFFFFFFF0300000000000000010000000000000001000000FBFFFFFF0400000002000000FDFFFFFF000000000000000001000000FFFFFFFF010000000200000000000000000000000000000001000000FEFFFFFF030000000100000000000000000000000000000001000000FEFFFFFF00000000FFFFFFFFFFFFFFFF00000000030000000600000000000000030000000200000006000000FBFFFFFF0000000002000000FFFFFFFF06000000FFFFFFFFFDFFFFFFFBFFFFFF020000000300000004000000FCFFFFFF03000000030000000100000005000000FFFFFFFF01000000FEFFFFFFFCFFFFFF0400000003000000FDFFFFFF000000000000000003000000FBFFFFFF00000000FFFFFFFF00000000010000000000000002000000FCFFFFFF00000000FFFFFFFF0000000003000000FFFFFFFFFCFFFFFF0300000000000000FBFFFFFF04000000F9FFFFFF0000000000000000020000000300000003000000FEFFFFFF00000000FDFFFFFF0200000003000000FCFFFFFFFBFFFFFFFEFFFFFF06000000020000000000000004000000FFFFFFFF000000000100000007000000FFFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFF020000000100000002000000FFFFFFFF02000000FEFFFFFFFFFFFFFF00000000FEFFFFFFFFFFFFFFFEFFFFFFFFFFFFFFFFFFFFFF00000000FDFFFFFF0100000002000000F8FFFFFFFEFFFFFFFBFFFFFFFFFFFFFF02000000FFFFFFFF09000000FDFFFFFF01000000FEFFFFFF01000000FBFFFFFFFBFFFFFF04000000FEFFFFFFFEFFFFFF010000000000000002000000FDFFFFFF00000000070000000300000001000000"> : tensor<20x20xi32>
    return %0, %1 : tensor<20x20xi32>, tensor<20x20xi32>
  }
  func.func private @expected() -> tensor<20x20xi32> {
    %0 = stablehlo.constant dense<"0x0000000006000000FEFFFFFF05000000000000000400000000000000000000000000000000000000000000000000000000000000FAFFFFFF00000000F4FFFFFF0000000000000000FFFFFFFF000000000300000000000000FEFFFFFF000000000300000000000000F1FFFFFF000000000300000000000000000000000400000004000000000000000000000004000000FCFFFFFFF4FFFFFF0000000000000000FAFFFFFF02000000000000000000000002000000FFFFFFFF000000000000000005000000000000000000000000000000000000000000000003000000FAFFFFFF0600000000000000000000000000000002000000F4FFFFFF0000000003000000150000000200000000000000DCFFFFFF00000000FDFFFFFFFBFFFFFF03000000FFFFFFFFFCFFFFFF00000000F7FFFFFF00000000030000000000000004000000000000000000000000000000000000000000000008000000FAFFFFFF02000000FAFFFFFF0000000000000000FEFFFFFF1E000000FEFFFFFF080000000200000000000000F6FFFFFFF1FFFFFF0F000000000000000100000000000000F1FFFFFFF4FFFFFF03000000FAFFFFFFFAFFFFFFFCFFFFFF0200000014000000FDFFFFFF000000000000000000000000F7FFFFFFFFFFFFFF03000000FAFFFFFFFAFFFFFF010000000A0000000300000014000000050000000000000000000000F8FFFFFF14000000F8FFFFFF000000000C0000000000000000000000FAFFFFFF020000000C00000000000000090000000000000000000000FCFFFFFFFDFFFFFF0000000001000000000000000000000000000000FDFFFFFF000000000000000003000000FDFFFFFFFEFFFFFFF7FFFFFFFCFFFFFFFAFFFFFFFDFFFFFF02000000000000000200000002000000040000000100000000000000FFFFFFFF0000000000000000FCFFFFFF000000000000000000000000FAFFFFFF060000000200000000000000ECFFFFFF02000000F9FFFFFF03000000FAFFFFFF0000000000000000000000000600000000000000FEFFFFFF000000000C00000004000000FCFFFFFFECFFFFFFFEFFFFFF030000000C0000000300000001000000000000000000000000000000F4FFFFFF010000000900000000000000F6FFFFFFFEFFFFFF000000000000000000000000FCFFFFFF00000000F0FFFFFFF0FFFFFF000000000000000009000000FDFFFFFF000000000000000000000000FAFFFFFF00000000FCFFFFFF00000000FCFFFFFF0600000000000000FBFFFFFF00000000000000000000000000000000FCFFFFFFFCFFFFFF00000000060000000E0000000000000000000000F4FFFFFF000000000000000000000000090000000000000006000000FEFFFFFFFFFFFFFF0000000006000000FEFFFFFF0900000000000000FFFFFFFF00000000FFFFFFFFF1FFFFFF0C000000FCFFFFFFF7FFFFFF000000000000000000000000FFFFFFFFFCFFFFFF06000000000000000000000000000000FDFFFFFF00000000FDFFFFFF00000000000000000000000000000000020000000400000000000000FFFFFFFFFDFFFFFF000000000000000006000000000000000600000008000000EEFFFFFF0500000000000000FCFFFFFF010000000000000003000000000000000A000000F8FFFFFFFDFFFFFF04000000FCFFFFFF0600000003000000010000000A000000FBFFFFFF0300000000000000080000000400000000000000000000000000000000000000030000000F000000000000000200000000000000FFFFFFFF00000000020000000000000000000000FEFFFFFF00000000030000000000000000000000F4FFFFFF00000000FBFFFFFF00000000000000000000000000000000020000000000000006000000000000000000000006000000020000000000000000000000F1FFFFFF0200000006000000020000000000000008000000FFFFFFFF0000000002000000EBFFFFFF0100000000000000000000000000000000000000FAFFFFFF00000000000000000400000000000000FEFFFFFFFCFFFFFF00000000FAFFFFFF06000000FAFFFFFF02000000000000000000000000000000FEFFFFFF040000001800000004000000000000000100000002000000FDFFFFFF0000000000000000FFFFFFFF06000000FCFFFFFFECFFFFFF0000000000000000FCFFFFFFF6FFFFFFFFFFFFFF00000000F8FFFFFF0000000000000000F9FFFFFFFAFFFFFF04000000"> : tensor<20x20xi32>
    return %0 : tensor<20x20xi32>
  }
}
