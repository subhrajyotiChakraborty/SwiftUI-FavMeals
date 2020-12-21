//
//  AddMeals.swift
//  FanMeals
//
//  Created by Subhrajyoti Chakraborty on 21/12/20.
//

import SwiftUI

struct AddMeals: View {
    @ObservedObject var meals: Meals
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var description = ""
    @State private var rating = 3
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    @State private var image: Image?
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var showActionSheet = false
    let ratings = [1, 2, 3, 4, 5]
    
    func loadImage() {
        guard let uiImage = inputImage else { return }
        image = Image(uiImage: uiImage)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name", text: $name)
                    TextField("Description", text: $description)
                    Picker("Rating", selection: $rating) {
                        ForEach(ratings, id: \.self) {
                            Text("\($0)")
                        }
                    }
                }
                Section {
                    if image != nil {
                        image?
                            .resizable()
                            .scaledToFit()
                    } else {
                        Image("defaultMealImage")
                            .resizable()
                            .scaledToFit()
                    }
                    Button(action: {
                        self.showActionSheet = true
                    }, label: {
                        Text("Select A Photo")
                    })
                }
                Section {
                    Button(action: {
                        let mealImage = MealImage(withImage: inputImage!)
                        let newMeal = Meal(mane: name, description: description, rating: rating, image: mealImage)
                        meals.meals.append(newMeal)
                        meals.save()
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Save")
                    })
                }
            }
            .navigationBarTitle(Text("Add Meal"))
            .sheet(isPresented: $showImagePicker, onDismiss: loadImage, content: {
                ImagePicker(image: $inputImage, sourcetype: sourceType)
            })
            .actionSheet(isPresented: $showActionSheet, content: {
                ActionSheet(title: Text("Select a picture from?"), message: nil, buttons: [.default(Text("Library"), action: {
                    self.sourceType = .photoLibrary
                    self.showImagePicker = true
                }), .default(Text("Camera"), action: {
                    self.sourceType = .camera
                    self.showImagePicker = true
                })])
            })
        }
    }
}

struct AddMeals_Previews: PreviewProvider {
    static var previews: some View {
        AddMeals(meals: Meals())
    }
}
