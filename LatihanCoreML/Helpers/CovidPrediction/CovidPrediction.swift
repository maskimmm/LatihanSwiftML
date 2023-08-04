//
//  CovidPrediction.swift
//  LatihanCoreML
//
//  Created by Rifqi Alhakim Hariyantoputera on 29/07/23.
//

import Foundation
import CoreML

class CovidPrediction {
    var model: CovidModel?
    
    init(){
        do{
            let config = MLModelConfiguration()
            self.model = try CovidModel(configuration: config)
        } catch {
            print("Error load model.")
        }
    }

    func predict(answer: [Int]) -> Float? {
        var result: Float?
        do{
            let multiArray = try MLMultiArray(shape: [1, 13], dataType: .float32)
            
            for index in answer.indices{
                let mlValue = NSNumber(value: answer[index])
                multiArray[index] = mlValue
            }
            
            let pred = try self.model!.prediction(flatten_input: multiArray)
            print("Prediksi COVID 19: \(pred.Identity[0])")
            result = pred.Identity[0].floatValue
        } catch {
            print("Catch an error.")
        }
        
        return result
    }
}
