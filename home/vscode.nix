{ config, ... }:

{
  programs.vscode = {
    enable = true;
    userSettings = {
      "editor.formatOnSave" = true;
      "editor.formatOnSaveMode" = "modifications";
      "telemetry.telemetryLevel" = "off";
      "[nix]" = {
        "editor.insertSpaces" = true;
        "editor.tabSize" = 2;
        "editor.autoIndent" = "full";
        "files.trimTrailingWhitespace" = true;
        "editor.formatOnSaveMode" = "file";
      };
      "editor.rulers" = [ 80 ];
      "workbench.tree.renderIndentGuides" = "always";
      "scm.inputFontSize" = 11;
      # "window.zoomLevel" = -0.75;
      "editor.fontFamily" = "'monospace'";
      "editor.fontSize" = 14;
      "workbench.colorTheme" = "Default Dark+";
      "terminal.integrated.fontSize" = 14;
      "rust-analyzer.inlayHints.parameterHints.enable" = false;
      "rust-analyzer.inlayHints.typeHints.enable" = false;
      "rust-analyzer.inlayHints.bindingModeHints.enable" = true;
      "workbench.colorCustomizations" = {
        "[Default Dark+]" = {
          "editorInlayHint.foreground" = "#868686f0";
          "editorInlayHint.background" = "#18181800";
          # Overrides for specific kinds of inlay hints
          "editorInlayHint.typeForeground" = "#486148f0";
          "editorInlayHint.parameterForeground" = "#486148f0";
        };
      };
      "[cpp]" = {
        "editor.wordBasedSuggestions" = false;
        "editor.suggest.insertMode" = "replace";
        "editor.semanticHighlighting.enabled" = true;
      };
    };
  };
}
