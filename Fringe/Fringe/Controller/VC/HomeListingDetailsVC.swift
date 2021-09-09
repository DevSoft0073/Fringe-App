//
//  HomeListingDetailsVC.swift
//  Fringe
//
//  Created by MyMac on 9/9/21.
//
import UIKit
import SDWebImage
import Foundation
import Alamofire

class HomeListingDetailsVC : BaseVC {
    
    @IBOutlet weak var lblDetails: FGRegularLabel!
    @IBOutlet weak var btnFav: UIButton!
    @IBOutlet weak var lblPrice: FGMediumLabel!
    @IBOutlet weak var lblRating: FGRegularLabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var lblAddress: FGMediumLabel!
    @IBOutlet weak var lblName: FGSemiboldLabel!
    @IBOutlet weak var imgMain: UIImageView!
    
    var detailsData: HomeModal?
    var favUnfav: FavUnfvModal?
    var check = true
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //------------------------------------------------------
    
    deinit { //same like dealloc in ObjectiveC
        
    }
    
    //------------------------------------------------------
    
    //MARK: Custome
    
    func setup() {
        lblName.text = detailsData?.golfCourseName
        lblAddress.text = detailsData?.location
        lblPrice.text = detailsData?.price
        lblRating.text = detailsData?.rating
        lblDetails.text = detailsData?.golfCourseName
        ratingView.rating = Double(detailsData?.rating ?? String()) ?? 0.0
        imgMain.sd_addActivityIndicator()
        imgMain.sd_setIndicatorStyle(UIActivityIndicatorView.Style.medium)
        imgMain.sd_showActivityIndicatorView()
        if let image = detailsData?.image, image.isEmpty == false {
            let imgURL = URL(string: image)
            imgMain.sd_setImage(with: imgURL) { ( serverImage: UIImage?, _: Error?, _: SDImageCacheType, _: URL?) in
                self.imgMain.sd_removeActivityIndicator()
            }
        } else {
            self.imgMain.sd_removeActivityIndicator()
        }
        if detailsData?.image?.isEmpty == true{
            self.imgMain.image = UIImage(named: "placeholder-image-1")
        }
        if detailsData?.isFav == "1" {
            self.btnFav.setImage(UIImage(named: FGImageName.iconWhiteHeart), for: .normal)
        }else{
            self.btnFav.setImage(UIImage(named: FGImageName.iconUnFavWhiteHeart), for: .normal)
        }
    }
    
    func performFavUnfavStudio(completion:((_ flag: Bool) -> Void)?) {

        let headers:HTTPHeaders = [
           "content-type": "application/json",
            "Token": currentUser?.authorizationToken ?? String(),
          ]

        let parameter: [String: Any] = [
            Request.Parameter.golfID: detailsData?.golfID ?? String(),
        ]

        RequestManager.shared.requestPOST(requestMethod: Request.Method.favUnfav, parameter: parameter, headers: headers, showLoader: false, decodingType: ResponseModal<FavUnfvModal>.self, successBlock: { (response: ResponseModal<FavUnfvModal>) in
            print(response)

            LoadingManager.shared.hideLoading()

            if response.code == Status.Code.success {

                if let stringUser = try? response.data?.jsonString() {
                    print(stringUser)
                    self.favUnfav = response.data
                    DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: response.message ?? "") {
                    }
                    if self.favUnfav?.isFav == "1"{
                        self.btnFav.setImage(UIImage(named: FGImageName.iconWhiteHeart), for: .normal)
                    }else{
                        self.btnFav.setImage(UIImage(named: FGImageName.iconUnFavWhiteHeart), for: .normal)
                    }
                }
            } else {

                delay {

                }
            }

        }, failureBlock: { (error: ErrorModal) in

            LoadingManager.shared.hideLoading()

            delay {
                DisplayAlertManager.shared.displayAlert(animated: true, message: error.errorDescription, handlerOK: nil)
            }
        })
    }
    
    //------------------------------------------------------
    
    //MARK: Actions
    
    @IBAction func btnFavUnFav(_ sender: Any) {
        performFavUnfavStudio { (flag : Bool) in
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.pop()
    }
    
    @IBAction func btnRequest(_ sender: Any) {
        
        let controller = NavigationManager.shared.checkAvailabilityVC
        push(controller: controller)
    }
    
    @IBAction func btnChat(_ sender: Any) {
        
    }
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //------------------------------------------------------
}
