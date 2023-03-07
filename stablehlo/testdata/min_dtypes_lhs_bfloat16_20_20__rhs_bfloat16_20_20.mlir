// RUN-DISABLED(#1278): stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<20x20xbf16>, tensor<20x20xbf16>)
    %1 = call @expected() : () -> tensor<20x20xbf16>
    %2 = stablehlo.minimum %0#0, %0#1 : tensor<20x20xbf16>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xbf16>, tensor<20x20xbf16>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<20x20xbf16>, tensor<20x20xbf16>) {
    %0 = stablehlo.constant dense<"0xB6C068BF8AC0DEC0F5BE774098403F40FBBFC34022BF514009BF9F3FB8C003C08D4095BEECBE623F9E3F6840D5C03340413D304008C07DC0943EABBFDAC01BC0493FB23F984040C026403DC0DD3F17BFACC0B74003C03EBF6E4087C0933D073F5EBFE43F743FC1C0FC3DD7BF853FAFBF0F3FFCBFC8BF3EBE6D40D8BE9ABFD13E913E8CC0A53F1340EFC0BEBFEFBF9E3DB1C09A3F0440563D883FA540663F824024C09A4083401F40634076BF7540FCBF57BF57BEED40334001C000408CBD3EBFF2BD763D30402DC0A9BFAABBEDBF903F7A402CC0D43F54BF853E9140A53F3BBE3940A23EB9BF1A40FEBF17BFB53F37C096C0943F75BE00C0AD3F17C0C4C098C0FD3F04406740E83F4EC01CBF52C068C08340663F39C008BF8A403B40AFBF2EC0213F894046BFBE3F5B4082C0CC3F663F12C023C0353EC0C0AE40D5BF473F6D3C6E3F46C0E83FCAC0FCBF473FCCC077BFBB3F9540C83F36BF3C400C40ED3F573D3340EFBFF6BD6DBF94BECB4075BF11C088408BC02FC06940FD3FF14026C00C4088BF27C026C01C40E1BF924009BF18C083BECC3F14C010BF3D408BC018C0F03F8F4025C0CBC09DC003407C3F173F31BF4DBF2A40A5BFA33FF7BF3B3FFE3F9FC0E13F8F40E3BF3AC0043F753E0EC0883D3BC0834015C018BFCE3E86C031BFBA3E0FC05C3E9340ABC013C0B73F1C40DA3F0D3E8CC0EABD334022C0EABC023FDF3F1EBFC2C07C3EDFBF5DC0483F8F3F7B3F2D3FD23FF8BE21BFB1BF76C089C088C004C0EE3F6CC0FA4005410240D0C0DCBE61C0434048BE913FDDBF29C0834098BE4CBF1B3E334047C0C5BE99BE2BC02140A8BFF5BF5A40EC3F263FA1BF96C002C056BFBF3FA0BF0C40224020404D4098400D40A640083F24409240ECBF55C098C0A140344028BF2040EABF33BE03C0243EC54080C0903F334064BF123F0AC01F405740EEBF43C0A74084C0EE3FE3BF5FC05DC03D4093C0F43FC3BFC1BD6F4017C0CE3FB6BE373F0A4005BFCC3F39C0123F943F0BBF4B3E43C09C3F6F4096C0A040BA3E3840C2BF3BC03040ABC0A6C0C1BE59408FC0C13E5840204033BF4F4018C03BC02340A2C04F401D4095403F4012C0A9BF4D405F40EABE24C0CA3D8FBFAAC0"> : tensor<20x20xbf16>
    %1 = stablehlo.constant dense<"0xB6BF0E3F9A3E15400FC0B43F3E40DE3FA8400740973F93BF5FC04A40AA40723FB13F23C1BA40B6C02F3FAD409BBF4EC0104092C06B40DBBF03C0B8BF97C073C024C003C1C7BF5EC0F13D2040A53F3EBF6BC00FC01641E93F9F3F89409B3F8240B0BFA83F19400BBDC5408ABA8EBE583FD7BFD6C08ABF75C03D4093BFA24006BF8BBFAD3EB340EE3FBF3F9E4085BFC7401D3FB9C09E408A3FC7BE5ABE9DC0384043BF9DC052BFDD3F83C0AE4032BE33C0833EE6C08CC02ABF1AC0223F2F3E9B4096BF8EBF40C04B3FC5BF8E409E3E454016C020C090BD243F31C086407FBF4BC020406EBF00406740E2BE173FEC3FE340013FA53F023F39C0D8BF0141443EB6C0D440B2BF6ABE46C0A9BF2F40B4BF18BF7F4009C08D3FCCBF1FC05F3FF63D9440D1BFA73F65BFBC400CBF0F402140E2BF5D403AC0143D9F3EAFC0354073400440033EF03E3EC015BFF03FAF3F3D3F93BE25C0D640B03E4EC0A73FA8BF533F1DC028C05CBF86BFC2BE404066BE2AC012BEC53F8FBE5AC0983FD0BE83BE6B402FC0EA3F80C0F33ECB3F614093BF95BF21BF77C0E03E553EF33DAB40E8C049C0D43F9ABF10C0F0BFCF3FE3BF92BF8440CF3F0A40CD3F0FC072BF33C051C029C00EC0B3BE2BC02CC0B23F0640C73FAABE403FA040D23E324040BFF83E3C3F274072C0AEBFAD3DFE3F08C031C016C082C0DDBEEEBF99402F408A3F12BF88BFB53EE8C0414041C010C06EBFC8C0144090C01140AC40D83F344093BF203F97C0A8BE98C0D5BFA33F9F3F713FE840324098C0F2BF8BBFD43F3840D3BE0DC046401240F5BF82C006C066BF00C06E4085C09A3DC5BF2C3FB4BF9E3F683E32C0E63F864094406B3F9840E940B83C7A407B3FCBC014C08C3F3940B2C0DF3E39BF15BF94BF55BF18C154BEF4BF24C052C041C019C01C4019C0AA4067C03ABF86BFFEBF933F9C3F48406FC00C4060403D405E40CF3FC8402240ACC03140EEBF9340C0BFA4C06D40B940C1BE0CC1FA3F633F253F51403BC03EC01040A3408EC066408140AC3D84BFD43B423FD63F053E344072400D3F3A3F9040413F6DC06440574085C09E401DC0CB3FFE3F9F3FAA407340FF3FC83F21C0D6C05D3F96C0C93F99BF674057407C40"> : tensor<20x20xbf16>
    return %0, %1 : tensor<20x20xbf16>, tensor<20x20xbf16>
  }
  func.func private @expected() -> tensor<20x20xbf16> {
    %0 = stablehlo.constant dense<"0xB6C068BF8AC0DEC00FC0B43F3E40DE3FFBBF074022BF93BF5FC09F3FB8C003C0B13F23C1ECBEB6C02F3F6840D5C04EC0413D92C008C07DC003C0B8BFDAC073C024C003C1C7BF5EC0F13D3DC0A53F3EBFACC00FC003C03EBF9F3F87C0933D073FB0BFA83F743FC1C0FC3DD7BF8EBEAFBFD7BFD6C0C8BF75C03D4093BF9ABF06BF8BBF8CC0A53FEE3FEFC0BEBFEFBF9E3DB1C0B9C00440563DC7BE5ABE9DC0384024C09DC052BFDD3F83C076BF32BE33C057BFE6C08CC02ABF1AC0223F8CBD3EBF96BF8EBF40C02DC0C5BFAABBEDBF903F16C02CC090BD54BF31C086407FBF4BC020406EBFB9BF1A40FEBF17BFB53F37C096C0943F75BE39C0D8BF17C0C4C0B6C0FD3FB2BF6ABE46C04EC01CBF52C068C07F4009C039C0CCBF1FC05F3FAFBF2EC0D1BFA73F65BFBE3F0CBF82C0CC3FE2BF12C03AC0143DC0C0AFC0D5BF473F6D3C033E46C03EC0CAC0FCBF473FCCC077BF25C09540B03E4EC0A73FA8BF533F1DC028C0EFBF86BF6DBF94BE66BE2AC011C0C53F8BC05AC0983FD0BE83BE26C02FC088BF80C026C0CB3FE1BF93BF95BF18C077C0E03E14C010BF3D40E8C049C0D43F9ABF25C0CBC09DC0E3BF92BF173F31BF4DBFCD3F0FC072BF33C051C029C09FC0B3BE2BC02CC03AC0043F753E0EC0883D3BC0D23E15C040BFCE3E86C031BF72C00FC0AD3DFE3FABC031C016C082C0DDBEEEBF8CC0EABD8A3F22C088BFB53EE8C01EBFC2C010C0DFBFC8C0483F90C07B3F2D3FD23FF8BE93BFB1BF97C089C098C004C0A33F6CC0713FE8400240D0C0F2BF61C0D43F48BED3BE0DC029C01240F5BF82C006C066BF47C0C5BE85C02BC0C5BFA8BFF5BF9E3F683E32C0A1BF96C002C056BFBF3FA0BFB83C22407B3FCBC014C08C3F3940B2C0DF3E39BFECBF55C098C018C154BEF4BF24C052C041C019C0243E19C080C067C03ABF86BFFEBF0AC09C3F48406FC043C0604084C0EE3FE3BF5FC05DC0ACC093C0EEBFC3BFC0BFA4C017C0CE3FC1BE0CC1FA3F05BF253F39C03BC03EC00BBF4B3E8EC09C3F6F4096C084BFD43B423FC2BF3BC03040ABC0A6C0C1BE59408FC06DC05840204085C04F401DC03BC0FE3FA2C04F401D40FF3FC83F21C0D6C05D3F96C0EABE24C0CA3D8FBFAAC0"> : tensor<20x20xbf16>
    return %0 : tensor<20x20xbf16>
  }
}
