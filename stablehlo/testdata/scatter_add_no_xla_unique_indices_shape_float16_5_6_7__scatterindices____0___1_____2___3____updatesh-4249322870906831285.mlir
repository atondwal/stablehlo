// RUN-DISABLED: stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[[0], [1]], [[2], [3]]]> : tensor<2x2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xf16>, tensor<5x2x2x7xf16>)
    %2 = call @expected() : () -> tensor<5x6x7xf16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<f16>, %arg1: tensor<f16>):
      %5 = stablehlo.add %arg0, %arg1 : tensor<f16>
      stablehlo.return %5 : tensor<f16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 3], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1], index_vector_dim = 2>, unique_indices = true} : (tensor<5x6x7xf16>, tensor<2x2x1xi32>, tensor<5x2x2x7xf16>) -> tensor<5x6x7xf16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xf16>, tensor<5x6x7xf16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xf16>, tensor<5x2x2x7xf16>) {
    %0 = stablehlo.constant dense<"0xCDBD40BA60C071341937634354A564437D3B29BE963A593F84B8DEBD7C402E3C9F3FA7ABA0C601BA0A445CB693C5F642D2AF9EC5FD373141283E8EBEB04377C19DBF0138E8BE673C343C6A3FA144BAC5C242C1BAE13A8B2F2232354262C4DB4458BD6343D9BFD74409BE34B03044B5BD9EC10CB83CC8163CAAC76DC46CC11F409CBEA637F7AACB3C4545E9B900C6A23E26434240B33B39B32A4189BA41C157C6BFBB41BE25C5433F023241BC01B813C469C21E3063C00CC04B379540ADC2F239F24010B31F44533CEE43B345F63C0C4520C115407EC3C7BD5A2C32BC63BF443D4838E2C24041552B38B94045724131B99CC0A9C095465CB159C321BEC1C399B3DCC1D1BCFF4422C3013F59C06A4108C024C528C4E0405EC42E3D02BDC844E5406CBE094136BD42C33C4434473AB6663F97C06D385D3FD8C17FC1EEC44BBC3DC1953F903FB1C09AB91DC19DC13CBDBD412EBE8EC4D044DC44ECC1A4B6D44253C4EBB871426F392FBF083822C01145FAC4BABD8BBE8645A2BF1EC48843F54280421A3F443725C9CE46ADC6FAC05544993764C06DBD543B5533E732CEBE42AE5B4484BCF838"> : tensor<5x6x7xf16>
    %1 = stablehlo.constant dense<"0xE141FB44AEBE5FC4DAC34A40953492B48141FFC158AF37B98C3BECBEE9BC5DB9FD3CCDC611BC73392238443869BC9B409CC003C4DEC354462A3455BC5F28D0B8FA43523DF0BF48C45AC0C4BAED3B9642E34008BDFFBEF1409DBAACAA56416C4598BACBBF2FC7F238AE36B946D5C2A8BCB1B6E63340453640BDBD104221B998BFDCB03BC4613AA9418A4027BBB43A43C56FC57531743E9E3D36BF12BBC538DB4363BF58C25A413843E240BA40FBC0A345F23FF8BFE54130409D394FBB8CC5B7C09E432FC2BABB16BB44222DB5FBC0EFB05E3A8F350B3EAD3807C269414229DD35C136853C2EC14E458CB765BBEEC1554494437AC59B405EBCEBC4AAC0DFC17BBDD1B538C4602CDAC27BC1AEBD16C022BA0F3ED245063CF043"> : tensor<5x2x2x7xf16>
    return %0, %1 : tensor<5x6x7xf16>, tensor<5x2x2x7xf16>
  }
  func.func private @expected() -> tensor<5x6x7xf16> {
    %0 = stablehlo.constant dense<"0xF53D3344B7C318C4F7C2D6454034D24260438AC4AB39BE3C103665C20F3CFE354E42DCC6A4C770AC8E445830ADC6C845DBC0D0C8DEC27648283E8EBEB04377C19DBF0138E8BE673C343C6A3FA144BAC5C242C1BA7B3CB9BB3A33014150B63046A4C2B4B823C4FD4325B85342A2465EC18FC4DC3FA6C8C13BFFC4F83B12C3302F6BC8623CCF35EC476A3F9CBF00C6A23E26434240B33B39B32A4189BA41C157C6BFBB41BE25C5433F60B388BAC044E0BFA4C45242ABC1D8C3DD34C2BF15C12643BE4476BCF6442EC4E0BDDF45B54174465EC4A13C4DC2F8401DBF38C4A23AED444838E2C24041552B38B94045724131B99CC0A9C095465CB159C321BEBEBD40406CC56F44FC468FC5B34420ADD142DCC158C984C63F4676C7443546C0CB443F4018C4BA400EB890C2BF45CA47CEC28E4482C05C3B5D3FD8C17FC1EEC44BBC3DC1953F903FB1C09AB91DC19DC13CBDBD417EBCDAC272401549DEC25CBD30370020594283C0F741C6C16AC466C4434059C62EBFDBC5984556C5DCC6B140BE3DF84094424646A4C86349ADC6FAC05544993764C06DBD543B5533E732CEBE42AE5B4484BCF838"> : tensor<5x6x7xf16>
    return %0 : tensor<5x6x7xf16>
  }
}

