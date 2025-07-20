# Installs all terminal apps that are meant to be shared between host and
# container. Install from inside the devcontainer, because that has the
# libraries needed to compile.
distrobox-enter bx -- bash <<EOF
    # Install Rust
    if ! command -v rustup >/dev/null; then
        # Install rustup and Rust stable
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
        rustup default stable
        rustup update
        echo "Installed Rust"
    else
        echo "Rust is already installed."
    fi

    # Set up cargo config
    if [ ! -d "$HOME/.cargo/config.toml" ]; then
      mkdir -p ~/.cargo
      cp ~/.local/share/omakase-blue/configs/cargo.toml ~/.cargo/config.toml
    fi

    # Set up rustfmt config
    if [ ! -d "$HOME/.config/rustfmt/rustfmt.toml" ]; then
      mkdir -p ~/.config/rustfmt
      cp ~/.local/share/omakase-blue/configs/rustfmt.toml ~/.config/rustfmt/rustfmt.toml
    fi

    # Install binstall first
    curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash

    cargo binstall -y --locked \
        bunyan \
        cargo-audit \
        cargo-bloat \
        cargo-deny \
        cargo-edit \
        cargo-leptos \
        cargo-nextest \
        cargo-semver-checks \
        cargo-update \
        dircnt \
        ffsend \
        flamegraph \
        git-stats \
        gping \
        leptosfmt \
        numbat-cli \
        openring \
        pgen \
        ren-find \
        rep-grep \
        rimage \
        sqlx-cli \
        star-history \
        talk-timer \
        titlecase \
        toml-fmt \
        typeracer \
        wasm-bindgen-cli

    cargo install --git https://github.com/lukehsiao/tool.git --locked

    # Install tooling for leptos
    rustup target add wasm32-unknown-unknown

    # Install rust-analyzer
    rustup component add rust-analyzer
EOF

echo "Installed all core rust tooling."

brew install make

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# For git grab
mkdir -p ~/repos
