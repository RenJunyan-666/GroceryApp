//
//  updateCompanyViewController.swift
//  GroceryApp
//
//  Created by Junyan Ren on 3/13/23.
//

import UIKit
import CoreData

class UpdateCompanyViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var addressText: UITextField!
    @IBOutlet weak var countryText: UITextField!
    @IBOutlet weak var zipText: UITextField!
    @IBOutlet weak var typeText: UITextField!
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let request: NSFetchRequest<Company> = Company.fetchRequest()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var companyId:Int32 = 1
    var isExpand: Bool = false
    
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
    
    @IBAction func updatePressed(_ sender: UIButton) {
        let companyName = self.nameText.text ?? ""
        let companyAddress = self.addressText.text ?? ""
        let companyCountry = self.countryText.text ?? ""
        let companyZip = self.zipText.text ?? ""
        let companyType = self.typeText.text
        if companyName != "" && companyAddress != "" && companyCountry != "" && companyZip != "" {
            request.predicate = NSPredicate(format: "id == \(companyId)")
            do {
                let updateCompany = try context.fetch(request)[0]
                updateCompany.name = companyName
                updateCompany.address = companyAddress
                updateCompany.country = companyCountry
                updateCompany.zip = companyZip
                updateCompany.companyType = companyType
                if let safeLogo = logoView.image {
                    updateCompany.logo = safeLogo.pngData()! as Data
                }
                self.updateCompany()
            } catch {
                print("Error: \(error)")
            }
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
    func updateCompany(){
        do {
            try context.save()
        } catch {
            print("Error: \(error)")
        }
    }
}
