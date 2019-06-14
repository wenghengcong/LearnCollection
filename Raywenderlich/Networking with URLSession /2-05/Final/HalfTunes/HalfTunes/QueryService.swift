/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation

// Runs query data task, and stores results in array of Tracks
class QueryService {

  typealias QueryResult = ([Track]?, String) -> ()
  var tracks: [Track] = []
  var errorMessage = ""

  // SearchViewController creates defaultSession
  lazy var defaultSession: URLSession = {
    let config = URLSessionConfiguration.default
    config.waitsForConnectivity = true
    return URLSession(configuration: config)
  }()
  var dataTask: URLSessionDataTask?
  let decoder = JSONDecoder()

  func getSearchResults(searchTerm: String, completion: @escaping QueryResult) {
    dataTask?.cancel()

    guard var urlComponents = URLComponents(string: "https://itunes.apple.com/search")
      else { return }
    urlComponents.query = "media=music&entity=song&term=\(searchTerm)"
    guard let url = urlComponents.url else { return }

    dataTask = defaultSession.dataTask(with: url) { data, response, error in
      defer { self.dataTask = nil }
      if let error = error {
        self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
      } else if let data = data,
        let response = response as? HTTPURLResponse,
        response.statusCode == 200 {
        self.updateSearchResults(data)
        DispatchQueue.main.async {
          completion(self.tracks, self.errorMessage)
        }
      }
    }
    dataTask?.resume()
  }

  // MARK: - Helper methods
  fileprivate func updateSearchResults(_ data: Data) {
    tracks.removeAll()
    do {
      let list = try decoder.decode(TrackList.self, from: data)
      tracks = list.results
    } catch let decodeError as NSError {
      errorMessage += "Decoder error: \(decodeError.localizedDescription)"
      return
    }
  }

}


