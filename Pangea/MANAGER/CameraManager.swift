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
//    @Binding var location: String
//    @Binding var date: String
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) { }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraViewController>) -> UIImagePickerController {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = context.coordinator
        return vc
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
            
            //            if let asset: PHAsset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset {
            //                        print("Asset: \(asset)")
            //                        print("Creation Data \(String(describing: asset.creationDate))")
            //                        print("Location: \(String(describing: asset.location))")
            //                    } else {
            //                        print("Asset: nil")
            //                    }
            var pickerImage: UIImage?
            
            
            
            if let URL = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
                print("Image URL: \(URL)")
                let opts = PHFetchOptions()
                opts.fetchLimit = 1
                let assets = PHAsset.fetchAssets(withALAssetURLs: [URL], options: opts)
                
                print(assets)
                
                
                for assetIndex in 0..<assets.count {
                    let asset = assets[assetIndex]
                    let location = String(describing: asset.location)
                    
                    
                    
                    let longitude = String(describing: asset.location?.coordinate.longitude)
                    
                    let latitude = String(describing: asset.location?.coordinate.latitude)
                    
                    let creationDate = (asset.creationDate?.description)!
                    
                    
                    print(longitude)
                    print(latitude)
                    
                    print(location)
                    
                    DispatchQueue.main.async {
                        self.parent.selectedImage = pickerImage
//                        self.parent.date = creationDate
//                        self.parent.location = self.parent.location
                       
                    }
                    
                    
                }
            }
            
            if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                pickerImage = editedImage
            } else if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                pickerImage = selectedImage
            }
            
        }
    }
}

struct CustomPhotoPickerView: UIViewControllerRepresentable {
    
    @Binding var selectedImage: UIImage?
    @Binding var date: Date?
    @Binding var location: CLLocationCoordinate2D?
    
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        config.filter = .images
        config.selectionLimit = 1
        let controller = PHPickerViewController(configuration: config)
        controller.delegate = context.coordinator
        return controller
    }
    
    func makeCoordinator() -> CustomPhotoPickerView.Coordinator {
        return Coordinator(self)
    }
    
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
    }
    
    class Coordinator: PHPickerViewControllerDelegate {
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.presentationMode.wrappedValue.dismiss()
            guard !results.isEmpty else {
                return
            }
            
            let imageResult = results[0]
            
            if let assetId = imageResult.assetIdentifier {
                let assetResults = PHAsset.fetchAssets(withLocalIdentifiers: [assetId], options: nil)
                DispatchQueue.main.async {
                    self.parent.date = assetResults.firstObject?.creationDate
                    self.parent.location = assetResults.firstObject?.location?.coordinate
                }
            }
            if imageResult.itemProvider.canLoadObject(ofClass: UIImage.self) {
                imageResult.itemProvider.loadObject(ofClass: UIImage.self) { (selectedImage, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        DispatchQueue.main.async {
                            self.parent.selectedImage = selectedImage as? UIImage
                        }
                    }
                }
            }
        }
        
        private let parent: CustomPhotoPickerView
        init(_ parent: CustomPhotoPickerView) {
            self.parent = parent
        }
    }
}

