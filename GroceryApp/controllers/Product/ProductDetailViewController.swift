//
//  ProductDetailViewController.swift
//  GroceryApp
//
//  Created by Junyan Ren on 3/27/23.
//

import UIKit
import CoreData

class ProductDetailViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var companyIdLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    var selectedProductId: Int32 = 1
    
    let request: NSFetchRequest<Product> = Product.fetchRequest()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadProduct()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadProduct()
    }

    @IBAction func updatePressed(_ sender: UIButton) {
        performSegue(withIdentifier: "updateProduct", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! UpdateProductViewController
        destinationVC.productId = selectedProductId
    }
    
    //MARK: - model operation methods
    func loadProduct(){
        request.predicate = NSPredicate(format: "id == \(selectedProductId)")
        do {
            let curProduct = try context.fetch(request)[0]
            nameLabel.text = curProduct.name
            idLabel.text = "ID: \(curProduct.id)"
            descriptionLabel.text = "\(curProduct.describle ?? "No Description")"
            ratingLabel.text = "Rating: \(curProduct.rating)"
            companyIdLabel.text = "Company ID: \(curProduct.companyId)"
            quantityLabel.text = "Quantity: \(curProduct.quantity)"
        } catch {
            print("Error: \(error)")
        }
    }
}
