//
//  ViewController.swift
//  GroceryApp
//
//  Created by Junyan Ren on 3/9/23.
//

import UIKit
import CoreData

class MainViewController: UIViewController, CompanyManagerDelegate {
    
    let companyRequest: NSFetchRequest<Company> = Company.fetchRequest()
    let postRequest: NSFetchRequest<Post> = Post.fetchRequest()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var posts = [Post]()
    var companyManager = CompanyManager()

    var alert = UIAlertController(title: "Attention", message: "Please create post first!", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        companyManager.delegate = self
        companyManager.performRequest()
        
//        file manager
//        let manager = FileManager.default
//        guard let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first else {
//            return
//        }
//        print(url.path)
    }

    //MARK: - components operation methods
    @IBAction func searchPressed(_ sender: UIBarButtonItem) {
        refresh()
        if posts.count == 0 {
            popup(view: self, alert: alert)
        } else {
            performSegue(withIdentifier: "search", sender: self)
        }
    }
    
    @IBAction func operationPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "operation", sender: self)
    }
    
    @IBAction func orderPressed(_ sender: UIBarButtonItem) {
        refresh()
        if posts.count == 0 {
            popup(view: self, alert: alert)
        } else {
            performSegue(withIdentifier: "order", sender: self)
        }
    }
    
    //MARK: - fetch companies from api
    func didUpdateCompany(companyList: [CompanyData]) {
        do {
            for data in companyList {
                let id = Int32(data.id) ?? -1
                companyRequest.predicate = NSPredicate(format: "id == \(id)")
                let existingCompany = try context.fetch(companyRequest) as [Company]
                if existingCompany.count == 0 {
                    let newCompany = Company(context: context)
                    newCompany.id = Int32(data.id) ?? -1
                    newCompany.name = data.name
                    newCompany.address = data.address
                    newCompany.country = data.country
                    newCompany.zip = data.zipcode
                    newCompany.logo = data.logo.data(using: .utf8)
                    newCompany.companyType = data.companyType
                    try context.save()
                }
            }
        } catch {
            print("Error: \(error)")
        }
    }

    //MARK: - model operation methods
    func findPosts(){
        do {
            posts = try context.fetch(postRequest)
        } catch {
            print("Error: \(error)")
        }
    }
    
    func refresh(){
        do {
            self.posts = try context.fetch(postRequest) as [Post]
        } catch {
            print("Error: \(error)")
        }
    }
}

