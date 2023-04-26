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
    
    // Certainly there are safer ways to implement conversion to and from dictionaries,
    // such as using a library, but this project just uses a simple example to convey
    // what is the thing you need.
    
    func toDictionary() -> Dictionary<String,Any> {
        return ["id": id, "name": name, "description": description,
                "stockAmount": stockAmount, "unit": unit]
    }
    
    static func fromDictionary(_ dict:Dictionary<String,Any>) -> Product {
        return Product(id: dict["id"] as! String, name: dict["name"] as! String, description: dict["description"] as! String, stockAmount: dict["stockAmount"] as! Int, unit: dict["unit"] as! String)
    }
}
