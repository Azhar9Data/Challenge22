//
//  AddRecipeView.swift
//  Challenge22
//
//  Created by Azhar on 19/04/1446 AH.
//
import SwiftUI
import PhotosUI

struct AddRecipeView: View {
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var selectedImage: UIImage? = nil
    @State private var isImagePickerPresented = false
    
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
                .frame(width: UIScreen.main.bounds.width - 0, height: 200) // Set max width and height
                .clipped() // Ensures no overflow outside the frame
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
                        // Action for adding an ingredient
                        print("Add Ingredient tapped")
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.cccc)
                    }
                }
                .padding(.horizontal)
                Spacer()
            }
            .navigationTitle("New Recipe")
            .navigationBarItems(
                leading: Button(action: {
                    // Action for back button
                    print("Back tapped")
                }) {
                    Text("Back")
                        .foregroundColor(.cccc)
                },
                trailing: Button(action: {
                    // Action for save button
                    print("Save tapped")
                }) {
                    Text("Save")
                        .foregroundColor(.cccc)
                }
                    .disabled(title.isEmpty)
            )

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


#Preview {
    AddRecipeView()
}
