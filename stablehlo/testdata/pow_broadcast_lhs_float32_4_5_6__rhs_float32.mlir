// RUN-DISABLED: stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<4x5x6xf32>, tensor<f32>)
    %1 = call @expected() : () -> tensor<4x5x6xf32>
    %2 = stablehlo.broadcast_in_dim %0#1, dims = [] : (tensor<f32>) -> tensor<4x5x6xf32>
    %3 = stablehlo.power %0#0, %2 : tensor<4x5x6xf32>
    %4 = stablehlo.custom_call @check.eq(%3, %1) : (tensor<4x5x6xf32>, tensor<4x5x6xf32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<4x5x6xf32>, tensor<f32>) {
    %0 = stablehlo.constant dense<"0xAE8E2740302E2BC02581C9C042B71B40148278C091D0B5C056CF7ABEA1767BC05A5BF53FABBD783FA67593400A55A63E41AB23C0C4FAE8BED66A553FEED4DE40EC6D17BF639985BFFB2E003F5A27BF3FE56B4CBF878E54404F65BEBFFFC3983F923CD53FD0E4763F97130A40B482B9404910C9BFE56FA4C083BA7EBF321A85C0AF78F9BFF11A8FC0B6B8184063603440173AAEBE1FC21EC0EB6FE13F9C950FBFBDB5B5BDC7F36F3FCB1A03BFB16CECBFF0C93BC04BBE45C00533B53E7568BC3F7BF0DE3F684B28401C4D044012D161C0683108BF04C9863ECA26B03FE95C773F76426BC00D4A6940B41960C0278D953FD1CB503FD901EABE0187ED405BE81041F6840F40A9418F40C29D333FEE44BE3F399F294066929140EE41764026032740F3A63440E7C6FC3E1C78C53FB411303FD1DD71C0A22B633F7BE8AF409AF4EF406B8C20400E39063F3C48B040C767DDBF5986003E1FB70A409B97E9BC266E4740932A9940623FAB409A7A3DC0A62533BF1B0579C046CC33BF572D03BBC1F324C042A18CC0D25C1F3F9071D23FEBAB70BF6C3F94C030DA8C40BDED2F3F11C9763F2C807D3EF4F149C056BA3C3E7AC18E40BE9793BF7D609B407152A44071A9C1BE1D0B94409DFD6940093555C0DCC92DC0958716BD391D974044C5623F712D54C0"> : tensor<4x5x6xf32>
    %1 = stablehlo.constant dense<-1.02286649> : tensor<f32>
    return %0, %1 : tensor<4x5x6xf32>, tensor<f32>
  }
  func.func private @expected() -> tensor<4x5x6xf32> {
    %0 = stablehlo.constant dense<"0x584EBF3E0000C0FF0000C0FF0433CE3E0000C0FF0000C0FF0000C0FF0000C0FF7C94033F79D2833F6B96563E49224A400000C0FF0000C0FFFB2D9A3F6DAB0C3E0000C0FF0000C0FFC1DA01407EDB293F0000C0FFC8FC953E0000C0FFFCA1553F00E3173FBCD4843F762EE93EEEAD293E0000C0FF0000C0FF0000C0FF0000C0FF0000C0FF0000C0FFE255D23E2A69B13E0000C0FF0000C0FFE77B0F3F0000C0FF0000C0FF47C3883F0000C0FF0000C0FF0000C0FF0000C0FFB02F3940C7632C3FE920113FEB72BE3E3099F33E0000C0FF0000C0FF84A57A401AAB383FC592843F0000C0FF125E883E0000C0FF95545A3FBFAB9D3F0000C0FF22C6033EC504D73DD923E03E92075D3EEAEAB73F42AA2A3FB0ECBC3E2C6F593EC506813ED5F1BF3E4822B13EC2BD0340884D243F5BB5BB3F0000C0FF84A3903FD228333E0269023E50DAC73E30C3F73F48C5323E0000C0FF39AC05414B15E83E0000C0FFC017A03EBF694E3EFA25383E0000C0FF0000C0FF0000C0FF0000C0FF0000C0FF0000C0FF0000C0FF23DCCF3FEFF2193F0000C0FF0000C0FFAAE3603E9BDCBB3F03E4843F837485400000C0FFB178B44095D25D3E0000C0FFE2684B3E3B17403E0000C0FFD3B8553E08F3873E0000C0FF0000C0FF0000C0FFDE47513E4DE6903F0000C0FF"> : tensor<4x5x6xf32>
    return %0 : tensor<4x5x6xf32>
  }
}
