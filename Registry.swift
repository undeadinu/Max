import Foundation
import SwiftyJSON
import CryptoSwift
public class Registry {

  public let url = NSURL(string: "https://api.github.com/repos/colton/max/contents/.Registry")

  public func allFonts() {
    let data = NSData(contentsOfURL: url!.URLByAppendingPathComponent("Fonts"))
    let json = JSON(data: data!)
    var i = 0
    var fontsArray : [Font] = []
    for _ in json {
      let fontData = NSData(contentsOfURL: NSURL(string: json[i]["download_url"].string!)!)
      let fontJSON = JSON(data: fontData!)
      fontsArray.append(Font(name: fontJSON["name"].string, download: fontJSON["download"].string, sha256: fontJSON["sha256"].string))
      i++
    }

    print(fontsArray)
    for i in fontsArray {
      print(i.name)
    }

  }

  public func fontSHA(data : NSData) -> String {
    let hash = data.sha256()
    let shaString = "\(hash)".stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "<>")).stringByReplacingOccurrencesOfString(" ", withString: "")
    return shaString
  }
}
