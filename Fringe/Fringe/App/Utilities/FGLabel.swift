//
//  FGLabel.swift
//  NewProject
//
//  Created by Dharmesh Avaiya on 22/08/20.
//  Copyright © 2020 dharmesh. All rights reserved.
//

import UIKit

class FGBaseLabel: UILabel {

    private var fontDefaultSize: CGFloat {
        return font.pointSize
    }
    
    public var fontSize: CGFloat = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
       fontSize = getDynamicFontSize(fontDefaultSize: fontDefaultSize)
    }
}

class FGSFProDisplayRegularLabel: FGBaseLabel {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.font = FGFont.PoppinsRegular(size: self.fontSize)
    }
}

class FGSFProDisplayBoldLabel: FGBaseLabel {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.font = FGFont.PoppinsBold(size: self.fontSize)
    }
}
