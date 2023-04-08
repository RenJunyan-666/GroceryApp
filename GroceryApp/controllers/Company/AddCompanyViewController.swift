//
//  AddCompanyViewController.swift
//  GroceryApp
//
//  Created by Junyan Ren on 3/13/23.
//

import UIKit
import CoreData

class AddCompanyViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var idText: UITextField!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var addressText: UITextField!
    @IBOutlet weak var countryText: UITextField!
    @IBOutlet weak var zipText: UITextField!
    @IBOutlet weak var typeText: UITextField!
    @IBOutlet weak var logoView: UIImageView!
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
    @IBAction func logoPressed(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func addPressed(_ sender: UIButton) {
        let companyId = strToInt(str: idText.text ?? "")
        let companyName = self.nameText.text ?? ""
        let companyAddress = self.addressText.text ?? ""
        let companyCountry = self.countryText.text ?? ""
        let companyZip = self.zipText.text ?? ""
        let companyType = self.typeText.text
        
        if companyId != -1 && companyName != "" && companyAddress != "" && companyCountry != "" && companyZip != "" {
            let newCompany = Company(context: self.context)
            newCompany.id = Int32(companyId)
            newCompany.name = companyName
            newCompany.address = companyAddress
            newCompany.country = companyCountry
            newCompany.zip = companyZip
            newCompany.companyType = companyType
            if let safeLogo = logoView.image {
                newCompany.logo = safeLogo.pngData()! as Data
            }
            self.saveCompany()
            popup(view: self, alert: successAlert)
        } else {
            popup(view: self, alert: invalidAlert)
        }
    }
    
    //MARK: - image picker controller methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {return}
        logoView.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - model operation methods
    func saveCompany() {
        do {
            try context.save()
        } catch {
            print("Error: \(error)")
        }
    }
}
