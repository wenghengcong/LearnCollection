import UIKit

let url = URL(string: "http://www.google.com")!
let request = URLRequest(url: url)

URLSession.shared.dataTask(with: request) {
  (data, response, error) in
    if let httpResponse = response as? HTTPURLResponse,
       let fields = httpResponse.allHeaderFields as? [String: String] {
    
      let cookies = HTTPCookie.cookies(withResponseHeaderFields: fields, for: url)
      if let cookie = cookies.first {
        print("cookie name: \(cookie.name)")
        print("cookie value: \(cookie.value)")
        
        var cookieProperties: [HTTPCookiePropertyKey: Any] = [:]
        cookieProperties[.name] = cookie.name
        cookieProperties[.value] = cookie.value
        cookieProperties[.domain] = cookie.domain
        
        if let myCookie = HTTPCookie(properties: cookieProperties) {
          HTTPCookieStorage.shared.setCookie(myCookie)
          HTTPCookieStorage.shared.deleteCookie(myCookie)
        }
        
      }
    }
}.resume()


