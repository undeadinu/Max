import Foundation
import SwiftyJSON
public class Registry {

  public let url = NSURL(string: "https://api.github.com/repos/colton/max/contents/.Registry")

  func allFonts() {
  let data = NSData(contentsOfURL: url!)

  let json = JSON(data: data!)
if let test = json[0]["name"].string {
  print(test)
}
  }
}
