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
