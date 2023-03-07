// RUN-DISABLED(#1278): stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<20x20xf32>, tensor<1x20xf32>)
    %1 = call @expected() : () -> tensor<20x20xf32>
    %2 = stablehlo.broadcast_in_dim %0#1, dims = [0, 1] : (tensor<1x20xf32>) -> tensor<20x20xf32>
    %3 = stablehlo.minimum %0#0, %2 : tensor<20x20xf32>
    %4 = stablehlo.custom_call @check.eq(%3, %1) : (tensor<20x20xf32>, tensor<20x20xf32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<20x20xf32>, tensor<1x20xf32>) {
    %0 = stablehlo.constant dense<"0x4B15F4BF204DFFBF698A0A401609F43F0E0E1BBD46579C40B11F554085CD5940A0C6A73FD9B101C06CBE49BF1E6D8E40C3E41B402059073FBCEE94BFC513AB3FF1990540A5600DBF8384603F6177D43FC51182C0C62593C08DAB2EBF34741F3F9718FA3FFB8B87403AF39D40F9A59540182FD8BFEBE0833DDF700740EF948D3EAE4736BF87D2D33FC32313C0A9DEA3C0C2409A3F40878FC0922E4FC002F6C4BFE7C62FC0C82A52C0340644C0C36964408096353F89A15D40875781BEEBB76D4063CB97C0E5B84EC0DD94A0BFD9C0C1BF4933113FCC07C7BFA4AABC4049F27CBECA1EF1BC5207E440A3C787C0B70028BEA31AE13EECF5D53FF1F082BF876E26C0C02F82C08E712ABF7C4C9FC00C717440CE057CBF7C1F583FE4288740B264184010089E3F2BCA91BF75E7473E61FD8240828C6DBFFB38DDBE1BDDBB3E0F40A4404B5D4B40466DEC3E9F3E183F1220AF403DD83EC036CC45400F5B23BE450ABE3F2382E9BEEF8349C0DFF02E401EE7FCBF0FE985BFA5C154BF383ED2BFE37CA2C0486FC23FFF69E440D92FEBC0F07D89400A76F8BF52E7203FC44E06C074C87DBD5DA4A4BFD9C15DBF184647C0F5DF52BF1A49753FF3D3763F82C8DBBD623C6540230CB84013B9D4406DA08940A77351C0FF264A3FD1DF40BE386D97BF73DA003F3BD9E7BF406672409F06E9BFF172B33FA069E4C0FDA92CC0B7D74FC0ADE157408A73DD3EE1F1AA40E85F5540DDBC8A3FD4346E40422847C05CE69F40DAA5C23F36C683400310E0BF0D5FFA3FD23A8740C24C0040187F43408ECEEFBF8BF120C0287DB43E7188D6BFDED16A402013A7BF496A05BFEA2C36BF90752B406D264C4081D384C073E0BAC07186EA3E99A31AC003283CC0B98B22C0B5191E404C265EBF7349AEBD4051A340425AB4BFC406853FC17419C06E4891C0E4EFA9C046EE05C012B30540FDEC4DBF8120883FACB93EC0089001C01BE035C02AD18640453D1840B568C3C0223631405AF4B8BFCAD441C0609C783FEE798F3F0CC51DC045C0983F719064401F047240319946C010A4454027D69040C4AF5ABFEE82DF402B197FC06DEDB33F2BF9DE3F8C93BA40C0FB454009B0BAC010EE81408E9D0C402EEC4C40CD9D64BFC5047E3FF12F623FC10945C049F2993EB55D0EC0E27228C0F41B6740ADAC84C0FE266E40B460053F69BFE140F6F08ABF2FAE85BF21C8C93E4FF6074046A9644020B8A2BFF0623FC00DFF3EBFBD7B813EFFB64C40196EB1C03340863EAF669C3F0594F93D2AA4C63FE2216A3F8315A03FF72D4A40A476493F223C9D3F55295140C327A03F927E4F4043EED3BF8B1D8B40C6A4873F633758BFBD9A8BC0399E8440AF40F53F4E6B59BEAD7A3940705860BEE0F8173F98D1AFC08BDA7740BCE8873F8C6FBF401D7F09C0C7F679C0E324FB3F5D8BB73F03142E400021093FAFBCAB3F6A85E1C022948540020F28C088114FC06DC008C073EA3C40E6CCF7BFEF11FA3FED9686C0C230ABC0E35AC03E206D3D4021C790C074712AC0367570BF70EC7640A2D99040C12C8340576193C0DE3C9DBB1E32153FFBF66440637637BFC6DFD1C0DE36CF3E382A85403B8721C05DEC2EC0725FAAC0C2C830BF10A51C40724B2CBC85F218BF0E3933BD7B71FA3F0B335CC05BDEB1BF2BCCBBC0C6C22A3F263768BF32B940BDC64762C0DC0F3940BCC9BD3FBA6D17402AEC3A402D0CC23F61C00640E6BF73BF0C34C33E4EFAE63F811503C09FD7933E605FCA400A3FF43E91CC11C036DF3D40C8A42140D2B497BDEAE8FD3FB78FC5C0153D9D3EEFE10CC021F5884070CD6B400658DA3EE9CB18C081E5433F38848B3FBCB1CA4071EBA1C097CE93C0F6FAF5BF8F41ACBFCC1A6B40013523C0C70A1CBF11DD0C4067C9A9C0779D014180E0E7BDC127AE3F7BA460BF47B7813F83AADDBFCB2900C0A7DF86C0FA1277404A4F90401D67B33F81F886400EC33D408F95513F5653703FB01F88BF6AC6A6405FC80CC0BC4AC8BF7BE93EC0E7368DC0F421CCBE626359BF7F21064036E73340DC7FA040246EA23F6CF52F3EF02041BDD05086BF21ACF7BE7CE158C02939A2BFEEEF8BC0F8568940B13CBA40361615BF6534D7401A8882408F96363FE1510740879958C027810E409154AFBE5AF1A24032AD0B3FB4F6A43F69DB8F3E3DF802BFFF95A03E8E7F63C02257E0C04F490D40AB5296C0B7FA333F7A03D0BFD70F59C0B417F43E3B93A6C06EEFE7407E4873401AB92CBF8815C53DF20C84C0"> : tensor<20x20xf32>
    %1 = stablehlo.constant dense<[[-0.198643804, 2.0680716, -3.6039443, 4.23760176, -4.85730648, 1.88867819, -1.2768209, 2.92531276, 1.46337175, -4.20012569, -1.49525714, -1.09894812, 2.81529498, -0.271151662, 0.81087476, -6.68338871, -3.44050097, 3.99835587, 0.154152885, 0.215952128]]> : tensor<1x20xf32>
    return %0, %1 : tensor<20x20xf32>, tensor<1x20xf32>
  }
  func.func private @expected() -> tensor<20x20xf32> {
    %0 = stablehlo.constant dense<"0x4B15F4BF204DFFBF06A766C01609F43F0E6F9BC035C0F13FDE6EA3BF53383B40A0C6A73F6E6786C09664BFBF55AA8CBFC3E41B4064D48ABEBCEE94BF52DED5C02B315CC0A5600DBF41DA1D3E8E225D3EC51182C0C62593C006A766C034741F3F0E6F9BC035C0F13FDE6EA3BF53383B40182FD8BF6E6786C09664BFBF55AA8CBFAE4736BF64D48ABEC32313C052DED5C02B315CC040878FC0922E4FC002F6C4BFE7C62FC0C82A52C006A766C0C36964400E6F9BC035C0F13FDE6EA3BF53383B4063CB97C06E6786C09664BFBFD9C0C1BF4933113FCC07C7BF7D954F3F52DED5C02B315CC010E57F40A3C787C0B70028BE48694BBEECF5D53F06A766C0876E26C00E6F9BC08E712ABF7C4C9FC053383B40CE057CBF6E6786C09664BFBF55AA8CBF10089E3F2BCA91BF75E7473E52DED5C02B315CC0FB38DDBE41DA1D3E8E225D3E48694BBE466DEC3E06A766C06F9A87400E6F9BC035C0F13FDE6EA3BF450ABE3F2382E9BE6E6786C09664BFBF1EE7FCBF0FE985BFA5C154BF383ED2BF52DED5C02B315CC010E57F40D92FEBC08E225D3E0A76F8BF52E7203F06A766C074C87DBD0E6F9BC0D9C15DBF184647C0F5DF52BF1A49753F6E6786C09664BFBF55AA8CBFCB2D344064D48ABE7D954F3F52DED5C02B315CC0D1DF40BE386D97BF8E225D3E3BD9E7BF495B044006A766C0F172B33FA069E4C0FDA92CC0B7D74FC053383B408A73DD3E6E6786C09664BFBF55AA8CBFCB2D3440422847C07D954F3F52DED5C02B315CC00310E0BF41DA1D3E8E225D3E48694BBE495B044006A766C08BF120C00E6F9BC07188D6BFDE6EA3BF2013A7BF496A05BF6E6786C09664BFBF55AA8CBF81D384C073E0BAC07186EA3E52DED5C02B315CC0B98B22C041DA1D3E4C265EBF48694BBE495B044006A766C0C406853F0E6F9BC06E4891C0E4EFA9C046EE05C0C44FBB3F6E6786C09664BFBFACB93EC0089001C01BE035C07D954F3F52DED5C0B568C3C0223631405AF4B8BFCAD441C048694BBEEE798F3F06A766C045C0983F0E6F9BC035C0F13F319946C053383B40C44FBB3F6E6786C09664BFBF2B197FC06DEDB33F64D48ABE7D954F3F52DED5C009B0BAC010E57F4041DA1D3E8E225D3ECD9D64BFC5047E3F06A766C0C10945C00E6F9BC0B55D0EC0E27228C053383B40ADAC84C06E6786C09664BFBF55AA8CBFF6F08ABF2FAE85BF21C8C93E52DED5C02B315CC020B8A2BFF0623FC00DFF3EBF48694BBE495B0440196EB1C03340863E0E6F9BC00594F93DDE6EA3BFE2216A3F8315A03F6E6786C09664BFBF55AA8CBFCB2D344064D48ABE7D954F3F52DED5C02B315CC0C6A4873F633758BFBD9A8BC048694BBEAF40F53F06A766C0AD7A39400E6F9BC0E0F8173F98D1AFC053383B40BCE8873F6E6786C01D7F09C0C7F679C0E324FB3F64D48ABE7D954F3F52DED5C02B315CC06A85E1C041DA1D3E020F28C088114FC06DC008C006A766C0E6CCF7BF0E6F9BC0ED9686C0C230ABC0E35AC03EC44FBB3F21C790C074712AC055AA8CBFCB2D344064D48ABE7D954F3F52DED5C02B315CC01E32153F41DA1D3E637637BFC6DFD1C0DE36CF3E06A766C03B8721C00E6F9BC0725FAAC0DE6EA3BF10A51C40724B2CBC6E6786C09664BFBF55AA8CBF0B335CC05BDEB1BF2BCCBBC052DED5C02B315CC032B940BDC64762C08E225D3E48694BBE495B044006A766C02D0CC23F0E6F9BC0E6BF73BFDE6EA3BF4EFAE63F811503C06E6786C09664BFBF55AA8CBF91CC11C064D48ABE7D954F3F52DED5C02B315CC0B78FC5C041DA1D3EEFE10CC048694BBE495B044006A766C0E9CB18C00E6F9BC038848B3FDE6EA3BF71EBA1C097CE93C06E6786C09664BFBF55AA8CBF013523C0C70A1CBF7D954F3F52DED5C02B315CC080E0E7BD41DA1D3E7BA460BF48694BBE83AADDBF06A766C0A7DF86C00E6F9BC035C0F13FDE6EA3BF53383B40C44FBB3F6E6786C09664BFBF55AA8CBFCB2D34405FC80CC0BC4AC8BF52DED5C0E7368DC0F421CCBE626359BF8E225D3E48694BBE495B044006A766C06CF52F3E0E6F9BC0D05086BFDE6EA3BF7CE158C02939A2BFEEEF8BC09664BFBF55AA8CBF361615BF64D48ABE7D954F3F52DED5C02B315CC0879958C041DA1D3E9154AFBE48694BBE32AD0B3F06A766C069DB8F3E0E6F9BC0FF95A03E8E7F63C02257E0C0C44FBB3FAB5296C09664BFBF7A03D0BFD70F59C064D48ABE3B93A6C052DED5C02B315CC01AB92CBF8815C53DF20C84C0"> : tensor<20x20xf32>
    return %0 : tensor<20x20xf32>
  }
}
