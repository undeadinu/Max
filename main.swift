import Foundation
import Commander
import Open

//Utilities().FontsDirectory().open()
//print(Utilities().fontIsInstalled("FiraMono-Regular"))

//print(reg.url.open())
/*
let filemanager:NSFileManager = NSFileManager()
let fonts = filemanager.enumeratorAtPath(reg.url.path!)
var fontsArray = Array<AnyObject>()
while let font = fonts?.nextObject() {
  if font.hasSuffix("ttf") {
  //  print(font)
  }
}*/
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
    }
  }}.run()
