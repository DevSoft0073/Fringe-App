//
//  AppFunctions.swift
//  NewProject
//
//  Created by Dharmesh Avaiya on 22/08/20.
//  Copyright © 2020 dharmesh. All rights reserved.
//

import Foundation
import UIKit
import AssistantKit
import Toucan


/// This function will retutn font size according to device.
///
/// - Parameter fontDefaultSize: <#fontDefaultSize description#>
/// - Returns: <#return value description#>
func getDynamicFontSize(fontDefaultSize: CGFloat ) -> CGFloat {
    
    var fontSize : CGFloat = 0.0
    let device = Device.version
       
    if device == Version.phone4 || device == Version.phone5 {
        fontSize = fontDefaultSize
    } else if device == Version.phone6 || device == Version.phone7 || device == Version.phone6S || device == Version.phone8 {
        fontSize = fontDefaultSize
    } else if device == Version.phone7Plus || device == Version.phone8Plus {
        fontSize = fontDefaultSize + FGFont.increaseSize
    } else if device == Version.phoneX || device == Version.phoneXR || device == Version.phoneXS || device == Version.phoneXSMax {
        fontSize = fontDefaultSize + FGFont.increaseSize
    } else
    //7.9 inches
    if device == Version.padMini || device == Version.padMini2 || device == Version.padMini3 || device == Version.padMini4 {
        fontSize = fontDefaultSize - FGFont.reduceSize
    //9.7 inches
    } else if device == Version.padAir || device == Version.padAir2  || device == Version.pad1 || device == Version.pad2 || device == Version.pad3 || device == Version.pad4 {
        //fontSize = fontDefaultSize + PMFont.increaseSize
        fontSize = fontDefaultSize
    //10.5 and later
    } else if device == Version.padPro {
        fontSize = fontDefaultSize + FGFont.increaseSize
    } else {
        fontSize = fontDefaultSize
    }
    
    return fontSize
}

/// Delay in execuation of statement
/// - Parameters:
///   - delay: <#delay description#>
///   - closure: <#closure description#>
func delay(_ delay: Double = 0.3, closure:@escaping ()->()) {
    DispatchQueue.main.async {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
}

func delayInLoading(_ delay: Double = 1, closure:@escaping ()->()) {
    DispatchQueue.main.async {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
}

func getPlaceholderImage() -> UIImage? {
    return Toucan.init(image: UIImage(named: FGImageName.iconPlaceHolder)!).resizeByCropping(FGSettings.profileImageSize).maskWithRoundedRect(cornerRadius: FGSettings.profileImageSize.width/2, borderWidth: FGSettings.profileBorderWidth, borderColor: FGColor.appGreen).image
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}


func getEmptyView() -> UIView {
    let view = UIView(frame: CGRect.zero)
    view.backgroundColor = UIColor.clear
    return view
}

func localized(code: Int) -> String {
    
    let codeKey = String(format: "error_%d", code)
    let localizedMessage = codeKey.localized()
    return localizedMessage
}


func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
    
    let size = image.size

    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height

    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if(widthRatio > heightRatio) {
        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
        newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
    }

    // This is the rect that we've calculated out and this is what is actually used below
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return newImage!
}
//func localized(code: Int) -> String {
//
//    let codeKey = String(format: "error_%d", code)
//    let localizedMessage = codeKey.localized()
//    return localizedMessage
//}

