{lib, ...}: (self: super: {
  vscode = super.vscode.overrideAttrs (oldAttrs: {
    libPath = lib.makeLibraryPath [super.libglvnd];
  });
})
