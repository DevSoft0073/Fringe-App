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

class FGRegularLabel: FGBaseLabel {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.font = FGFont.PoppinsRegular(size: self.fontSize)
    }
}

class FGLightLabel: FGBaseLabel {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.font = FGFont.PoppinsLight(size: self.fontSize)
    }
}
class FGMediumLabel: FGBaseLabel {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.font = FGFont.PoppinsMedium(size: self.fontSize)
    }
}
class FGSemiboldLabel: FGBaseLabel {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.font = FGFont.PoppinsSemiBold(size: self.fontSize)
    }
}
class FGBoldLabel: FGBaseLabel {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.font = FGFont.PoppinsBold(size: self.fontSize)
    }
}
