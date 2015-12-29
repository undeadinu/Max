import Foundation
import SwiftyJSON
import CryptoSwift
public class Registry {

  public let url = NSURL(string: "https://api.github.com/repos/colton/max/contents/.Registry")

  func allFonts() {
  let data = NSData(contentsOfURL: url!.URLByAppendingPathComponent("Fonts"))
  let json = JSON(data: data!)
  var i = 0
  for _ in json {
    print(json[i]["sha"])
    let fontData = NSData(contentsOfURL: NSURL(string: "https://raw.githubusercontent.com/Colton/Max/master/.Registry/Fonts/FiraMono-Regular.json")!)
    let fontJSON = JSON(data: fontData!)
    if let download = fontJSON["url"].string {
      let font = NSData(contentsOfURL: NSURL(string:fontJSON["url"].string!)!)
      print(font!.sha256())
}
    i++
  }
  }
}
