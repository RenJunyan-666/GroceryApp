//
//  TypeTableViewController.swift
//  GroceryApp
//
//  Created by Junyan Ren on 3/27/23.
//

import UIKit
import CoreData

class TypeTableViewController: UITableViewController {
    let typeRequest: NSFetchRequest<ProductType> = ProductType.fetchRequest()
    let postRequest: NSFetchRequest<Post> = Post.fetchRequest()
    let orderRequest: NSFetchRequest<Order> = Order.fetchRequest()
    let requestAll: NSFetchRequest<ProductType> = ProductType.fetchRequest()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var types = [ProductType]()

    override func viewDidLoad() {
        super.viewDidLoad()
        findTypes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        findTypes()
        tableView.reloadData()
    }
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addType", sender: self)
    }
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - model operation methods
    func deleteType(_ types: [ProductType]){
        for type in types {
            context.delete(type)
        }
        do {
            try context.save()
        } catch {
            print("Error: \(error)")
        }
    }
    
    func deletePosts(_ posts: [Post]){
        for post in posts {
            context.delete(post)
        }
        do {
            try context.save()
        } catch {
            print("Error: \(error)")
        }
    }
    
    func deleteOrders(_ orders: [Order]){
        for order in orders {
            context.delete(order)
        }
        do {
            try context.save()
        } catch {
            print("Error: \(error)")
        }
    }
    
    func findTypes(){
        do {
            types = try context.fetch(requestAll)
        } catch {
            print("Error: \(error)")
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return types.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TypeCell", for: indexPath)
        cell.textLabel?.text = "\(types[indexPath.row].productType!)"
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "addType" {
            let destinationVC = segue.destination as! TypeDetailViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedTypeId = types[indexPath.row].id
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deleteId = types[indexPath.row].id
            typeRequest.predicate = NSPredicate(format: "id == \(deleteId)")
            postRequest.predicate = NSPredicate(format: "productTypeId == \(deleteId)")
            do {
                let deleteType = try context.fetch(typeRequest)
                let deletePosts = try context.fetch(postRequest) as [Post]
                
                let allOrders = try context.fetch(orderRequest)
                let deleteOrders = getOrdersByPosts(orders: allOrders, posts: deletePosts)
                
                self.deleteType(deleteType)
                self.deletePosts(deletePosts)
                self.deleteOrders(deleteOrders)
            } catch {
                print("Error: \(error)")
            }
            self.types.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
