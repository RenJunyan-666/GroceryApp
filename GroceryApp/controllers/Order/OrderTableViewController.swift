//
//  OrderTableViewController.swift
//  GroceryApp
//
//  Created by Junyan Ren on 3/27/23.
//

import UIKit
import CoreData

class OrderTableViewController: UITableViewController {
    let requestAll: NSFetchRequest<Order> = Order.fetchRequest()
    let requestDelete: NSFetchRequest<Order> = Order.fetchRequest()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var orders = [Order]()

    override func viewDidLoad() {
        super.viewDidLoad()
        findOrders()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        findOrders()
        tableView.reloadData()
    }

    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "createOrder", sender: self)
    }
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - model operation methods
    func deleteOrder(_ orders: [Order]) {
        for order in orders {
            context.delete(order)
        }
        do {
            try context.save()
        } catch {
            print("Error: \(error)")
        }
    }
    
    func findOrders(){
        do {
            orders = try context.fetch(requestAll)
        } catch {
            print("Error: \(error)")
        }
    }
    
    //MARK: - table view methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath)
        cell.textLabel?.text = "Order ID: \(orders[indexPath.row].id)"
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "createOrder" {
            let destinationVC = segue.destination as! OrderDetailViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedOrderId = orders[indexPath.row].id
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deleteId = orders[indexPath.row].id
            requestDelete.predicate = NSPredicate(format: "id == \(deleteId)")
            do {
                let deleteOrder = try context.fetch(requestDelete)
                self.deleteOrder(deleteOrder)
            } catch {
                print("Error: \(error)")
            }
            self.orders.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
