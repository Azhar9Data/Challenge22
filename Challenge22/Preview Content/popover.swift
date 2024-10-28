//
//  popover.swift
//  Challenge22
//
//  Created by Azhar on 25/04/1446 AH.
//

import SwiftUI

struct NewRecipePopover: View {
    @State private var ingredientName: String = ""
    @State private var selectedMeasurement: MeasurementUnit = .spoon
    @State private var servingCount: Int = 1

    var body: some View {
        VStack(spacing: 20) {
            Text("New Recipe")
                .font(.title)
                .bold()
                .foregroundColor(.black)

            // Ingredient Name
            VStack(alignment: .leading) {
                Text("Ingredient Name")
                    .font(.headline)
                    .foregroundColor(.black)
                TextField("Ingredient Name", text: $ingredientName)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }

            // Measurement
            VStack(alignment: .leading) {
                Text("Measurement")
                    .font(.headline)
                    .foregroundColor(.black)
                HStack(spacing: 20) {
                    MeasurementButton(title: "🥄 Spoon", selectedMeasurement: $selectedMeasurement, measurement: .spoon)
                    MeasurementButton(title: "🥤 Cup", selectedMeasurement: $selectedMeasurement, measurement: .cup)
                }
            }

            // Serving
            VStack(alignment: .leading) {
                Text("Serving")
                    .font(.headline)
                    .foregroundColor(.black)
                HStack(spacing: 10) {
                    Button(action: { if servingCount > 1 { servingCount -= 1 } }) {
                        Text("-")
                            .font(.title)
                            .frame(width: 40, height: 40)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    Text("\(servingCount)")
                        .font(.title2)
                        .frame(width: 50)
                    Button(action: { servingCount += 1 }) {
                        Text("+")
                            .font(.title)
                            .frame(width: 40, height: 40)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    MeasurementButton(title: selectedMeasurement == .spoon ? "🥄 Spoon" : "🥤 Cup", selectedMeasurement: $selectedMeasurement, measurement: selectedMeasurement)
                }
            }

            // Action Buttons
            HStack(spacing: 20) {
                Button("Cancel") {
                    // Cancel action
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.systemGray6))
                .foregroundColor(.red)
                .cornerRadius(8)

                Button("Add") {
                    // Add action
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 10)
        .padding()
    }
}

enum MeasurementUnit {
    case spoon, cup
}

struct MeasurementButton: View {
    let title: String
    @Binding var selectedMeasurement: MeasurementUnit
    let measurement: MeasurementUnit

    var body: some View {
        Button(action: {
            selectedMeasurement = measurement // Select either spoon or cup
        }) {
            Text(title)
                .padding()
                .frame(maxWidth: .infinity)
                .background(selectedMeasurement == measurement ? Color.orange : Color(.systemGray6))
                .foregroundColor(selectedMeasurement == measurement ? .white : .black)
                .cornerRadius(8)
        }
    }
}

struct NewRecipePopover_Previews: PreviewProvider {
    static var previews: some View {
        NewRecipePopover()
    }
}
