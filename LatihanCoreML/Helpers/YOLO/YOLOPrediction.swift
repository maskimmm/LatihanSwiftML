//
//  YOLOPrediction.swift
//  LatihanCoreML
//
//  Created by Rifqi Alhakim Hariyantoputera on 04/08/23.
//

import Foundation
import CoreML
import Vision
import UIKit

// Pake class bawaan YOLOModel
class YOLOPrediction {
    var yoloModel: YOLOModel?
    
    init(){
        do{
            let config = MLModelConfiguration()
            self.yoloModel = try YOLOModel(configuration: config)
        } catch {
            print("Error load model.\nError: \(error.localizedDescription)")
        }
    }
    
    func detectObjects(image: UIImage){
        var pixelBuffer: CVPixelBuffer?
        var result: [VNRecognizedObjectObservation]?
        do {
            if let ciImage = CIImage(image: image) {
                let imageWidth = 640
                let imageHeight = 640
                CVPixelBufferCreate(nil, imageWidth, imageHeight, kCVPixelFormatType_32BGRA, nil, &pixelBuffer)
                
                if let pb = pixelBuffer {
                    let ciContext = CIContext()
                    ciContext.render(ciImage, to: pb)
                    pixelBuffer = pb
                }
            }
            
            let pred = try yoloModel?.prediction(input: YOLOModelInput(image: pixelBuffer!, iouThreshold: 0.45, confidenceThreshold: 0.25))
            print(pred!)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}

// Pure Vision x CoreML
class YOLOVisionML {
    var coreModel: VNCoreMLModel?
    
    init(){
        do{
            if let modelURL = Bundle.main.url(forResource: "YOLOModel", withExtension: "mlmodelc") {
                coreModel = try VNCoreMLModel(for: MLModel(contentsOf: modelURL))
            }
        } catch {
            print("Error load model.\nError: \(error.localizedDescription)")
        }
    }
    
    /// Use _VNRecognizedObjectObservation_ for Object Detection Model
    /// Use _VNClassificationObservation_ for Classification Model
    func detectObjects(_ image: UIImage) -> [VNRecognizedObjectObservation] {
        var result: [VNRecognizedObjectObservation]?
        
        // Create Request
        let request = VNCoreMLRequest(model: coreModel!) { request, error in
            if error != nil {
                return
            }
            
            guard let observations = request.results as? [VNRecognizedObjectObservation] else {
                return
            }
            
            result = observations
        }
        
        let imageRequestHandler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
        
        do {
            try imageRequestHandler.perform([request])
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        
        return result!
    }
   
}
