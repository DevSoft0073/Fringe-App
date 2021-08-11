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

class PMSFProDisplayRegularButton: FGBaseButton {

    /// common lable layout
    ///
    /// - Parameter aDecoder: <#aDecoder description#>
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.titleLabel?.font = PMFont.sfProDisplayRegular(size: self.fontSize)
        self.imageView?.contentMode = .scaleAspectFit
    }
}

class PMSFProDisplayBoldButton: FGBaseButton {

    /// common lable layout
    ///
    /// - Parameter aDecoder: <#aDecoder description#>
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.titleLabel?.font = PMFont.sfProDisplayBold(size: self.fontSize)
        self.imageView?.contentMode = .scaleAspectFit
    }
}
