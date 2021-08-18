//
//  FGButton.swift
//  NewProject
//
//  Created by Dharmesh Avaiya on 22/08/20.
//  Copyright © 2020 dharmesh. All rights reserved.
//

import Foundation
import UIKit

class FGBaseButton: UIButton {

    var fontDefaultSize : CGFloat {
        return self.titleLabel?.font.pointSize ?? 0.0
    }
    var fontSize : CGFloat = 0.0
    
    /// common lable layout
    ///
    /// - Parameter aDecoder: <#aDecoder description#>
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        fontSize = getDynamicFontSize(fontDefaultSize: fontDefaultSize)
    }
}

class FGRegularButton: FGBaseButton {

    /// common lable layout
    ///
    /// - Parameter aDecoder: <#aDecoder description#>
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.titleLabel?.font = FGFont.PoppinsRegular(size: self.fontSize)
        self.imageView?.contentMode = .scaleAspectFit
    }
}

class FGBoldButton: FGBaseButton {

    /// common lable layout
    ///
    /// - Parameter aDecoder: <#aDecoder description#>
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.titleLabel?.font = FGFont.PoppinsBold(size: self.fontSize)
        self.imageView?.contentMode = .scaleAspectFit
    }
}
class FGLightButton: FGBaseButton {

    /// common lable layout
    ///
    /// - Parameter aDecoder: <#aDecoder description#>
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.titleLabel?.font = FGFont.PoppinsLight(size: self.fontSize)
        self.imageView?.contentMode = .scaleAspectFit
    }
}
class FGMediumButton: FGBaseButton {

    /// common lable layout
    ///
    /// - Parameter aDecoder: <#aDecoder description#>
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.titleLabel?.font = FGFont.PoppinsMedium(size: self.fontSize)
        self.imageView?.contentMode = .scaleAspectFit
    }
}
class FGSemiboldButton: FGBaseButton {

    /// common lable layout
    ///
    /// - Parameter aDecoder: <#aDecoder description#>
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.titleLabel?.font = FGFont.PoppinsSemiBold(size: self.fontSize)
        self.imageView?.contentMode = .scaleAspectFit
    }
}
class FGActiveButton: FGMediumButton {

    //------------------------------------------------------
    
    //MARK: Customs
    
    func setup() {
                
        self.cornerRadius = FGSettings.cornerRadius
        self.shadowOffset = CGSize.zero
//        self.shadowOpacity = FGSettings.shadowOpacity
        
        self.backgroundColor = FGColor.appGreen
        //self.setBackgroundImage(UIImage(named: TFImageName.background), for: .normal)
        self.clipsToBounds = true
    }
    
    /// common lable layout
    ///
    /// - Parameter aDecoder: <#aDecoder description#>
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
             
       setup()
    }
}

class FGActiveButtonEdit: FGRegularButton {

    //------------------------------------------------------
    
    //MARK: Customs
    
    func setup() {
                
        self.cornerRadius = FGSettings.cornerRadius
        self.shadowOffset = CGSize.zero
//        self.shadowOpacity = FGSettings.shadowOpacity
        
        self.backgroundColor = UIColor.clear
        //self.setBackgroundImage(UIImage(named: TFImageName.background), for: .normal)
        self.clipsToBounds = true
    }
    
    /// common lable layout
    ///
    /// - Parameter aDecoder: <#aDecoder description#>
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
             
       setup()
    }
}

