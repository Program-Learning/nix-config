{
  lib,
  mylib,
  nixpkgs,
  forAllSystems,
  ...
}@inputs:
let
  importDevShell = path: import path inputs;
in
builtins.foldl' (acc: elem: lib.recursiveUpdate acc (importDevShell elem)) { } (mylib.scanPaths ./.)
