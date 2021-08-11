//
//  FGCustomCameraView.swift
//  Fringe
//
//  Created by Dharmani Apps on 11/08/21.
//

//
//  SCCustomCameraView.swift
//  SessionControl
//

import Foundation
import AVFoundation
import UIKit

typealias ImageCompletionHandler = (_ image: UIImage?, _ buffer: CMSampleBuffer?, _ error: Error?) -> Void

final class FGCustomCameraView: UIView, AVCapturePhotoCaptureDelegate {
    
    var isOn : Bool = false
    var handler: ImageCompletionHandler?
    
    private lazy var photoDataOutput: AVCapturePhotoOutput = {
        let v = AVCapturePhotoOutput()
        v.connection(with: .video)?.isEnabled = true
        return v
    }()
    
    private let photoDataOutputQueue: DispatchQueue = DispatchQueue(label: "JKVideoDataOutputQueue")
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let l = AVCaptureVideoPreviewLayer(session: session)
        l.videoGravity = .resizeAspectFill
        return l
    }()
    
    private let captureDevice: AVCaptureDevice? = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
    private lazy var session: AVCaptureSession = {
        let s = AVCaptureSession()
        s.sessionPreset = .hd1280x720
        return s
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        contentMode = .scaleAspectFit
        #if targetEnvironment(simulator)
        // we're on the simulator - calculate pretend movement
        #else
        beginSession()
        #endif
    }
    
    private func beginSession() {
        do {
            guard let captureDevice = captureDevice else {
                fatalError("Camera doesn't work on the simulator! You have to test this on an actual device!")
            }
            let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            if session.canAddInput(deviceInput) {
                session.addInput(deviceInput)
            }
            
            if session.canAddOutput(photoDataOutput) {
                session.addOutput(photoDataOutput)
            }
            layer.masksToBounds = true
            layer.addSublayer(previewLayer)
            previewLayer.frame = bounds
            session.startRunning()
            isOn = true
        } catch let error {
            debugPrint("\(self.self): \(#function) line: \(#line).  \(error.localizedDescription)")
        }
    }
    
    func capturePhoto(imageHandler: @escaping ImageCompletionHandler) {
        handler = imageHandler
        let settings = AVCapturePhotoSettings()
        photoDataOutput.capturePhoto(with: settings, delegate: self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer.frame = bounds
    }
}

//extension FGCustomCameraView: AVCapturePhotoCaptureDelegate {
//
//    public func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
//                        resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Swift.Error?) {
//            if let error = error {
//                if let handler = handler {
//                    handler(nil, nil, error)
//                }
//            } else if let buffer = photoSampleBuffer, let data = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: buffer, previewPhotoSampleBuffer: nil),
//                let image = UIImage(data: data) {
//                    if let handler = handler {
//                        handler(image, buffer, nil)
//                    }
//                }
//        }
//}

