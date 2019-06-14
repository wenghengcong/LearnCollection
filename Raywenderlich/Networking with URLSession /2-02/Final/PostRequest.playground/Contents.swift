import UIKit

let json = "{ 'hello' : 'world' }"
let url = URL(string: "http://httpbin.org/post")!
var request = URLRequest(url: url)

request.httpMethod = "Post"
request.httpBody = json.data(using: .utf8)

let session = URLSession(configuration: .default)
let task = session.dataTask(with: request) {
  
  (data, response, error) in
    if let data = data {
      if let postResponse = String(data: data, encoding: .utf8) {
        print(postResponse)
      }
    }
  
}
task.resume()
