//
//  DisplayController.swift
//  GroceryApp
//
//  Created by Junyan Ren on 3/21/23.
//

import Foundation

//MARK: - display products
func viewAllProducts(_ products: [Product]) -> [String] {
    var result:[String] = []
    if products.count != 0 {
        for product in products {
            result += ["\(product.id), \(product.name!), \(product.describle ?? "No description"), \(product.rating) rates, C\(product.companyId), \(product.quantity) units"]
        }
    }
    return result
}

//MARK: - display posts
func viewAllProductPosts(_ posts: [Post]) -> [String]{
    var result:[String] = []
    if posts.count != 0 {
        for post in posts {
            result += ["\(post.id), T\(post.productTypeId), C\(post.companyId), Pr\(post.productId), \(showDate(date: post.postedDate!)), $\(post.price), \(post.describle ?? "No Description.")"]
        }
    }
    return result
}

//MARK: - display companies
func viewAllCompanies(_ companies:[Company]) -> [String]{
    var result:[String] = []
    if companies.count != 0 {
        for company in companies {
            result += ["\(company.id), \(company.name!), \(company.address!), \(company.country!), \(company.zip!), \(company.companyType ?? "No Types")"]
        }
    }
    return result
}

//MARK: - display types
func viewAllProductTypes(_ types: [ProductType]) -> [String] {
    var result:[String] = []
    if types.count != 0 {
        for type in types {
            result += ["\(type.id), \(type.productType!)"]
        }
    }
    return result
}

//MARK: - display orders
func viewAllOrders(_ orders: [Order]) -> [String] {
    var result:[String] = []
    if orders.count != 0 {
        for order in orders {
            result += ["\(order.id), Po\(order.postId), Pr\(order.productId), \(order.productType!), \(showDate(date: order.date!))"]
        }
    }
    return result
}
