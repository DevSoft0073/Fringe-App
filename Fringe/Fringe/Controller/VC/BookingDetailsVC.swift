//
//  BookingDetailsVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 21/08/21.
//

import UIKit
import SDWebImage
import Foundation

class BookingDetailsVC : BaseVC {
    
    @IBOutlet weak var imgMain: UIImageView!
    @IBOutlet weak var lblName: FGSemiboldLabel!
    @IBOutlet weak var lblAddress: FGMediumLabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var lblRating: FGRegularLabel!
    @IBOutlet weak var lblRate: FGMediumLabel!
    @IBOutlet weak var lblDate: FGRegularLabel!
    @IBOutlet weak var lblStatus: FGRegularLabel!
    
    var bookingDetails: BookingModal?
        
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setup() {
        lblName.text = bookingDetails?.golfCourseName
        lblAddress.text = bookingDetails?.location
        lblRating.text = "5"
        lblRate.text = bookingDetails?.price
        ratingView.rating = Double(bookingDetails?.rating ?? String()) ?? Double()
//      lblDate.text = "\(stringToDate(string: bookingDetails?.dates ?? String(), dateFormat: "dd-MM-yyyy") ?? )"
//      lblDate.text = bookingDetails?.dates ?? String()
        let dateValue = bookingDetails?.dates ?? String()
        let dateValu = NumberFormatter().number(from: dateValue)?.doubleValue ?? 0.0
        lblDate.text = convertTimeStampToDate(dateVal: dateValu)
        imgMain.sd_addActivityIndicator()
        imgMain.sd_setIndicatorStyle(UIActivityIndicatorView.Style.medium)
        imgMain.sd_showActivityIndicatorView()
        imgMain.image = getPlaceholderImage()
        if let image = bookingDetails?.image, image.isEmpty == false {
            let imgURL = URL(string: image)
            imgMain.sd_setImage(with: imgURL) { ( serverImage: UIImage?, _: Error?, _: SDImageCacheType, _: URL?) in
                self.imgMain.sd_removeActivityIndicator()
            }
        } else {
            self.imgMain.sd_removeActivityIndicator()
        }
    }
    
    //------------------------------------------------------
    
    deinit { //same like dealloc in ObjectiveC
        
    }
    
    //------------------------------------------------------
    
    //MARK: Actions
    
    @IBAction func btnBack(_ sender: Any) {
        self.pop()
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
        let controller = NavigationManager.shared.bookingDetailsRatingVC
        controller.golfID = bookingDetails?.golfID ?? String()
        push(controller: controller)
    }
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        ratingView.isUserInteractionEnabled = false
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //------------------------------------------------------
}

