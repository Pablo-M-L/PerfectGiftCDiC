//
//  ImagePicker.swift
//  PerfectGiftCDiC
//
//  Created by pablo on 6/7/21.
//

import Foundation

import UIKit
import SwiftUI
import Photos

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var selectedImage: UIImage
    @Binding var selectedImageDone: Bool
    @Environment(\.presentationMode) private var presentationMode
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = context.coordinator
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        return imagePickerController
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        var parent: ImagePicker
         
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
     
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
     
            if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                parent.selectedImage = image
                parent.selectedImageDone = true
            }
     
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    
}

func resizeImage(image: UIImage)->UIImage{
    // le doy el mismo valor a width que a height para que el resultado sea una imagen cuadrada.
    let originalSize = image.size
    //obtener factor de escalado
    let witdhRatio = 250 / originalSize.width
    let heightRatio = 250 / originalSize.width
    //let heightRatio = 250 / originalSize.height
    
    let targerRatio = max(witdhRatio, heightRatio)
    let newSize = CGSize(width: originalSize.width * targerRatio, height: originalSize.width * targerRatio)
    
    //definir el rectangulo. (la zona donde se va a renderizar)
    let rectImagen = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
    
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rectImagen)
    
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    //destapar nuevaImagen que es UIImage?
    guard let nuevaImagen = newImage else {
        return image
    }
    return nuevaImagen
    
}
