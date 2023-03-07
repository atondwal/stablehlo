// RUN-DISABLED: stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<1> : tensor<2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<3x5x40xf32>, tensor<3x5x2xf32>)
    %2 = call @expected() : () -> tensor<3x5x40xf32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<f32>, %arg1: tensor<f32>):
      %5 = stablehlo.multiply %arg0, %arg1 : tensor<f32>
      stablehlo.return %5 : tensor<f32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 1], inserted_window_dims = [2], scatter_dims_to_operand_dims = [2], index_vector_dim = 1>} : (tensor<3x5x40xf32>, tensor<2x1xi32>, tensor<3x5x2xf32>) -> tensor<3x5x40xf32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<3x5x40xf32>, tensor<3x5x40xf32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<3x5x40xf32>, tensor<3x5x2xf32>) {
    %0 = stablehlo.constant dense<"0x6CB9ECBEAFB62940831DB7C0684D8EC0758489BEBF8D663F99E090BF72434EBEECAFC63F52D564C0CF84FDBEC015F4BCDF5BF4BF042E303F82D75D40B8D9623EA7958FBF0377D23FE20471C0F4D7B4C04CF51040043028403E2D2FC062F8CABF2B1D814000EE7EBFE27F363F86D1F3BDEFC46C3FC89ACDC0F02DB5BFC273BAC0E3DD29405072EB3D114A18C0580834C0B3778040577D804025BB9940C29A97BF2637A03D25A9583FF6742440D82B253E722AA04090A92D3F3E017640A46295408E4CAB3F1B3E8440CB2069405D87AA3F3AA361406D0AB0405E4D883FC6F092C09D79DCBEEF4511405B4C18C0175AC73F0685953FA0D656BF6603674085E9D6BF47887F3B04CB8A407D69F7BFDD6607BFD59294C0D32DD23F3E079ABF0C3D0A3E0F8AC5BE2A98F1BFECD598400F99D7BF65EB10C0BB588A4061F720BE2BB85E402B38A74072D6DC3E9A563540E5ACBDBF0D9D68C0F8A293BF7160FE3F0401133FC31B8A4087C8113E685ED2BFA82787C0001E8AC058EC554033416FBF2C2810BF698DB4BFF3A364C0D733383F9E61ACBE56C74540E6702240C9A60F3EB7BC4EBFDE50FC3E8D507E3FD69D52C06F462140C9EE6140D04F05C07BCABA3F97330E3F53EA82BF6CC28DC0AF30A8BF8B2B57C0A0C8603F03F677BF00AF48BE5547BE3F384567401F8521C03ACF4EC0AFCF8C3FD8F974401AE232BF78D182C05A2B233D9CB151BEF66D04C0DB4E37400EA0B8C03191BB3F254CF1BF9AA493C0E05BAFBFA06C5BBEB4F249BFF6C5B64022CEBDBF05B32540F45E96408500AFC02DA67D404DBC9E3FA2966040D341983F03978140D90A92407C4F08C027F96BC0FFDC3C3F340152BF55B037BFCFBD943E6624A93F15FD963E54CEBBBE25C567BFD5B9A33F61461BBF4ACC30C0C24E0F4031AF8C3F4CE96D40AF8BA1C08473FDC0FFA7CBC0DBF92140EBB87440F75C76400938A8403B602C40B95B1B40F05A263F403F064061F28F3F8D5512BF9AC4474089358C3FA9003740F7ECB840989C123FC8F2CFBF50AF4F4095328440BFBC2EBF3A615E404D21AFC04426A1407B1100C01EE11BBF51173F408F8735C06FA73DBD68CFBEBF7A762140F02B27BF9029043EB5A29340AD20F8BFE24B7BBF421089BE1F047FBF42D629C0633066407E46853E008FBBBFAC1D343F54108EC0CA212EBF9C610C40055600C0E22364BFDBA133C003F8BDBFF2961E408CEBC63FAAA884BFFF7501C079CF1D40A46980C00C7AE8BFBAB3EBBEF1B74440828B063F5549CC3FA961AAC0EC2CA94077FC2E408C797DC0388D5540DB12C53FDAEA3FBFA4315DC06B8722BFBA0CA0C0647606C10036E6BF821FD93FC7100DBFC77714BF28D11F40C74CD83F790F5340A34132C048F7B23EC6DC9740D0CE863F8038CABC473401401643793F0F11033F0AF3AB3EDE9C403E5734904051B0303F315D7F4085399B3F6E80B73E210120C0007E1A40A8D8BB3E279821C0F9801D3FC68F0EC0543249C0B93D41405C9F4940A05C0BC166CE304033E297C0370FC6BF5BEDF83F36A3CFC03325384075E9063EBE2F1440CA1353C025AA91BF66A384BF2B4A6BC038CA95BED67F4CC0A3CC0840038A7AC04E18D340C20C5B409988683FAC2B483EE05EA5BFA40E5A40303FB440901B61C0ED130B3E5DC7CFC0ED01193F8BC16B3F23E586BFCB143A3D03569FC071577FC07D37A43FCE7EDE40BE5A354005318F40DB3B354011AAA840ECCE6240AAAF60BFF0E2E5BB5B588CBF265989BF2A4A5DBF10A8A63F2DEF1540FB563B3FF5B066C0130D02BF842B90C0016508C0915A14C0D5947D3C62DD28BFD93CBABEDCA25CC010CB35400DB0013E02B24DBFB6128FBFC5A8EE3EC998863FC457BE3F7452803E63E6D440161E893FB26FC83FBC4114402DB880407504C7C0DB1148BFFB4456C04C1B9EC0D904ED3D7F973D402E6D09C01ED405C1DAF91340137F3A402834BEBFD38438C0F8CE973FEAE0254070EC3B40B46E3BBF523336BF80FE5D4078BC95BF2049C73F1254B1C0324E8CBF04286A3F48CAADBF8574EEBE91AA43BF246CE33F605348BFC4635F3F8F979E4031B18140BF7391BFB49802C038219A3F54A7313E0EE982C07121063F75E5E3BDDF961C3FF4C9DF3E86F701BF1E7415C0DA66FD3EC12B87BFA561D7BFC34DFD3F5A66DEBFAABE603FAB0E643FAC479CC0473B83BF6845F43FC775A33E285D4140D47353C0F58F993E91BD9A3F319620C0CFC485C02FC144C0CAC7943E231102C1335BC03F65382E3F16049ABF88711FC0A6F62640B872DE3F34B925C0FCB8B03E6E1C4FBF71AB3DC0BB275EBF879A6C40B4B88A4052B79D3FB396AAC052B3F3BEF7C962C0DE2D93C0ACE8B53F3A1AAF3FEDB980406433C63E0675CCBE7603ABBFAD9F23C0EEDF40C05474993F779E193F8072D8400F5AA3C09ACE6B407D9D5F40DD728B3F9DE30A4020E525403B80CC3FA92A394049E2313FCB10C1BE18EAB3BF8A3C05C0EFB4BE3D307A90BFB52FE0BFDDB2C53FE6591FBFBA472C40CC12B44043BA90C0BA09D6BFA63B9740D0120B40E02F9DBFAF0C9740725C7E3F335D4F40E659943F1A6F09BF35BC06C0F6B94BBF11DE493FA22AE6BF5158103F7EF8AC40B4E686C025389E3DBDDB1540EC75AA3E2AE594BFCEE36740359C33C046171B40B179353F1A7F7E40F19C08C0DB3A243DFB52FC3FB2B50CC068CC953E9415AFBF520BF9BEA4F8C5BF7F0C88C098A8A43E7D8F91BED84E00C0DBB3E7BF579AC83FD6658FC0A611D1BF0EA8BE3D2D8181C0EF8AEFC06DEE72BFD5CB8D3BA13F79C078E70CC0DE7541BF83D616402A5714C08F9361BEF9A884C0CBCB524014C978BDEE6F76C0F035063F3E620840A4C14740323EE53F2316793F311021BF909E89BE5C1656C0A4B427C0879ED33F2E6294C00024433D461C7EC0DB57A4C0029009C05DD15440F7B5BC40E3DA8A407ACDF440DE96B1C0CAF058C03275574029486D3F9AF754BEFB698FBF2FCD39BE9C7C2140858DA5401241873FA4E44BC002B1C43F51D39740456AB23D7C15B83E428E26C0A7D4D53F8EDBF73F426580C09B7B4E40BDE4A33FAC5FBF3EDC73B5C0D59D5D3F1BC590BF847F9440E9FD8D4038BFA73F819A89C0869F82BF2CA39B3F42F566407BB96BC0C64524BFA2F503C012464A3FC9DF8840DF1115C04C2D3DBEE2A157C0053915BF02671A40BC3C10409F98A4C046CA8B3F024525BE5DBFB83EB63CAD3F5CAFF2BF06A586C02EEABEBF86A97BC03574B73F772957C08C3685C057DDFE3F68BEEF3FA6111D400ABEF03F457DDFBF8BFF3C40804487BEA4C62340D78B77BE7FE9F7C003416BC0C10D693F937FF53F853C8540944EE2BF6EEE5EC05D72933FE81AA340A9ECBD3FDA32DEBF"> : tensor<3x5x40xf32>
    %1 = stablehlo.constant dense<[[[0.426363707, -1.10807753], [-0.627411305, -8.53027915], [-5.18695068, -0.758723616], [4.54188156, -0.541787088], [-0.1174144, -2.20145893]], [[2.74650335, -2.67192197], [1.32962549, 0.559449375], [-3.84330106, 1.67456245], [-1.49408638, 0.599618733], [1.66962171, 1.15010393]], [[0.748463035, 4.16177797], [0.0618203022, -3.63005829], [-0.380831689, -0.155107424], [2.50445318, -0.53890413], [-2.16113496, 1.96971583]]]> : tensor<3x5x2xf32>
    return %0, %1 : tensor<3x5x40xf32>, tensor<3x5x2xf32>
  }
  func.func private @expected() -> tensor<3x5x40xf32> {
    %0 = stablehlo.constant dense<"0x6CB9ECBE415CA0BF831DB7C0684D8EC0758489BEBF8D663F99E090BF72434EBEECAFC63F52D564C0CF84FDBEC015F4BCDF5BF4BF042E303F82D75D40B8D9623EA7958FBF0377D23FE20471C0F4D7B4C04CF51040043028403E2D2FC062F8CABF2B1D814000EE7EBFE27F363F86D1F3BDEFC46C3FC89ACDC0F02DB5BFC273BAC0E3DD29405072EB3D114A18C0580834C0B3778040577D804025BB9940C29A97BF2637A03D23F29040F6742440D82B253E722AA04090A92D3F3E017640A46295408E4CAB3F1B3E8440CB2069405D87AA3F3AA361406D0AB0405E4D883FC6F092C09D79DCBEEF4511405B4C18C0175AC73F0685953FA0D656BF6603674085E9D6BF47887F3B04CB8A407D69F7BFDD6607BFD59294C0D32DD23F3E079ABF0C3D0A3E0F8AC5BE2A98F1BFECD598400F99D7BF65EB10C0BB588A4061F720BE2BB85E402B38A7404A46D93F9A563540E5ACBDBF0D9D68C0F8A293BF7160FE3F0401133FC31B8A4087C8113E685ED2BFA82787C0001E8AC058EC554033416FBF2C2810BF698DB4BFF3A364C0D733383F9E61ACBE56C74540E6702240C9A60F3EB7BC4EBFDE50FC3E8D507E3FD69D52C06F462140C9EE6140D04F05C07BCABA3F97330E3F53EA82BF6CC28DC0AF30A8BF8B2B57C0A0C8603F03F677BF00AF48BE5547BE3F3845674092BAC6403ACF4EC0AFCF8C3FD8F974401AE232BF78D182C05A2B233D9CB151BEF66D04C0DB4E37400EA0B8C03191BB3F254CF1BF9AA493C0E05BAFBFA06C5BBEB4F249BFF6C5B64022CEBDBF05B32540F45E96408500AFC02DA67D404DBC9E3FA2966040D341983F03978140D90A92407C4F08C027F96BC0FFDC3C3F340152BF55B037BFCFBD943E6624A93F15FD963E54CEBBBE25C567BFD5B9A33F61461BBF0ECC36BFC24E0F4031AF8C3F4CE96D40AF8BA1C08473FDC0FFA7CBC0DBF92140EBB87440F75C76400938A8403B602C40B95B1B40F05A263F403F064061F28F3F8D5512BF9AC4474089358C3FA9003740F7ECB840989C123FC8F2CFBF50AF4F4095328440BFBC2EBF3A615E404D21AFC04426A1407B1100C01EE11BBF51173F408F8735C06FA73DBD68CFBEBF7A762140F02B27BF9029043EB5A29340AD20F8BFFB83E640421089BE1F047FBF42D629C0633066407E46853E008FBBBFAC1D343F54108EC0CA212EBF9C610C40055600C0E22364BFDBA133C003F8BDBFF2961E408CEBC63FAAA884BFFF7501C079CF1D40A46980C00C7AE8BFBAB3EBBEF1B74440828B063F5549CC3FA961AAC0EC2CA94077FC2E408C797DC0388D5540DB12C53FDAEA3FBFA4315DC06B8722BFBA0CA0C0647606C10036E6BF821FD93FC7100DBFCAE0DCBE28D11F40C74CD83F790F5340A34132C048F7B23EC6DC9740D0CE863F8038CABC473401401643793F0F11033F0AF3AB3EDE9C403E5734904051B0303F315D7F4085399B3F6E80B73E210120C0007E1A40A8D8BB3E279821C0F9801D3FC68F0EC0543249C0B93D41405C9F4940A05C0BC166CE304033E297C0370FC6BF5BEDF83F36A3CFC03325384075E9063EBE2F1440CA1353C025AA91BF66A384BF3E49BD4138CA95BED67F4CC0A3CC0840038A7AC04E18D340C20C5B409988683FAC2B483EE05EA5BFA40E5A40303FB440901B61C0ED130B3E5DC7CFC0ED01193F8BC16B3F23E586BFCB143A3D03569FC071577FC07D37A43FCE7EDE40BE5A354005318F40DB3B354011AAA840ECCE6240AAAF60BFF0E2E5BB5B588CBF265989BF2A4A5DBF10A8A63F2DEF1540FB563B3FF5B066C0130D02BF842B90C0016508C052E80440D5947D3C62DD28BFD93CBABEDCA25CC010CB35400DB0013E02B24DBFB6128FBFC5A8EE3EC998863FC457BE3F7452803E63E6D440161E893FB26FC83FBC4114402DB880407504C7C0DB1148BFFB4456C04C1B9EC0D904ED3D7F973D402E6D09C01ED405C1DAF91340137F3A402834BEBFD38438C0F8CE973FEAE0254070EC3B40B46E3BBF523336BF80FE5D4078BC95BF2049C73F1254B1C0324E8CBF67D1E03F48CAADBF8574EEBE91AA43BF246CE33F605348BFC4635F3F8F979E4031B18140BF7391BFB49802C038219A3F54A7313E0EE982C07121063F75E5E3BDDF961C3FF4C9DF3E86F701BF1E7415C0DA66FD3EC12B87BFA561D7BFC34DFD3F5A66DEBFAABE603FAB0E643FAC479CC0473B83BF6845F43FC775A33E285D4140D47353C0F58F993E91BD9A3F319620C0CFC485C02FC144C0CAC7943E231102C15ECB954065382E3F16049ABF88711FC0A6F62640B872DE3F34B925C0FCB8B03E6E1C4FBF71AB3DC0BB275EBF879A6C40B4B88A4052B79D3FB396AAC052B3F3BEF7C962C0DE2D93C0ACE8B53F3A1AAF3FEDB980406433C63E0675CCBE7603ABBFAD9F23C0EEDF40C05474993F779E193F8072D8400F5AA3C09ACE6B407D9D5F40DD728B3F9DE30A4020E525403B80CC3FA92A394049E2313FCB10C1BE18EAB3BFBB32EF3EEFB4BE3D307A90BFB52FE0BFDDB2C53FE6591FBFBA472C40CC12B44043BA90C0BA09D6BFA63B9740D0120B40E02F9DBFAF0C9740725C7E3F335D4F40E659943F1A6F09BF35BC06C0F6B94BBF11DE493FA22AE6BF5158103F7EF8AC40B4E686C025389E3DBDDB1540EC75AA3E2AE594BFCEE36740359C33C046171B40B179353F1A7F7E40F19C08C0DB3A243DFB52FC3FB2B50CC068CC953E9415AFBF4060EBBCA4F8C5BF7F0C88C098A8A43E7D8F91BED84E00C0DBB3E7BF579AC83FD6658FC0A611D1BF0EA8BE3D2D8181C0EF8AEFC06DEE72BFD5CB8D3BA13F79C078E70CC0DE7541BF83D616402A5714C08F9361BEF9A884C0CBCB524014C978BDEE6F76C0F035063F3E620840A4C14740323EE53F2316793F311021BF909E89BE5C1656C0A4B427C0879ED33F2E6294C00024433D461C7EC0DB57A4C0029009C0AA9D8FC0F7B5BC40E3DA8A407ACDF440DE96B1C0CAF058C03275574029486D3F9AF754BEFB698FBF2FCD39BE9C7C2140858DA5401241873FA4E44BC002B1C43F51D39740456AB23D7C15B83E428E26C0A7D4D53F8EDBF73F426580C09B7B4E40BDE4A33FAC5FBF3EDC73B5C0D59D5D3F1BC590BF847F9440E9FD8D4038BFA73F819A89C0869F82BF2CA39B3F42F566407BB96BC0C64524BFA2F503C012464A3F87A991C1DF1115C04C2D3DBEE2A157C0053915BF02671A40BC3C10409F98A4C046CA8B3F024525BE5DBFB83EB63CAD3F5CAFF2BF06A586C02EEABEBF86A97BC03574B73F772957C08C3685C057DDFE3F68BEEF3FA6111D400ABEF03F457DDFBF8BFF3C40804487BEA4C62340D78B77BE7FE9F7C003416BC0C10D693F937FF53F853C8540944EE2BF6EEE5EC05D72933FE81AA340A9ECBD3FDA32DEBF"> : tensor<3x5x40xf32>
    return %0 : tensor<3x5x40xf32>
  }
}

