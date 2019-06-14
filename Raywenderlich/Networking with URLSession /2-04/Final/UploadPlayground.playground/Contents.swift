import UIKit

class SessionDelegate: NSObject, URLSessionDataDelegate {
  
  func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
    
    let progress = round(Float(totalBytesSent) / Float(totalBytesExpectedToSend) * 100)
    print("progress: \(progress) %")
    
  }
  
}

let image = UIImage(named: "mojave-day.jpg")
let imageData = image?.jpegData(compressionQuality: 1.0)
let uploadURL = URL(string: "http://127.0.0.1:5000/upload")!

var request = URLRequest(url: uploadURL)
request.httpMethod = "Post"

let session = URLSession(configuration: .default, delegate: SessionDelegate(), delegateQueue: OperationQueue.main)
let task = session.uploadTask(with: request, from: imageData) {
  
  (data, response, error) in
  let serverResponse = String(data: data!, encoding: .utf8)
  print(serverResponse!)
  
}

task.resume()
