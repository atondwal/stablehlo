// RUN-DISABLED(#1278): stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x20xbf16>
    %1 = call @expected() : () -> tensor<20x20xbf16>
    %2 = stablehlo.custom_call @check.eq(%0, %1) : (tensor<20x20xbf16>, tensor<20x20xbf16>) -> tensor<i1>
    return %2 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x20xbf16> {
    %0 = stablehlo.constant dense<"0x833F5CC01FC0FA3F99C0983FC8BDD1BFFFBB9A3E5640AF3FE03E93BEA7BF10BF97BE5DC0AD40C23F2DC0983C8D4092C0B23F94402BC009BE53C0AE4041C08340E03F21C0B0C0EBBF06409DBF61C00CBF40BFA5C0093FBE40AF4072403F40EAC0DD3FAF401F4091402EC03E404A3E1E40D83F24C0723F7740C73F03C0B5BFAFBFF4BFD1BE053FFFBF33BE82BF0A40953E3540D2BF72BE523F0BC0B1C01240813EA2BF92C0474096BF9EC0B6BF78C0B0C021C00440FD3E98C046401F3F69BEC9BDDEBF08405DBF883F05C02FC00540ABC0BF3F6FBFC1C05840F93FE53F073F93BEE83FC8C08EC07ABF0D4091BF6540CE3F3BC07D408AC0B5BF0BC083C09DBFBCC0C4BE8CBFAEBE6C401E409C3F7A40E4BFAA3DF03F91BFE93F8C40AB40194022C08BBF8A3F74C0BAC06E403ABFF7BF833FFBBF493E7FBEF0BE794057C061BF0A409B40CB3F123DB440DBBF0A40C0BFB6C022BFEFBE6EC00C3ED2BD90C0043F2F40213D73BF63C06CBF9FC06FC0E1BE3AC042C0F73C323FAD40C5C0A5BEA7C074BF2C3E7EBF4FC01ABEBB3F48C029403C3F96BD2BBFB540723F1FBF343FD040ADBFCC3FE3BF5CC093BE75BF47C09BC0883EFF4053C08940054002BEAAC0D940D6BF05C0CE3EE5BDBABE45402E4081BF04400B3E53C05A40B8BFD0C0CBC0393FFEBF0E4062BF3D3F05C0AE4061C0D0C01E3F01C00B40164014BF113F3DBF6FC014BE194097401041323FA5BFA2BFC340B23D3640453E19C06A409A3E62BF66C0CB3E923E90BF51BF37C090C06E407EC0B9BECB40F4BEFCBF924087C044405E3E4BBE94405640FC3FA23FA73F65BFE23F3840864003403AC096BE63C07DBF0A403440853F10C067C006C03140D04084408A40AD3F8D3F42C02A403AC0F73F3C403CBFBA3F2D40D6C061402BC04ABFDC40DEC063C00E408740883F08C18AC00C400B408AC0BC3FB840A23F8A40883F22405B3F9FBF1440D13F2240C13F9FBF823FFCBF93BF99BF99C0BEBF3D40E5BFEF3FD7407ABF5FC0DEBF95BF8DC018BF15C041C0A93F66C0DE40DBBE534017C00B3EA73FCDBE32C09AC078BFB7BFCFBFEABFCA3EA0BEA13FFBBF4B40BFC037C0143F80C077C006C0824091C02AC039C0ACBF96BE"> : tensor<20x20xbf16>
    return %0 : tensor<20x20xbf16>
  }
  func.func private @expected() -> tensor<20x20xbf16> {
    %0 = stablehlo.constant dense<"0x833F5CC01FC0FA3F99C0983FC8BDD1BFFFBB9A3E5640AF3FE03E93BEA7BF10BF97BE5DC0AD40C23F2DC0983C8D4092C0B23F94402BC009BE53C0AE4041C08340E03F21C0B0C0EBBF06409DBF61C00CBF40BFA5C0093FBE40AF4072403F40EAC0DD3FAF401F4091402EC03E404A3E1E40D83F24C0723F7740C73F03C0B5BFAFBFF4BFD1BE053FFFBF33BE82BF0A40953E3540D2BF72BE523F0BC0B1C01240813EA2BF92C0474096BF9EC0B6BF78C0B0C021C00440FD3E98C046401F3F69BEC9BDDEBF08405DBF883F05C02FC00540ABC0BF3F6FBFC1C05840F93FE53F073F93BEE83FC8C08EC07ABF0D4091BF6540CE3F3BC07D408AC0B5BF0BC083C09DBFBCC0C4BE8CBFAEBE6C401E409C3F7A40E4BFAA3DF03F91BFE93F8C40AB40194022C08BBF8A3F74C0BAC06E403ABFF7BF833FFBBF493E7FBEF0BE794057C061BF0A409B40CB3F123DB440DBBF0A40C0BFB6C022BFEFBE6EC00C3ED2BD90C0043F2F40213D73BF63C06CBF9FC06FC0E1BE3AC042C0F73C323FAD40C5C0A5BEA7C074BF2C3E7EBF4FC01ABEBB3F48C029403C3F96BD2BBFB540723F1FBF343FD040ADBFCC3FE3BF5CC093BE75BF47C09BC0883EFF4053C08940054002BEAAC0D940D6BF05C0CE3EE5BDBABE45402E4081BF04400B3E53C05A40B8BFD0C0CBC0393FFEBF0E4062BF3D3F05C0AE4061C0D0C01E3F01C00B40164014BF113F3DBF6FC014BE194097401041323FA5BFA2BFC340B23D3640453E19C06A409A3E62BF66C0CB3E923E90BF51BF37C090C06E407EC0B9BECB40F4BEFCBF924087C044405E3E4BBE94405640FC3FA23FA73F65BFE23F3840864003403AC096BE63C07DBF0A403440853F10C067C006C03140D04084408A40AD3F8D3F42C02A403AC0F73F3C403CBFBA3F2D40D6C061402BC04ABFDC40DEC063C00E408740883F08C18AC00C400B408AC0BC3FB840A23F8A40883F22405B3F9FBF1440D13F2240C13F9FBF823FFCBF93BF99BF99C0BEBF3D40E5BFEF3FD7407ABF5FC0DEBF95BF8DC018BF15C041C0A93F66C0DE40DBBE534017C00B3EA73FCDBE32C09AC078BFB7BFCFBFEABFCA3EA0BEA13FFBBF4B40BFC037C0143F80C077C006C0824091C02AC039C0ACBF96BE"> : tensor<20x20xbf16>
    return %0 : tensor<20x20xbf16>
  }
}
