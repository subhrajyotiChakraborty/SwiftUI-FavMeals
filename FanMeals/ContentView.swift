//
//  ContentView.swift
//  FanMeals
//
//  Created by Subhrajyoti Chakraborty on 21/12/20.
//

import SwiftUI

struct ContentView: View {
    @State private var openAddMeals = false
    @State private var addNumber = ""
    @ObservedObject var meals = Meals()
    
    func deleteItem(at offset: IndexSet) {
        meals.meals.remove(atOffsets: offset)
        meals.save()
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(meals.meals, id: \.id) { meal in
                    NavigationLink(
                        destination: DetailView(mealData: meal)) {
                        Text("\(meal.mane)")
                        Text("\(meal.rating)")
                    }
                }
                .onDelete(perform: { indexSet in
                    deleteItem(at: indexSet)
                })
            }
            .navigationBarTitle(Text("FavMeals"))
            .navigationBarItems(leading: EditButton(), trailing: Button(action: {
                openAddMeals.toggle()
            }, label: {
                Image(systemName: "plus")
            }))
            .sheet(isPresented: $openAddMeals, content: {
                AddMeals(meals: meals)
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct DetailView: View {
    var mealData: Meal
    @State private var image: Image?
    
    func getImage() {
        if  mealData.image != nil {
            let mealImage = mealData.image!
            let uiImage = mealImage.getImage()
            guard let safeUIImage = uiImage else { return }
            image = Image(uiImage: safeUIImage)
        }
    }
    var body: some View {
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
        }
        .onAppear(perform: {
            getImage()
        })
    }
}
