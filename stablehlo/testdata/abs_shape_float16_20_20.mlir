// RUN-DISABLED(#1278): stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x20xf16>
    %1 = call @expected() : () -> tensor<20x20xf16>
    %2 = stablehlo.abs %0 : tensor<20x20xf16>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xf16>, tensor<20x20xf16>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x20xf16> {
    %0 = stablehlo.constant dense<"0x5E40ADBE83435BBDC2B1963F193F17C83EBAE7B6D04666C5CFC02ABA71C749C5B43FCC4150424F2E67BD7CBEE73D3DC12FBE1B40EEAFECC068C18CC135425B458ABFB1C2D9C432C8813E65AB6D405040C0BAA3B793B3E73E25C568C10F2F9BBF5822C1B833C6C2C4D9C018448BBFF93966BF84B8DDC16CB4ACC4CBBD9E449C366643B7C00E4463C4BFBF133D2A4206AFBE3446BD42C6C6C41DC3BAC165C82D419BC0313B2BB9264164C21240323E3034E9C48B426D4089C15FC4E63633C26642263C7C433ABC4BB5593C7341464208BDC3BE5BBD6541A1B889BE30C2263EF03753B976B72940A7C04EB8E744B5470D41F42E9F35E140B5BFF9C0404422BABEC530C4C9BAAC3F81BB81B25DB313BC4FB801C3CB4034C63145894262BC93BCF5BB6CC1D2BC193B15BCBEBD063D873E673B46434DB6143C613D1045104086C342C0A837FAC5884112C1A53A494141C1D343E63E3440604382C05D40D3C11BC458BF944640AAD53F8AC14F3D95BFEB3F9DC3CB3916403CC2C8AACAB0934169BB6DB905C3D23D2DC1094437C0964126C1A03C97BD59C59D3B05C55AC592C14B4301C40DA9C9C3D84353C3C7ABE53FB7C09CC094433532464109C349BD5F3822BFC63D2C3774B17DBF16404CC2AEC1D8C4C34435BCEA3A5FBDF3B559BFA4B8B1BE103CDE3E01BB0C42054067C40A3CE5BD4A43CB40F63966C3503845C4A8C00FC65FBC7EBB9F3C4BC0D93DD3368DC3F3C2DD3EBE356F43E340E43BC5409C2534C556393D4207C3013EFBBFC4B98C3C54BD123E14BAE9BA0AB44D3A8C4400A80CBA29C7F0C2CDB9BDC08BC13D42DDB32CBEDDC097C2FA3E6F2DA43CE74063B82AB92BC0A8B990C1C0C0773CB23B9C3C5E41963E56C53FB443404D3FEB3D2040EA3E7A42A3BCBFB4DB3AEB3E73B423BBBCBA1844CCBEA0C225C1C8390CB430B98C2BD5C1DDC238BE3A3BF2C18D4449417CC161C67E4141C8C04373C351BD9941933C39C12EC4E93452B93CC86642EFC15D3BF83E42417641A742BDBCD94192C01ABC2444A0C361C15D2DBD4329BC3844804396BBACBB7F31D437953BAFC3B3B155C1133E7341F2BF35B7163D33C40FC713BE643F3AC3A83AA4B5FCC380C1E7BF5FC4F043"> : tensor<20x20xf16>
    return %0 : tensor<20x20xf16>
  }
  func.func private @expected() -> tensor<20x20xf16> {
    %0 = stablehlo.constant dense<"0x5E40AD3E83435B3DC231963F193F17483E3AE736D0466645CF402A3A71474945B43FCC4150424F2E673D7C3EE73D3D412F3E1B40EE2FEC4068418C4135425B458A3FB142D9443248813E652B6D405040C03AA3379333E73E254568410F2F9B3F5822C1383346C244D94018448B3FF939663F8438DD416C34AC44CB3D9E449C366643B7400E446344BF3F133D2A42062FBE34463D4246C6441D43BA4165482D419B40313B2B39264164421240323E3034E9448B426D4089415F44E63633426642263C7C433A3C4B35593C73414642083DC33E5B3D6541A138893E3042263EF037533976372940A7404E38E744B5470D41F42E9F35E140B53FF9404044223ABE453044C93AAC3F813B81325D33133C4F380143CB40344631458942623C933CF53B6C41D23C193B153CBE3D063D873E673B46434D36143C613D1045104086434240A837FA4588411241A53A49414141D343E63E3440604382405D40D3411B44583F9446402AD53F8A414F3D953FEB3F9D43CB3916403C42C82ACA309341693B6D390543D23D2D410944374096412641A03C973D59459D3B05455A4592414B4301440D29C943D8435343C72BE53FB7409C409443353246410943493D5F38223FC63D2C3774317D3F16404C42AE41D844C344353CEA3A5F3DF335593FA438B13E103CDE3E013B0C42054067440A3CE53D4A43CB40F639664350384544A8400F465F3C7E3B9F3C4B40D93DD3368D43F342DD3EBE356F43E340E43BC5409C25344556393D420743013EFB3FC4398C3C543D123E143AE93A0A344D3A8C4400280C3A2947F042CD39BD408B413D42DD332C3EDD409742FA3E6F2DA43CE74063382A392B40A8399041C040773CB23B9C3C5E41963E56453F3443404D3FEB3D2040EA3E7A42A33CBF34DB3AEB3E7334233BBC3A1844CC3EA0422541C8390C3430398C2BD541DD42383E3A3BF2418D4449417C4161467E414148C0437343513D9941933C39412E44E93452393C486642EF415D3BF83E42417641A742BD3CD94192401A3C2444A04361415D2DBD43293C38448043963BAC3B7F31D437953BAF43B3315541133E7341F23F3537163D33440F47133E643F3A43A83AA435FC438041E73F5F44F043"> : tensor<20x20xf16>
    return %0 : tensor<20x20xf16>
  }
}
