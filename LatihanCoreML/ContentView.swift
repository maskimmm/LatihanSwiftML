//
//  ContentView.swift
//  LatihanCoreML
//
//  Created by Rifqi Alhakim Hariyantoputera on 29/07/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack{
            NavigationLink{
                TextBasedView()
            } label: {
                Text("ML Text Based")
            }
            NavigationLink{
                ImageBasedView()
            } label: {
                Text("ML Image Based")
            }
            NavigationLink{
                CameraBasedView()
            } label: {
                Text("ML Realtime Video Based")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            ContentView()
        }
    }
}
