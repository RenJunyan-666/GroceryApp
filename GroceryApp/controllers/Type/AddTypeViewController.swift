//
//  AddTypeViewController.swift
//  GroceryApp
//
//  Created by Junyan Ren on 3/14/23.
//

import UIKit
import CoreData

class AddTypeViewController: UIViewController {
    @IBOutlet weak var idText: UITextField!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var isExpand: Bool = false
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
        let typeId = strToInt(str: self.idText.text ?? "")
        let typeName = self.nameText.text ?? ""
        
        if typeId != -1 && typeName != "" {
            let newType = ProductType(context: self.context)
            newType.id = Int32(typeId)
            newType.productType = typeName
            saveType()
            popup(view: self, alert: successAlert)
        } else {
            popup(view: self, alert: invalidAlert)
        }
    }
    
    //MARK: - model operation methods
    func saveType() {
        do {
            try context.save()
        } catch {
            print("Error: \(error)")
        }
    }
}
