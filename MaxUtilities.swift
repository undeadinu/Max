import Foundation
import Mustache
import Open

public struct Utilities {
  func FontsDirectory() -> NSURL {
    return NSFileManager.defaultManager().URLsForDirectory(.LibraryDirectory, inDomains: .UserDomainMask)[0].URLByAppendingPathComponent("Fonts")
  }

  func installedFonts()  {
    let filemanager:NSFileManager = NSFileManager()
    let fonts = filemanager.enumeratorAtPath(FontsDirectory().path!)
    var fontsArray = Array<AnyObject>()
    while let font = fonts?.nextObject() {
      if font.hasSuffix("ttf") {
        fontsArray.append(LocalFont(name: font.stringByDeletingPathExtension))
      }
    }
    print(fontsArray)
  }

  func fontIsInstalled(font: String) -> Bool {
    return NSFileManager().fileExistsAtPath(FontsDirectory().URLByAppendingPathComponent(font + ".ttf").path!)
  }

  func fontInfo(font: LocalFont, infoType : String) -> String {
    let username = NSUserName()
    let shellScript = "do shell script \"cd && cd ../\(username)/Library/Fonts && mdls \(font.name).ttf -name \(infoType) -raw\""
    var error: NSDictionary?
    if let scriptObject = NSAppleScript(source: shellScript) {
        if let output: NSAppleEventDescriptor = scriptObject.executeAndReturnError(
                                                                           &error) {
            return output.stringValue!
        }
    }
    return ""
  }
}

func fontSHA(data : NSData) -> String {
  let hash = data.sha256()
  let shaString = "\(hash)".stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "<>")).stringByReplacingOccurrencesOfString(" ", withString: "").stringByReplacingOccurrencesOfString("<", withString:"").stringByReplacingOccurrencesOfString(">", withString:"")
  return shaString
}

public func installFont(font: Font) {
  if (font.download != nil) {
  let installURL = Utilities().FontsDirectory().URLByAppendingPathComponent(font.name! + ".ttf")
  var fontData : NSData = NSData()
  do {
    fontData = try NSData(contentsOfURL: font.download!, options: NSDataReadingOptions())
  } catch {}
if fontSHA(fontData).rangeOfString(font.sha256!) != nil {
    fontData.writeToURL(installURL, atomically: false)
    print("\u{2713} Installed font: \(font.name!)".green())
} else {
  print("\u{2717} Max can not verify the integrity of this font. The SHA256 hash does not match the one generated.".red())
}
} else {
  print("\u{2717} Could not find font \"\(font.name!)\" in the registry. Browse the registry at https://github.com/Colton/Max/tree/master/.Registry".red())
}
}

public func uninstallFont(font: Font) {
  if (NSFileManager.defaultManager().fileExistsAtPath(Utilities().FontsDirectory().URLByAppendingPathComponent(font.name! + ".ttf").path!)) {
  do {
    try NSFileManager.defaultManager().removeItemAtURL(Utilities().FontsDirectory().URLByAppendingPathComponent(font.name! + ".ttf"))
  } catch {}
} else {
  print("⚠️  Font is not installed.".yellow())
}
}

public func uninstallFamily(family: Family) {
  
}


public func installFamily(family: Family) {
  if (family.name != "") {
    for font in family.fonts! {
      installFont(font)
    }
    print("\u{2713} Installed family: \(family.name!)".green())
  } else {
    print("\u{2717} Could not find family \"\(family.name!)\" in the registry. Browse the registry at https://github.com/Colton/Max/tree/master/.Registry".red())
  }
}


public func previewFont(font: Font) {
  if (font.download != nil) {
  let template : Template
  do {
   template = try Template(string: String(data: NSData(contentsOfURL: NSURL(string: "https://raw.githubusercontent.com/Colton/Max/master/.Preview/preview.html")!)!, encoding: NSUTF8StringEncoding)!)
   let data : [String : String] = ["name": font.name!, "download": font.download!.absoluteString]
   do {
     let rendering = try template.render(Box(data))
     let base64string = rendering.dataUsingEncoding(NSUTF8StringEncoding)!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
     let base64template = "data:text/html;base64," + base64string
     let shellScript = "tell application \"Safari\"\nactivate\nopen location \"\(base64template)\"\nend tell"
     var error: NSDictionary?
     if let scriptObject = NSAppleScript(source: shellScript) {
      scriptObject.executeAndReturnError(&error)
     }
   } catch _ {}
  } catch _ {}
} else {
  print("\u{2717} Could not find font \"\(font.name!)\"in the registry. Browse the registry at https://github.com/Colton/Max/tree/master/.Registry".red())
}
}

public func previewFamily(family: Family) {
  if (family.name != "") {
  let template : Template
  do {
   template = try Template(string: String(data: NSData(contentsOfURL: NSURL(string: "https://raw.githubusercontent.com/Colton/Max/master/.Preview/familypreview.html")!)!, encoding: NSUTF8StringEncoding)!)
   let data : [String : AnyObject] = ["name": family.name!, "fonts": family.fonts!]
   do {
     let rendering = try template.render(Box(data))
     let base64string = rendering.dataUsingEncoding(NSUTF8StringEncoding)!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
     let base64template = "data:text/html;base64," + base64string
     let shellScript = "tell application \"Safari\"\nactivate\nopen location \"\(base64template)\"\nend tell"
     var error: NSDictionary?
     if let scriptObject = NSAppleScript(source: shellScript) {
      scriptObject.executeAndReturnError(&error)
     }
   } catch _ {}
  } catch _ {}
} else {
  print("\u{2717} Could not find family \"\(family.name)\" in the registry. Browse the registry at https://github.com/Colton/Max/tree/master/.Registry".red())
}
}



public class LocalFont {
  var name = ""
  var location = NSURL()

  var copyright = ""
  var family = ""

  init() {}

  init(name : String) {
    self.name = name
    self.location = Utilities().FontsDirectory().URLByAppendingPathComponent("\(name).ttf")
    self.copyright = Utilities().fontInfo(self, infoType: "kMDItemCopyright")
    self.family = Utilities().fontInfo(self, infoType: "com_apple_ats_name_family").componentsSeparatedByString("\"")[1] // Removes the quotes around the family array
    }
}

public class Font : MustacheBoxable {

    public let name: String?

    public var download: NSURL?

    public let sha256: String?

    public var mustacheBox: MustacheBox {
        return Box(["name": self.name, "download" : self.download!.absoluteString])
    }

    public init(name: String?, download: NSURL?, sha256: String?) {
        self.name = name
        self.download = download
        self.sha256 = sha256
    }
}

public class Family {

    public let name: String?
    public var fonts: [Font]?

    public init(name: String?, fonts: [Font]?) {
        self.name = name
        self.fonts = fonts
    }
}

// String extensions for colors in the terminal output
public extension String {

  // bold
  func bold() -> String {
      return "\u{001B}[1m"+self+"\u{001B}[22m"
  }

  // italic
  func italic() -> String {
      return "\u{001B}[3m"+self+"\u{001B}[23m"
  }

  // underline
  func underline() -> String {
      return "\u{001B}[4m"+self+"\u{001B}[24m"
  }

  // inverse
  func inverse() -> String {
      return "\u{001B}[7m"+self+"\u{001B}[27m"
  }

  // strikethough
  func strikethrough() -> String {
      return "\u{001B}[9m"+self+"\u{001B}[29m"
  }

  // set foreground color to black
  func black() -> String {
      return "\u{001B}[30m"+self+"\u{001B}[0m"
  }

  //　set foreground color to red
  func red() -> String {
      return "\u{001B}[31m"+self+"\u{001B}[0m"
  }

  //  set foreground color to green
  func green() -> String {
      return "\u{001B}[32m"+self+"\u{001B}[0m"
  }

  //    set foreground color to yellow
  func yellow() -> String {
      return "\u{001B}[33m"+self+"\u{001B}[0m"
  }

  //    set foreground color to blue
  func blue() -> String {
      return "\u{001B}[34m"+self+"\u{001B}[0m"
  }

  //    set foreground color to magenta
  func magenta() -> String {
      return "\u{001B}[35m"+self+"\u{001B}[0m"
  }

  //    set foreground color to cyan
  func cyan() -> String {
      return "\u{001B}[36m"+self+"\u{001B}[0m"
  }

  //    set foreground color to white
  func white() -> String {
      return "\u{001B}[37m"+self+"\u{001B}[0m"
  }

  //    set foreground color to white
  func defaultColor() -> String {
      return "\u{001B}[39m"+self+"\u{001B}[0m"
  }


  //    set background color to green
  func bgBlack() -> String {
      return "\u{001B}[40m"+self+"\u{001B}[0m"
  }

  //    set background color to green
  func bgRed() -> String {
      return "\u{001B}[41m"+self+"\u{001B}[0m"
  }

  //    set background color to green
  func bgGreen() -> String {
      return "\u{001B}[42m"+self+"\u{001B}[0m"
  }

  //    set background color to yellow
  func bgYellow() -> String {
      return "\u{001B}[43m"+self+"\u{001B}[0m"
  }
      //    set background color to blue
  func bgBlue() -> String {
      return "\u{001B}[44m"+self+"\u{001B}[0m"
  }

  //    set background color to magenta
  func bgMagenta() -> String {
      return "\u{001B}[45m"+self+"\u{001B}[0m"
  }

  //    set background color to cyan
  func bgCyan() -> String {
      return "\u{001B}[46m"+self+"\u{001B}[0m"
  }

  //    set background color to white
  func bgWhite() -> String {
      return "\u{001B}[47m"+self+"\u{001B}[0m"
  }

  //    set background color to default
  func bgDefaultColor() -> String {
      return "\u{001B}[49m"+self+"\u{001B}[0m"
  }
}
