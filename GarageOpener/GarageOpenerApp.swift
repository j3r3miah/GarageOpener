// Created by jeremiah_boyle on 3/4/21.
// Copyright © 2021 Airbnb Inc. All rights reserved.

import SwiftUI

@main
struct GarageOpenerApp: App {
  var body: some Scene {
    WindowGroup {
      let finder = ServiceFinder(serviceName: "garage")
      ContentView(model: GarageModel(api: GarageAPI(serviceFinder: finder)))
    }
  }
}
