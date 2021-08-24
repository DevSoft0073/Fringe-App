//
//  FGTextView.swift
//  Fringe
//
//  Created by Dharmani Apps on 11/08/21.
//

import Foundation
import UIKit

class FGBaseTextView: UITextView {
    
    public var fontDefaultSize : CGFloat {
        return font?.pointSize ?? 0.0
    }
    public var fontSize : CGFloat = 0.0
    
    public var padding: Double = 8
    
    private var leftEmptyView: UIView {
        return UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: padding, height: Double.zero)))
    }
    private var rightEmptyView: UIView {
        return leftEmptyView
    }
    
    override func becomeFirstResponder() -> Bool {
        HighlightLayer()
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        resetLayer()
        return super.resignFirstResponder()
    }
    
    //------------------------------------------------------
    
    //MARK: Customs
    
    fileprivate func setupDefault() {
        
        self.cornerRadius = FGSettings.cornerRadius
        self.borderWidth = FGSettings.borderWidth
//        self.borderColor = FGColor.appWhite
//        self.shadowColor = FGColor.appWhite
        self.shadowOffset = CGSize.zero
        self.shadowOpacity = FGSettings.shadowOpacity
//        self.tintColor = FGColor.appWhite
//        self.textColor = FGColor.appWhite
    }
    
    fileprivate func HighlightLayer() {
        self.borderColor = FGColor.appBorder
        self.buttonColor = FGColor.appButton
    }
    
    fileprivate func resetLayer() {
//        self.borderColor = FGColor.appWhite
//        self.tintColor = FGColor.appWhite
    }
        
    /// common text field layout for inputs
    ///
    /// - Parameter aDecoder: <#aDecoder description#>
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
}

class FGRegularWithoutBorderTextView: UITextView {

    public var fontDefaultSize : CGFloat {
        return font?.pointSize ?? 0.0
    }
    
    /// common text field layout for inputs
    ///
    /// - Parameter aDecoder: aDecoder description
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
                
        let fontSize = getDynamicFontSize(fontDefaultSize: fontDefaultSize)
        self.font = FGFont.PoppinsRegular(size: fontSize)
    }
}

class FGRegularTextView: FGBaseTextView {

    /// common text field layout for inputs
    ///
    /// - Parameter aDecoder: aDecoder description
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.font = FGFont.PoppinsRegular(size: fontSize)
    }
}

class FGBoldTextView: FGBaseTextView {

    /// common text field layout for inputs
    ///
    /// - Parameter aDecoder: aDecoder description
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.font = FGFont.PoppinsBold(size: fontSize)
    }
}


