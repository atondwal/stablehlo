// RUN-DISABLED: stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<20x30xbf16>, tensor<20x30xbf16>)
    %1 = call @expected() : () -> tensor<20x30xbf16>
    %2 = stablehlo.power %0#0, %0#1 : tensor<20x30xbf16>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x30xbf16>, tensor<20x30xbf16>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<20x30xbf16>, tensor<20x30xbf16>) {
    %0 = stablehlo.constant dense<"0x5ABECCBFA93F57C082BEF5BFB23F2EC0C33F06C06FC0BFC0094088C0F83EBFBE70C03E3F3240C1402A402BC0D2BFA2BEB7BFAFBFFEBF21C068C04040DDBFFE3FB6408BBFD6405DC0934032C0783F05C0A1BFC13EEBC02B404E40333FCD3F4A40873EC63F02401BC0C8BEE3BF18407D3FADC0054010C079C040BF94C0763F4F408F3F74BF43C0ABBF7B3FA14081406640C6BE2C40BC3EEABFA73F90C00A4058C08EC003C01DC0A3BE0D401BC012411A40774080C005C09CC011C0ABC0B3404840433F123F064034C09FBFC4BF743F69C04340A93F28BFAD40773E11400841CDBF9F40C1BF28408A3F5140D8BF9B404C403C4061BFD03F234011C0FDBF6C3FBFBEB040794097BF46C004C048C040C07E40FABFE4BF4DC0AFBF164063BF1640273F56C00EC0653FA7BFAF3F48BF48BFD4BEDD400DC0A13E07BF253FC53FC6BFBA40B3401E3DAE40C43E2A3E74C043C08F3FECBF4DC0F2BFE13F89C035C010BFC3C075C0343D71405EC019401E3F38409B3E293F1E400DBFE4408B4021C0383FF33EE33EF33FFFBE293F3CC024BFB0BF5640D940F23F51BE86BFCC3E1CBFDE4019C0393F074090BFA24000404BBF0940B14081407ABE92C0E43F86BFC2BFBEBA4DC060BF55409C3D3CC0BCBF093F84C048C0FC3FDAC068C0433FFDBFBE3F9240C2C0B33E5DBFACBF6440FB3F44BF44C05A40E3C085406DC047BFB0C028BF00BE0E416ABF91C0123F8840AFBEF33F06C05340DC3F8C3F3E4043C040BF40C003C0E93FA13FB03F25406E3D87BFF4C0243FF73FF63F40BD8A40873FBFBFDDBFADBFFF405C401CC03FC029BF1D3FB340A9BFEC3E1B4060C0DFC004C0E33F1BC01FC05440A33F084029C0214017409A3FF53FA740953F87402AC00940CA3F9B409740543F813F483FC7BEBE400E40753FEA3FB74029C0B6C0163FBDBF04BFA6BF58400B3C694013C0AA3F673F9E4055BF4840A240A4BF84409F3F03C07640F23EE0BFEB3F514047BF9CBF313FA1C013C0F9BF6B40BB40AA3F02C0384042C01F4086C0323F2DC05EC02940A83F24BF80C0D0BFAA40CBC093BFFABF84402A409F40484017C0B53FD3BF1F3FC6BE323E9AC096BF10407C401940DE400DBFAB3F114087C051C036BE0B40B93F47C093BF233DEEC07340C3404FBE58C04040D1BF4CC017401040973FCE3FD2BF214001C0703F12C09F405940833E273F75BF1A3F174086C097406C401EC0A0C049C0C3C0A5C07EC02C403BC0E7BF3EC09640F93E193FAB3FFA3F95BE7840E83FCC3F9F409C3F2440A54012401DC00840113FD6BFC9402E40254059C0D0BF214028C040C000C016C0E5404FC024C092BF633FFBBF1E3FCA3F63C088BF17BFA6BF943F02BFBF40974047BF87BE213F483F813AEEBFC3C064401740D53FCFBF8940C13FA0BF0CC072C000BFFE4048BE3BC0EA3EFD3EA3C069C00C40DC3FADBFC93E1D40153F9FBEB140BB3F8EBFCFBFD1BE50BEDEBF01C0AF4076BF02BEA13F89C094C09440B53F6FBFA23F984009C087C035C0C03F10C049C0B1BF87C0A5C0433E0FC09CC090C0DABE334064BF1A40B24044BE6C40064040C02EC0B73F66C0573FBFBFACBE88C08F40CF3F153E773E60BE6F40BFC041C0B74040402CBE25C00D40223FE7C0F44082BF1FBD8BC0B33F8EBF584029C0DBBFD4BF20C044C010BFDD3F83400A4099C0BFC05440"> : tensor<20x30xbf16>
    %1 = stablehlo.constant dense<"0x96BF12409F40C83F0940FFBFB2BF8CC0BDC0E8BF7DC0D93FE53E2EC03AC0BAC09A3FECC089BF8BC0A5BE453F123E32BF3D403F3FF9BE7840264049C068BF0DC076C0D6BCF43F76C0914064C06E40DA3F7740A440C33F9440C43F6EBF09BF25C059C097BD033E0A40883C9340E1C0C63FDC3FB13FB53FBF3FA9C0A140C2BE853F9FBFE4BF9DC096BEFCBF1240A8C0C2BEB1C0214059BF00C0DCBF9A40923FFDBF9BBF5C3E97BF0E3F813FBA4083404E4022C089C02B3F5840333E1C3F183F20BED7BFA14081C0D33E484016BEB6C053403940DE40FBBF8CC0163FC3BC643F6F408FBFBABF2D3E71C02B40903F16BF743FCFBE9DBFDEBF21BF0D4020BFF23F8140E6BDCE4036BF523FBFBE3EBFB8BF0ABF45C00BBE0FC0A6C09AC0D5C08C3FE6BF0E400340A43F5BC00C404AC04D40943F15BE463FAF3F673FB73F37C0B0BF5A40E13F213DD5C0933EAF3F4AC001BF9E3EFCBF82BE723E1BBEB53FDF3FA74057C0A6BF093EEFBF1EC06EBC6CBFA83E7A40C93FC3BFE8BD01BF094076404EC0523D0C400C4060C024C06A3F93C0143E5FC00DC0B4BF98C081403CBF7ABF38C046C0833F54C0CF402B40294098409BBF3C4090C0A3C02DC0AD3F973FD1BE62C09D401840323F824036C03ABF2CBF5E40953EF0BDB4406CBFC13F16C061C0624082C046C0A83F58C0ADC0C53E4EC08A40BC408DC0D93F1AC1A8BE973F43C06540B140A1BF61405FC05F403240CABFCBBFE0BD43C0813EBEBF90C0CBBEC6C0F5BF1B401C3FFC3F63C083BE9EC0C83CD4402B3F0AC0783F2DC0EA3F4640EBBF7540D63F20400C40A73F5D40374034C036C04CC0373F7A3CD3BFD24003C019389E40C1C01A3FDB40AB3FF63F2B405A4018C00EC0EEC071BF23402B3FFFC0803F5A3F87C0A53E8140BC40403FD6BFD7BDB13F85C051C0DD3F47BF08C0F0BFD3C000C0BEBD89406E404840D5BF8D40E240D4C03D40B33F87BE9D3E87BEB43FD540C940E8BF9A3E9E400EC0B53F3A3F12C0BE4021C08D3F82C0E53FA6BF613F2F3D7ABF30409540F6BEB040E0BF92C0EA4063C0C5C0CCBFF9BFBC3FC2BFC840C23FB6C00F400FC097BF7CBE1C4092C0FC40D23F4EC006BF6BC044BEC4BE503E90BF9E3FC33F5BBFAE40B0BEF0BFAA3FAB402E3F504060BF79C06D3F86C0803FBE4013C0FABE82C062C0F0BEAD4070407EC04C400040243F04C005C043BEA13FC5BE9DC0E7BF1A4095BF3A405EC0AFBF9D40043F57C0943F72C03DC06F4026C027BE0F3FE13FDABF5EC052C064C07DC0F6BF4AC00340DCC03640024012BF3C4019400FC0F7BF534097C040BE9BC0553E9E3F16C0EE40284007407BBF76BFF83FC5BF1AC0963FE3BFBCBF99404AC044C06D40E340ACC0AE3FB6BE8A3E613F4C3E5F3E4C3F1840BA3FCDBD8240F9BF234076BC03C002C08CC0EFBA9DBFB5BF47BFC7BFF140AFBFECC0243F9440E9BF2BC0CFBF9A408FC02DC09EC0CCBF96BF1A3FC33F91BE9FBF0941F8BF30C0E1BEC3BED6C059409FC0203F5ABF3C401B3F1F40A83FABBF85C06A4062C0A53E9BC07F403E40494015BDB2C05EC0D1BF1F3FBC3FF33D464002401A40273F3A4090401440E63EA440CA3F2A4043409D3EF73F30406BC050C05AC0F1C019C0C2BFACBF5C3F2EC0F23E0140584014BE883F33408AC0733F803F5F4012C0573FD9BFB74020C18C40D93F98C0"> : tensor<20x30xbf16>
    return %0, %1 : tensor<20x30xbf16>, tensor<20x30xbf16>
  }
  func.func private @expected() -> tensor<20x30xbf16> {
    %0 = stablehlo.constant dense<"0xC0FFC0FF7F40C0FFC0FFC0FF223FC0FFAA3DC0FFC0FFC0FFB43FC0FF0441C0FFC0FF1041AB3ED6393B3FC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FF023DC0FF623EA43AC0FF1642C0FF7A44C0FF633FC0FFC0FFDD3BC0FFBC42C040B33F473F543DB842783F8C3FC0FFC0FFC0FF163B7B3FC0FF3040C0FFC0FFC0FFC0FF823F59405F3FC0FFC0FFC0FF853F1F422E3A1E3FC0FF40411640993E223FC0FF1A40C0FFC0FFC0FFC0FFC0FF0E40C0FF05468741063DC0FFC0FFC0FFC0FFC0FF3240563FCA3F733D503DC0FFC0FFC0FFA83FC0FFC841DC40C0FF233ADF3E7B3FD740C0FF2B3EC0FF973F413FBD41C0FFCB3E4140263FC0FFDD3E0E3FC0FFC0FF5C3FC0FF533FC445C0FFC0FFC0FFC0FFC0FFF43EC0FFC0FFC0FFC0FF883CC0FF22400A40C0FFC0FF5E3FC0FFFE3FC0FFC0FFC0FF413FC0FF533EC0FF093F953EC0FFC943A541613F5637423FB03DC0FFC0FF843FC0FFC0FFC0FF6B3FC0FFC0FFC0FFC0FFC0FF293FAC3DC0FF7D3FC83FB53F1A3C053F813EC0FFBE3EBA41C0FF3940763F2D3E8240C0FF3940C0FFC0FFC0FF743C723CD13EC0FFC0FFFC3FC0FF7A3BC0FF383FAD3DC0FF9842C840C0FFCC3E1843F73AC0FFC0FF0C40C0FFC0FFC0FFC0FFC0FF1440F037C0FFC0FFC33FC0FFC0FF6C3FC0FFC0FF2A3FC0FF7F3E5543C0FFCF41C0FFC0FF883AA63FC0FFC0FFA844C0FF3341C0FFC0FFC0FFC0FFC0FF2B48C0FFC0FFE2401B43C0FFBA3EC0FF613F453E833F4C3EC0FFC0FFC0FFC0FF8940933FF03F0E3D0540C0FFC0FF563DC73F7A3EC0FF9E3C8D3FC0FFC0FFC0FF0142AF41C0FFC0FFC0FF7D3E013CC0FF3D41F13FC0FFC0FFC0FF9E3EC0FFC0FF3F3A943F2E43C0FFBC401F41F03F5B3ED23CA53E843EC0FFD53FD83C9B4070400E40803FBD3EC0FF7340873E813F13403B3AC0FFC0FFC23FC0FFC0FFC0FFB43DC73F7D43C0FF1B40983F8E44C0FF0A3AF042C0FF303F893FC0FFD540DF3BC0FFAA3EB73FC0FFC0FF183FC0FFC0FFC0FF1B3DE040A23EC0FF823EC0FF853FC0FFBC3EC0FFC0FF51431F3FC0FFC0FFC0FF1038C0FFC0FFC0FFEF3DE0433641C93AC0FFEC3EC0FF903FC0FF3745C0FFC0FF973DFA3E273D313FC0FF883FCC3EC0FFC0FFC0FF8842623FC0FFC0FF0E33C0FF9942533EC0FFC0FF253CD1BFC0FF0F3E2C3F033F3F3EC0FF1343C0FFA53FC0FFC6410C4085411B40C0FF073F383FC0FF793DB941C0FFC0FFC0FFC0FFC0FFC0FF143DC0FFC0FFC0FFA043D0408B3F963F5040C0FF153C113E433EE83A2F3F523DE641623BC0FF9440B13FC0FFA242DB3D253EC0FFC0FF573FC0FFC0FFC0FFC0FF0B4AC0FFC0FFC0FF903FC0FF0740AB3EC0FFC0FFC0FFC0FF223FC0FF3B446B47C0FFC0FF973F703F153BC0FFC0FF3040F6400640C0FFB843E63EC0FFC0FFC0FFC0FFF338C0FFC0FF4240DD3FC0FFC0FFB03E973CC0FF593C483E8840C0FF6B453C3EC0FFC0FFC0FFC0FFC0FFC0FF1E3FC0FFC0FF243FC0FFC0FF0F3FCA3DC0FF9F3E2940C0FFC0FFC0FF2F40C0FFC0FFC0FFC0FFC0FF163FC0FFC0FFC0FFC0FF773FC0FF433D793DC0FFDA408C3FC0FFC0FF1740C0FF1A3FC0FFC0FFC0FF06450940C43B573CC0FF4B41C0FFC0FF633BC23CC0FFC0FF9B3EED3FC0FF833BC0FFC0FFC0FF743FC0FFF041C0FFC0FFD4BFC0FFC0FFC0FFCB3E4645F139C0FFC0FF5E3B"> : tensor<20x30xbf16>
    return %0 : tensor<20x30xbf16>
  }
}
