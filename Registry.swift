import Foundation

public class Registry {

  public var url = NSURL()

  init() {}

  init(url: NSURL) {
    self.url = url
  }
}
