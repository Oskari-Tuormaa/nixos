# Glyphie: libcosmic-native emoji picker for COSMIC/Wayland
{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  just,
  pkg-config,
  libxkbcommon,
  wayland,
  libdrm,
  wl-clipboard,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "glyphie";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "lkbddh";
    repo = "glyphie";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GkzH9SsJ8p80eilGqRkwlq5u681Jb64UXVruYxJpA/A=";
  };

  cargoHash = "sha256-iLiVHWyQgH/3OF6wOo1QHdhY+Q9ZqnIVXct3VAICXQc=";

  nativeBuildInputs = [
    just
    pkg-config
    libcosmicAppHook
  ];

  buildInputs = [
    libxkbcommon
    wayland
    libdrm
  ];

  # The justfile's build/check recipes would redo what cargo already did
  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "cargo-target-dir"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}"
  ];

  # wl-copy keeps the clipboard contents alive after the picker exits
  preFixup = ''
    libcosmicAppWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ wl-clipboard ]})
  '';

  meta = {
    homepage = "https://github.com/lkbddh/glyphie";
    description = "Fast, lightweight emoji picker for COSMIC/Wayland";
    mainProgram = "glyphie";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
