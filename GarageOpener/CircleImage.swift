// Created by jeremiah_boyle on 3/3/21.
// Copyright © 2021 Airbnb Inc. All rights reserved.

import SwiftUI

struct CircleImage: View {
    var body: some View {
        Image("garage")
          .resizable()
          .scaledToFit()
          .frame(width: 180, height:180)
          .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
          .overlay(Circle().stroke(Color.white, lineWidth: 4))
          .shadow(radius: 7)
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage()
    }
}
