// RUN-DISABLED: stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<1> : tensor<2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<3x5x40xbf16>, tensor<3x5x2xbf16>)
    %2 = call @expected() : () -> tensor<3x5x40xbf16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<bf16>, %arg1: tensor<bf16>):
      %5 = stablehlo.multiply %arg0, %arg1 : tensor<bf16>
      stablehlo.return %5 : tensor<bf16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 1], inserted_window_dims = [2], scatter_dims_to_operand_dims = [2], index_vector_dim = 1>} : (tensor<3x5x40xbf16>, tensor<2x1xi32>, tensor<3x5x2xbf16>) -> tensor<3x5x40xbf16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<3x5x40xbf16>, tensor<3x5x40xbf16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<3x5x40xbf16>, tensor<3x5x2xbf16>) {
    %0 = stablehlo.constant dense<"0x8EC0403F01C1C73F2640B2BFF3BF88C00B400A418040F93F5FBF04C0E8C005C022BF1FC0E1BF77BE90BFEF3F6A40F93E52C09140CDBE1D408DBFE53E933F75C096C088C03AC0DD406E4091C0D440A23E47400DC01340E63E2B408A3FEEBEB1BFF23F56404F4082BE92C05BC024BFA4BF07407B3F29409CC0B3C0C9408B407DC038C09140B33EB93FD9C040BF8040283FE5BFED401440093F85C0B0BF2840204016C0FB3FEF4016406DC06A402EC03E405440913FF9BFEE3E3B4079C0A1BF103E9940EABF95401EC08740D73F22BE0B4036C0223F953E9BBF01BF9BBF78C03EC03C404CC0F8BFBDBFC7BEA13F6C3F81400140254093C0313FDE3E64BF13C083C04EBE43BF77BFFFC095BFF43F9E3D47C0913DEC3F7C3FE0BEB9401C40673E5DC0EABFFABF04BF0B4180BF8DC0BC3F3D401740D5BFBBC05C40CE3F03BEDD40D0BF9A3FC6BF30402940EB3FA53FA640C3BF14C06FBF6640DAC03D405D403DC0523EAD3E904099BFEFBD9A40FDBF49BFD8BE0DC0FABCBEBF1FC0A23FA03F743F3BBFF9BF9ABE2A40BB3F9BC0B13F0EBF9CC0B5BF2D4082BF4FBF17C097BF254049BF284032C12FC0B63F20C185BE9F3F8340C53F3BC0C7BFEFBF26C06AC035C0533EC8BF8CBF7340E140BEC094C0EEBF35C0D1BE2540BA3F33C04DC03EC072C00740C6BE9D40F43E4340E03F42400CC0BBBF31C029BF76400341E93FB73FBBBF2DBFA5BF57BE09C0A13F02C0BEBF05C0A0C01FBF0CBFDFBEA1C061400DC0933F25BE1140AA40124036407A401FC09F4025BF29C0EDBFA13EAB3E8BC0D5BF06C05B3F843F0A407BC09D4033BF50C0A1C0B1C07A40D9BE8ABF1DC0CCC00CC076BEE93F27409BBF9640BFBE1540D140BF3F96C024403AC0ADBDF33E943F2340973FCBC094C0A93F8A409C400F405D40D2BF41BFED3F23C0F2BF96C0D4BFB83F693F87BE6BC0FDBFCEBF8A408740983F32400840E13FAD3E3B402440EFBD234013BFDDBF124048C014C09FBFF9BFAF3F9CC016BE86C02FC0BAC034C053404CBF0FC02DC02240833FC9C0B8BE7BC03DC00A3F323FA9C03740A9BF40BEB3BFA8C08840EE4071C0E3BE254081407DC00C3F2D402240D7BF2C3D69BF3F408ABFFA3F4EBFDA3F0340D5BF12C0CDBF15BF1B406FBF8740C33F52405DBF09C0EB3FC03F4D40B540B2BF5140AC409CBE2F40D240C0BF8CC0F43F2B3E833FA0BE1EC0F8BE08C04DC03BC01BBE84BF2B408B406CC01DC03B3EC1BFA44097C03E3F2740674006BFDB3F63C0D4BFAF3FD43DA83EE0C0D2BF50BF4C40023F53BF53408840E63FADBF48C0A2BEE3BEB3C054C07ABE003FD8BD8ABF204086C028C0DABF2EC03FBF55400C3F5C3FB1C0DB3F8A3E7AC0BDBF6F409440173F01C00A40B33E16BE8E40893F0A409040373FB040C53FCCBE414091C0E6BFC8BFBBBF5DBF6FC03CC054C05EC01EBFDD3EE83F463F83BF793FB1BFD33F83BF12C0AC3E7EC0A84004C0C5BF80BF0040FFBFEDBFB3BF36406CBF8DBF8CBF2EC06A3F6B3FA3BF8EC02ABEF3BF6C3E60C0A73F3F3FB5BFA13F99BF1C4022C00AC071BFA14062BF44404ABF593D0C40783F4CC0693F68C08F4013C035C0F54004C03A3FA8BF7AC017C08EC041BF8640A0C0FDBF044046C008C05DC0AD40F5C067BF3D40E6BE9640A2BE5CBF02C0D3C0184090407EC09AC0E6BF9FBFB040583FB0C0"> : tensor<3x5x40xbf16>
    %1 = stablehlo.constant dense<[[[6.906250e+00, -2.949220e-01], [-3.765630e+00, -7.000000e+00], [7.187500e-01, -9.023430e-01], [1.703130e+00, -8.500000e+00], [-1.117190e+00, -2.546880e+00]], [[1.960940e+00, 1.968750e+00], [3.406250e+00, 6.500000e+00], [5.218750e+00, -1.992190e-01], [1.515630e+00, 1.806640e-01], [1.079100e-01, -2.609380e+00]], [[2.921880e+00, -3.406250e+00], [-2.062500e+00, 4.312500e+00], [5.031250e+00, -7.000000e+00], [-1.429690e+00, -5.156250e-01], [5.031250e+00, 3.593750e+00]]]> : tensor<3x5x2xbf16>
    return %0, %1 : tensor<3x5x40xbf16>, tensor<3x5x2xbf16>
  }
  func.func private @expected() -> tensor<3x5x40xbf16> {
    %0 = stablehlo.constant dense<"0x8EC0C4BF01C1C73F2640B2BFF3BF88C00B400A418040F93F5FBF04C0E8C005C022BF1FC0E1BF77BE90BFEF3F6A40F93E52C09140CDBE1D408DBFE53E933F75C096C088C03AC0DD406E4091C0D440A23E474069C21340E63E2B408A3FEEBEB1BFF23F56404F4082BE92C05BC024BFA4BF07407B3F29409CC0B3C0C9408B407DC038C09140B33EB93FD9C040BF8040283FE5BFED401440093F85C0B0BF2840204016C0A2BFEF4016406DC06A402EC03E405440913FF9BFEE3E3B4079C0A1BF103E9940EABF95401EC08740D73F22BE0B4036C0223F953E9BBF01BF9BBF78C03EC03C404CC0F8BFBDBFC7BEA13F6C3F8140014016C293C0313FDE3E64BF13C083C04EBE43BF77BFFFC095BFF43F9E3D47C0913DEC3F7C3FE0BEB9401C40673E5DC0EABFFABF04BF0B4180BF8DC0BC3F3D401740D5BFBBC05C40CE3F03BEDD40D0BF9A3F8DC030402940EB3FA53FA640C3BF14C06FBF6640DAC03D405D403DC0523EAD3E904099BFEFBD9A40FDBF49BFD8BE0DC0FABCBEBF1FC0A23FA03F743F3BBFF9BF9ABE2A40BB3F9BC0B13F0EBF9CC0B5BF274182BF4FBF17C097BF254049BF284032C12FC0B63F20C185BE9F3F8340C53F3BC0C7BFEFBF26C06AC035C0533EC8BF8CBF7340E140BEC094C0EEBF35C0D1BE2540BA3F33C04DC03EC072C00740C6BEDA42F43E4340E03F42400CC0BBBF31C029BF76400341E93FB73FBBBF2DBFA5BF57BE09C0A13F02C0BEBF05C0A0C01FBF0CBFDFBEA1C061400DC0933F25BE1140AA40124036407A401FC09F4025BF29C0F73FA13EAB3E8BC0D5BF06C05B3F843F0A407BC09D4033BF50C0A1C0B1C07A40D9BE8ABF1DC0CCC00CC076BEE93F27409BBF9640BFBE1540D140BF3F96C024403AC0ADBDF33E943F2340973FCBC094C0B93E8A409C400F405D40D2BF41BFED3F23C0F2BF96C0D4BFB83F693F87BE6BC0FDBFCEBF8A408740983F32400840E13FAD3E3B402440EFBD234013BFDDBF124048C014C09FBFF9BFAF3F9CC016BE86C0453FBAC034C053404CBF0FC02DC02240833FC9C0B8BE7BC03DC00A3F323FA9C03740A9BF40BEB3BFA8C08840EE4071C0E3BE254081407DC00C3F2D402240D7BF2C3D69BF3F408ABFFA3F4EBFDA3F0340854112C0CDBF15BF1B406FBF8740C33F52405DBF09C0EB3FC03F4D40B540B2BF5140AC409CBE2F40D240C0BF8CC0F43F2B3E833FA0BE1EC0F8BE08C04DC03BC01BBE84BF2B408B406CC01DC03B3EC1BF36C297C03E3F2740674006BFDB3F63C0D4BFAF3FD43DA83EE0C0D2BF50BF4C40023F53BF53408840E63FADBF48C0A2BEE3BEB3C054C07ABE003FD8BD8ABF204086C028C0DABF2EC03FBF55400C3F5C3F4343DB3F8A3E7AC0BDBF6F409440173F01C00A40B33E16BE8E40893F0A409040373FB040C53FCCBE414091C0E6BFC8BFBBBF5DBF6FC03CC054C05EC01EBFDD3EE83F463F83BF793FB1BFD33F83BF12C07E3E7EC0A84004C0C5BF80BF0040FFBFEDBFB3BF36406CBF8DBF8CBF2EC06A3F6B3FA3BF8EC02ABEF3BF6C3E60C0A73F3F3FB5BFA13F99BF1C4022C00AC071BFA14062BF44404ABF593D0C40783F4CC0844168C08F4013C035C0F54004C03A3FA8BF7AC017C08EC041BF8640A0C0FDBF044046C008C05DC0AD40F5C067BF3D40E6BE9640A2BE5CBF02C0D3C0184090407EC09AC0E6BF9FBFB040583FB0C0"> : tensor<3x5x40xbf16>
    return %0 : tensor<3x5x40xbf16>
  }
}

