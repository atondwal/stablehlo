// RUN-DISABLED(#1278): stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x30xbf16>
    %1 = call @expected() : () -> tensor<20x30xbf16>
    %2 = stablehlo.custom_call @check.eq(%0, %1) : (tensor<20x30xbf16>, tensor<20x30xbf16>) -> tensor<i1>
    return %2 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x30xbf16> {
    %0 = stablehlo.constant dense<"0xEDBF1A40D4BF4940023F99BDD7403CBFF84025409F3FA13FFF3F14C09340F0BFC83FAE3E874013408A3E0A407DC0E4C01EC074C0C43F92BFFE3E993F04C0703FCB40ABC05340D9BF33C037BE973F03BF43404EBF53BF4A40244082C0C73F50C022403140AA3E103EBF4037C0514057400FC08340F33FA8C066BEA840903F43BFB93F5CC0CBBF3E3FBC3FEABECC40B73F89BF1B3E5DC07E3F2CC0D23DD1BF93BF85BE4F3FC5C0DE3F2FBF76C0E0BDA23FAD3FF83FCF3F423F27BD90407EC0203F27C08DBFA6BF8EBF94C0E43E45C02E40A83F65C08D3F13C0944038402DC0983F3EBC3FBF1F40933F2DC054C0AEC01E3FC4BE02C0684039401F40A93EC93F35C0E9C04740F7BD2FC0863FCFBFA53FE03F4440E23FA44048BEB83CCABF1DC07A401340C7BEC8BD66C07740AD3F85BE71C07AC031C015C036404C3F753F114183C003C0DEBDC84090BFA7402C4096BFEDBF22C06E40DEBF89C029BE23C06740D3BFE53EDA3F12C0C83F5040893F9F4030C0154070C0FAC066C0AEBF0D3FD9403BBE274070C0EBBFF3BF403EBAC0C3409DC05AC010BF273F11C029C0A63F75BE0BBC99BF3240A0BF59BF2BC0CE405C40A23F323F513E733F653F7140D8BFEEBE4B3E45C06BBF5840233E3A40D8C087BFE33F18409FBF24C03EBF4A40C8BF48BE32C037BFC73DBA409B40C13F054081BFF9BFBB3F9D3E73C03640283F04C0D5BEE7BD4B3F1240124017BFB63E28C09E3E3C400F40973D3040464009C018C08EBD65C0674036C039C01DC0A2BE364066C0AABEB5C047408CC00D3FBFBD38C0E03FD34043400FBF62C0ACC0D6BF9F4068C0CEC05040B23FFF3EB8BF81408EC09AC0C43E6BBFC840F43FD3BE9A408EBE4D409C3F86C022C09540E23F39C02B40D83F27C039BFC9C036C0B440A0BF77C04F40823FB73F77C078C05040CB3F1440F7BF29C02640B2C016C09EBE2B408F3F9140F73FEFC0DF3F47BF61C0DCBFA0BFF43F02400AC00C40A9C0AE3E493F04C1A0C097BF433F0F4035405B400EBF40C07B4032BE0E41AB3E5A3E96C0944049C056C0E9C08CBD40C0853F14C077C0A440293F86C0B4C0E2BE8CBF87BFA7C0B5BF2EC010BF51C0BFBF1E4090C068C0EDBF3EC0CDBFC2BF61BF2D3F37404EC0BEBD95BF94C03EC02FC00E403DC0B3BFC3BF47C0B93F54BF30BF6D402F4085C08840C83FC2BF30C05E3F35C0313E60C06CC0444051C0DFC0B3403DBF03BFF93EE13F1D3F723FCCC09CC05C3FA940064015C021BFAC4030BF7EC0B93FBABE55C0B7C023C09E3F17408BBE26C0EDBFCB3E5EC0BC3F344080C0C93F63400DBFF03E063ECB3F1EBF3C40BFBFA8BFBC4053C011C0E63FB0BE8CC01C409E4038C050C051C0FA3FD23F88403C40104094BF96C027C0BBC0033E9F3E8D3ECC3FA8BFB9BD233E9040D0BE36BF61C0064003C0CCC04CC086C0C9406940003FCD3F3340E3BC7BBF1CC0AA40D540CB3F3DC016BFA13FFB4061C06840ED3E4A409A40C240B4407B401240EB3F224029C03C4094BFFB3CA7C0ACBF2AC01340B63F34402CBF1C40BABEDFBF823F99C0B53F65408940944013C0D7BF95BFF9BFAAC0DB3F864002C0D33C414082BFE03FE0BF9340BCC009BE133F074081C0ACBFAD3FAE40003F93C0613FA4BF4AC0953F74C0883F5CC0993F3840FD3FCA4022C0CA3F6440B03FEABEAF4040404D40"> : tensor<20x30xbf16>
    return %0 : tensor<20x30xbf16>
  }
  func.func private @expected() -> tensor<20x30xbf16> {
    %0 = stablehlo.constant dense<"0xEDBF1A40D4BF4940023F99BDD7403CBFF84025409F3FA13FFF3F14C09340F0BFC83FAE3E874013408A3E0A407DC0E4C01EC074C0C43F92BFFE3E993F04C0703FCB40ABC05340D9BF33C037BE973F03BF43404EBF53BF4A40244082C0C73F50C022403140AA3E103EBF4037C0514057400FC08340F33FA8C066BEA840903F43BFB93F5CC0CBBF3E3FBC3FEABECC40B73F89BF1B3E5DC07E3F2CC0D23DD1BF93BF85BE4F3FC5C0DE3F2FBF76C0E0BDA23FAD3FF83FCF3F423F27BD90407EC0203F27C08DBFA6BF8EBF94C0E43E45C02E40A83F65C08D3F13C0944038402DC0983F3EBC3FBF1F40933F2DC054C0AEC01E3FC4BE02C0684039401F40A93EC93F35C0E9C04740F7BD2FC0863FCFBFA53FE03F4440E23FA44048BEB83CCABF1DC07A401340C7BEC8BD66C07740AD3F85BE71C07AC031C015C036404C3F753F114183C003C0DEBDC84090BFA7402C4096BFEDBF22C06E40DEBF89C029BE23C06740D3BFE53EDA3F12C0C83F5040893F9F4030C0154070C0FAC066C0AEBF0D3FD9403BBE274070C0EBBFF3BF403EBAC0C3409DC05AC010BF273F11C029C0A63F75BE0BBC99BF3240A0BF59BF2BC0CE405C40A23F323F513E733F653F7140D8BFEEBE4B3E45C06BBF5840233E3A40D8C087BFE33F18409FBF24C03EBF4A40C8BF48BE32C037BFC73DBA409B40C13F054081BFF9BFBB3F9D3E73C03640283F04C0D5BEE7BD4B3F1240124017BFB63E28C09E3E3C400F40973D3040464009C018C08EBD65C0674036C039C01DC0A2BE364066C0AABEB5C047408CC00D3FBFBD38C0E03FD34043400FBF62C0ACC0D6BF9F4068C0CEC05040B23FFF3EB8BF81408EC09AC0C43E6BBFC840F43FD3BE9A408EBE4D409C3F86C022C09540E23F39C02B40D83F27C039BFC9C036C0B440A0BF77C04F40823FB73F77C078C05040CB3F1440F7BF29C02640B2C016C09EBE2B408F3F9140F73FEFC0DF3F47BF61C0DCBFA0BFF43F02400AC00C40A9C0AE3E493F04C1A0C097BF433F0F4035405B400EBF40C07B4032BE0E41AB3E5A3E96C0944049C056C0E9C08CBD40C0853F14C077C0A440293F86C0B4C0E2BE8CBF87BFA7C0B5BF2EC010BF51C0BFBF1E4090C068C0EDBF3EC0CDBFC2BF61BF2D3F37404EC0BEBD95BF94C03EC02FC00E403DC0B3BFC3BF47C0B93F54BF30BF6D402F4085C08840C83FC2BF30C05E3F35C0313E60C06CC0444051C0DFC0B3403DBF03BFF93EE13F1D3F723FCCC09CC05C3FA940064015C021BFAC4030BF7EC0B93FBABE55C0B7C023C09E3F17408BBE26C0EDBFCB3E5EC0BC3F344080C0C93F63400DBFF03E063ECB3F1EBF3C40BFBFA8BFBC4053C011C0E63FB0BE8CC01C409E4038C050C051C0FA3FD23F88403C40104094BF96C027C0BBC0033E9F3E8D3ECC3FA8BFB9BD233E9040D0BE36BF61C0064003C0CCC04CC086C0C9406940003FCD3F3340E3BC7BBF1CC0AA40D540CB3F3DC016BFA13FFB4061C06840ED3E4A409A40C240B4407B401240EB3F224029C03C4094BFFB3CA7C0ACBF2AC01340B63F34402CBF1C40BABEDFBF823F99C0B53F65408940944013C0D7BF95BFF9BFAAC0DB3F864002C0D33C414082BFE03FE0BF9340BCC009BE133F074081C0ACBFAD3FAE40003F93C0613FA4BF4AC0953F74C0883F5CC0993F3840FD3FCA4022C0CA3F6440B03FEABEAF4040404D40"> : tensor<20x30xbf16>
    return %0 : tensor<20x30xbf16>
  }
}
