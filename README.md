# nvim

My Neovim configuration.

## Homebrew dependencies

Install the tools this config expects with:

```sh
brew install neovim tree-sitter-cli lua luarocks ripgrep
```

Notes:

- `tree-sitter-cli` is required so `nvim-treesitter` can compile parsers.
- `lua` and `luarocks` are used by parts of the Neovim ecosystem and local tooling.
- `ripgrep` is used for fast searching and picker integrations.

## Ubuntu dependencies

Install the system packages first with:

```sh
sudo apt update
sudo apt install -y neovim lua5.4 luarocks ripgrep cargo
```

Install the Treesitter CLI with:

```sh
cargo install tree-sitter-cli
```

Notes:

- `tree-sitter-cli` is required so `nvim-treesitter` can compile parsers.
- `cargo` is included because Ubuntu typically does not package a current `tree-sitter-cli` binary directly.
