// Created by jeremiah_boyle on 3/3/21.
// Copyright © 2021 Airbnb Inc. All rights reserved.

import Foundation

class GarageModel : ObservableObject {
  enum State {
    case idle, closed, open
  }
  
  @Published private(set) var state = State.idle
  @Published private(set) var lastUpdate: String?
  @Published private(set) var lastToggle: String?
  @Published private(set) var loading = false
  
  private let api: RequestProtocol
  private let updateInterval = TimeInterval(1)
  
  private lazy var timer: DispatchSourceTimer = {
    let t = DispatchSource.makeTimerSource()
    t.schedule(deadline: .now(), repeating: self.updateInterval)
    t.setEventHandler(handler: { [weak self] in self?.load() })
    return t
  }()
  
  private lazy var dateFormatter: DateFormatter = {
    var fmt = DateFormatter()
    fmt.dateStyle = .long
    fmt.timeStyle = .medium
    return fmt
  }()
  
  init(api: RequestProtocol) {
    self.api = api
    timer.resume()
  }
  
  func load() {
    DispatchQueue.main.async {
      self.loading = true
    }
    print("[model] loading door state")
    api.isOpen() { [weak self] isOpen in
      if let model = self {
        model.state = isOpen ? .open : .closed
        model.lastUpdate = self?.dateFormatter.string(from: Date())
        model.loading = false
        print("[model] door state = \(model.state)")
      }
    }
  }
  
  func toggleDoor() {
    print("[model] toggling door")
    api.toggleDoor() { [weak self] () in
      if let model = self {
        model.lastToggle = self?.dateFormatter.string(from: Date())
        print("[model] toggled door")
      }
    }
  }
}
