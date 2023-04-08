//
//  AddPostViewController.swift
//  GroceryApp
//
//  Created by Junyan Ren on 3/14/23.
//

import UIKit
import CoreData

class AddPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var idText: UITextField!
    @IBOutlet weak var typeIdText: UITextField!
    @IBOutlet weak var productIdText: UITextField!
    @IBOutlet weak var priceText: UITextField!
    @IBOutlet weak var descriptionText: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var isExpand: Bool = false
    
    let productRequest: NSFetchRequest<Product> = Product.fetchRequest()
    let typeRequest: NSFetchRequest<ProductType> = ProductType.fetchRequest()
    let allProductRequest: NSFetchRequest<Product> = Product.fetchRequest()
    let allTypeRequest: NSFetchRequest<ProductType> = ProductType.fetchRequest()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var products = [Product]()
    var types = [ProductType]()
    
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
        let postId = strToInt(str: self.idText.text ?? "")
        let typeId = strToInt(str: self.typeIdText.text ?? "")
        let productId = strToInt(str: self.productIdText.text ?? "")
        let postPrice = strToDouble(str: self.priceText.text ?? "")
        let postDescription = self.descriptionText.text
        let postedDate = datePicker.date
        
        findProducts()
        findTypes()
        
        if postId != -1 && validProductId(myId: productId, products: products) && validTypeId(myId: typeId, types: types) && postPrice != -1.0 {
            let newPost = Post(context: self.context)
            productRequest.predicate = NSPredicate(format: "id == \(productId)")
            typeRequest.predicate = NSPredicate(format: "id == \(typeId)")
            do {
                let product = try context.fetch(productRequest)[0]
                let type = try context.fetch(typeRequest)[0]
                newPost.product = product
                newPost.company = product.company
                newPost.productType = type
                newPost.id = Int32(postId)
                newPost.productId = Int32(productId)
                newPost.productTypeId = Int32(typeId)
                newPost.companyId = product.companyId
                newPost.postedDate = postedDate
                newPost.price = postPrice
                newPost.describle = postDescription
                newPost.logo = newPost.company?.logo
                self.savePost()
            } catch {
                print("Error: \(error)")
            }
            popup(view: self, alert: successAlert)
        } else {
            popup(view: self, alert: invalidAlert)
        }
    }
    
    //MARK: - model operation methods
    func savePost() {
        do {
            try context.save()
        } catch {
            print("Error: \(error)")
        }
    }
    
    func findProducts(){
        do {
            products = try context.fetch(allProductRequest)
        } catch {
            print("Error: \(error)")
        }
    }
   
    func findTypes(){
        do {
            types = try context.fetch(allTypeRequest)
        } catch {
            print("Error: \(error)")
        }
    }
}
