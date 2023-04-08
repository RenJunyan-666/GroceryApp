//
//  CompanyData.swift
//  GroceryApp
//
//  Created by Junyan Ren on 4/3/23.
//

import Foundation

struct CompanyData: Codable {
    let id: String
    let name: String
    let address: String
    let country: String
    let zipcode: String
    let logo: String
    let companyType: String
}
