import Foundation
import SwiftyJSON
import CryptoSwift
public class Registry {

  public let url = NSURL(string: "https://api.github.com/repos/colton/max/contents/.Registry")

  public func allFonts() {
  let data = NSData(contentsOfURL: url!.URLByAppendingPathComponent("Fonts"))
  let json = JSON(data: data!)
  var i = 0
  var fontsArray = []
  for _ in json {
    let fontData = NSData(contentsOfURL: NSURL(string: "https://raw.githubusercontent.com/Colton/Max/master/.Registry/Fonts/FiraMono-Regular.json")!)
    let fontJSON = JSON(data: fontData!)
    if let _ = fontJSON["url"].string {
      let font = NSData(contentsOfURL: NSURL(string:fontJSON["url"].string!)!)
      print(fontSHA(font!))
}
    i++
  }
  }

  public func fontSHA(data : NSData) -> String {
    let hash = data.sha256()
    let shaString = "\(hash)".stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "<>")).stringByReplacingOccurrencesOfString(" ", withString: "")
    return shaString
  }
}
