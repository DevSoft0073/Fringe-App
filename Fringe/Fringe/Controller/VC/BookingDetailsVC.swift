//
//  BookingDetailsVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 21/08/21.
//

import UIKit
import Toucan
import SDWebImage
import Foundation

class BookingDetailsVC : BaseVC {
    
    @IBOutlet weak var lblDescription: FGRegularLabel!
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
        lblRating.text = bookingDetails?.rating
        lblRate.text = "$\(bookingDetails?.price ?? String())"
        ratingView.rating = Double(bookingDetails?.rating ?? String()) ?? Double()
        let dateValue = bookingDetails?.dates ?? String()
        let dateValu = NumberFormatter().number(from: dateValue)?.doubleValue ?? 0.0
        lblDate.text = convertTimeStampToDate(dateVal: dateValu)

        //image
        imgMain.sd_addActivityIndicator()
        imgMain.sd_setIndicatorStyle(UIActivityIndicatorView.Style.medium)
        imgMain.sd_showActivityIndicatorView()
        imgMain.image = getPlaceholderImage()
        if bookingDetails?.golfImages?.count ?? 0 > 0{
            if let image = bookingDetails?.golfImages?[0], image.isEmpty == false {
                let imgURL = URL(string: image)
                imgMain.sd_setImage(with: imgURL) { ( serverImage: UIImage?, _: Error?, _: SDImageCacheType, _: URL?) in
                    if let serverImage = serverImage {
                        self.imgMain.image = Toucan.init(image: serverImage).resizeByCropping(FGSettings.profileImageSize).maskWithRoundedRect(cornerRadius: 0, borderWidth: FGSettings.profileBorderWidth, borderColor: .clear).image
                    }
                    self.imgMain.sd_removeActivityIndicator()
                }
            } else {
                self.imgMain.sd_removeActivityIndicator()
            }
        } else {
            self.imgMain.sd_removeActivityIndicator()
            imgMain.image = UIImage(named: FGImageName.imgPlaceHolder)
        }
        
        //description
        
        lblDescription.text = bookingDetails?.bookingModalDescription
        
        //status value
        
        if bookingDetails?.sessionComplete == "0" {
            
            lblStatus.text = "Pending"
            
        } else {
            
            lblStatus.text = "Complete"
            
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
        
        if bookingDetails?.sessionComplete == "0" {
            
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: "You can rate golf club when booking has been complete.") {
                
            }
            
        } else {
            
            let controller = NavigationManager.shared.bookingDetailsRatingVC
            controller.golfID = bookingDetails?.golfID ?? String()
            controller.bookingDetails = self.bookingDetails
            push(controller: controller)
            
        }
        
       
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

