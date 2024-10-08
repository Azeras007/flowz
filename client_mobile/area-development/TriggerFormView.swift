//
//  TriggerFormData.swift
//  area-development
//
//  Created by Antoine Laurans on 07/10/2024.
//


import SwiftUI

struct TriggerFormData {
    var fields: [String: String]
}

struct TriggerFormView: View {
    var trigger: Trigger
    var actionFormData: FormData
    @State private var formData: [String: String] = [:]
    @State private var savedFormData: TriggerFormData?
    @State private var name: String = ""
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ZStack {
                Text("Fill in the fields")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.primary)
                    .frame(maxWidth: .infinity, alignment: .center)

                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrowtriangle.left.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(colorScheme == .dark ? Color.white : Color.primary)
                    }
                    .padding(.leading, 20)

                    Spacer()
                }
            }
            .padding(.top, 40)
            .navigationBarHidden(true)

            
            Form {
                TextField("Name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                ForEach(trigger.metadataFields , id: \.name) { field in
                    if field.type == "text" {
                        TextField(field.label, text: Binding(
                            get: { formData[field.name] ?? "" },
                            set: { formData[field.name] = $0 }
                        ))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    if field.type == "string"{
                        TextField(field.label, text: Binding(
                            get: { formData[field.name] ?? "" },
                            set: { formData[field.name] = $0 }
                        ))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
            }
            .padding(.horizontal)
            
            Button(action: {
                saveFormData()
                createArea(name: name, trigger: trigger, actionFormData: actionFormData, triggerFormData: savedFormData)
            }) {
                Text("Submit")
                    .padding()
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .background(Color.yellow)
                    .foregroundColor(.black)
                    .cornerRadius(10)
            }
            
            Spacer()
        }
        .padding()
    }
    
    func saveFormData() {
        savedFormData = TriggerFormData(fields: formData)
        print("Trigger form data saved: \(savedFormData?.fields ?? [:])")
    }
}
