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
        let photoQualityPrioritizationMode = AVCapturePhotoOutput.QualityPrioritization.speed
        
        init(_ imagePickerController: CameraViewController) {
            self.parent = imagePickerController
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey : Any]) {
            guard let image = info[.originalImage] as? UIImage else { return }
            parent.selectedImage = image
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
