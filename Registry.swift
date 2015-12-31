import Foundation
import SwiftyJSON
import CryptoSwift

public class Registry {

  public let url = NSURL(string: "https://api.github.com/repos/colton/max/contents/.Registry")

  // MARK: -  Individual font functions
  public func allFonts() -> [Font] {
    let data = NSData(contentsOfURL: url!.URLByAppendingPathComponent("Fonts"))
    let json = JSON(data: data!)
    var i = 0
    var fontsArray : [Font] = []
    for _ in json {
      let fontData = NSData(contentsOfURL: NSURL(string: json[i]["download_url"].string!)!)
      let fontJSON = JSON(data: fontData!)
      fontsArray.append(Font(name: fontJSON["name"].string, download: NSURL(string: fontJSON["download"].string!), sha256: fontJSON["sha256"].string))
      i++
    }
    return fontsArray
  }

  public func family(name: String) -> Family {
    let data = NSData(contentsOfURL: url!.URLByAppendingPathComponent("Families/\(name).json"))
    if (data != nil) {
      let info = JSON(data: data!)
      let familyData = NSData(contentsOfURL: NSURL(string: info["download_url"].string!)!)
      let family = JSON(data: familyData!)
      var fontsArray : [Font] = []
      var i = 0
      for _ in family["fonts"].arrayValue {
        fontsArray.append(font(family["fonts"][i].stringValue))
        i++
    }
    return Family(name: family["name"].string, fonts: fontsArray)
  } else {
    return Family(name: "", fonts: [])
    }
  }

  public func font(name: String) -> Font {
    let data = NSData(contentsOfURL: url!.URLByAppendingPathComponent("Fonts/\(name).json"))

    if (data != nil) {
      let info = JSON(data: data!)
      let fontData = NSData(contentsOfURL: NSURL(string: info["download_url"].string!)!)
      let font = JSON(data: fontData!)

      return Font(name: font["name"].string, download: NSURL(string: font["download"].string!), sha256: font["sha256"].string)
    } else {
      return Font(name: "", download: NSURL(), sha256 : "")
    }
  }

  func fontSHA(data : NSData) -> String {
    let hash = data.sha256()
    let shaString = "\(hash)".stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "<>")).stringByReplacingOccurrencesOfString(" ", withString: "")
    return shaString
  }

  // MARK: - Font family functions
  func allFamilies() -> [Family] {
    let data = NSData(contentsOfURL: url!.URLByAppendingPathComponent("Families"))
    let json = JSON(data: data!)
    var i = 0
    var familiesArray : [Family] = []
    for _ in json {
      let fontData = NSData(contentsOfURL: NSURL(string: json[i]["download_url"].string!)!)
      let fontJSON = JSON(data: fontData!)

      var fontsArray : [Font] = []
      for fontName in fontJSON["fonts"].arrayValue {
        fontsArray.append(font(fontName.string!))
      }
      familiesArray.append(Family(name: fontJSON["name"].string, fonts: fontsArray))
      i++
    }
    return familiesArray
  }

}
