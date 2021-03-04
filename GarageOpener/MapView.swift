// Created by jeremiah_boyle on 3/3/21.
// Copyright © 2021 Airbnb Inc. All rights reserved.

import SwiftUI
import MapKit

struct Place: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct MapView: View {
  @State private var home: Place = Place(coordinate: CLLocationCoordinate2D(latitude: 37.787687333149876, longitude: -122.4650735376832))

    @State private var region = MKCoordinateRegion(
      center: CLLocationCoordinate2D(latitude: 37.787687333149876, longitude: -122.4650735376832),
      span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    )

    var body: some View {
      Map(coordinateRegion: $region, annotationItems: [home]) { place in
        MapPin(coordinate: place.coordinate)
      }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
