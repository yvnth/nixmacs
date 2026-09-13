{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    bash-language-server
    cargo
    clang-tools
    direnv
    dockerfile-language-server
    dockerfmt
    go
    gopls
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
        docker
        dockerfile-mode
        embark
        embark-consult
        envrc
        flycheck
        ghostel
        go-mode
        just-ts-mode
        justl
        lsp-mode
        lsp-pyright
        lsp-ui
        magit
        marginalia
        nix-mode
        orderless
        org-appear
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
