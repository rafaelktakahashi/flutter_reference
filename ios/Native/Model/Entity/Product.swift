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
    
    // You might also want a factory method that accepts a dictionary, in case this
    // entity also needs to be sent from Flutter to native.
    
    func toDictionary() -> Dictionary<String,Any> {
        return ["id": id, "name": name, "description": description,
                "stockAmount": stockAmount, "unit": unit]
    }
}
