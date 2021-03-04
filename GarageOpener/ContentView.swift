// Created by jeremiah_boyle on 2/27/21.
// Copyright © 2021 Airbnb Inc. All rights reserved.

import SwiftUI

struct ContentView: View {
  @ObservedObject var model: GarageModel

  var body: some View {
    VStack() {
      MapView()
        .ignoresSafeArea(edges: .top)
        .frame(height: 300)

      CircleImage()
        .offset(x: 95, y:-110)
        .padding(.bottom, -200)

      VStack(alignment: .leading) {
        Text("Garage Door")
          .font(.largeTitle)

        Text("Lake St - San Francisco, CA")
          .font(.subheadline)

        Divider()

        Spacer()

        HStack() {
          Spacer()

          Button(action: {
            model.toggleDoor()
          }) {
            VStack() {
              switch model.state {
              case .loading:
                ProgressView()
                  .progressViewStyle(CircularProgressViewStyle())
                  .scaleEffect(2.5, anchor: .center)
              case .closed, .idle:
                Image("closed").resizable()
              case .open:
                Image("open").resizable()
              }
            }
            .frame(width: 250, height:250)
          }
          .buttonStyle(CustomButtonStyle())
          .disabled(model.state == .loading)

          Spacer()
        }
        Spacer()
      }.padding()
      Spacer()
    }
    .onAppear() {
      model.load()
    }
  }
}

struct CustomButtonStyle: ButtonStyle {
  func makeBody(configuration: Self.Configuration) -> some View {
    return configuration.label
      .padding()
      .background(
        RoundedRectangle(cornerRadius: 16)
          .fill(Color.white)
          .shadow(radius: configuration.isPressed ? 1 : 6)
      )
      .foregroundColor(Color.white)
      .opacity(configuration.isPressed ? 0.5 : 1)
      .scaleEffect(configuration.isPressed ? 0.95 : 1)
      .animation(.easeInOut(duration: 0.2))
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(model: GarageModel(api: MockAPI()))
  }
}
