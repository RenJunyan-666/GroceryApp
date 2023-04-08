//
//  CreateOrderViewController.swift
//  GroceryApp
//
//  Created by Junyan Ren on 3/14/23.
//

import UIKit
import CoreData

class CreateOrderViewController: UIViewController {
    @IBOutlet weak var idText: UITextField!
    @IBOutlet weak var postIdText: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var isExpand: Bool = false
    
    let request: NSFetchRequest<Post> = Post.fetchRequest()
    let requestAll: NSFetchRequest<Post> = Post.fetchRequest()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var posts = [Post]()
    
    var invalidAlert = UIAlertController(title: "Attention", message: "Invalid Input!", preferredStyle: .alert)
    var successAlert = UIAlertController(title: "Success", message: "Create Successfully!", preferredStyle: .alert)

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
    @IBAction func createPressed(_ sender: UIButton) {
        let orderId = strToInt(str: idText.text ?? "")
        let postId = strToInt(str: postIdText.text ?? "")
        let date = datePicker.date
        findPosts()
        if validPostId(myId: postId, posts: posts) && orderId != -1 {
            let newOrder = Order(context: self.context)
            request.predicate = NSPredicate(format: "id == \(postId)")
            do {
                let post = try context.fetch(request)[0]
                newOrder.post = post
                newOrder.id = Int32(orderId)
                newOrder.postId = Int32(postId)
                newOrder.productId = post.productId
                newOrder.productType = post.productType?.productType
                newOrder.date = date
                self.saveOrder()
            } catch {
                print("Error: \(error)")
            }
            popup(view: self, alert: successAlert)
        } else {
            popup(view: self, alert: invalidAlert)
        }
    }
    
    //MARK: - model operation methods
    func saveOrder() {
        do {
            try context.save()
        } catch {
            print("Error: \(error)")
        }
    }
    
    func findPosts(){
        do {
            posts = try context.fetch(requestAll)
        } catch {
            print("Error: \(error)")
        }
    }
}
