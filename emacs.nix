{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    bash-language-server
    cargo
    clang-tools
    dockerfile-language-server
    dockerfmt
    go
    gopls
    graphviz
    lldb
    nerd-fonts.jetbrains-mono
    nixd
    nixfmt
    pyright
    ruff
    rust-analyzer
    rustc
    rustfmt
    sbcl
    shellcheck
    shfmt
    sqlite
    yaml-language-server
    yamlfmt
  ];
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk;
    extraPackages =
      epkgs: with epkgs; [
        all-the-icons
        apheleia
        catppuccin-theme
        consult
        corfu
        dap-mode
        dashboard
        dockerfile-mode
        embark
        embark-consult
        flycheck
        ghostel
        go-mode
        justl
        lsp-mode
        lsp-pyright
        lsp-ui
        magit
        marginalia
        nix-mode
        orderless
        org-appear
        org-modern
        paredit
        rainbow-delimiters
        rust-mode
        spacious-padding
        treesit-grammars.with-all-grammars
        use-package
        vertico
        which-key
        yaml-mode
      ];
    extraConfig = builtins.readFile ./init.el;
  };
}
