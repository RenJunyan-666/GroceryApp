//
//  UpdateProductViewController.swift
//  GroceryApp
//
//  Created by Junyan Ren on 3/14/23.
//

import UIKit
import CoreData

class UpdateProductViewController: UIViewController {
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var descriptionText: UITextField!
    @IBOutlet weak var ratingText: UITextField!
    @IBOutlet weak var companyIdText: UITextField!
    @IBOutlet weak var quantityText: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let companyRequest: NSFetchRequest<Company> = Company.fetchRequest()
    let productRequest: NSFetchRequest<Product> = Product.fetchRequest()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var productId:Int32 = 1
    var isExpand: Bool = false
    var companies = [Company]()
    
    var invalidAlert = UIAlertController(title: "Attention", message: "Invalid Input!", preferredStyle: .alert)
    var successAlert = UIAlertController(title: "Success", message: "Update Successfully!", preferredStyle: .alert)

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: - scroll up
    @objc func keyboardAppear(){
        if !isExpand {
            self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.scrollView.frame.height + 250)
            isExpand = true
        }
    }
    
    @objc func keyboardDisappear(){
        if isExpand {
            self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.scrollView.frame.height - 250)
            isExpand = false
        }
    }
    
    //MARK: - components operation methods
    @IBAction func updatePressed(_ sender: UIButton) {
        let productName = self.nameText.text ?? ""
        let productDescription = self.descriptionText.text
        let productRating = strToInt(str: self.ratingText.text ?? "")
        let companyId = strToInt(str: self.companyIdText.text ?? "")
        let productQuantity = strToInt(str: self.quantityText.text ?? "")
        findCompanies()
        if productName != "" && validRating(rating: productRating) && validCompanyId(myId: companyId, companies: companies) && validQuantity(quantity: productQuantity) {
            productRequest.predicate = NSPredicate(format: "id == \(productId)")
            companyRequest.predicate = NSPredicate(format: "id == \(companyId)")
            do {
                let updateProduct = try context.fetch(productRequest)[0]
                updateProduct.company = try context.fetch(companyRequest)[0]
                updateProduct.name = productName
                updateProduct.describle = productDescription
                updateProduct.rating = Int32(productRating)
                updateProduct.companyId = Int32(companyId)
                updateProduct.quantity = Int32(productQuantity)
                self.updateProduct()
            } catch {
                print("Error: \(error)")
            }
            popup(view: self, alert: successAlert)
        } else {
            popup(view: self, alert: invalidAlert)
        }
    }
    
    //MARK: - model operation methods
    func updateProduct() {
        do {
            try context.save()
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
}
