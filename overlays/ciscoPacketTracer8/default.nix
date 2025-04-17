_: (_: super: {
  ciscoPacketTracer8 =
    super.ciscoPacketTracer8.overrideAttrs
    (oldAttrs: let
      new_src = ./CiscoPacketTracer822_amd64_signed.deb;
    in {
      src = new_src;
    });
})
