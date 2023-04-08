//
//  ProductTableViewController.swift
//  GroceryApp
//
//  Created by Junyan Ren on 3/27/23.
//

import UIKit
import CoreData

class ProductTableViewController: UITableViewController {
    let productRequest: NSFetchRequest<Product> = Product.fetchRequest()
    let postRequest: NSFetchRequest<Post> = Post.fetchRequest()
    let orderRequest: NSFetchRequest<Order> = Order.fetchRequest()
    let requestAll: NSFetchRequest<Product> = Product.fetchRequest()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var products = [Product]()

    override func viewDidLoad() {
        super.viewDidLoad()
        findProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        findProducts()
        tableView.reloadData()
    }
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addProduct", sender: self)
    }
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - model operation methods
    func deleteProduct(_ products: [Product]) {
        for product in products {
            context.delete(product)
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
    
    func findProducts(){
        do {
            products = try context.fetch(requestAll)
        } catch {
            print("Error: \(error)")
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath)
        cell.textLabel?.text = "\(products[indexPath.row].id): \(products[indexPath.row].name!)"
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "addProduct" {
            let destinationVC = segue.destination as! ProductDetailViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedProductId = products[indexPath.row].id
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deleteId = products[indexPath.row].id
            productRequest.predicate = NSPredicate(format: "id == \(deleteId)")
            postRequest.predicate = NSPredicate(format: "productId == \(deleteId)")
            do {
                let deleteProduct = try context.fetch(productRequest)
                let deletePosts = try context.fetch(postRequest)
                
                let allOrders = try context.fetch(orderRequest)
                let deleteOrders = getOrdersByPosts(orders: allOrders, posts: deletePosts)
                
                self.deleteProduct(deleteProduct)
                self.deletePosts(deletePosts)
                self.deleteOrders(deleteOrders)
            } catch {
                print("Error: \(error)")
            }
            self.products.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
