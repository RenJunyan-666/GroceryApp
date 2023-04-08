//
//  UpdatePostViewController.swift
//  GroceryApp
//
//  Created by Junyan Ren on 3/14/23.
//

import UIKit
import CoreData

class UpdatePostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var typeIdText: UITextField!
    @IBOutlet weak var productIdText: UITextField!
    @IBOutlet weak var priceText: UITextField!
    @IBOutlet weak var descriptionText: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var isExpand: Bool = false
    
    let productRequest: NSFetchRequest<Product> = Product.fetchRequest()
    let postRequest: NSFetchRequest<Post> = Post.fetchRequest()
    let typeRequest: NSFetchRequest<ProductType> = ProductType.fetchRequest()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var products = [Product]()
    var types = [ProductType]()
    var postId:Int32 = 1
    
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
        let typeId = strToInt(str: self.typeIdText.text ?? "")
        let productId = strToInt(str: self.productIdText.text ?? "")
        let postPrice = strToDouble(str: self.priceText.text ?? "")
        let postDescription = self.descriptionText.text
        let postedDate = datePicker.date
        findProducts()
        findTypes()
        if validProductId(myId: productId, products: products) && validTypeId(myId: typeId, types: types) && postPrice != -1.0 {
            productRequest.predicate = NSPredicate(format: "id == \(productId)")
            postRequest.predicate = NSPredicate(format: "id == \(postId)")
            typeRequest.predicate = NSPredicate(format: "id == \(typeId)")
            do {
                let updatePost = try context.fetch(postRequest)[0]
                let product = try context.fetch(productRequest)[0]
                let type = try context.fetch(typeRequest)[0]
                updatePost.product = product
                updatePost.productType = type
                updatePost.company = product.company
                updatePost.productId = Int32(productId)
                updatePost.productTypeId = Int32(typeId)
                updatePost.companyId = product.companyId
                updatePost.postedDate = postedDate
                updatePost.describle = postDescription
                updatePost.price = postPrice
                updatePost.logo = updatePost.company?.logo
                self.updatePost()
            } catch {
                print("Error: \(error)")
            }
            popup(view: self, alert: successAlert)
        } else {
            popup(view: self, alert: invalidAlert)
        }
    }
    
    //MARK: - model operation methods
    func updatePost() {
        do {
            try context.save()
        } catch {
            print("Error: \(error)")
        }
    }
    
    func findProducts(){
        do {
            products = try context.fetch(productRequest)
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
