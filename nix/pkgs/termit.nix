with import <nixpkgs> {};
#{ stdenv, fetchurl, pkgconfig, cmake, gtk3, vte, lua, pcre}:
# to install:
# nix-env -f termit.nix -i
stdenv.mkDerivation {
  pname = "termit";

  src = fetchurl {
    url = "https://github.com/nonstop/termit/releases/download/termit-3.0/termit-3.0.tar.gz";
    sha256 = "085996581721a536f083353b48830a6194923ff6042c5b59a63d61805a213367";
  };

  # dirtyfix for compilation
  postUnpack = ''
    export cmakeFlags="-DXDG_DIR=/tmp"
    ''
  ;

  nativeBuildInputs = [ cmake pkgconfig];

  buildInputs = with stdenv.lib; [
    gtk3
    vte
    lua
    pcre
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/nonstop/termit";
    description = "Simple terminal emulator based on vte library, extensible via Lua.";
    license = licenses.gpl3;
    maintainers = with maintainers; [ nonstop ];
    platforms = with platforms; linux;
  };
}
