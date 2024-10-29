//
//  AddRecipeView.swift
//  Challenge22
//
//  Created by Azhar on 19/04/1446 AH.
//
import SwiftUI
import PhotosUI

struct Ingredient: Identifiable {
    let id = UUID()
    let name: String
    let servingCount: Int
    let measurement: MeasurementUnit
}

enum MeasurementUnit: String {
    case spoon = "Spoon"
    case cup = "Cup"
}
struct AddRecipeView: View {
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var selectedImage: UIImage? = nil
    @State private var isImagePickerPresented = false
    @State private var isPopoverPresented = false // State variable for popover
    @State private var isSaveTapped = false // New state for navigation
    @State private var ingredients: [Ingredient] = []
    
    
    var body: some View {
        NavigationView {
            VStack {
                // Photo Upload Section
                Button(action: {
                    isImagePickerPresented = true // Open the image picker
                }) {
                                        
                ZStack {
                if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                .resizable()
                .scaledToFill() // Fills the frame
                .frame(width: UIScreen.main.bounds.width, height: 200) // Set max width and height
                .clipped() // Ensures the image stays within frame bounds
                } else {
                // Default upload image icon and text when no image is selected
                VStack {
                Image(systemName: "photo.badge.plus")
                .resizable()
                .scaledToFill()  // Adjusted to scaledToFit for placeholder
                .frame(width: 80, height: 80)
                .foregroundColor(.cccc)
                Text("Upload Photo")
                .font(.headline)
                .foregroundColor(.black)
                                                }
                                            }
                                        }
                    .frame(maxWidth: .infinity, minHeight: 150)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(0)
                    .clipped() // Clips any overflow outside the button area
                    .overlay(
                        Group {
                    if selectedImage == nil {
                    VStack {
                    Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.clear)
                    .overlay(
                    Rectangle()
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                    .foregroundColor(.cccc)
                                                       )
                    Spacer()
                    Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.clear)
                    .overlay(
                    Rectangle()
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                    .foregroundColor(.cccc)
                                                       )
                                               }
                                           }
                                       }
                                   )
                               }
                .padding(.bottom, 20)
                .sheet(isPresented: $isImagePickerPresented) {
                PhotoPicker(selectedImage: $selectedImage)
                              }
                
                // Title Input
                VStack(alignment: .leading) {
                    Text("Name")
                        .font(.headline)
                        .fontWeight(.bold)
                    TextField("Recipe Name", text: $title)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
                
                // Description Input
                VStack(alignment: .leading) {
                    // Label for the text editor
                    Text("Description")
                        .font(.headline)
                        .fontWeight(.bold)
                    TextField("Description", text: $description)
                        .padding(.all, 10)
                        .padding(.bottom, 96)
                        .frame(width: 360 , height: 150)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
                
                // Add Ingredient Section
                HStack {
                    Text("Add Ingredient")
                        .font(.headline)
                        .fontWeight(.bold)
                    Spacer()
                    Button(action: {
                    isPopoverPresented = true // Show the popover when plus button is tapped
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.cccc)
                    }
                }
                .padding(.horizontal)
                
                List(ingredients) { ingredient in
                    HStack {
                        Text(ingredient.name)
                        Spacer()
                        Text("\(ingredient.servingCount) \(ingredient.servingCount == 1 ? ingredient.measurement.rawValue : ingredient.measurement.rawValue + "s")")
                    }
                }
                Spacer()
                
            }
            .navigationTitle("New Recipe")
            .navigationBarItems(
                        leading: Button("Back") {
                            print("Back tapped")
                        }
                        .foregroundColor(.orange), // Orange color for the Back button
                        trailing: Button("Save") {
                            print("Save tapped")
                        }
                            .foregroundColor((selectedImage == nil || title.isEmpty || description.isEmpty) ? .gray : .orange) // Gray when disabled
                                .disabled(selectedImage == nil || title.isEmpty || description.isEmpty) // Disable when any field is empty
                    )
                         .popover(isPresented: $isPopoverPresented) {
                             NewRecipePopoverView(isPopoverPresented: $isPopoverPresented) { newIngredient in
                                 ingredients.append(newIngredient)
                             }
                         }
                     }
                 }
             }
struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?

    func makeUIViewController(context: Context) -> some UIViewController {
        var config = PHPickerConfiguration()
        config.filter = .images // Only show images in the picker
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: PhotoPicker

        init(_ parent: PhotoPicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            if let firstResult = results.first {
                firstResult.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    DispatchQueue.main.async {
                        self?.parent.selectedImage = image as? UIImage
                    }
                }
            }
        }
    }
}

struct NewRecipePopoverView: View {
    @State private var ingredientName: String = ""
    @State private var selectedMeasurement: MeasurementUnit = .spoon
    @State private var servingCount: Int = 1
    @Binding var isPopoverPresented: Bool // Use binding to control visibility
    var onAdd: (Ingredient) -> Void
    
    var body: some View {
            VStack(spacing: 20) {
        
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
                        MeasurementButton(title: "🥛 Cup", selectedMeasurement: $selectedMeasurement, measurement: .cup)
                    }
                }
                .padding()
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
                        MeasurementButton(title: selectedMeasurement == .spoon ? "🥄 Spoon" : "🥛 Cup", selectedMeasurement: $selectedMeasurement, measurement: selectedMeasurement)
                    }
                }

                // Action Buttons
                HStack(spacing: 20) {
                    Button("Cancel") {
                      isPopoverPresented = false // Dismiss the popover
                        // Cancel action
        
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray6))
                    .foregroundColor(.red)
                    .cornerRadius(8)

                    Button("Add") {
                        _ = servingCount == 1 ? selectedMeasurement.rawValue : selectedMeasurement.rawValue + "s"
                        let newIngredient = Ingredient(name: ingredientName, servingCount: servingCount, measurement: selectedMeasurement)
                        onAdd(newIngredient)
                        isPopoverPresented = false
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(ingredientName.isEmpty ? Color.gray : Color.orange) // Gray background when disabled
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .disabled(ingredientName.isEmpty) // Disables the button if ingredient name is empty
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 10)
            .padding()
        }
    }
// MeasurementButton
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

#Preview {
    AddRecipeView()
}
