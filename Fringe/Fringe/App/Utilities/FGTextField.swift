//
//  FGTextField.swift
//  NewProject
//
//  Created by Dharmesh Avaiya on 22/08/20.
//  Copyright © 2020 dharmesh. All rights reserved.
//

import Foundation
import UIKit
import MonthYearPicker

class FGBaseTextField: UITextField {
    
    public var fontDefaultSize : CGFloat {
        return font?.pointSize ?? 0.0
    }
    public var fontSize : CGFloat = 0.0
    
    public var padding: Double = 8
    
    private var leftEmptyView: UIView {
        return UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: padding, height: Double.zero)))
    }
    
    private var leftButton : UIButton {
        return UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: padding, height: Double.zero)))
    }
    
    private var rightEmptyViewForButton : UIView {
        return leftButton
    }
    
    private var rightEmptyView: UIView {
        return leftEmptyView
    }
    
    override func becomeFirstResponder() -> Bool {
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        return super.resignFirstResponder()
    }
    
    //------------------------------------------------------
    
    //MARK: Customs
    
    fileprivate func setupDefault() {
        
        self.cornerRadius = FGSettings.cornerRadius
        
    }
    
    private func setup() {
        
        fontSize = getDynamicFontSize(fontDefaultSize: fontDefaultSize)
        
        leftView = leftEmptyView
        leftViewMode = .always
        
        rightView = rightEmptyView
        rightViewMode = .always
        
        setupDefault()
    }
    
    /// common text field layout for inputs
    ///
    /// - Parameter aDecoder: <#aDecoder description#>
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
}

class FGProDisplayRegularTextField: FGBaseTextField {

    /// common text field layout for inputs
    ///
    /// - Parameter aDecoder: aDecoder description
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.font = FGFont.PoppinsBold(size: fontSize)
    }
}

class FGProDisplayBoldTextField: FGBaseTextField {

    /// common text field layout for inputs
    ///
    /// - Parameter aDecoder: aDecoder description
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.font = FGFont.PoppinsBold(size: fontSize)
    }
}
class FGProDisplaySemiBoldTextField: FGBaseTextField {

    /// common text field layout for inputs
    ///
    /// - Parameter aDecoder: aDecoder description
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.font = FGFont.PoppinsSemiBold(size: fontSize)
    }
}
class FGRegularTextField: FGBaseTextField {
    
    /// common text field layout for inputs
    ///
    /// - Parameter aDecoder: aDecoder description
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.font = FGFont.PoppinsRegular(size: fontSize)
    }
}
class FGBoldTextField: FGBaseTextField {
    
    /// common text field layout for inputs
    ///
    /// - Parameter aDecoder: aDecoder description
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.font = FGFont.PoppinsBold(size: fontSize)
    }
}
class FGMediumTextField: FGBaseTextField {
    
    /// common text field layout for inputs
    ///
    /// - Parameter aDecoder: aDecoder description
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.font = FGFont.PoppinsMedium(size: fontSize)
    }
}


class FGEmailTextField: FGRegularTextField {
    
    var leftEmailView: UIView {
        let imgView = UIImageView(image: UIImage(named: ""))
        imgView.contentMode = .scaleAspectFit
        return imgView
    }
    
    
    //------------------------------------------------------
    
    //MARK: Customs
    
    func setup() {
        
        leftView = leftEmailView
        
        self.keyboardType = .emailAddress
        self.autocorrectionType = .no
        
    }
    
    //------------------------------------------------------
    
    //MARK: Override
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(origin: CGPoint(x: CGFloat(padding), y: CGFloat(padding * 0.2)), size: CGSize(width: CGFloat(padding) * 0, height: bounds.height -  CGFloat(padding * 0.1)))
    }
    
    //------------------------------------------------------
    
    //MARK: Init
    
    /// common text field layout for inputs
    ///
    /// - Parameter aDecoder: aDecoder description
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
}
class FGPasswordTextField: FGRegularTextField {
    
    var leftPasswordView: UIView {
        let imgView = UIImageView(image: UIImage(named: ""))
        imgView.contentMode = .scaleAspectFit
        return imgView
    }
    
    //------------------------------------------------------
    
    //MARK: Customs
    
    func setup() {
        
        leftView = leftPasswordView
        
        self.isSecureTextEntry = true
        self.keyboardType = .default
        self.autocorrectionType = .no
    }
    
    //------------------------------------------------------
    
    //MARK: Override
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(origin: CGPoint(x: CGFloat(padding), y: CGFloat(padding * 0.2)), size: CGSize(width: CGFloat(padding) * 0, height: bounds.height -  CGFloat(padding * 0.1)))
    }
    
    //------------------------------------------------------
    
    //MARK: Init
    
    /// common text field layout for inputs
    ///
    /// - Parameter aDecoder: aDecoder description
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
}
class FGUsernameTextField: FGMediumTextField {
    
    var leftUserView: UIView {
        let imgView = UIImageView(image: UIImage(named:""))
        imgView.contentMode = .scaleAspectFit
        return imgView
    }
    
    //------------------------------------------------------
    
    //MARK: Customs
    
    func setup() {
        
        leftView = leftUserView
        
        self.keyboardType = .default
        self.autocorrectionType = .no
        self.autocapitalizationType = .words
    }
    
    //------------------------------------------------------
    
    //MARK: Override
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(origin: CGPoint(x: CGFloat(padding), y: CGFloat(padding * 0.2)), size: CGSize(width: CGFloat(padding) * 0, height: bounds.height -  CGFloat(padding * 0.1)))
    }
    
    //------------------------------------------------------
    
    //MARK: Init
    
    /// common text field layout for inputs
    ///
    /// - Parameter aDecoder: aDecoder description
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
}
class FGBirthDateTextField: FGRegularTextField, UITextFieldDelegate {
    
    var rightUserView: UIView {
        let imgView = UIImageView(image: UIImage(named: FGImageName.iconCalender))
        imgView.contentMode = .scaleAspectFit
        return imgView
    }
    
    private static let height: CGFloat = 20
    private static let crossButtonSize = CGSize(width: height, height: height)
    private let crossButtonView = UIButton(frame: CGRect(origin: CGPoint.zero, size: crossButtonSize))
    
    let dpDate = UIDatePicker()
    
    //------------------------------------------------------
    
    //MARK: Customs
    
    func setup() {
        
        rightView = rightUserView
        
        self.keyboardType = .default
        self.autocorrectionType = .no
        self.autocapitalizationType = .words
        dpDate.datePickerMode = .date
        if #available(iOS 13.4, *) {
            dpDate.preferredDatePickerStyle = .wheels
            dpDate.backgroundColor = .white
            dpDate.setValue(UIColor.black, forKeyPath: "textColor")
            dpDate.setValue(false, forKeyPath: "highlightsToday")
            
        } else {
            // Fallback on earlier versions
        }
        inputView = dpDate
        dpDate.setDate(Date(), animated: false)
        crossButtonView.contentMode = .center
        crossButtonView.setImage(UIImage(named: ""), for: UIControl.State.normal)
        
    }
    
    //------------------------------------------------------
    
    //MARK: Override
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(origin: CGPoint(x: self.bounds.width - CGFloat(padding * 4), y: CGFloat(padding * 1.6)), size: CGSize(width: CGFloat(padding) * 2, height: bounds.height -  CGFloat(padding * 3.2)))
        
    }
    
    //------------------------------------------------------
    
    //MARK: UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        self.text = DateTimeManager.shared.stringFrom(date: dpDate.date, inFormate: DateFormate.MMM_DD_COM_yyyy)
//    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let today = Date()
        let gregorian = NSCalendar(identifier: NSCalendar.Identifier.gregorian)
        let age = gregorian?.components([.month, .day, .year], from: dpDate.date, to: today, options:[])
        
        if (age?.year)! < 13 {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.ageMustBeGreaterThen13, handlerOK: nil)
            self.text = ""
        } else {
//            self.text = DateTimeManager.shared.stringFrom(date: dpDate.date, inFormate: DateFormate.MMM_DD_COM_yyyy)
            
        }
    }
    
    //------------------------------------------------------
    
    //MARK: Init
    
    /// common text field layout for inputs
    ///
    /// - Parameter aDecoder: aDecoder description
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.delegate = self
    }
}
class FGGenderTextField: FGRegularTextField, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var rightUserView: UIView {
        let imgView = UIImageView(image: UIImage(named: FGImageName.iconDropDown))
        imgView.contentMode = .scaleAspectFit
        return imgView
    }
    
    private static let height: CGFloat = 20
    private static let crossButtonSize = CGSize(width: height, height: height)
    private let crossButtonView = UIButton(frame: CGRect(origin: CGPoint.zero, size: crossButtonSize))
    
    let pvGender = UIPickerView()
    let pvOptions: [String] = ["Not to Answer", "Male", "Female"]
    var selectedOption: String? {
        didSet {
            self.text = selectedOption
        }
    }
    
    //------------------------------------------------------
    
    //MARK: Customs
    
    func setup() {
        
        rightView = rightUserView
        
        self.keyboardType = .default
        self.autocorrectionType = .no
        self.autocapitalizationType = .words
        
        
        pvGender.dataSource = self
        pvGender.delegate = self
        inputView = pvGender
        
        crossButtonView.contentMode = .center
        crossButtonView.setImage(UIImage(named: ""), for: UIControl.State.normal)
    }
    
    //------------------------------------------------------
    
    //MARK: Override
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(origin: CGPoint(x: self.bounds.width - CGFloat(padding * 4), y: CGFloat(padding * 1.6)), size: CGSize(width: CGFloat(padding) * 2, height: bounds.height -  CGFloat(padding * 3.2)))
        
    }
    
    //------------------------------------------------------
    
    //MARK: UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if selectedOption == nil {
            selectedOption = pvOptions.first
        }
    }
    
    //------------------------------------------------------
    
    //MARK: UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pvOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pvOptions[row]
    }
    
    //------------------------------------------------------
    
    //MARK: UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedOption = pvOptions[row]
    }
    
    //------------------------------------------------------
    
    //MARK: Init
    
    /// common text field layout for inputs
    ///
    /// - Parameter aDecoder: aDecoder description
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.delegate = self
    }
}
class FGMobileNumberTextField: FGRegularTextField {
    
    var leftUserView: UIView {
        let imgView = UIImageView(image: UIImage(named: ""))
        imgView.contentMode = .scaleAspectFit
        return imgView
    }
    
    //------------------------------------------------------
    
    //MARK: Customs
    
    func setup() {
        
        leftView = leftUserView
        self.keyboardType = .numberPad
        self.autocorrectionType = .no
        self.autocapitalizationType = .words
    }
    
    //------------------------------------------------------
    
    //MARK: Override
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(origin: CGPoint(x: CGFloat(padding), y: CGFloat(padding * 0.2)), size: CGSize(width: CGFloat(padding) * 0, height: bounds.height -  CGFloat(padding * 0.1)))
    }
    
    
    //------------------------------------------------------
    
    //MARK: Init
    
    /// common text field layout for inputs
    ///
    /// - Parameter aDecoder: aDecoder description
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
}

