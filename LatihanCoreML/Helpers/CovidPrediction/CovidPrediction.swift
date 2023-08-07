//
//  CovidPrediction.swift
//  LatihanCoreML
//
//  Created by Rifqi Alhakim Hariyantoputera on 29/07/23.
//

import Foundation
import CoreML

// Pake class bawaan CovidModel
class CovidPrediction {
    var model: CovidModel?
    
    init(){
        do{
            let config = MLModelConfiguration()
            self.model = try CovidModel(configuration: config)
        } catch {
            print("Error load model.\nError: \(error.localizedDescription)")
        }
    }

    func predict(answer: [Int]) -> Float? {
        var result: Float?
        do{
            // Create MLMultiArray from inputs
            let multiArray = try MLMultiArray(shape: [1, 13], dataType: .float32)
            for index in answer.indices{
                let mlValue = NSNumber(value: answer[index])
                multiArray[index] = mlValue
            }
            
            // Predict
            let pred = try self.model!.prediction(input: CovidModelInput(flatten_input: multiArray))
            
            // Result
            result = pred.Identity[0].floatValue
            print("Prediksi COVID 19: \(result!)")
        } catch {
            print("Catch an error.\nError: \(error.localizedDescription)")
        }
        
        return result
    }
}

// Pure CoreML
class CovidCoreML {
    var coreModel: MLModel?
    
    init(){
        do{
            if let modelURL = Bundle.main.url(forResource: "CovidModel", withExtension: "mlmodelc"){
                coreModel = try MLModel(contentsOf: modelURL)
            }
        } catch {
            print("Error load model.\nError: \(error.localizedDescription)")
        }
    }
    
    func predict(answer: [Int]) -> Float? {
        var result: Float?
        do{
            // Create MLMultiArray from inputs
            let multiArray = try MLMultiArray(shape: [1, 13], dataType: .float32)
            for index in answer.indices{
                let mlValue = NSNumber(value: answer[index])
                multiArray[index] = mlValue
            }
            
            // Convert MLMultiArray to MLFeatureProvider
            let featureValue = MLFeatureValue(multiArray: multiArray)
            let featureDictionary = ["flatten_input" : featureValue]
            let featureProvider = try MLDictionaryFeatureProvider(dictionary: featureDictionary)
            
            // Predict
            let predictionOptions = MLPredictionOptions()
            let predict = try coreModel?.prediction(from: featureProvider, options: predictionOptions)
            
            // Result
            result = predict!.featureValue(for: "Identity")!.multiArrayValue![0].floatValue
            print("Prediksi COVID 19: \(result!)")
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        
        return result
    }
}
