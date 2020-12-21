//
//  Meal.swift
//  FanMeals
//
//  Created by Subhrajyoti Chakraborty on 21/12/20.
//

import Foundation
import SwiftUI

struct Meal: Identifiable, Codable {
    let id = UUID()
    var mane: String
    var description: String
    var rating: Int
    var image: MealImage?
}

struct MealImage: Codable {
    let imageData: Data?
    
    init(withImage image: UIImage) {
        self.imageData = image.pngData()
    }
    
    func getImage() -> UIImage? {
        guard let image = imageData else { return nil }
        let uiImage = UIImage(data: image)
        return uiImage
    }
}

class Meals: ObservableObject {
    @Published var meals = [Meal]()
    static let savedKey = "MealsKey"
    
    init() {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let filePath = path[0].appendingPathComponent(Self.savedKey)
        do {
            let data = try Data(contentsOf: filePath)
            let decodedData = try JSONDecoder().decode([Meal].self, from: data)
            self.meals = decodedData
            return
        } catch {
            print("error while decoding the data \(error.localizedDescription)")
        }
        self.meals = []
    }
    
    func getPath() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
    
    func load() {
        let filePath = getPath().appendingPathComponent(Self.savedKey)
        do {
            let data = try Data(contentsOf: filePath)
            let decodedData = try JSONDecoder().decode([Meal].self, from: data)
            self.meals = decodedData
        } catch {
            print("error while decoding the data \(error.localizedDescription)")
        }
    }
    
    func save() {
        let filePath = getPath().appendingPathComponent(Self.savedKey)
        do {
            let data = try JSONEncoder().encode(meals)
            try data.write(to: filePath, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("error while encoding the data \(error.localizedDescription)")
        }
    }
}
