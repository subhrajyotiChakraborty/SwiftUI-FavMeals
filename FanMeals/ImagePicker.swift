//
//  ImagePicker.swift
//  FanMeals
//
//  Created by Subhrajyoti Chakraborty on 21/12/20.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    
    @Environment (\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    var sourcetype: UIImagePickerController.SourceType
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = sourcetype
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        //
    }
    
    func makeCoordinator() -> Coordinate {
        Coordinate(self)
    }
    
    class Coordinate: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.editedImage] as? UIImage {
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
