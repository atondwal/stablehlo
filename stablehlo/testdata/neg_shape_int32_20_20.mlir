// RUN: stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x20xi32>
    %1 = call @expected() : () -> tensor<20x20xi32>
    %2 = stablehlo.negate %0 : tensor<20x20xi32>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xi32>, tensor<20x20xi32>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x20xi32> {
    %0 = stablehlo.constant dense<"0x00000000000000000700000003000000FFFFFFFF0100000000000000FFFFFFFF01000000FCFFFFFF03000000FDFFFFFF02000000FEFFFFFFFCFFFFFF0100000000000000000000000000000002000000FBFFFFFFFDFFFFFF06000000FDFFFFFF00000000FFFFFFFF0000000003000000FFFFFFFFFDFFFFFFFBFFFFFF0200000004000000FEFFFFFF0100000003000000FAFFFFFFFCFFFFFFFBFFFFFFFCFFFFFF020000000000000000000000FFFFFFFF010000000000000001000000FDFFFFFFFCFFFFFF0600000000000000FDFFFFFF03000000FEFFFFFFFDFFFFFF000000000200000002000000FBFFFFFF00000000000000000600000002000000FCFFFFFFFEFFFFFF00000000010000000000000002000000FFFFFFFF010000000200000000000000FFFFFFFFFFFFFFFFFBFFFFFFFCFFFFFF030000000500000001000000FFFFFFFFFFFFFFFF04000000FEFFFFFFFEFFFFFFFFFFFFFFFAFFFFFF00000000FFFFFFFF0700000000000000FEFFFFFFFEFFFFFF000000000300000000000000FDFFFFFFFAFFFFFF02000000FFFFFFFFFFFFFFFF02000000FFFFFFFF040000000000000000000000FFFFFFFFFDFFFFFF00000000FCFFFFFFFBFFFFFF05000000FDFFFFFFFFFFFFFF00000000FFFFFFFF0000000002000000FDFFFFFF0100000000000000FFFFFFFF03000000010000000800000003000000FDFFFFFFFEFFFFFFFFFFFFFF020000000200000000000000FEFFFFFFFDFFFFFF00000000FFFFFFFFFFFFFFFF06000000050000000000000000000000FFFFFFFF01000000FFFFFFFF01000000FFFFFFFFFEFFFFFF06000000050000000000000003000000FEFFFFFF02000000030000000300000003000000FFFFFFFF00000000FEFFFFFF0000000001000000040000000200000002000000FBFFFFFF01000000010000000000000000000000FCFFFFFFFDFFFFFF01000000000000000000000001000000FFFFFFFF00000000FFFFFFFF010000000000000001000000FDFFFFFF01000000FBFFFFFFFEFFFFFF000000000100000002000000FFFFFFFF03000000FFFFFFFF00000000FAFFFFFFFFFFFFFFFEFFFFFF00000000FFFFFFFF02000000FCFFFFFF000000000000000002000000000000000100000000000000FFFFFFFFFBFFFFFF0000000002000000FAFFFFFF0000000001000000FAFFFFFF01000000FFFFFFFF00000000FBFFFFFF02000000FFFFFFFFFFFFFFFF030000000400000003000000FDFFFFFFFCFFFFFF050000000400000002000000FEFFFFFF000000000000000001000000000000000400000004000000FBFFFFFF0700000000000000020000000200000004000000FFFFFFFF0000000001000000FDFFFFFF03000000FEFFFFFFFCFFFFFF0000000000000000000000000100000003000000FDFFFFFF0200000001000000FCFFFFFFFCFFFFFF000000000300000000000000FAFFFFFF03000000FDFFFFFF0300000001000000FDFFFFFF000000000100000000000000FFFFFFFF02000000FAFFFFFF00000000FDFFFFFFFEFFFFFFFEFFFFFF00000000FFFFFFFF0000000006000000FFFFFFFF01000000FCFFFFFF01000000FFFFFFFFFFFFFFFF02000000FDFFFFFFFBFFFFFFFFFFFFFF0000000000000000FCFFFFFFFEFFFFFFFEFFFFFF0100000003000000FFFFFFFFFFFFFFFFFFFFFFFF000000000200000000000000FDFFFFFF00000000FCFFFFFF00000000FDFFFFFF01000000010000000500000005000000FCFFFFFF01000000FEFFFFFF0000000000000000FFFFFFFF00000000FBFFFFFF02000000FCFFFFFFFFFFFFFFFFFFFFFFFBFFFFFFFDFFFFFF02000000FEFFFFFFFEFFFFFFFAFFFFFF0000000000000000000000000000000002000000FFFFFFFFF8FFFFFFFFFFFFFF0100000001000000FDFFFFFF0000000002000000FFFFFFFF00000000FFFFFFFF000000000400000001000000FFFFFFFF0000000001000000FBFFFFFFFBFFFFFFFFFFFFFF00000000FDFFFFFFFAFFFFFF000000000300000000000000FFFFFFFFFFFFFFFFFFFFFFFFFBFFFFFF01000000FFFFFFFF030000000000000000000000FFFFFFFF02000000FFFFFFFF00000000030000000300000000000000FBFFFFFF05000000FDFFFFFF0000000000000000FBFFFFFF00000000FCFFFFFF0300000007000000FFFFFFFF01000000040000000100000001000000FFFFFFFF02000000FFFFFFFFFFFFFFFFFFFFFFFF0100000000000000"> : tensor<20x20xi32>
    return %0 : tensor<20x20xi32>
  }
  func.func private @expected() -> tensor<20x20xi32> {
    %0 = stablehlo.constant dense<"0x0000000000000000F9FFFFFFFDFFFFFF01000000FFFFFFFF0000000001000000FFFFFFFF04000000FDFFFFFF03000000FEFFFFFF0200000004000000FFFFFFFF000000000000000000000000FEFFFFFF0500000003000000FAFFFFFF03000000000000000100000000000000FDFFFFFF010000000300000005000000FEFFFFFFFCFFFFFF02000000FFFFFFFFFDFFFFFF06000000040000000500000004000000FEFFFFFF000000000000000001000000FFFFFFFF00000000FFFFFFFF0300000004000000FAFFFFFF0000000003000000FDFFFFFF020000000300000000000000FEFFFFFFFEFFFFFF050000000000000000000000FAFFFFFFFEFFFFFF040000000200000000000000FFFFFFFF00000000FEFFFFFF01000000FFFFFFFFFEFFFFFF0000000001000000010000000500000004000000FDFFFFFFFBFFFFFFFFFFFFFF0100000001000000FCFFFFFF020000000200000001000000060000000000000001000000F9FFFFFF00000000020000000200000000000000FDFFFFFF000000000300000006000000FEFFFFFF0100000001000000FEFFFFFF01000000FCFFFFFF00000000000000000100000003000000000000000400000005000000FBFFFFFF0300000001000000000000000100000000000000FEFFFFFF03000000FFFFFFFF0000000001000000FDFFFFFFFFFFFFFFF8FFFFFFFDFFFFFF030000000200000001000000FEFFFFFFFEFFFFFF000000000200000003000000000000000100000001000000FAFFFFFFFBFFFFFF000000000000000001000000FFFFFFFF01000000FFFFFFFF0100000002000000FAFFFFFFFBFFFFFF00000000FDFFFFFF02000000FEFFFFFFFDFFFFFFFDFFFFFFFDFFFFFF01000000000000000200000000000000FFFFFFFFFCFFFFFFFEFFFFFFFEFFFFFF05000000FFFFFFFFFFFFFFFF00000000000000000400000003000000FFFFFFFF0000000000000000FFFFFFFF010000000000000001000000FFFFFFFF00000000FFFFFFFF03000000FFFFFFFF050000000200000000000000FFFFFFFFFEFFFFFF01000000FDFFFFFF01000000000000000600000001000000020000000000000001000000FEFFFFFF040000000000000000000000FEFFFFFF00000000FFFFFFFF00000000010000000500000000000000FEFFFFFF0600000000000000FFFFFFFF06000000FFFFFFFF010000000000000005000000FEFFFFFF0100000001000000FDFFFFFFFCFFFFFFFDFFFFFF0300000004000000FBFFFFFFFCFFFFFFFEFFFFFF020000000000000000000000FFFFFFFF00000000FCFFFFFFFCFFFFFF05000000F9FFFFFF00000000FEFFFFFFFEFFFFFFFCFFFFFF0100000000000000FFFFFFFF03000000FDFFFFFF0200000004000000000000000000000000000000FFFFFFFFFDFFFFFF03000000FEFFFFFFFFFFFFFF040000000400000000000000FDFFFFFF0000000006000000FDFFFFFF03000000FDFFFFFFFFFFFFFF0300000000000000FFFFFFFF0000000001000000FEFFFFFF0600000000000000030000000200000002000000000000000100000000000000FAFFFFFF01000000FFFFFFFF04000000FFFFFFFF0100000001000000FEFFFFFF0300000005000000010000000000000000000000040000000200000002000000FFFFFFFFFDFFFFFF01000000010000000100000000000000FEFFFFFF000000000300000000000000040000000000000003000000FFFFFFFFFFFFFFFFFBFFFFFFFBFFFFFF04000000FFFFFFFF020000000000000000000000010000000000000005000000FEFFFFFF0400000001000000010000000500000003000000FEFFFFFF02000000020000000600000000000000000000000000000000000000FEFFFFFF010000000800000001000000FFFFFFFFFFFFFFFF0300000000000000FEFFFFFF01000000000000000100000000000000FCFFFFFFFFFFFFFF0100000000000000FFFFFFFF05000000050000000100000000000000030000000600000000000000FDFFFFFF0000000001000000010000000100000005000000FFFFFFFF01000000FDFFFFFF000000000000000001000000FEFFFFFF0100000000000000FDFFFFFFFDFFFFFF0000000005000000FBFFFFFF030000000000000000000000050000000000000004000000FDFFFFFFF9FFFFFF01000000FFFFFFFFFCFFFFFFFFFFFFFFFFFFFFFF01000000FEFFFFFF010000000100000001000000FFFFFFFF00000000"> : tensor<20x20xi32>
    return %0 : tensor<20x20xi32>
  }
}
