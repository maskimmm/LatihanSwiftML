//
//  ImageBasedView.swift
//  LatihanCoreML
//
//  Created by Rifqi Alhakim Hariyantoputera on 04/08/23.
//

import SwiftUI
import Combine
import PhotosUI

struct ImageBasedView: View {
    @StateObject var vm = ImageBasedViewModel()
    var body: some View {
        VStack{
            HStack{
                PhotosPicker("Select Photo Item", selection: $vm.photoPickerItem, matching: .images)
                Spacer()
                Button{
                    if vm.uiImage != nil {
                        vm.detectObject(uiImage: vm.uiImage!, confidence: 0.7)
                    }
                } label: {
                    Text("Detect Object")
                }
                .disabled(vm.uiImage != nil ? false : true)
            }
            
            Spacer()
            
            if vm.uiImage != nil {
                Image(uiImage: vm.uiImage!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: vm.screenSize.width * 0.8, height: vm.screenSize.height * 0.6)
                    .background(.black)
                    .overlay {
                        if !vm.detectedObject.isEmpty {
                            ForEach(0..<vm.detectedObject.count, id: \.self){ index in
                                let color = Color(red: Double.random(in: 0...255)/255, green: Double.random(in: 0...255)/255, blue: Double.random(in: 0...255)/255)
                                ZStack(alignment: .topLeading){
                                    Text(" \(vm.detectedObject[index].labels.first?.identifier ?? "Unknown"): \(vm.detectedObject[index].confidence.formatted()) ")
                                        .fontWeight(.medium)
                                        .foregroundColor(.white)
                                        .background(color)
                                    RoundedRectangle(cornerRadius: 0)
                                        .stroke(color, lineWidth:5)
                                }
                                .frame(width: vm.detectedObject[index].boundingBox.size.width * (vm.screenSize.width * 0.8), height: vm.detectedObject[index].boundingBox.size.height * (vm.screenSize.height * 0.6))
                                .position(x: vm.detectedObject[index].boundingBox.midX * (vm.screenSize.width * 0.8), y: vm.detectedObject[index].boundingBox.midY * (vm.screenSize.height * 0.6))
                            }
                        }
                    }
            }
            
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.size.width * 0.9)
        .onChange(of: vm.photoPickerItem) { _ in
            Task {
                if let data = try? await vm.photoPickerItem?.loadTransferable(type: Data.self) {
                    if let uiImage = UIImage(data: data) {
                        vm.uiImage = uiImage
                        vm.detectedObject = []
                        return
                    }
                }
                
                print("Failed")
            }
        }
    }
}

struct ImageBasedView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            ImageBasedView()
        }
    }
}
