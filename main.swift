import Foundation
import Commander
import Open

//Utilities().FontsDirectory().open()
print(Utilities().fontIsInstalled("FiraMono-Regular"))

let reg = Registry(url: NSURL(string: "https://github.com/mozilla/Fira/blob/master/")!)

if let data = NSData(contentsOfURL: NSURL(string: "http://s000.tinyupload.com/download.php?file_id=04927064231429684987&t=0492706423142968498762360")!) { // may return nil, too
  let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
  print(json)
    }
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
      print("Installing font: \(fontName)".green())
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
