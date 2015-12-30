import Foundation
import Commander
import Open

print(Registry().allFamilies()[0].fonts![1].sha256!)
test()
Group {
  $0.command("install",
  Flag("font", description: "Install a single font (Default)"),
  Flag("family", description: "Install a font family"),
    Argument<String>("fontName"),
    description: "Install a font"
  ) { font, family, fontName in
      if (family) {
        print("Installing font family: \(fontName)".green())
      } else {
      print("\u{2714}  Installing font: \(fontName)".green())
    }
  }

  $0.command("uninstall",
  Flag("font", description: "Uninstall a single font (Default)"),
  Flag("family", description: "Uninstall a font family"),
    Argument<String>("fontName"),
    description: "Uninstall a font"
  ) { font, family, fontName in
      if (family) {
        print("Uninstalling font family: \(fontName)")
      } else {
      print("Uninstalling font: \(fontName)")
    }}

    $0.command("preview",
    Flag("font", description: "Preview a single font (Default)"),
    Flag("family", description: "Preview a font family"),
      Argument<String>("fontName"),
      description: "Preview a font"
    ) { font, family, fontName in
        if (family) {
          print("Opening preview for font family: \(fontName)")
        } else {
        print("Opening preview for font: \(fontName)")
      }
  }}.run()
