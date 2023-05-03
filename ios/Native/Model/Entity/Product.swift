//
//  Product.swift
//  Runner
//
//  Created by Rafael Takahashi on 29/03/23.
//

import Foundation

struct Product : PlaygroundEntity {
    public let id: String
    public let name: String
    public let description: String
    public let stockAmount: Int
    public let unit: String
    /// Price per unit, in cents of euro. Ex.: 5511 is 55 euros and 11 cents.
    ///
    /// The reason why I'm using euros in this example is to demonstrate formatting.
    public let pricePerUnitCents: Int
    
    // Certainly there are safer ways to implement conversion to and from dictionaries,
    // such as using a library, but this project just uses a simple example to convey
    // what is the thing you need.
    
    func toDictionary() -> Dictionary<String,Any> {
        return ["id": id, "name": name, "description": description,
                "stockAmount": stockAmount, "unit": unit, "pricePerUnitCents": pricePerUnitCents]
    }
    
    static func fromDictionary(_ dict:Dictionary<String,Any>) -> Product {
        return Product(id: dict["id"] as! String, name: dict["name"] as! String, description: dict["description"] as! String, stockAmount: dict["stockAmount"] as! Int, unit: dict["unit"] as! String, pricePerUnitCents: dict["pricePerUnitCents"] as! Int)
    }
}
