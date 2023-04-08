//
//  TypeDetailViewController.swift
//  GroceryApp
//
//  Created by Junyan Ren on 3/27/23.
//

import UIKit
import CoreData

class TypeDetailViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    var selectedTypeId: Int32 = 1
    
    let request: NSFetchRequest<ProductType> = ProductType.fetchRequest()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadType()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadType()
    }
    
    @IBAction func updatePressed(_ sender: UIButton) {
        performSegue(withIdentifier: "updateType", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! UpdateTypeViewController
        destinationVC.typeId = selectedTypeId
    }
    
    //MARK: - model operation methods
    func loadType(){
        request.predicate = NSPredicate(format: "id == \(selectedTypeId)")
        do {
            let curType = try context.fetch(request)[0]
            nameLabel.text = curType.productType
            idLabel.text = "ID: \(curType.id)"
        } catch {
            print("Error: \(error)")
        }
    }
}
