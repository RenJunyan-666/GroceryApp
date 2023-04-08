//
//  AddProductViewController.swift
//  GroceryApp
//
//  Created by Junyan Ren on 3/14/23.
//

import UIKit
import CoreData

class AddProductViewController: UIViewController {
    @IBOutlet weak var idText: UITextField!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var descriptionText: UITextField!
    @IBOutlet weak var ratingText: UITextField!
    @IBOutlet weak var companyIdText: UITextField!
    @IBOutlet weak var quantityText: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var isExpand: Bool = false
    
    var request: NSFetchRequest<Company> = Company.fetchRequest()
    var requestAll: NSFetchRequest<Company> = Company.fetchRequest()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var companies = [Company]()
    
    var invalidAlert = UIAlertController(title: "Attention", message: "Invalid Input!", preferredStyle: .alert)
    var successAlert = UIAlertController(title: "Success", message: "Add Successfully!", preferredStyle: .alert)

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
    @IBAction func addPressed(_ sender: UIButton) {
        let productId = strToInt(str: self.idText.text ?? "")
        let productName = self.nameText.text ?? ""
        let productDescription = self.descriptionText.text
        let productRating = strToInt(str: self.ratingText.text ?? "")
        let companyId = strToInt(str: self.companyIdText.text ?? "")
        let productQuantity = strToInt(str: self.quantityText.text ?? "")
        findCompanies()
        if productId != -1 && productName != "" && validRating(rating: productRating) && validCompanyId(myId: companyId, companies: companies) && validQuantity(quantity: productQuantity) {
            let newProduct = Product(context: self.context)
            request.predicate = NSPredicate(format: "id == \(companyId)")
            do {
                newProduct.company = try context.fetch(request)[0]
                newProduct.id = Int32(productId)
                newProduct.name = productName
                newProduct.describle = productDescription
                newProduct.rating = Int32(productRating)
                newProduct.companyId = Int32(companyId)
                newProduct.quantity = Int32(productQuantity)
                saveProduct()
            } catch {
                print("Error: \(error)")
            }
            popup(view: self, alert: successAlert)
        } else {
            popup(view: self, alert: invalidAlert)
        }
    }
    
    //MARK: - model operation methods
    func saveProduct() {
        do {
            try context.save()
        } catch {
            print("Error: \(error)")
        }
    }
    
    func findCompanies(){
        do {
            companies = try context.fetch(requestAll)
        } catch {
            print("Error: \(error)")
        }
    }
}
