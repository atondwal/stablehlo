// RUN-DISABLED(#1278): stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x30xf16>
    %1 = call @expected() : () -> tensor<20x30xf16>
    %2 = stablehlo.multiply %0, %0 : tensor<20x30xf16>
    %3 = stablehlo.constant dense<1.000000e+00> : tensor<f16>
    %4 = stablehlo.broadcast_in_dim %3, dims = [] : (tensor<f16>) -> tensor<20x30xf16>
    %5 = stablehlo.divide %4, %2 : tensor<20x30xf16>
    %6 = stablehlo.custom_call @check.eq(%5, %1) : (tensor<20x30xf16>, tensor<20x30xf16>) -> tensor<i1>
    return %6 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x30xf16> {
    %0 = stablehlo.constant dense<"0x04464D41CA3551461F413CC24345783E1C4093B9E7BDCDC6D8BD784136C6D6BB7847EB413544C4BD8F3448C04F37EC3A3A3DF9B3D2382BC03F415040AAC034C236452F45163D4A459FC5A241724161C674C4884144BC13B338C498B406B9A93C79C477BA013CE9C25440ABC098C252C759B9173EDBC2F333CAC2DF4411461CACE5C134C1A24095C0FE3C1CC5133E1BB8B345D433B9C0B6C19BBE073A034497448744CD3FAF4424402EB26840F34292335039EC40B8C0FF403CC1CDBF9F388E43A1C19FC642430131204888C53044C644A5C164427D405C385D414D45C7B887B5C4A1BCC12ABB1DC57BB80A4468463742E74485C455B45E3AC7BC0EC1B3B8DA309240A13C0C45C2BF50C0D73A78BCF73A1FC4BFC093426645094199BD5241B6425BC52DC42EC44C3C63BB53B300C2F1424BBDBDBEA0375231A24138BC0ABB57C17EBED321F8BD9A3C513DD64083C0A2C221BAA931823C91C235C1FEC158C4243F90C01E45ED32ACBC70C2BF3EA439ACBC4242EA405DC03435BCC057BF23BCF3B43E44873A77429DBD1444DBB6123D173CD9C129C60046D1BEA139F1BB61C22A44AF4119A91F48C4BDDC45093C2AC3D0BCF4C5C9BB19C2403DC1B861B9CF3F06B873454ABD7140BB3BEC371D40CEBDF3471E4192436E401742583F6DBF0DBB35C2E438E8BF49B47244293864C24544EBABE141D83DA43EC837693D8542B73EC4C19E45FB46903AB3BE77C4F13731BB00C1583E6A36F42E72369635A43DD143F23A1240583D5CC4FD3E21C44A38A3B953C750BD3E42353F2C3CF4B7D4406EBC7B3732457036DA3C00403B41C431C6C31F397E429B3C6DBAF6412C4275426036FA3B6F4022C084C0CD3DE5BE5940A8BCBFC39DBCBC4499BA032D29BD1E3C4C4378C0B0396BBA3435DCC3B3B9923C36C2F2BC32C25E3F31C368BBAB40BF42B7C0DD415BC247BC96425DC569398BB8DA41D140C83C61432836AE477D4056C492C30C3D87BD1241AB43CE3EC8BEDAC039BF5A455838E03F473DDDC205B542C321C27CC5CC434BBFB6C49CBF203B4EBFAA3F59BD5F40C63BC9C2C6BCB5B77F43B4BF11BFF240D0B9D83D6EC4B6386BBF64BF61BC68BFC0BC43B3F8C5CC439E32E741A8BEC5C344BC514418C14046733067400EBA20B5AAB87C40493989BC3BB43E41533653BC58C6FBC51331C13F94443C3C47C03F40183B694026C0043ECF38B0BD44C0A93EFBBFF03CB9C4E0BCA33CC23E9ABD34C032316CBFA8C03EC34EC106BF50448A3DCF37BEC6E3C207BF80BF6FC08A43DFC667B9E9C3893F81C3593E66C369C2863EE12E533C46BF333535B993C33DBAE8BD7AC12842A03929452DBF7FC461425AC2FC44502593C34FC27AB8B747B1BBB03C783CF43C37C69A3C5F3F6448CCC62DB06CC3C4B169BBFAC229B9DA34FAC55FC2E8B890BA06C4523F26B524300AC113402A42AB419C47D74147C40AB5FDA56C43BDC502B724BC9540FFB91BC57BC7D940AE450045093A5245A6C16A3EEABD373F51BC1C433F455EC218B31DB2632605C19440414400B165C497BE3BB29A32C9438544F032A1C43144FF3F583E56C1D240613B423A1544963EAB4297C048BBB540D23B09448EBF323CA642AFC24043444076C6B73F27B6A7C471C3FA39B94165C392BCAD41BEBD053F72C1DB307E3670439D3D48B973AEF1BDCDB8164419BE"> : tensor<20x30xf16>
    return %0 : tensor<20x30xf16>
  }
  func.func private @expected() -> tensor<20x30xf16> {
    %0 = stablehlo.constant dense<"0x13278E30A4476A26E230962E9F281E3694331E40593789257F374830A3262B3C97244F2F3B2BB337294AFC32CB44583DB038074C82415E33A730E232E331A82EB728C328F33894280D28093051304B26752A2F30083B1E4D312B104A1341E539662A213EFC3B5C2DD532DF31E42DC7247A40E736722D0D4C8E2D6529F426945B5E2FBA30F63118322339E728F0369843E2272D4CBE31D92FDE350B3FF42B142A3E2A3534D6297833B44E97324D2D774C89404931C0312031AC303534FE417C2C0A30D725DC2C1C5186232F284D2B9E290530452E5B32BD4273308E289B413148B36FC92FFD3CE6286042D92B3D26A12E5429452AD24A513E9B390331CC4171512132FA3907294134E232793D693A473D892BAE31EC2D64280C3116388530AF2D7628572B542BEE3AB13CC54C1C2F502D9238A335684485500930313B2A3D7D3013368D6F30370C3A873879314932D12DD13EFE4F4C3AF02DB930212FC82A05352632E328564DDD392E2EA0350640DD398A2E4D31BA32BA48B531C0347B3B39491C2B033E212E1038B32B7245FB38A63B7D2FBF261C2782350A400F3C4B2E612BEC2FED608923B3377427DD3BFD2C873939273A3CE22EA538AA416C403334E843502894387E32493C1444903399370D24E330772C8632E72EBF34A434263DA52E5A411934F94A7A2A6543452E052B155C682F7F37CE353A446038062EAD35B32F0F284125F23DB4356C2A0F44F33C1F315C363A464C552A461A480638312C4E3DBA337B38BD2A3E35822BF6420840C5248938922EEE345B3B0C447E31863A9344BE282E4671390034AE30B34F3C2CE240132E093A343E342FB82E242E4D46063C83327F3347329B376335C532E739442C043AB529E13D1859CF388D3BCF2C6932EA3F373EBA48252CE23F213AA32E3C39AC2EB734F32CAB3CDF31A02DC231732F562EFF3AE72D732860403442792F84319939B42CC14657245B32CF2A772C07393138FB305A2C873591357131E9347828C84221349938702D1449DC2CD12E4128362CD034C5296C340B3DCD345C347A38B3323C3C902D9E394F448E2C503420353C31943F7F37862AC541A734B034AD3AAB34AC39DB4C3027362CD94D592FC7353D2C083BDF2AEF308E2677529B32FC3EE048E3415D3295403A3A284BA8306646D83A5C262827F95042341C2A233BFF321933173D9432713313378941EA370833C63505344039BE296339F4399B3514383E33BE50A634E731E22C8C303035E22A2C383344A125662D2F358D348332812C6C256340182C82348C2C5B36AD2C3B2E04366955D83AD734BC48B940762C943E57374430C12E0C40CF28F934552A4B2E582E27298968762C6E2E63424D24543CD439693A3839A1260C3AB634A3228B255753A62CB34FAA3C422DCF4071492B274E2E5141F23DE82BC734D54878530B31B733BD2EF82F6C24822FFF2A0B492367A62CC6273645783B18321E3FE92893247231F0271F29073F852803303A365237EB34DF3A112DA728512E174DD94E476614311C32132B1F51A12AE535994EDF4D3A2C452A524DFA294A2B01345C367F308231B43C8A3EAF2BE735C22D1432D43CC731303CDD2B7C34463BCB2DBC2DDF2C083322264D34C446EA299F2C2B3FD12FAE2C213AF22FC437323551306E511346A12C10389740285640378E41AC2BE236"> : tensor<20x30xf16>
    return %0 : tensor<20x30xf16>
  }
}
