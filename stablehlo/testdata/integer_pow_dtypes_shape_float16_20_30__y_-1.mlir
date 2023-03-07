// RUN-DISABLED(#1278): stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x30xf16>
    %1 = call @expected() : () -> tensor<20x30xf16>
    %2 = stablehlo.constant dense<1.000000e+00> : tensor<f16>
    %3 = stablehlo.broadcast_in_dim %2, dims = [] : (tensor<f16>) -> tensor<20x30xf16>
    %4 = stablehlo.divide %3, %0 : tensor<20x30xf16>
    %5 = stablehlo.custom_call @check.eq(%4, %1) : (tensor<20x30xf16>, tensor<20x30xf16>) -> tensor<i1>
    return %5 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x30xf16> {
    %0 = stablehlo.constant dense<"0x3441BE3E93C366423AAE52BDC9C39ABD1A44AA400A417F4349B1B83E4CC40742C73F54410B3EC02F383F6DA92DC40FC0FC3F953DDAB0ECC0703C593B5CBE9F3C01BA1041FEC52D456DB3E1BE35C5E9C34241C6395F420F40B4441F450F3CDF45CAC48DC4E13CFABBE1449E427B3FB4C3C03D90C4793D1A3F544583341CBA1C48C73C77412B44114034B93045483C1A43DAC621C34248F8373935684046B61ABD20C50C456A351C400B41F53C3635033972461A414CBEFEC5A8B6774067C1DAC0A2BA0F981FC132C07540AD2307C0C83B8D427AC132C15E438B45C0443C438545AAB91EC1FD40473669B6293C1A46892E40431DC3BEBAD9A9C040E7B070C19B3C4A4389C66F44C6B8E333BCBCCEB83DBE0F4236BC0A40C0C4E8BE30B6A8BA9C388CBECD45FD4407C1ECBF3E42583737BF25C44CB8B93D0939BA414E4118C181BC8CBA57B3E2C412B8C5B3A4422BC58FBAEA4628BCADB31D44623D0B444338DC40BCC2CB47E5BC4C45E1AC813E5E3984B515428AC77147D13ABA38132E29BC58C0093C13C526BF1B40DE42F0BE653084441D43E0BFB0C718C3563DB1403FBE0E3E08320A3E3334BB408D3A5440493CE7B49641E1C7D0B6A0BF04B97AC37CC244437BC4D1297B3CD9BE043D72BFBDC2DABF7E3DD9BCB93FCFBF54C452C3D23F084180B9C0BCCC434CC156BE683B5BC3883C074784390FC08EC408302BBFBE3C9E4235BDE146B8C304381B43FC4393B5A3BFEEC245AEE3B8BC448D3BC93EDCC7E040E24496C2EAC16F299FB98F44ED41294169C600C49FC13AC5AB4500C00E4102B90FC4BDBC19B8803D70B831C144BEE2BDF0C838C46835863A6E3DA4C060C07042B7C6143059C247BE70384C456DC017C1BFC2553C48B9CDC1F3C06CC2E83DCEB525C32F36283A58BBAD44E6406045D4476FBA2B41D5C034BCEB455BBE3E43884290B8CB43173C0C40D53EFC3C7A406444C432E9C1A1B70E4061B8A4B94739D4C2244116B823414F3FDEBD1EBD9E3B59C1DF408F309A3E0243EE3EE74385411DC67DC0242FCEBF3A40B344E53590A8E23C68392CC20A42EAC1DABA05419D2C6F35ECB84542B3BC4FC24ABFBB4227442F4104B9ACBFFC4121C21B3F6746D7BB1EC1E6413EC0DAC121C96BB1A5BDD4BC0FC0C9C0C3A501436F467D4113C6D7C222C137C1C43182C4F2442D3D87380EC166352EC7CB420CC496430BB9042D2E2DAE2C82C431C492C25A9649290A4054BD74C0AABE66BBF5B8FD3F2FBBFCB5694128BF9440C9382EBDDCB91B4555BC1E437DC42CC57F3BCCC26940A74007BCC7445FC25242183C7C3212BB923BDCBEC437A1BC92C60FC162456ABC493C46C3A7C3CD3643B7DC4470C0692D793EB5C6CBBD9EBFDABFB8396EC1152D34C5B2C4063A144573BB0041403F11B063C2ECBA82BD79B3E1BE44424AC65442A5C1EB43913CF8436CC1FD3D51BC813CFCC3423E633B1040F4C42645A5C3DBBF0FC15E42F0B792410BC11844E2449844F6B385B90E3250BD3D44ABB69B42C4BC59C12CC6D83C83C2B1BEC83FCC39933EC1450EC633C6B8354FBBA7BDA945A6BE3D431E3B07B4DCC5CD473EC59CC2E8C39F4554C24A397736FFB5AC41EC3AF9C2FC3611C56F3E2DC57CB95CC0BA4201BFC1B0954671BC03C40F41974468BE7743BC45F943F5C15CC0E3BDFCA514C59DB7EDBA4A468AC4D73C"> : tensor<20x30xf16>
    return %0 : tensor<20x30xf16>
  }
  func.func private @expected() -> tensor<20x30xf16> {
    %0 = stablehlo.constant dense<"0x2636BF383AB4003524C904BA1CB4B6B9CD33DC365A3645340EC6C33873B34F351D3802364C3921486F38E6CDAAB3E2B70238BC3999C680B6363B5B3C08B9ED3A54BD523657B12F324FC4A7B825B20CB416368B3D0635E237CE324032E23B7331AFB208B38F3A03BC8F32D634473827B4913904B3D9398238023218433DBDC92FB33ADB35AD33DF3726BE2B32793B8234ACB07DB4842F0440214243371AC146BA3EB25732E941C9375836753A2442633EF730463615B957B1CFC02B37ECB599B6D3BCE2DF40B6A1B72E372B54F2B71D3CE334D8B529B65834C631BD326C34CC31A6BD41B66A361941FEC0B13B3F31E6486A3480B4BFBC79CDBD3687C6E3B5F33A6434E6B03833B4BE0F44C2BAA9BE21B9483599BBEC37BDB2A2B82CC1CFBCF13EE3B884316A325DB60AB820355C406FB8B9B373BF98395B3E9735083648B61BBBE3BC5CC48EB2DDBF1EC4D23431B2E1BCA130B3BB2BC4C833F239EA33823F9636C0B41B308ABA0B328FCAEC38F63DCDC143353FB04D30B23CC53E4549B1BB5EB7EE3B4EB27AB8CB37A9349DB848471633803410B82AB083B4FF39D23620B949394E454D399F43C436E33C6537783B87C2BB3510B0B2C032B861BE48B4EFB4683424B3804D243BACB8613A4CB8C0B413B8D4399ABA253819B865B35FB418385C36D1BDBDBA1B340BB60DB9523C5AB4103B8E30CD3DE2B707B3F04777B8BF3AD63425BAA73025B4F83F81340234BEC131B89EB41BC98CBEC2323D3CB73812B090368E32DCB469B5E44DB1BD053366353436FEB000B4B1B51FB2A53100B8553664BEE2B3C1BACFBFD13936BF2AB61BB971B97BAE96B3EB41E83CE539E5B650B7F934C4B0D9470BB519B9363F0B323BB749B6BEB4633B0FBE84B577B6FCB46B3983C17BB42D41333D5CBCD8328836F4311630F9BC31369FB69DBB683109B96B34E63404BF1B34D33BE837AF386C3A26374A33BB446AB532C0E4374FBFACBD103EB0B43A36D5BF3B36613874B941BA333CFCB592360547D93891349E380D34CC353CB121B77B481AB89237CF326E4104CF8E3AEB3D2FB54D3569B5ACBC6036F04AE44180BE1B35CFBA13B564B8C134B5332C3661BE2CB8593539B58138003115BC41B66D358BB778B53DAEE8C5ABB9A1BAE2B7B0B68ED19234F930D53545B1AEB43CB623B68D4519B379322F3A113F55B6ED4175B0B634E8B3383458BE614A2E4AD74A19B3A2B3DFB40AE10E4EEC3702BA30B7CDB853BC75BE023874BC59C1EA3579B8FD36B03E2EBA76BD453263BB7F3421B330B2453CB5B44237E136F2BBB33206B51035D13BEF4487BC3A3CAAB81F40EABADFB053B6F23140BB783B66B42FB4B54068C0963236B7EA49F238C5B086B933B813B8983DE5B54C4A26B2D1B2503D4D324CBC66366A38DFC703B59FBCCFB948C4A7B81B3517B10F35ABB50B34023B0434E7B558396ABB1B3B02B41D39553CE03776B2373230B413B853B6073508C0BF3558B6D1338E32F73205C4CCBD494506BA8D33CDC0D834B7BAFCB52FB19B3AEAB4C8B81D38853DDE38903149B129B1984161BCA9B9A731D0B86C347F3CF2C376B11A301BB2D7B40CB4B1310FB50D3EF34056C1A4359F3C97B4954051B2F9382FB2D6BD57B7C23492B8BBC6DD3034BBFAB35336F932FFB84934953104345FB557B770B959D14DB234C09FBC17310DB39D3A"> : tensor<20x30xf16>
    return %0 : tensor<20x30xf16>
  }
}
