//
//  ImageBasedViewModel.swift
//  LatihanCoreML
//
//  Created by Rifqi Alhakim Hariyantoputera on 04/08/23.
//

import Foundation
import SwiftUI
import PhotosUI
import Vision
import VisionKit

class ImageBasedViewModel: ObservableObject {
    
    @Published var photoPickerItem : PhotosPickerItem?
    @Published var uiImage : UIImage?
    @Published var bbx: [CGRect] = []
    @Published var bbxLabel: [String] = []
    @Published var detectedObject: [VNRecognizedObjectObservation] = []
    let screenSize: CGSize = UIScreen.main.bounds.size
    
    func detectObject(uiImage: UIImage, confidence: Float){
        let vnModel = YOLOVisionML()
        let result = vnModel.detectObjects(uiImage)
        self.detectedObject = result.filter({$0.confidence >= confidence})

//        var tmpBbx: [CGRect] = []
//        var tmpBbxLabel: [String] = []
        
//        let result = vnModel.detectObjects(uiImage)
//        for observation in result {
//            if !observation.confidence.isLess(than: confidence) {
//                let boundingBox = observation.boundingBox
//                let label = observation.labels.first?.identifier ?? "Unknown"
//                let confidence = observation.confidence
//                tmpBbx.append(boundingBox)
//                tmpBbxLabel.append(label)
//                print("------------")
//                print("Label: \(label), Confidence: \(confidence), BoundingBox: \(boundingBox)")
//                print("minX - midX - maxX - origin.x")
//                print("\(boundingBox.minX) - \(boundingBox.midX) - \(boundingBox.maxX) - \(boundingBox.origin.x)")
//                print("width - size.width")
//                print("\(boundingBox.width) - \(boundingBox.size.width)")
//
//            }
//        }
//
//        self.bbxLabel = tmpBbxLabel
//        self.bbx = tmpBbx
//        print("VNModel: \(bbx.count)")
        
    }
}
