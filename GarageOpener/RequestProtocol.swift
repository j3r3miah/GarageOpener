// Created by jeremiah_boyle on 3/3/21.
// Copyright © 2021 Airbnb Inc. All rights reserved.

import Foundation

protocol RequestProtocol {
  func isOpen(result: @escaping (Bool) -> ())
  func toggleDoor(result: @escaping () -> ())
}
