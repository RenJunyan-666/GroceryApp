//
//  OrderDetailViewController.swift
//  GroceryApp
//
//  Created by Junyan Ren on 3/27/23.
//

import UIKit
import CoreData

class OrderDetailViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postIdLabel: UILabel!
    @IBOutlet weak var productIdLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    var selectedOrderId: Int32 = 1
    
    let request: NSFetchRequest<Order> = Order.fetchRequest()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadOrder()
    }
    
    //MARK: - model operation methods
    func loadOrder(){
        request.predicate = NSPredicate(format: "id == \(selectedOrderId)")
        do {
            let curOrder = try context.fetch(request)[0]
            nameLabel.text = "Order ID: \(curOrder.id)"
            postIdLabel.text = "Post ID: \(curOrder.postId)"
            productIdLabel.text = "Product ID: \(curOrder.productId)"
            typeLabel.text = "Product Type: \(curOrder.productType!)"
            dateLabel.text = "\(showDate(date: curOrder.date!))"
        } catch {
            print("Error: \(error)")
        }
    }
}
