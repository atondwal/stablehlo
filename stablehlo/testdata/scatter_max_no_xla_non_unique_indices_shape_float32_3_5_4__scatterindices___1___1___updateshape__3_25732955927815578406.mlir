// RUN-DISABLED: stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<1> : tensor<2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<3x5x4xf32>, tensor<3x2x4xf32>)
    %2 = call @expected() : () -> tensor<3x5x4xf32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<f32>, %arg1: tensor<f32>):
      %5 = stablehlo.maximum %arg0, %arg1 : tensor<f32>
      stablehlo.return %5 : tensor<f32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 2], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1], index_vector_dim = 1>} : (tensor<3x5x4xf32>, tensor<2x1xi32>, tensor<3x2x4xf32>) -> tensor<3x5x4xf32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<3x5x4xf32>, tensor<3x5x4xf32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<3x5x4xf32>, tensor<3x2x4xf32>) {
    %0 = stablehlo.constant dense<[[[1.50537109, -0.00501686335, -0.989427328, 1.99348652], [2.69639969, 0.334796578, -1.88759458, 4.97222233], [-4.34852934, 3.29068542, 1.4118433, -0.554469526], [-8.00633621, 0.616560459, -1.85838759, 1.883550e+00], [-1.86314416, -1.27211201, 2.09765172, 2.37872028]], [[5.77594709, -1.41367888, 0.457406878, -5.58877468], [2.37203836, -0.752662837, 0.368346244, 1.57407224], [0.555696905, 0.349916726, 2.51987576, -0.338052154], [-5.21427441, -1.66735268, 2.00438118, 2.57472515], [-4.67342281, 0.541565835, 7.15206671, -3.28540587]], [[-2.17271471, 0.931059599, 0.927113234, 1.96647584], [1.48963404, -8.64811325, 2.57129622, 1.30660677], [-3.76535726, 5.71720648, -0.65778619, 1.21471107], [-2.95958829, 1.89201224, -2.9214623, -3.1581552], [1.04050505, 4.23087549, -5.872080e+00, -3.09106684]]]> : tensor<3x5x4xf32>
    %1 = stablehlo.constant dense<[[[-1.83843231, 1.39420223, -1.84631395, 1.54700625], [-3.0765903, 0.976682722, -4.469760e-01, -1.77597582]], [[3.59669471, -6.12265825, 5.18160391, 2.04425287], [-1.60592473, -1.70330036, 5.43947268, -1.8059032]], [[0.164142415, -3.29113173, -3.79413819, 0.111804932], [1.748010e+00, -0.659482777, 3.67051435, 2.0711832]]]> : tensor<3x2x4xf32>
    return %0, %1 : tensor<3x5x4xf32>, tensor<3x2x4xf32>
  }
  func.func private @expected() -> tensor<3x5x4xf32> {
    %0 = stablehlo.constant dense<[[[1.50537109, -0.00501686335, -0.989427328, 1.99348652], [2.69639969, 1.39420223, -4.469760e-01, 4.97222233], [-4.34852934, 3.29068542, 1.4118433, -0.554469526], [-8.00633621, 0.616560459, -1.85838759, 1.883550e+00], [-1.86314416, -1.27211201, 2.09765172, 2.37872028]], [[5.77594709, -1.41367888, 0.457406878, -5.58877468], [3.59669471, -0.752662837, 5.43947268, 2.04425287], [0.555696905, 0.349916726, 2.51987576, -0.338052154], [-5.21427441, -1.66735268, 2.00438118, 2.57472515], [-4.67342281, 0.541565835, 7.15206671, -3.28540587]], [[-2.17271471, 0.931059599, 0.927113234, 1.96647584], [1.748010e+00, -0.659482777, 3.67051435, 2.0711832], [-3.76535726, 5.71720648, -0.65778619, 1.21471107], [-2.95958829, 1.89201224, -2.9214623, -3.1581552], [1.04050505, 4.23087549, -5.872080e+00, -3.09106684]]]> : tensor<3x5x4xf32>
    return %0 : tensor<3x5x4xf32>
  }
}

