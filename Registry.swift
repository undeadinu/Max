import Foundation
import SwiftyJSON
import CryptoSwift

public class Registry {

  public let url = NSURL(string: "https://api.github.com/repos/colton/max/contents/.Registry")

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

  public func font(name: String) -> Font {
    let data = NSData(contentsOfURL: url!.URLByAppendingPathComponent("Fonts/\(name).json"))
    let info = JSON(data: data!)
    let fontData = NSData(contentsOfURL: NSURL(string: info["download_url"].string!)!)
    let font = JSON(data: fontData!)

    return Font(name: font["name"].string, download: NSURL(string: font["download"].string!), sha256: font["sha256"].string)
  }

  func fontSHA(data : NSData) -> String {
    let hash = data.sha256()
    let shaString = "\(hash)".stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "<>")).stringByReplacingOccurrencesOfString(" ", withString: "")
    return shaString
  }
}
