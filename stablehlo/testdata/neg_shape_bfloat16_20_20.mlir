// RUN-DISABLED(#1278): stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x20xbf16>
    %1 = call @expected() : () -> tensor<20x20xbf16>
    %2 = stablehlo.negate %0 : tensor<20x20xbf16>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xbf16>, tensor<20x20xbf16>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x20xbf16> {
    %0 = stablehlo.constant dense<"0x2040893E9D3F8E401140A83E5840B1405F409940D7BF573FF3BF27BD5F40DABEA4BF103F6140BFBE0341D83FC93E2A3FCE3F6D40823F04418FC04EC03B40DABF4B4085C0963FDD3FF43F94408F3EBDBF8D40C0BF97BFD53F0AC1EABFC5BF3EC0213F0EC05EBF674052400BBF4B408EBFCEBF33C0CD3EA7401BBE1340A23E3DC01CC0C0C086BF4CBF373F8740D7C0B8BE38BD90C0BB3F6BC03DBF7940464087BF0DC109BFA0C0E7BFD9BFB0BEC3BEA6C0874003410DC0A7BF35C08C400F3FB6BF10C0C0BE71C0863EE540DF3D4CC022BFA040ABBF9CBF913F3BC04640513F5BC02C40153EB9C03A402D40DEBF1B4018405340C43F3DC0A1BFA9C0B13F02C031C0EFC00F40CDC067C0154088408EBFA6BFF9BFDD3F1EBF79BFF1BFE13E71C0CDBFC83E3EC0C4BB09C19AC00840AE3EE5BFE03F2C40993F94C0103F6AC019C07840D1BF41C083BF70C0B740013F6640A1BF5040AABE5C3F1CC0A5BEC03F1FC02ABFD1BF7B4093C0E4BE733D3840E93DB140863F3940F7BEE3BFE83E2540BE3DCABF2ABE2E4092408EBE02400740593E823F25C0EE3EF0BFD13F88BF14C0ECBF47C0A3C07BBFED3E4240B5BFB1BE564082BCC23B64401EC0DBBBC84041C02D3FCABEB43FDABF2DC0E4BF0AC04F40883F894090BF54C05F40443E7840594035C09B3FBAC08AC0EB409B3F00408F40A840A23FFC3EE04084BFBB3E9D3F5F400740DE3F3E40484011C0243D414057C04C40AD40C140873E9F4025BFA0BFBC3DF0BD193F3440A2C0443E23C0B44070408FBFCD3C193EA8C0F73FF6BF1BC0823EDC405CC004BEE240E53FC740DDBF173EA240A1C04E4055C0B2C0B7C0ABC0483F5940D53EFEBF27BE04C096BFD6C070BF99C088BF35C12240A8C0873E10BF823F113F8D3EB8BF96BEFF3E86BF4DBF084076BFC03F823FC3BFE63F4BC0AA40E1C05AC085BFA73F9140063E5FC0BCBF42405DBE37C0B53F0BC094BFAC3F3FBF0FC03A4089BF75401FBFE0C0CC405F3FCABFA5401340EB3F184097406040D7BE5F3F8DBFA2C089C09840BABFC6BEB0C0AAC0CA3F73406FC0D0BF41C083BF51406BBFAC3FF4BE8A40643FCE3E14405A3FC440D1C03A40D0C09B3FC5BF313F24BF92C03440F4BF"> : tensor<20x20xbf16>
    return %0 : tensor<20x20xbf16>
  }
  func.func private @expected() -> tensor<20x20xbf16> {
    %0 = stablehlo.constant dense<"0x20C089BE9DBF8EC011C0A8BE58C0B1C05FC099C0D73F57BFF33F273D5FC0DA3EA43F10BF61C0BF3E03C1D8BFC9BE2ABFCEBF6DC082BF04C18F404E403BC0DA3F4BC0854096BFDDBFF4BF94C08FBEBD3F8DC0C03F973FD5BF0A41EA3FC53F3E4021BF0E405E3F67C052C00B3F4BC08E3FCE3F3340CDBEA7C01B3E13C0A2BE3D401C40C040863F4C3F37BF87C0D740B83E383D9040BBBF6B403D3F79C046C0873F0D41093FA040E73FD93FB03EC33EA64087C003C10D40A73F35408CC00FBFB63F1040C03E714086BEE5C0DFBD4C40223FA0C0AB3F9C3F91BF3B4046C051BF5B402CC015BEB9403AC02DC0DE3F1BC018C053C0C4BF3D40A13FA940B1BF02403140EF400FC0CD40674015C088C08E3FA63FF93FDDBF1E3F793FF13FE1BE7140CD3FC8BE3E40C43B09419A4008C0AEBEE53FE0BF2CC099BF944010BF6A40194078C0D13F4140833F7040B7C001BF66C0A13F50C0AA3E5CBF1C40A53EC0BF1F402A3FD13F7BC09340E43E73BD38C0E9BDB1C086BF39C0F73EE33FE8BE25C0BEBDCA3F2A3E2EC092C08E3E02C007C059BE82BF2540EEBEF03FD1BF883F1440EC3F4740A3407B3FEDBE42C0B53FB13E56C0823CC2BB64C01E40DB3BC8C041402DBFCA3EB4BFDA3F2D40E43F0A404FC088BF89C0903F54405FC044BE78C059C035409BBFBA408A40EBC09BBF00C08FC0A8C0A2BFFCBEE0C0843FBBBE9DBF5FC007C0DEBF3EC048C0114024BD41C057404CC0ADC0C1C087BE9FC0253FA03FBCBDF03D19BF34C0A24044BE2340B4C070C08F3FCDBC19BEA840F7BFF63F1B4082BEDCC05C40043EE2C0E5BFC7C0DD3F17BEA2C0A1404EC05540B240B740AB4048BF59C0D5BEFE3F273E0440963FD640703F9940883F354122C0A84087BE103F82BF11BF8DBEB83F963EFFBE863F4D3F08C0763FC0BF82BFC33FE6BF4B40AAC0E1405A40853FA7BF91C006BE5F40BC3F42C05D3E3740B5BF0B40943FACBF3F3F0F403AC0893F75C01F3FE040CCC05FBFCA3FA5C013C0EBBF18C097C060C0D73E5FBF8D3FA240894098C0BA3FC63EB040AA40CABF73C06F40D03F4140833F51C06B3FACBFF43E8AC064BFCEBE14C05ABFC4C0D1403AC0D0409BBFC53F31BF243F924034C0F43F"> : tensor<20x20xbf16>
    return %0 : tensor<20x20xbf16>
  }
}
