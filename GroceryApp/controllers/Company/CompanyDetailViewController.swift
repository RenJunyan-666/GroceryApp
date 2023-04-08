//
//  CompanyDetailViewController.swift
//  GroceryApp
//
//  Created by Junyan Ren on 3/27/23.
//

import UIKit
import CoreData

class CompanyDetailViewController: UIViewController {

    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var zipLabel: UILabel!
    @IBOutlet weak var companyTypeLabel: UILabel!
    var selectedCompanyId: Int32 = 1
    
    let request: NSFetchRequest<Company> = Company.fetchRequest()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCompany()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadCompany()
    }

    @IBAction func updatePressed(_ sender: UIButton) {
        performSegue(withIdentifier: "updateCompany", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! UpdateCompanyViewController
        destinationVC.companyId = selectedCompanyId
    }
    
    //MARK: - model operation methods
    func loadCompany(){
        request.predicate = NSPredicate(format: "id == \(selectedCompanyId)")
        do {
            let curCompany = try context.fetch(request)[0]
            nameLabel.text = curCompany.name
            idLabel.text = "ID: \(curCompany.id)"
            addressLabel.text = "Address: \(curCompany.address!)"
            countryLabel.text = "Country: \(curCompany.country!)"
            zipLabel.text = "Zip: \(curCompany.zip!)"
            companyTypeLabel.text = "Type: \(curCompany.companyType ?? "No Company Type")"
            if let safeLogo = curCompany.logo {
                let url = URL(string: String(data: safeLogo, encoding: .utf8) ?? "")
                if url != nil {
                    logoView.load(url: url!)
                } else {
                    logoView.image = UIImage(data: safeLogo)
                }
            }
        } catch {
            print("Error: \(error)")
        }
    }
}

//MARK: - load remote images
extension UIImageView {
    func load(url: URL){
        DispatchQueue.global().async {[weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
