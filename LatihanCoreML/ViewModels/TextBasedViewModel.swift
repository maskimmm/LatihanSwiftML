//
//  TextBasedViewModel.swift
//  LatihanCoreML
//
//  Created by Rifqi Alhakim Hariyantoputera on 04/08/23.
//

import Foundation

class TextBasedViewModel: ObservableObject {
    
    let symptoms: [Symptom] = [
        Symptom(id: UUID(), symptomName: "Breathing Problem", description: ""),
        Symptom(id: UUID(), symptomName: "Fever", description: ""),
        Symptom(id: UUID(), symptomName: "Dry Cough", description: ""),
        Symptom(id: UUID(), symptomName: "Sore Throat", description: ""),
        Symptom(id: UUID(), symptomName: "Running Nose", description: ""),
        Symptom(id: UUID(), symptomName: "Asthma", description: ""),
        Symptom(id: UUID(), symptomName: "Chronic Lung Disease", description: ""),
        Symptom(id: UUID(), symptomName: "Headache", description: ""),
        Symptom(id: UUID(), symptomName: "Heart Disease", description: ""),
        Symptom(id: UUID(), symptomName: "Diabetes", description: ""),
        Symptom(id: UUID(), symptomName: "Hyper Tension", description: ""),
        Symptom(id: UUID(), symptomName: "Fatigue", description: ""),
        Symptom(id: UUID(), symptomName: "Gastrointestinal", description: "")
    ]
    
    @Published var testResult: Float?
    
    @Published var answers: [Int] = []
    
    init(){
        for _ in symptoms {
            answers.append(1)
        }
    }
    
    func calculateResult(datas: [Int]){
        let covidModel = CovidPrediction()
//        let covidModel = CovidCoreML()
        self.testResult = covidModel.predict(answer: datas)
        if self.testResult != nil {
            self.testResult = self.testResult! * 100
        }
//        print(result?.description)
    }
}
