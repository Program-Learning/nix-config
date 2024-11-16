{lib, ...}: (_: super: {
  flutter = lib.hiPrio super.flutter;
})
