// Created by jeremiah_boyle on 3/3/21.
// Copyright © 2021 Airbnb Inc. All rights reserved.

import Foundation

class GarageModel : ObservableObject {
  enum State {
    case idle, loading, closed, open
  }

  @Published private(set) var state = State.loading

  private let api: RequestProtocol

  init(api: RequestProtocol) {
    self.api = api
  }

  func load() {
    state = .loading
    api.isOpen() { [weak self] isOpen in
      self?.state = isOpen ? .open : .closed
    }
  }

  func toggleDoor() {
    state = .loading
    api.toggleDoor() { [weak self] isOpen in
      self?.state = isOpen ? .open : .closed
    }
  }
}
