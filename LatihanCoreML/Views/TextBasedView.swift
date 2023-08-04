//
//  TextBasedView.swift
//  LatihanCoreML
//
//  Created by Rifqi Alhakim Hariyantoputera on 29/07/23.
//

import SwiftUI

struct TextBasedView: View {
    @StateObject var vm = TextBasedViewModel()
    
    var body: some View {
        VStack {
            Form{
                if vm.answers.count == vm.symptoms.count {
                    Section{
                        ForEach(vm.symptoms.indices, id: \.self){ index in
                            Picker("\(vm.symptoms[index].symptomName)", selection: $vm.answers[index]){
                                Text("No").tag(1)
                                Text("Yes").tag(0)
                            }
                        }
                    }
                    if vm.testResult != nil {
                        Section{
                            Text("Prediction result: \(vm.testResult!) %")
                        }
                    }
                    Button{
                        vm.calculateResult(datas: vm.answers)
                    } label: {
                        Text("Check!")
                    }
                }
            }
            .scrollContentBackground(.hidden)
        }
        .padding()
        .background(Color.gray.opacity(0.05))
    }
}

struct TextBasedView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            TextBasedView()
        }
    }
}
