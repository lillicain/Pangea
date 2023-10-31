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
    @Binding var date: Date?
    @Binding var location: CLLocationCoordinate2D?
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) { }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraViewController>) -> UIImagePickerController {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = context.coordinator
        return vc
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
            var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
            config.filter = .images
            config.selectionLimit = 1
            let controller = PHPickerViewController(configuration: config)
            controller.delegate = context.coordinator
            return controller
        }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate, AVCapturePhotoCaptureDelegate, PHPickerViewControllerDelegate {
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
            
            if let asset: PHAsset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset {
                        print("Asset: \(asset)")
                print("Created \(String(describing: asset.creationDate))")
                        print("Location: \(String(describing: asset.location))")
                
                    }
        }
        
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
    }
}


extension CameraViewController {
    static func printEXIFData(imageData: Data) {
        var exifData: CFDictionary? = nil
        imageData.withUnsafeBytes {
            let bytes = $0.baseAddress?.assumingMemoryBound(to: UInt8.self)
            if let cfData = CFDataCreate(kCFAllocatorDefault, bytes, imageData.count),
               let source = CGImageSourceCreateWithData(cfData, nil) {
                exifData = CGImageSourceCopyPropertiesAtIndex(source, 0, nil)
                print(exifData)
            }
        }
    }
    
    func createLocationMetadata() -> NSMutableDictionary? {
        if let location = LocationManager().location {

                let gpsDictionary = NSMutableDictionary()
                var latitude = location.coordinate.latitude
                var longitude = location.coordinate.longitude
                var altitude = location.altitude
                var latitudeRef = "N"
                var longitudeRef = "E"
                var altitudeRef = 0

                if latitude < 0.0 {
                    latitude = -latitude
                    latitudeRef = "S"
                }

                if longitude < 0.0 {
                    longitude = -longitude
                    longitudeRef = "W"
                }

                if altitude < 0.0 {
                    altitude = -altitude
                    altitudeRef = 1
                }

                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy:MM:dd"
                gpsDictionary[kCGImagePropertyGPSDateStamp] = formatter.string(from:location.timestamp)
                formatter.dateFormat = "HH:mm:ss"
                gpsDictionary[kCGImagePropertyGPSTimeStamp] = formatter.string(from:location.timestamp)
                gpsDictionary[kCGImagePropertyGPSLatitudeRef] = latitudeRef
                gpsDictionary[kCGImagePropertyGPSLatitude] = latitude
                gpsDictionary[kCGImagePropertyGPSLongitudeRef] = longitudeRef
                gpsDictionary[kCGImagePropertyGPSLongitude] = longitude
                gpsDictionary[kCGImagePropertyGPSDOP] = location.horizontalAccuracy
                gpsDictionary[kCGImagePropertyGPSAltitudeRef] = altitudeRef
                gpsDictionary[kCGImagePropertyGPSAltitude] = altitude

            if let heading = LocationManager().heading {
                    gpsDictionary[kCGImagePropertyGPSImgDirectionRef] = "T"
                    gpsDictionary[kCGImagePropertyGPSImgDirection] = heading.trueHeading
                }

                return gpsDictionary;
            }
            return nil
        }
        
        func getFileRepresentationWithLocationData(photo : AVCapturePhoto) -> Data {
            // get image metadata
            var properties = photo.metadata

            // add gps data to metadata
            if let gpsDictionary = createLocationMetadata() {
                properties[kCGImagePropertyGPSDictionary as String] = gpsDictionary
            }

            // create new file representation with edited metadata
            
            return photo.fileDataRepresentation(with: photo as! AVCapturePhotoFileDataRepresentationCustomizer) ?? Data()
        }
        
        func replacementMetadata(for photo: AVCapturePhoto) -> [String : Any]? {
            var properties = photo.metadata

            // add gps data to metadata
            if let gpsDictionary = createLocationMetadata() {
                properties[kCGImagePropertyGPSDictionary as String] = gpsDictionary
            }
            return properties
        }
    
}

//struct CustomPhotoPickerView: UIViewControllerRepresentable {
//        
//    @Binding var selectedImage: UIImage?
//    @Binding var date: Date?
//    @Binding var location: CLLocationCoordinate2D?
//    
//    @Environment(\.presentationMode) var presentationMode
//    
//    func makeUIViewController(context: Context) -> PHPickerViewController {
//        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
//        config.filter = .images
//        config.selectionLimit = 1
//        let controller = PHPickerViewController(configuration: config)
//        controller.delegate = context.coordinator
//        return controller
//    }
//    
//    func makeCoordinator() -> CustomPhotoPickerView.Coordinator {
//        return Coordinator(self)
//    }
//    
//    
//    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
//    }
//    
//    class Coordinator: PHPickerViewControllerDelegate {
//        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//            parent.presentationMode.wrappedValue.dismiss()
//            guard !results.isEmpty else {
//                return
//            }
//            
//            let imageResult = results[0]
//            
//            if let assetId = imageResult.assetIdentifier {
//                let assetResults = PHAsset.fetchAssets(withLocalIdentifiers: [assetId], options: nil)
//                DispatchQueue.main.async {
//                    self.parent.date = assetResults.firstObject?.creationDate
//                    self.parent.location = assetResults.firstObject?.location?.coordinate
//                }
//            }
//            if imageResult.itemProvider.canLoadObject(ofClass: UIImage.self) {
//                imageResult.itemProvider.loadObject(ofClass: UIImage.self) { (selectedImage, error) in
//                    if let error = error {
//                        print(error.localizedDescription)
//                    } else {
//                        DispatchQueue.main.async {
//                            self.parent.selectedImage = selectedImage as? UIImage
//                        }
//                    }
//                }
//            }
//        }
//        
//        private let parent: CustomPhotoPickerView
//        init(_ parent: CustomPhotoPickerView) {
//            self.parent = parent
//        }
//    }
//}
