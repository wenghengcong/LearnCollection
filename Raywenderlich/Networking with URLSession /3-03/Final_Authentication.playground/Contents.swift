import UIKit

import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true
//: ## Authentication: How to login to get an authentication token
let config = URLSessionConfiguration.default
config.waitsForConnectivity = true
let session = URLSession(configuration: config)

//: Endpoints for web app:
let baseURL = URL(string: "https://tilftw.herokuapp.com/")
let newUserEndpoint = URL(string: "users", relativeTo: baseURL)
let loginEndpoint = URL(string: "login", relativeTo: baseURL)
let newEndpoint = URL(string: "new", relativeTo: baseURL)

//: `Codable` structs for User, Acronym, Auth:
struct User: Codable {
  let name: String
  let email: String
  let password: String
}

struct Acronym: Codable {
  let short: String
  let long: String
}

struct Auth: Codable {
  let token: String
}

let encoder = JSONEncoder()
let decoder = JSONDecoder()

//: Prep a new user
let user = User(name: "jo", email: "jo@razeware.com", password: "password")

let loginString = "\(user.email):\(user.password)"
let loginData = loginString.data(using: .utf8)
let encodedString = loginData!.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))

var loginRequest = URLRequest(url: loginEndpoint!)
loginRequest.httpMethod = "Post"

loginRequest.allHTTPHeaderFields = [
  "accept": "application/json",
  "content-type": "application/json",
  "authorization": "Basic \(encodedString)"
]

var auth = Auth(token: "")
session.dataTask(with: loginRequest) {
  
  (data, response, error) in
    guard let response = response,
          let data = data else { PlaygroundPage.current.finishExecution() }
    print(response)
  
    do {
      auth = try decoder.decode(Auth.self, from: data)
      auth.token
    } catch let decodeError as NSError {
      print("Decoder error: \(decodeError.localizedDescription)\n")
      return
    }
  
    var tokenAuthRequest = URLRequest(url: newEndpoint!)
    tokenAuthRequest.httpMethod = "Post"
    tokenAuthRequest.allHTTPHeaderFields = [
      "accept": "application/json",
      "content-type": "application/json",
      "authorization": "Bearer \(auth.token)"
    ]
  
    let acronym = Acronym(short: "DOG", long: "Dutifully On Guard")
    do {
      tokenAuthRequest.httpBody = try encoder.encode(acronym)
    } catch let encodeError as NSError {
      print("Encoder error: \(encodeError.localizedDescription)\n")
      PlaygroundPage.current.finishExecution()
    }
  
    session.dataTask(with: tokenAuthRequest) {
      (_, response, _) in
        guard let response = response else { PlaygroundPage.current.finishExecution() }
        print(response)
        PlaygroundPage.current.finishExecution()
    }.resume()
}.resume()

