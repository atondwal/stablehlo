// RUN-DISABLED: stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[[0, 1], [2, 3]], [[4, 0], [1, 2]]]> : tensor<2x2x2xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xf32>, tensor<5x2x2xf32>)
    %2 = call @expected() : () -> tensor<5x6x7xf32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<f32>, %arg1: tensor<f32>):
      %5 = stablehlo.maximum %arg0, %arg1 : tensor<f32>
      stablehlo.return %5 : tensor<f32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1, 2], scatter_dims_to_operand_dims = [1, 2], index_vector_dim = 2>, unique_indices = true} : (tensor<5x6x7xf32>, tensor<2x2x2xi32>, tensor<5x2x2xf32>) -> tensor<5x6x7xf32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xf32>, tensor<5x6x7xf32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xf32>, tensor<5x2x2xf32>) {
    %0 = stablehlo.constant dense<"0x24C7193F57A29BBE6A231E40D91C7BC0789630C068765DBFDCC556C03A2979C0407F8D40A2930A3D02C50FC0E2FF3ABF474C93BF60429CBF15839EBEC7C07D40329F9DBF8704B540A0F5A7405046394024B994BF838451C05423864085FCA5BF891073C033A0614094EBA63EBEFEFD40D526B53F836D343D64E584C0857BB54083220BC0A995FC3E68F209C04B30F040E5B05340180A7F3F8B7BBC3FDAB25A402E4042BFB849EEBFECBFE9BF40C5CB3FEAB818C0E407943F5A36F83FEADD054048C53DC1395E5B40DA5637C097DDE040CE038340BA4167C062E1E13F369FCBBE7A1012BFD66A6E3F038E1F404770CA3F419532BFE8D13440FCE1DFBFC89D05401C662EC0809F5D409E138B4002057E3FD312ED3FEF1A19BF5C21A4C06C4A013E4C6E2DC08FCDBE4006FE68C0979204C116586C406DAF4840792241BF6D0544C026DA3DC025840F40EC0EDC3F5C76563FC17C3A409AA7663F2944D5BF65988ABE1518914056A9523EF61C1B4053C40640351564C00C4C56C08376C7C00F65C03EA70F4C401056EE4020CD36BF361FA3C07960E63FCEC625406BF4AEBFB8809D3F6BFF23C0B9890D4074842AC00D2A4B3FCAF187C08DDA70BECB6CADC090B3C13EC7B110BFD2683B40E7893FC07F317F40196DAC3E71D92140E7A35940C0C4AA3DE3E649C0D2761DC073B212C0FC76C7C0B0794340EA97B3C087BA8F3F71C5B5BDFC1734BF2E9CD2C0AA223B40E79F3FC0AF3B8E3F61D4B440C481B0BF9EC35040D3B0A43FF075014090C82740A8BB0EC0D5EF50C08BB7A7BFA8F0EF40B631934042275BBFF4067ABEBF9222C0147D4CBFC17090BDE38F5DC0EA4A003F9A6E86C03C26CFBE1324FBBE86B942C0DC3381C0819E23BFA2CBB1BF763296BFD42CA3BF9DA90540A8CA453F75912BC0ACA724BF7C9360C0BA6A85C00B490D3FA72F02C02B19D6BF4C1824405B5F0FC1967EBDC067E0573F176A18C09F7BD7C035172FC0AE15DE3ECC64213FEFF5AD409BDE413EA743124010F3623ED8135EBF092438400B8A51C0FB1BE040D43EC8BFE2EB54C0874FC33EF01760C08F4D07C042E80A40C04277BFABB59A3FECD6F93FC43F05BF36E76BC0260E9E4048BC813F4555D13F4A134A409CFC23BF61CA8DBF4A939EC0D3CBC7BF06E55EBF865D7D4042F270C070BF4840009619C0"> : tensor<5x6x7xf32>
    %1 = stablehlo.constant dense<[[[0.659340798, -2.44662499], [-0.260552317, 0.425184906]], [[2.49054122, 2.18156123], [0.586714327, -3.9362843]], [[1.88053691, -0.286122471], [-1.19593859, 1.83885765]], [[1.76608193, 3.7314992], [4.2032094, -3.34987736]], [[1.37199795, -0.018129427], [-0.337052971, 4.66021681]]]> : tensor<5x2x2xf32>
    return %0, %1 : tensor<5x6x7xf32>, tensor<5x2x2xf32>
  }
  func.func private @expected() -> tensor<5x6x7xf32> {
    %0 = stablehlo.constant dense<"0x24C7193F8FCA283F6A231E40D91C7BC0789630C068765DBFDCC556C03A2979C0407F8D40D6B1D93E02C50FC0E2FF3ABF474C93BF60429CBF15839EBEC7C07D40329F9DBF8704B540A0F5A7405046394024B994BF838451C05423864085FCA5BF891073C033A0614094EBA63EBEFEFD40D526B53F836D343D64E584C0857BB54083220BC0A995FC3E68F209C04B30F040E5B05340180A7F3F8B7BBC3FDAB25A402E4042BFB849EEBFECBFE9BF07651F40EAB818C0E407943F5A36F83FEADD054048C53DC1395E5B40DA5637C097DDE040CE038340BA4167C062E1E13F369FCBBE7A1012BFD66A6E3F038E1F40B39E0B40419532BFE8D13440FCE1DFBFC89D05401C662EC0809F5D409E138B4002057E3FD312ED3FEF1A19BFE932163F6C4A013E4C6E2DC08FCDBE4006FE68C0979204C116586C406DAF4840792241BF6D0544C026DA3DC025840F40EC0EDC3F5C76563FC17C3A406FB5F03F2944D5BF65988ABE1518914056A9523EF61C1B4053C40640351564C0B05FEB3F8376C7C00F65C03EA70F4C401056EE4020CD36BF361FA3C07960E63FCEC625406BF4AEBFB8809D3F6BFF23C0B9890D4074842AC00D2A4B3FCAF187C08DDA70BECB6CADC090B3C13EC7B110BFD2683B40E7893FC07F317F40196DAC3E71D92140E7A35940C0C4AA3DE3E649C0D2761DC073B212C0FC76C7C0B0794340EA97B3C087BA8F3FF90EE23FFC1734BF2E9CD2C0AA223B40E79F3FC0AF3B8E3F61D4B440C481B0BF9EC35040D3B0A43FF075014090C82740A8BB0EC0D5EF50C08BB7A7BFA8F0EF40B631934042275BBFF4067ABEBF9222C0147D4CBFC17090BDE38F5DC0EA4A003F9A6E86C03C26CFBE1324FBBEB1808640DC3381C0819E23BFA2CBB1BF763296BFD42CA3BF9DA90540A8CA453F75912BC0ACA724BF7C9360C0BA6A85C00B490D3FA72F02C02B19D6BF4C1824405B5F0FC1967EBDC067E0573F176A18C09F7BD7C035172FC0AE15DE3E7F209540EFF5AD409BDE413EA743124010F3623ED8135EBF092438400B8A51C0FB1BE040D43EC8BFE2EB54C0874FC33EF01760C08F4D07C042E80A40C04277BFABB59A3FECD6F93FC43F05BF3592ACBE260E9E4048BC813F4555D13F4A134A409CFC23BF61CA8DBF4A939EC0D3CBC7BF06E55EBF865D7D4042F270C070BF4840009619C0"> : tensor<5x6x7xf32>
    return %0 : tensor<5x6x7xf32>
  }
}

