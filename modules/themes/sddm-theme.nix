{ pkgs }:

let
  # imgLink = "https://github.com/Liam-Malone/nixos/blob/main/modules/backgrounds/desert.jpg";
  # image = pkgs.fetchurl {
  #   url = imgLink;
  #   sha256 = "1qyra0ps99pi64nhdmn211v8fxh9f6kd5sxpqaz9ab24janmf55c";
  # };
  image = ../backgrounds/desert.jpg;
in
pkgs.stdenv.mkDerivation {
  name = "sddm-theme";
  src = pkgs.fetchFromGitHub {
    owner = "nautilor";
    repo = "nord-sddm";
    rev = "ad72c3c7048c8aabe85bab41cbeab5f3c4502250";
    sha256 = "02idn5hggbqc0j01vhxij5nh748sgva123103d5ir0nl676rl782";
  };
  installPhase = ''
       mkdir -p $out
       cp -R ./* $out
       # rm Background.jpg
       cp -r ${image} $out/Background.jpg
     '';
}
