//
//  PostTableViewController.swift
//  GroceryApp
//
//  Created by Junyan Ren on 3/27/23.
//

import UIKit
import CoreData

class PostTableViewController: UITableViewController {
    let postRequest: NSFetchRequest<Post> = Post.fetchRequest()
    let orderRequest: NSFetchRequest<Order> = Order.fetchRequest()
    let searchRequest: NSFetchRequest<Post> = Post.fetchRequest()
    let requestAll: NSFetchRequest<Post> = Post.fetchRequest()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var invalidAlert = UIAlertController(title: "Attention", message: "Please Input valid value!", preferredStyle: .alert)
    
    var posts = [Post]()
    var searchBy = "Post"

    override func viewDidLoad() {
        super.viewDidLoad()
        findPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        findPosts()
    }
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addPost", sender: self)
    }
    
    @IBAction func refreshPressed(_ sender: UIBarButtonItem) {
        findPosts()
    }
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - model operation methods
    func deletePost(_ posts: [Post]) {
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
    
    func findPosts(){
        do {
            posts = try context.fetch(requestAll)
        } catch {
            print("Error: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadSearchedPosts(request: NSFetchRequest<Post>){
        do {
            posts = try context.fetch(request) as [Post]
        } catch {
            print("Error: \(error)")
        }
        if posts.count == 0 {
            findPosts()
            popup(view: self, alert: invalidAlert)
        }
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        cell.textLabel?.text = "Post ID: \(posts[indexPath.row].id)"
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "addPost" {
            let destinationVC = segue.destination as! PostDetailViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedPostId = posts[indexPath.row].id
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deleteId = posts[indexPath.row].id
            postRequest.predicate = NSPredicate(format: "id == \(deleteId)")
            orderRequest.predicate = NSPredicate(format: "postId == \(deleteId)")
            do {
                let deletePost = try context.fetch(postRequest)
                let deleteOrders = try context.fetch(orderRequest)
                self.deletePost(deletePost)
                self.deleteOrders(deleteOrders)
            } catch {
                print("Error: \(error)")
            }
            self.posts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

//MARK: - model search methods
extension PostTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let myId = strToInt(str: searchBar.text ?? "")
        if myId == -1 {
            findPosts()
            popup(view: self, alert: invalidAlert)
        } else {
            switch searchBy {
            case "Product":
                searchRequest.predicate = NSPredicate(format: "productId == \(myId)")
                loadSearchedPosts(request: searchRequest)
            case "Post":
                searchRequest.predicate = NSPredicate(format: "id == \(myId)")
                loadSearchedPosts(request: searchRequest)
            case "Company":
                searchRequest.predicate = NSPredicate(format: "companyId == \(myId)")
                loadSearchedPosts(request: searchRequest)
            case "Type":
                searchRequest.predicate = NSPredicate(format: "productTypeId == \(myId)")
                loadSearchedPosts(request: searchRequest)
            case "Rating":
                searchRequest.predicate = NSPredicate(format: "product.rating == \(myId)")
                loadSearchedPosts(request: searchRequest)
            default:
                findPosts()
            }
        }
    }
}
