//
//  OperationViewController.swift
//  GroceryApp
//
//  Created by Junyan Ren on 3/13/23.
//

import UIKit
import CoreData

class OperationViewController: UIViewController {
    let productRequest: NSFetchRequest<Product> = Product.fetchRequest()
    let companyRequest: NSFetchRequest<Company> = Company.fetchRequest()
    let typeRequest: NSFetchRequest<ProductType> = ProductType.fetchRequest()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var companies = [Company]()
    var products = [Product]()
    var types = [ProductType]()
    
    var alert = UIAlertController(title: "Attention", message: "Please create company first!", preferredStyle: .alert)

    override func viewDidLoad() {
        super.viewDidLoad()
        findProducts()
        findCompanies()
        findTypes()
    }
    
    //MARK: - components operation methods
    @IBAction func productPressed(_ sender: UIButton) {
        findCompanies()
        if companies.count == 0 {
            popup(view: self, alert: alert)
        } else {
            performSegue(withIdentifier: "goToProduct", sender: self)
        }
    }
    
    @IBAction func postPressed(_ sender: UIButton) {
        findProducts()
        findTypes()
        if products.count == 0 || types.count == 0 {
            alert.message = "Please create product or type first!"
            popup(view: self, alert: alert)
        } else {
            performSegue(withIdentifier: "goToPost", sender: self)
        }
    }
    
    @IBAction func companyPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToCompany", sender: self)
    }
    
    @IBAction func typePressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToType", sender: self)
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - model operation methods
    func findProducts(){
        do {
            products = try context.fetch(productRequest)
        } catch {
            print("Error: \(error)")
        }
    }
    
    func findCompanies(){
        do {
            companies = try context.fetch(companyRequest)
        } catch {
            print("Error: \(error)")
        }
    }
    
    func findTypes(){
        do {
            types = try context.fetch(typeRequest)
        } catch {
            print("Error: \(error)")
        }
    }
}
