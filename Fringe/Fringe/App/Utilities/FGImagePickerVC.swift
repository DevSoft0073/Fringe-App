//
//  FGImagePickerVC.swift
//  NewProject
//
//  Created by Dharmesh Avaiya on 22/08/20.
//  Copyright © 2020 dharmesh. All rights reserved.
//

import UIKit

public protocol FGImagePickerDelegate: class {
    
    func didSelect(controller: ImagePicker, image: UIImage?)
}

open class ImagePicker: NSObject {
    
    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: FGImagePickerDelegate?
    public var mediaTypes: [String] = ["public.image"]
    
    //------------------------------------------------------
    
    //MARK: Private
    
    fileprivate func configureNavigationBar() {
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
//            appearance.backgroundColor = FGColor.black
            appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
            
            UINavigationBar.appearance().tintColor = .black
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        } else {
            UINavigationBar.appearance().tintColor = .black
//            UINavigationBar.appearance().barTintColor = PMColor.black
            UINavigationBar.appearance().isTranslucent = false
        }
    }
    
    //------------------------------------------------------
    
    //MARK: Publuc
    
    public init(presentationController: UIViewController, delegate: FGImagePickerDelegate) {
        self.pickerController = UIImagePickerController()
        super.init()
        
        self.pickerController.navigationController?.navigationBar.tintColor = UIColor.black
        self.pickerController.navigationController?.navigationBar.tintColor = UIColor.black
        self.pickerController.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.presentationController = presentationController
        self.delegate = delegate
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = false
        self.pickerController.mediaTypes = mediaTypes
    }
    
    public func setMediaTypes(mediaTypes: [String]) {
        self.pickerController.mediaTypes = mediaTypes
    }
    
    public func present(from sourceView: UIView?) {
        
        guard presentationController != nil else {
            return
        }
        
        DisplayAlertManager.shared.displayActionSheet(target: presentationController!, animated: true, message: "", handlerCamera: {
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                self.configureNavigationBar()
                self.pickerController.sourceType = .camera
                self.pickerController.modalPresentationStyle = .overFullScreen
                self.presentationController?.present(self.pickerController, animated: true)
            }
            
        }, handlerPhotoLibrary: {
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                self.configureNavigationBar()
                self.pickerController.sourceType = .photoLibrary
                self.pickerController.modalPresentationStyle = .overFullScreen
                self.presentationController?.present(self.pickerController, animated: true)
            }
            
        }, handlerCancel: {
            
            //Handle cancel option
        })
    }
    
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)
         
        AppDelegate.shared.configureNavigationBar()
        self.delegate?.didSelect(controller: self, image: image)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
               
        if let editedImage = info[.editedImage] as? UIImage {
            return self.pickerController(picker, didSelect: editedImage)
        }
        if let originalImage = info[.originalImage] as? UIImage {
            return self.pickerController(picker, didSelect: originalImage)
        }
        return self.pickerController(picker, didSelect: nil)
    }
}

extension ImagePicker: UINavigationControllerDelegate {
    
    //Handle UINavigationControllerDelegate
}
