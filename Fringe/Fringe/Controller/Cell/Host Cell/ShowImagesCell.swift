//
//  ShowImagesCell.swift
//  SessionControl
//
//  Created by Apple on 15/04/21.
//  Copyright © 2021 dharmesh. All rights reserved.
//

import UIKit
import Foundation
import SDWebImage

class ShowImagesCell: UITableViewCell ,UICollectionViewDelegate , UICollectionViewDataSource{
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
    var images: [String] = []
        
    //------------------------------------------------------
    
    //MARK: Custome
    
    func setup(images: [String]) {
        self.images = images
        imagesCollectionView.reloadData()
    }
    
    //------------------------------------------------------
    
    //MARK: Collection view delegate datasource
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCellForShowImages", for: indexPath) as! CollectionViewCellForShowImages
        let image = images[indexPath.row]
        cell.setup(imageUrl: image)
        return cell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        let identifier = String(describing: CollectionViewCellForShowImages.self)
        let nibCell = UINib(nibName: identifier, bundle: Bundle.main)
        imagesCollectionView.register(nibCell, forCellWithReuseIdentifier: identifier)
    }
}
