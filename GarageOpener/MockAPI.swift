// Created by jeremiah_boyle on 3/3/21.
// Copyright © 2021 Airbnb Inc. All rights reserved.

import Foundation

class MockAPI: RequestProtocol {
  var isOpen = false

  func isOpen(result: @escaping (Bool) -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
      result(self.isOpen)
    })
  }

  func toggleDoor(result: @escaping (Bool) -> ()) {
    isOpen = !isOpen
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
      result(self.isOpen)
    })
  }
}
