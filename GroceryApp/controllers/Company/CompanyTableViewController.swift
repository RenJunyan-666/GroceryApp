//
//  CompanyTableViewController.swift
//  GroceryApp
//
//  Created by Junyan Ren on 3/27/23.
//

import UIKit
import CoreData

class CompanyTableViewController: UITableViewController {
    let companyRequest: NSFetchRequest<Company> = Company.fetchRequest()
    let productRequest: NSFetchRequest<Product> = Product.fetchRequest()
    let postRequest: NSFetchRequest<Post> = Post.fetchRequest()
    let orderRequest: NSFetchRequest<Order> = Order.fetchRequest()
    let requestAll: NSFetchRequest<Company> = Company.fetchRequest()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var companies = [Company]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        findCompanies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        findCompanies()
        tableView.reloadData()
    }
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addCompany", sender: self)
    }
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - model operation methods
    func deleteCompany(_ companies:[Company]){
        for company in companies {
            context.delete(company)
        }
        do {
            try context.save()
        } catch {
            print("Error: \(error)")
        }
        tableView.reloadData()
    }
    
    func deleteProducts(_ products: [Product]){
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
    
    func findCompanies(){
        do {
            companies = try context.fetch(requestAll)
        } catch {
            print("Error: \(error)")
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyCell", for: indexPath)
        cell.textLabel?.text = "\(companies[indexPath.row].id): \(companies[indexPath.row].name!)"
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "addCompany" {
            let destinationVC = segue.destination as! CompanyDetailViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCompanyId = companies[indexPath.row].id
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deleteId = companies[indexPath.row].id
            companyRequest.predicate = NSPredicate(format: "id == \(deleteId)")
            productRequest.predicate = NSPredicate(format: "companyId == \(deleteId)")
            postRequest.predicate = NSPredicate(format: "companyId == \(deleteId)")
            do {
                let deleteCompany = try context.fetch(companyRequest)
                let deleteProducts = try context.fetch(productRequest)
                let deletePosts = try context.fetch(postRequest)
                
                let allOrders = try context.fetch(orderRequest)
                let deleteOrders = getOrdersByPosts(orders: allOrders, posts: deletePosts)
                
                self.deleteCompany(deleteCompany)
                self.deleteProducts(deleteProducts)
                self.deletePosts(deletePosts)
                self.deleteOrders(deleteOrders)
            } catch {
                print("Error: \(error)")
            }
            self.companies.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
