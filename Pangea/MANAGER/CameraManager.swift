//
//  CameraManager.swift
//  Pangea
//
//  Created by Lillian Cain on 10/22/23.
//

import Foundation
import SwiftUI
import PhotosUI

struct CameraViewController: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var selectedImage: UIImage?
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) { 
    
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraViewController>) -> UIImagePickerController {
        let controller = UIImagePickerController()
        controller.sourceType = .camera
    controller.delegate = context.coordinator
        return controller
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate, AVCapturePhotoCaptureDelegate {
        var parent: CameraViewController
        var captureSession: AVCaptureSession!
        var capturePhotoOutput: AVCapturePhotoOutput!
        var theCamera: AVCaptureDevice!
        var videoPreviewLayer: AVCaptureVideoPreviewLayer?
        let photoQualityPrioritizationMode = AVCapturePhotoOutput.QualityPrioritization.quality
        
        init(_ imagePickerController: CameraViewController) {
            self.parent = imagePickerController
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey : Any]) {
            guard let image = info[.originalImage] as? UIImage else { return }
            
            parent.selectedImage = image
            parent.presentationMode.wrappedValue.dismiss()
        
            var pickerImage: UIImage?
            
            if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                pickerImage = editedImage
            } else if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                pickerImage = selectedImage
            }
            if let URL = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
                print("Image URL: \(URL)")
                let option = PHFetchOptions()
                option.fetchLimit = 1
                let assets = PHAsset.fetchAssets(withALAssetURLs: [URL], options: option)
                
                print(assets)
                
                for assetIndex in 0..<assets.count {
                    let asset = assets[assetIndex]
                    let location = asset.location
                
                    let latitude = asset.location?.coordinate.latitude
                    let longitude = asset.location?.coordinate.longitude
                    
                    print(latitude)
                    print(longitude)
         
                    print(location)
                    
                    DispatchQueue.main.async {
                        self.parent.selectedImage = pickerImage
                    }
                }
            }
        }
    }
}
