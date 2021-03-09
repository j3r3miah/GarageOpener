// Created by jeremiah_boyle on 3/3/21.
// Copyright © 2021 Airbnb Inc. All rights reserved.

import Foundation

class GarageAPI : RequestProtocol {
  var serviceFinder: ServiceFinder

  init(serviceFinder: ServiceFinder) {
    self.serviceFinder = serviceFinder
  }

  private func makeUrl(path: String = "") -> URL? {
    guard let ip = serviceFinder.ipAddress else {
      print("No IP found for service")
      return nil
    }
    let url = URL(string: "http://\(ip)/\(path)")!
    print("Fetching \(url)")
    return url
  }

  func isOpen(result: @escaping (Bool) -> ()) {
    guard let url = makeUrl(path: "api/status") else { return }
    let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
      if let error = error {
        print("Error with fetching films: \(error)")
        return
      }
      guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode) else {
        print("Error with the response, unexpected status code: \(response!)")
        return
      }
      if let data = data {
        // {"door": "closed", "timestamp": 1615248313, "rssi": -43}%
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        if let dictionary = json as? [String: Any] {
          if let state = dictionary["door"] as? String {
            result(state == "open")
          }
        }
      }
    })
    task.resume()
  }
  
  func toggleDoor(result: @escaping () -> ()) {
    guard let url = makeUrl(path: "api/activate") else { return }
    let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
      if let error = error {
        print("Error with fetching films: \(error)")
        return
      }
      guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode) else {
        print("Error with the response, unexpected status code: \(response!)")
        return
      }
      result()
    })
    task.resume()
  }
}
