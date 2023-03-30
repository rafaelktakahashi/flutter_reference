//
//  ProductRepository.swift
//  Runner
//
//  Created by Rafael Takahashi on 29/03/23.
//

import Foundation

class ProductRepository : InteropRepository {
    init() {
        super.init(withRepositoryName: "product")
        
        // We could probably use async methods here, but they're only
        // available in iOS 13.
        super.exposeMethod("fetchProducts") {
            [weak self] (_, fulfill, reject) in
            // This is just simulating a delay.
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                fulfill(self?.fetchProducts())
            }
            // You could call reject to return an error, but don't fulfill or
            // reject more than once.
        }
    }
    
    // Normally, a repository would also have methods to be used by iOS code, but this one
    // is merely an example of an interop repository that exposes its methods to the Flutter
    // side.
    // In real code, you would also have methods returning classes from RxSwift, or whatever
    // is your return type of choice.
    
    /// Method exposed to the other side of the bridge.
    /// Stuff from RxSwift is difficult to serialize, so we use separate functions like these that can throw errors.
    ///
    /// Be absolutely sure to only expose dictionaries, not objects, so that they make it to the other side of the bridge
    /// as a json.
    private func fetchProducts() -> Array<Dictionary<String,Any>> {
        return [
            Product(id: "0001", name: "Powder computer", description: "Finely ground computer", stockAmount: 3, unit: "g").toDictionary(),
            Product(id: "0090", name: "Paperback", description: "The backside of a sheet of paper (front side purchased separately).", stockAmount: 5, unit: "unit").toDictionary(),
            Product(id: "0022", name: "Green ideas", description: "Thought, concept or mental impression of the green variety.", stockAmount: 8, unit: "unit").toDictionary()
        ]
    }
}
