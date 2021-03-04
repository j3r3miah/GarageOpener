// Created by jeremiah_boyle on 3/3/21.
// Copyright © 2021 Airbnb Inc. All rights reserved.

import Foundation

class GarageAPI : RequestProtocol {
  func isOpen(result: @escaping (Bool) -> ()) {
    let url = URL(string: "http://192.168.1.214/")!
    print("Fetching \(url)")

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
        let str = String(decoding: data, as: UTF8.self)
        /*
         let str = """
         <head><meta http-equiv="refresh" content="5"></head>
         <h2>Garage is OPEN<br><p>Toggle <a href="/O">Garage Opener</a><br><p>Toggle <a href="/B">Backlight</a><br><p>No Surprises (-67 dBm)<br></h2>

         """*/

        let regex = try! NSRegularExpression(pattern: #"Garage is (\w+)"#)
        let match = regex.firstMatch(in: str, options: [], range: NSRange(str.startIndex..., in: str))
        let range = match?.range(at:1)
        if let range = range {
          if let swiftRange = Range(range, in: str) {
            let word = str[swiftRange]
            print("Extracted: \(word)")
            result(word == "OPEN")
            return
          }
        }

        print("Failed to extract result")
      }
    })
    task.resume()
  }
  
  func toggleDoor(result: @escaping () -> ()) {
    let url = URL(string: "http://192.168.1.214/O")!
    print("Fetching \(url)")

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
