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
      %5 = stablehlo.minimum %arg0, %arg1 : tensor<bf16>
      stablehlo.return %5 : tensor<bf16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 1], inserted_window_dims = [2], scatter_dims_to_operand_dims = [2], index_vector_dim = 1>} : (tensor<3x5x40xbf16>, tensor<2x1xi32>, tensor<3x5x2xbf16>) -> tensor<3x5x40xbf16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<3x5x40xbf16>, tensor<3x5x40xbf16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<3x5x40xbf16>, tensor<3x5x2xbf16>) {
    %0 = stablehlo.constant dense<"0x844065C0DCBF6EC021C0A63F4D40DC3FCDBE904020C0A74030BFAEBF684085C089BF9CBF41C0E83F12BF0E404840C740124094C021C0CDBF4940293F9A3F1BBF083FA640814023C01D3F60C013BEC34092405140A8407AC0594058C0FA4061C06440C0BF54C0AC3FB9C0E53FB4C039407FC0D63E2940B1BFCCC0FDB936C05BBF1C409B4068BFEDBE63C0B94058C0D8BF7DBE8B4034BE40C02ABFA44072BE6BBED23F1EC003C05BBE62BFF6BF363F48BE023F7EC0C03FFFC0F0BF6EC0F1BFD3C016402640154070C01B408EC019C0B5BF9F3FE7BFC3BF4E3F42C0F1BF5B403C4001C0AFBF91BF4BBEB9BE434085BEADC0833F823F83BF12C0783E6A4060C0E63F69BF3740C5BF88C093BF98401EC0C1C0493FA93E1840F6BF3E40D5BFBA3F8C3F254078BF9B3E93BF593F854007C0DBBF3A3EAE3E8AC06A40AEC0F63F483F1940353E203FADC0743FFABFDABF753FA03FA33F54BEC3C0ACC0734016409CC042C0F7C05DC0723F32C03DC073406D407DC06B404640DFBEDCBF5F4084C053BFB0C03F402FBEB63F9AC0903E523FB03F1EC08EBFB2BFCABF99C06E3F68C0983F524048C01D405EC059C04B400540DBC0853F054061BF8E401C3F9BBD80403CC0323E5EBF72C0743EDD3FBD400F400C404BC035C0164015BE1F3F9CBE09C00F3FB8BF70BF5340D03FA4C0A040F94045C005C19CC0413FDEBF8E400EBF9DBC0BBFB2BF35C017BF93BEB43F30C0C5BFBB3E924055C093BF05BF75406DBF754051C09E40BCC016BF6540A6BE1140F7BF143E7C400FC0E73FE63F31BF80C002C04C4076BF80C0BB405040A93F2C4098BFA63F504093BE7640B1C0A940EFBF393FB63FFE3FD4BF303E183C1C3D8A404B3FDE3FC7BF3BC0053F123F87404AC00F3F633EB8C0613F75BFAAC0E2C082BEB0BE93BF2B3FAA404F404D40AFC0B8C0443F3C408E3FEDBFEFBFACC089C0EE3E19C030BF94C0E03FD83F4FBF36C0F9BE4BC0034006409E3FBE408C40943E21BF60C00A400FBFF13D08C019C0B73FACBF433F20C04D3F5FC0003F2940AABFC7C078BF413F89BF103F05C09BC0D8BE41C079404CC0AB40CC40C1BE81C0F54063C056C02E40104088C0F0C0ABBF104060BE1040DCBF8140BE3F5640973F01401A40A93FD8BFC74015BF33BE25C0A340ECBFE8BF62C04AC05F40EF3F93C0A0BF47403B403F403140DA4023C0403F053F23402E3F48C01B40174195BF8C40A5402AC01240523FD13F60406B3FD1C0064031C0993F2C4012C09EC0A1C02B4017BF30C0593FA33F89C0EABFC5C03E3FF6BF02C0AB3F4FC0943F18C0C7BFD2C050BF5940A4406E3E83406CC0B53FFB3F1B404540434014403BC03EBE89BFF4BFCFBFB53F3C3ED3BF30BF02C0233D274001401AC093C0A9BFD73C1240794082407D401D40D7C04FC0023E15C0C540E6BF2CC09B3FA64079BE24C097409AC0B7C08DBFE740B1BF50BF7A404CBFE7BF1FBF0C4078C094BF49C037C0E3BFC73E95403D3F8FC045BE533FFEC06CC01FC030C0543EB3C08A40C640CF3EB8BF13C0594045404CBEE3C0C4BF15BF2BC0DE3F36C03A3C464013C06A40CB40FB3FA0BF48408C404C40CABF9D3F6240BA4093BFDA3F3240723F0BC16BC082BFC6BF6540D43F8F3E28C0B73E893EF33F2FBD873F3BC03C40FA409FBF82C08CBE44BF53C0344067C0F6BF1C40BCBF133F"> : tensor<3x5x40xbf16>
    %1 = stablehlo.constant dense<[[[3.359380e+00, 5.156250e+00], [1.968750e+00, -1.164060e+00], [-5.507810e-01, -2.093750e+00], [-2.296880e+00, -4.062500e+00], [3.765630e+00, -2.906250e+00]], [[3.000000e+00, 1.289060e-01], [1.476560e+00, -2.031250e+00], [-4.250000e+00, 2.500000e+00], [5.468750e+00, 9.570310e-01], [-1.148440e+00, -5.195310e-01]], [[-4.343750e+00, -1.250000e+00], [-2.265630e+00, 1.414060e+00], [-2.343750e+00, -7.470700e-02], [-2.375000e+00, -5.781250e-01], [-4.125000e+00, -1.468750e+00]]]> : tensor<3x5x2xbf16>
    return %0, %1 : tensor<3x5x40xbf16>, tensor<3x5x2xbf16>
  }
  func.func private @expected() -> tensor<3x5x40xbf16> {
    %0 = stablehlo.constant dense<"0x844065C0DCBF6EC021C0A63F4D40DC3FCDBE904020C0A74030BFAEBF684085C089BF9CBF41C0E83F12BF0E404840C740124094C021C0CDBF4940293F9A3F1BBF083FA640814023C01D3F60C013BEC340924095BFA8407AC0594058C0FA4061C06440C0BF54C0AC3FB9C0E53FB4C039407FC0D63E2940B1BFCCC0FDB936C05BBF1C409B4068BFEDBE63C0B94058C0D8BF7DBE8B4034BE40C02ABFA44072BE6BBED23F1EC003C05BBE62BFF6BF363F48BE023F7EC0C03FFFC0F0BF6EC0F1BFD3C016402640154070C01B408EC019C0B5BF9F3FE7BFC3BF4E3F42C0F1BF5B403C4001C0AFBF91BF4BBEB9BE434085BEADC0833F82C083BF12C0783E6A4060C0E63F69BF3740C5BF88C093BF98401EC0C1C0493FA93E1840F6BF3E40D5BFBA3F8C3F254078BF9B3E93BF593F854007C0DBBF3A3EAE3E8AC06A40AEC0F63F483F1940353E3AC0ADC0743FFABFDABF753FA03FA33F54BEC3C0ACC0734016409CC042C0F7C05DC0723F32C03DC073406D407DC06B404640DFBEDCBF5F4084C053BFB0C03F402FBEB63F9AC0903E523FB03F1EC08EBFB2BFCABF99C06E3F68C0983F524048C01D405EC059C04B400540DBC0853F054061BF8E401C3F9BBD80403CC0323E5EBF72C0743EDD3FBD400F400C404BC035C0164015BE1F3F9CBE09C00F3FB8BF70BF02C0D03FA4C0A040F94045C005C19CC0413FDEBF8E400EBF9DBC0BBFB2BF35C017BF93BEB43F30C0C5BFBB3E924055C093BF05BF75406DBF754051C09E40BCC016BF6540A6BE1140F7BF143E7C400FC088C0E63F31BF80C002C04C4076BF80C0BB405040A93F2C4098BFA63F504093BE7640B1C0A940EFBF393FB63FFE3FD4BF303E183C1C3D8A404B3FDE3FC7BF3BC0053F123F87404AC00F3F633EB8C0613F75BFAAC0E2C082BEB0BE93BF2B3FAA404F404D40AFC0B8C0443F3C408E3FEDBFEFBFACC089C0EE3E19C030BF94C0E03FD83F4FBF36C0F9BE4BC0034006409E3FBE408C40943E21BF60C00A400FBFF13D08C019C0B73FACBF433F20C04D3F5FC0003F2940AABFC7C078BF413F89BF103F05C09BC0D8BE41C079404CC0AB40CC40C1BE81C0F54063C056C02E40104088C0F0C0ABBF104060BE1040DCBF8140BE3F8BC0973F01401A40A93FD8BFC74015BF33BE25C0A340ECBFE8BF62C04AC05F40EF3F93C0A0BF47403B403F403140DA4023C0403F053F23402E3F48C01B40174195BF8C40A5402AC01240523FD13F604011C0D1C0064031C0993F2C4012C09EC0A1C02B4017BF30C0593FA33F89C0EABFC5C03E3FF6BF02C0AB3F4FC0943F18C0C7BFD2C050BF5940A4406E3E83406CC0B53FFB3F1B404540434014403BC03EBE16C0F4BFCFBFB53F3C3ED3BF30BF02C0233D274001401AC093C0A9BFD73C1240794082407D401D40D7C04FC0023E15C0C540E6BF2CC09B3FA64079BE24C097409AC0B7C08DBFE740B1BF50BF7A404CBF18C01FBF0C4078C094BF49C037C0E3BFC73E95403D3F8FC045BE533FFEC06CC01FC030C0543EB3C08A40C640CF3EB8BF13C0594045404CBEE3C0C4BF15BF2BC0DE3F36C03A3C464013C06A40CB40FB3F84C048408C404C40CABF9D3F6240BA4093BFDA3F3240723F0BC16BC082BFC6BF6540D43F8F3E28C0B73E893EF33F2FBD873F3BC03C40FA409FBF82C08CBE44BF53C0344067C0F6BF1C40BCBF133F"> : tensor<3x5x40xbf16>
    return %0 : tensor<3x5x40xbf16>
  }
}

