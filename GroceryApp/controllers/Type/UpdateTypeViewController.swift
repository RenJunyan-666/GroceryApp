//
//  UpdateTypeViewController.swift
//  GroceryApp
//
//  Created by Junyan Ren on 3/14/23.
//

import UIKit
import CoreData

class UpdateTypeViewController: UIViewController {
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var isExpand: Bool = false
    var typeId: Int32 = 1
    
    let request: NSFetchRequest<ProductType> = ProductType.fetchRequest()
    let requestAll: NSFetchRequest<ProductType> = ProductType.fetchRequest()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
        let typeName = self.nameText.text ?? ""
        if typeName != "" {
            request.predicate = NSPredicate(format: "id == \(typeId)")
            do {
                let updateType = try context.fetch(request)[0]
                updateType.productType = typeName
                self.updateType()
            } catch {
                print("Error: \(error)")
            }
            popup(view: self, alert: successAlert)
        } else {
            popup(view: self, alert: invalidAlert)
        }
    }
    
    //MARK: - model operation methods
    func updateType(){
        do {
            try context.save()
        } catch {
            print("Error: \(error)")
        }
    }
}
