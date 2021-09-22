//
//	FacebookModal.swift
//
//	Create by Dharmesh Avaiya on 16/3/2021
//	Copyright © 2021. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class FacebookModal : NSObject, NSCoding{

	var email : String = String()
	var firstName : String = String()
	var facebookId : String = String()
	var lastName : String = String()
	var name : String = String()
	var picture : PictureModal?


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		email = dictionary["email"] as? String ?? String()
		firstName = dictionary["first_name"] as? String ?? String()
        facebookId = dictionary["id"] as? String ?? String()
		lastName = dictionary["last_name"] as? String ?? String()
		name = dictionary["name"] as? String ?? String()
		if let pictureData = dictionary["picture"] as? [String:Any]{
			picture = PictureModal(fromDictionary: pictureData)
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        dictionary["email"] = email
        dictionary["first_name"] = firstName
        dictionary["id"] = facebookId
        dictionary["last_name"] = lastName
        dictionary["name"] = name
		if picture != nil{
			dictionary["picture"] = picture?.toDictionary()
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         email = aDecoder.decodeObject(forKey: "email") as? String ?? String()
         firstName = aDecoder.decodeObject(forKey: "first_name") as? String ?? String()
         facebookId = aDecoder.decodeObject(forKey: "id") as? String ?? String()
         lastName = aDecoder.decodeObject(forKey: "last_name") as? String ?? String()
         name = aDecoder.decodeObject(forKey: "name") as? String ?? String()
         picture = aDecoder.decodeObject(forKey: "picture") as? PictureModal
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
        aCoder.encode(email, forKey: "email")
        aCoder.encode(firstName, forKey: "first_name")
        aCoder.encode(facebookId, forKey: "id")
        aCoder.encode(lastName, forKey: "last_name")
        aCoder.encode(name, forKey: "name")
		if picture != nil {
			aCoder.encode(picture, forKey: "picture")
		}

	}

}
