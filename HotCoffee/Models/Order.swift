//
//  Order.swift
//  HotCoffee
//
//  Created by sungyeon kim on 2022/05/12.
//

import Foundation

struct Order: Codable {
    
    let name: String
    let email: String
    let type: CoffeeType
    let size: CoffeeSize
    
}

enum CoffeeType: String, Codable, CaseIterable {
    case cappuccino
    case latte
    case espressino
    case cortado
    case 자판기
}

enum CoffeeSize: String, Codable, CaseIterable {
    case small
    case medium
    case large
}

extension Order {
    
    static var all: Resource<[Order]> = {
        
        
        guard let url = URL(string: "https://guarded-retreat-82533.herokuapp.com/orders") else {
            fatalError("URL is incorrect!")
        }
        
        return Resource<[Order]>(url: url)
    }()
    
    static func create(viewModel: AddCoffeeOrderViewModel) -> Resource<Order?> {
        
        let order = Order(viewModel)
        
        guard let url = URL(string: "https://guarded-retreat-82533.herokuapp.com/orders") else {
            fatalError("URL is incorrect!")
        }
        
        guard let data = try? JSONEncoder().encode(order) else {
            fatalError("Error encoding!")
        }
        
        var resource = Resource<Order?>(url: url)
        resource.httpMethod = HttpMethod.post
        resource.body = data
        
        return resource
        
    }
}

extension Order {
    
    init?(_ viewModel: AddCoffeeOrderViewModel) {
        
        guard let name = viewModel.name,
              let email = viewModel.email,
              let selectedType = CoffeeType(rawValue: viewModel.selectedType!.lowercased()),
              let selectedSize = CoffeeSize(rawValue: viewModel.selectedSize!.lowercased()) else {
            return nil
        }
        
        self.name = name
        self.email = email
        self.type = selectedType
        self.size = selectedSize  
    }
}

