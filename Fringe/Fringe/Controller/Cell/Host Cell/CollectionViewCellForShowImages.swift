//
//  CollectionViewCellForShowImages.swift
//  Fringe
//
//  Created by Dharmani Apps on 31/08/21.
//

import UIKit
import Toucan
import SDWebImage

class CollectionViewCellForShowImages: UICollectionViewCell {

    @IBOutlet weak var showImages: UIImageView!
    
    //------------------------------------------------------
    
    //MARK: Custome
    
    func setup(imageUrl: String?) {
        
        //image
        showImages.sd_addActivityIndicator()
        showImages.sd_setIndicatorStyle(UIActivityIndicatorView.Style.medium)
        showImages.sd_showActivityIndicatorView()
        showImages.image = getPlaceholderImage()
        if let image = imageUrl, image.isEmpty == false {
            let imgURL = URL(string: image)
            showImages.sd_setImage(with: imgURL) { ( serverImage: UIImage?, _: Error?, _: SDImageCacheType, _: URL?) in
                self.showImages.sd_removeActivityIndicator()
            }
        } else {
            self.showImages.sd_removeActivityIndicator()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
