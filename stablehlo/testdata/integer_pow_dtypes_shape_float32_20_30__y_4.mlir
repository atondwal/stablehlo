// RUN-DISABLED(#1278): stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x30xf32>
    %1 = call @expected() : () -> tensor<20x30xf32>
    %2 = call @integer_pow(%0) : (tensor<20x30xf32>) -> tensor<20x30xf32>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x30xf32>, tensor<20x30xf32>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x30xf32> {
    %0 = stablehlo.constant dense<"0xE30F5640220DFBC0774F2D400C2323C0207BEBBEBC5B24403AA5933DC8DA423FB1598B3E78E12DC0973403BFF01A8DBFF6299AC07DCCE03E137785BC6D73AFC0F44D6FC0E7E15E3FC06BECBFF40A264010586FC03CA17A3F970FF5BE4B36B7BE288646BC455C4BC0DCF8AFBDB84C9FC00742BA40622451C03C023140D471C13FACEA85BF56E996BF135444406A5925409346753FC272B9BF3E08D6BF8F582C3F6606E53FC314DA403D7EAFC06BA9A140FC6065BEA8921BC0270202406D8B2D40C64B34C0E99C1C4025DD34402348F140E40DABBF2385B03E359E8D3E5220BABFF9C9303FC549AE3F5F7C3F403761BE3FE975CBC09D75E93F38C071BE5CE95A40A9C57FC06FDD993FBC4B2440D84736401F243E4069C5523F4FE43E3FC154F4BFD2EE31BE6BB0E1C00CDC1040145CDFBE6384E63F8C37734012C12AC06AF82BC058246F3ED6503BC004E66540C39C01C0CE93A2C07E3782BF5FE889BF58C4F73F9B0D253EE8FBFABFCE972F405B156EBFCC9AEB3F3FDE62C001A349BF0AD7D5C0B3AD6A406CCE93C0D7384F40EE52213F849C74BF35D1713ECDB2D64024F6FABF51261140F2C7A9BF1C24EC3F01D1B4C059939CBF41B3594046934340DEEEDB3F52D32040B104AE3F1AB80440D92F63C0C2CC2F405275873F879A16C03AC4DABF8591CF400ACE233F153C57C0D7718DC03E9B6A40C04A78406C05A0BFB8B24DC0C6B0BE3F702AD9BFF0757B402F83C23EC77FFCBFC5566EBF166281BFDCB007409DEEA74085A74F3F45B7564049B30240788D56C03E1688C0C24BA3407387803E0F909FC056B63E408261BABDD33205403AA230401356C73E544DABC0FB1D984048918EC0485AA4BF3AEB003FF77F0940999F403FFEF9A1BE171566C056B4E43FD0892CC093449340D47007C08F69313FDBBCCBC0B711803E746FA4BF0CA4A0C08F1C51BF81627D400B0F07BF666DE44049CB4EC043CEF440AC11AC3E741EE03FF0EBA8C0D6DC8BBECADA1440C3F7D6BF70381440DF910D4087328340AF18E7BF06D413BF7DDA8BC01BFB46C0F76233C0F60D744005AF90C0D729B3C0B2FF73C0A1A6653F288352C0DBC8453F09A2A3BF102C0E403CCC3BBE10BE5F3F044118C06978943D1C029140C5D00440FA96943F99E83C3FC730923EFD0C6F3F6985C03FE0717940148C903F56AA4C400FD55EC0D9F8E5BF7F7D31C00A43F4BF63263540A6486C407B9D3B40C0BE2540534B41BF7F5F55C0630462BF62DC014005A582BF1C94903F02E0BDBE46A092C0A2765A4068A4D33FAC88823FE9A4793E4C3E5DC08F6CD13F92415EC02849AABFD1B817BE01256040565435C07A51224091AB88C040860740977E094068503DC0C3133A40142D23C07155D63F7F4356C0580E51C0C7DECEC00718563FA3C929BE834F29C01E8B523FCBF3DF3F2589DA40195360BF63761540D95752403D53973F5AB484C0A4202240E3595140F66F0441DA1AE2BF27C5F3BF0E2F78C0930DA4409837B83E772F9BBEB0F21F3E12C62A3C177833405406B13FB4CFFA401402D23E85BABD3EA8BED33F8A2F21C08AAD6C3C5DB3B53FFCDD54408EB1654039066840DEBB40C0AD870040468648407E5E22400F434CC087FB7C40E1DD10C0A4F818BFC05BE4BE78B9AEC0C8A0B03FA1A621BFA7DC2F409E57F0BF6720E9BFD054203FDAEDD23F19F30440CAE0FEBEDCC9F23F9480A1BEFC994AC015C9AF3F54FEDFBEDF3C4CC03BBFAF3FEE5E2EC08A395EC0E5CE92403C66A24091A42C406CEC3D408666A63FA4AEA63F2B340CBE6977FEC0D1579340809215C027F2ADBF2E978940E637363E89A2ABBF6FAEE73FD00D9A402B929F404FD89B40772597C0C3D28240D6A301414BF8133F2195D03E489A823F73EEB4C054D05FBFD0BF863F723E903ED366C1406F2231404981C63FFD00B73F9B1B8CBFAD4811405AC61DBF85684FC032C6AEBF85E619C0D28CB3BF92AF1BBFD1228AC0B3985ABFDFBC64C0F2F75EC0B1B4CA3F4A9F1A40FA8E2CC0EC17193F6C17DA40B23C84BFD06D5AC070A83EBD0A2385BFFF6323C0332EC53FAD8461BF7C6F94BF46613440ECAA32C06AE39ABEA650DCC0497CF3BFEFC8703F2891DD3FF0A7793E1F46C3BFAE0D52C0580EA9BFD39465BF8C84824056281FC0EBBC77C01ADE98C0369A09C0C1E5B8BF4504903E3C3295BDB00229C0A5B833BEBD1B13C0FA0701C0B08C24BF73182DBF58E9AE40FDDF4E406BDB4BC0271002408DC29D3F7F846CC08CF790BF567A4EBEE23F90BF7D397A401D015A405072C4BF0331BDBFA1800AC08D948FBF2B93D1BFD8D7F5BF75BA86BEB3ABC2BF9C596640A402A23E5FF094C0661F9C3F8F5A473FE8358D3F98F60FC0BF2326400F5D90C047C3F33F9D4BF2BDFC4E90401B3702C0EFFD82BF84BC7B408FAE2B40D77C9C3E91BE913DBF3F743FA383CCBF04AD25C0E87997C016FC99BF11F7A140041DB2BFB36DA83F0406BC40B5CFBA3FE11DD5BF2E9771BEBD7CF2BF634C04C0D60202C0F2EF0340AF9674C0163BD53F43FA8F3FFC90A5C005CED7402199383FC7E4C84064D6FBBE27F49CC059EBF2BF76C5C4C063994AC0F1D169408ECA5E408E890440435C08BFD7E2EB3FB5875BC0D00905C09E2F7C3F3BD30740641F30C0351F09407A3A0BC04CC5E8BFF0E313C0B14B94BF4EC829BD8774A0404289963F197CFF3F65F16DC0FCB7DB3DC2ED214040B52CC00FE435BFE844E9C0154002402797964020DE864068A138BDE77B6CBF5F10B2BFEFF7B2BF5DC36640B81035C024876F3F3AA9EFBFDC665AC0950B8E3FA67DB7BE5533F44058F4A440583AA93FD199B53E6C6D903FBA2CF43F135198BF52B451BF26C64CBFF048F63F5A0CB53FE8FD0340517483BE5F469F4038E58FBD4FE2A3409CDE81BF817690407450A1407E49B53F8D8251C03A598A400329B13E175FF43F8AD92ABF5FE04B3F072B813FEC124DC032EBC33F5A5EE1BF5D344FBE3D57FD3F5C9486BF2704A33F488F43C0F648ADBE4F1557401172DBC008BB8EBF6B3FA840CB908A3EAF51ECBF17689A3F83799BC0DF3DA6C0B24154405AA06540AE80E2C0F73A6D3EE25EB03F635A57BFA23F79C05F5F4D40154BD1C0309C1AC06BEC883F85247DC0BB673C3E6FAB59BF2138C1BDC3E39CBE353989C0BBE807403D0A80BF05BD1AC10B627B3EB29F353F035434C0AEA1C0BE7F0CD8BEC739574077FEFABFC03F0DC01E08DE3F8365FA3F1E1FFB3E7800484017BA35BF4CC12FC01BAB5FC02F9253C0E0A3FFBF9139FC40C7ACEE3FB05AC14060F62DC0049EFC3F5891683FB03D36BBA580A040AD16843F516A7EC0CD24A0C07D54F13F76DAF7BF721CD83FDC8430BFD2C8ECBE57BCFD3E545070BFFE5215C02D5EA5BF"> : tensor<20x30xf32>
    return %0 : tensor<20x30xf32>
  }
  func.func private @expected() -> tensor<20x30xf32> {
    %0 = stablehlo.constant dense<"0xFE4DFA4295C56C45621957425DDE28426846373DABFB2D424498E237F0D9AB3E26CEB33BCEF15942BB4F8D3DFC08BD3F88AB0644E736183D054D973389EC6144B87843431117133F04383A41D1393542C2994343912F6B3F1CF8563DCD50863CA42AB9326FE1CB42E19E643844881944FE788F44FD12E442340E6A4253EEA640DF5B993FE651F73F211CB142913732424BB9573F85FE8C403D2AFA40D159523EE3FC2341C1D106453F246244DBD72244F000253B41A90B4285398841AA435842BFEE7B42F96E0F421D1F7F4233034A45881D4C40487B673C43CCBF3B3F118F402EE5683E92FE5B408845A042BA999C405648CC44EA0F314188964B3B7BE20843F3167F43E6A00540F7B72D42DE9A834215D19B427643EB3ECD4A9E3E756B54415EFB6E3AEBA31A4580F8D1419F5A143DAD4D284164925043D2AF4A42F6855042E8F0423B89C2924206812643819286414F9026449F19893F6579AC3F6B9F60419CF1303AA0846C4124A8624227833F3F15A93741A9E51D43390EC53E8144F94422CA34439595E3432ED0DB42777C213E7165553FC7CF4B3B624BFD44E56E6C4168A8D3410A1B4640B5563941A4DA7E44F54B0F4044E105436768AE4228750B41E27F1F429AA25A4047F2934151C91E4309BA63421B8BA03FDB4EF541B28508416749DD44B9A62B3EA5D5FF425BDCBE4348913443618862432F551C400C6BD54222A09D40F3910441ED516E43B9A5AA3CFB477241F855403F789F853F15A6A141AC9D3D4447A7DD3E7960FD42E0258B41639BFC42528BA3432D8729442A21823B848C1A4488B29D4216DA8F3877189641041468422037BC3CFC4C4D448C51FF4363FEC44385F52D4016B7833D6971AA41451DA43E751D243C8F09274357122341AD4A53423449E043D075A04193326C3ED965CD44EA46803B394F2E40ABC41E44DFF0E33EC6B275435FA89E3D63482245C700DA423E1356459300513CAC611641F71F4244C376B63B1E1CEA416D91FE404725E6417A89BF41D7468D4368002A4116B8E33D826AB64379E0BA4251E37642B0755343EBF3D0436CA9754442445343AFC9253F331CEA42546CB63E91EE2A4045D1C241C346943A9D5F153F8B1E00429CB3E73785D5D24365609441A572E83FD6D0973E6DCBD93BCCA4423F18C4A340F2C46643582AD03F102AD1422CF512439AB72641D09C6C42E12D5441AD5E804286C9394351B3934206EE33429369A63EF118F7428F8A1B3F7D9B87412BE98A3F9F58D03F48F29A3CD266DC4369C407434A2DEF40C1708A3F0782673B8FCF0E43784EE5409B711143CE78484001ADFC39417316431DE1804225812542C15DA6436CDBA041966AAA419E1F9942A7EA8E42EA072942EC93FB40B73FFB42E9B2E3420453DA441274FA3EEF22463A45EB43429F3FEA3E4DEF154172F2074529EF163FFDF4ED41C75BE942FC0AFA3F90E1934350BA2442BAFCE442A1B1924570C81B41CA79524160236243A5B12C448F49893C66460A3C050C1C3A91C74A32B2577742DD236A402CDE6B4512E0E73C0D789A3C0AA4EF40F2EE2042A2073B331BF0814025C3F4423EE9254397BF2C43B37DA442162282415CBEC04241B625421E85CF42502474432003D241FE8C023E4316223DA9345E446C0C68409FCC223E700C644265E24641F70D3041548C1D3E3CF8EB4006FA9441AF8A7B3D221B4F418C33223CA7DAC842FDA66340850B163DFC6BCF42F97363407B695C42965C1143AA7FDD43DED52544D9CD5342D21A9B42E3CA3640940838402940B839B2EB794584BEE04339A8EE417F455A40A0E4AA43D86C833AA5E64E40B9BA2B4147490644B1941A4407A40C44FDDCF8431DAC8B43E5AF8645E497E43D9AA4E13C84BB8A3FD0807F446A90153F5A359D3F8D6CCE3B5BC8A644B0B86A427818B940C1B485402EBFB73F1871D441CDBC133EC49ADC426E755E407AC005420DCA774031110C3E809EAD432C19083FB22A23434A511343A544C94054470842FB635342E9F7023E55D8064503CF913F7CAE074394849D365CD1953FECEB29425B34B4402B2C1A3FEA7BE73F00677C4235F472421F38093CD06D0C45927E5141845A483FF8A50F41438D673BD555AD405213E84250BE42404C96253F435F8A4331FC1842808460437D320244AFF3AA419D538B405120CD3B2044EC37A088424252BC783AD750DF41BB2C844151CB2E3EC508563E98285F442058DA4233E1CD423C74884192AE134008863A432098D23F36ACD83AC774CE3F18AB694330A106435789B14024BA98400578AF41B6A6CA3FC0F7E54022BA59415E1C9D3B1334AB40E3D027438540243C01A4EA4354A50D401148BC3EAB99BD3F74D2CC4126A63542011CCF4351735241AD6D4D394BCBCE43FF178941D6648C3FEE5D6F43A6204F42A1F90E3CEC25D7377022543F098CD04010A13342EF0AFB43830B06409B112444EEF36F4035DE3F4092FD94447D2F914089E9F5406C0C4B3B79144E4144149241643C8841A77D9041175155437270F64054E7CC3F9E27334423470145366D8A3EB42AC24467C06F3D9FAF10447E8D4F41A9B6B24448D8C842A928324379D9124329239341ECDCA43D208A384139700A43F05F9541E314713F1E4AA241616765429F93A841422DB34162FB2E41351AE441F49CE63FB71C463622091E446ADEF43FFBF17D418D0F3F4327EA0A39E6EB2342C51F54429E7B823E557C3045D03D8941DF38F543FEC29D430B868A36EE6A3A3FD1AF6F4027987440E40529434C218042D633443F9CA34441379D07437A1FC23F8622873C52F75345628530445D89434017A7813CFA79CF3F63E05341A05400406689E63EDA9BD13EDB4B5B41F1148040DABA90410C638E3BCE6F1944A46FCC37BFFB2B44CBA4873F2EAECF438D7221444CC28040D9AEE542ADB0AE4390DB6A3C688F544119244B3E35F5CD3E96BC843FE2D6D242DBA2AF4079C3194131BDDB3A16877541F46A9C3F955E28402B5AAE421BF9563C7D1DFF42AA390A4588E5C53FA80B3F44FFC9AF3BF2E53941228507400D4F0B448318364468F7F1428FB72543CFE11C453CC83C3BE1B26640ED32003F3F0B6643F911D442FBBBE444653C0842679AA73FB3C274433D34963A08CE053F8327A6383973103C9F13A943F9B0A241F928803F42B008468B066E3BE1B7813ECF1C7C425E24A43C19DD013DB0CAFF42448E6C418FCEBD4171DB1041B54F6A4176096D3DEBBDBE425B03823EAD7E6342032D1543F6DAEE4246907E41EF3A71452F6C4141839EA644B25A5A421DBC72415E5F2E3F8D7D832EE4381E449C27913F46B87943F2CF1C44942C4A41ABEF604177030241D479673EED5D3B3DF20F773D46CA463FE513ED41194C3240"> : tensor<20x30xf32>
    return %0 : tensor<20x30xf32>
  }
  func.func private @integer_pow(%arg0: tensor<20x30xf32>) -> tensor<20x30xf32> {
    %0 = stablehlo.multiply %arg0, %arg0 : tensor<20x30xf32>
    %1 = stablehlo.multiply %0, %0 : tensor<20x30xf32>
    return %1 : tensor<20x30xf32>
  }
}
