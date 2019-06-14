import UIKit

let sharedSession = URLSession.shared
sharedSession.configuration.allowsCellularAccess
sharedSession.configuration.allowsCellularAccess = false
sharedSession.configuration.allowsCellularAccess

let myDefaultConfiguration = URLSessionConfiguration.default
//A session configuration that uses no persistent storage for caches, cookies, or credentials.
let eConfig = URLSessionConfiguration.ephemeral
let bConfig = URLSessionConfiguration.background(withIdentifier: "com.raywenderlich.sessions")

myDefaultConfiguration.allowsCellularAccess = false
myDefaultConfiguration.allowsCellularAccess
myDefaultConfiguration.waitsForConnectivity = true

let myDefaultSession = URLSession(configuration: myDefaultConfiguration)
myDefaultSession.configuration.allowsCellularAccess

let defaultSession = URLSession(configuration: .default)
defaultSession.configuration.allowsCellularAccess
