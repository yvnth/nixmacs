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
    pyright
    rust-analyzer
    rustc
    sbcl
    sqlite
  ];

  programs.emacs = {
    enable = true;
    package = pkgs.emacs;
    extraPackages =
      epkgs: with epkgs; [
        all-the-icons
        catppuccin-theme
        company
        consult
        dap-mode
        dashboard
        embark
        embark-consult
        flycheck
        ghostel
        go-mode
        lsp-mode
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
