{ pkgs }:

let
  imgLink = "https://github.com/Liam-Malone/nixos/modules/backgrounds/desert.jpg";
  image = pkgs.fetchurl {
    url = imgLink;
    sha256 = "";
  };
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
       rm Background.jpg
       cp -r ${image} $out/Background.jpg
     '';
}
