{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    cargo
    clang-tools
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
    sqlite
  ];

  programs.emacs = {
    enable = true;
    package = pkgs.emacs;
    extraPackages =
      epkgs: with epkgs; [
        all-the-icons
        apheleia
        catppuccin-theme
        consult
        corfu
        dap-mode
        dashboard
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
        org-roam
        org-roam-ui
        paredit
        rainbow-delimiters
        rust-mode
        spacious-padding
        treesit-grammars.with-all-grammars
        use-package
        vertico
        websocket
        which-key
      ];
    extraConfig = builtins.readFile ./init.el;
  };
}
