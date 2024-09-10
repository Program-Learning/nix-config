{
  lib,
  mylib,
  nixpkgs,
  forAllSystems,
  ...
} @ inputs: let
  mergeTwoAttrs = attrs1: attrs2: lib.mkMerge [attrs1 attrs2];
  mergeAttrsList = attrSets: lib.lists.foldl' (prev: curr: mergeTwoAttrs prev curr) {} attrSets;
in
  # TODO: fix this
  mergeAttrsList (builtins.map (arrayElem: import arrayElem inputs) (mylib.scanPaths ./.))
