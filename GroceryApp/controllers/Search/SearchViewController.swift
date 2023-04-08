//
//  SearchViewController.swift
//  GroceryApp
//
//  Created by Junyan Ren on 3/15/23.
//

import UIKit

class SearchViewController: UIViewController {
    var searchTag = "Post"

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func productPressed(_ sender: UIButton) {
        searchTag = "Product"
        performSegue(withIdentifier: "goToPost", sender: self)
    }
    
    @IBAction func postPressed(_ sender: UIButton) {
        searchTag = "Post"
        performSegue(withIdentifier: "goToPost", sender: self)
    }
    
    @IBAction func companyPressed(_ sender: UIButton) {
        searchTag = "Company"
        performSegue(withIdentifier: "goToPost", sender: self)
    }
    
    @IBAction func typePressed(_ sender: UIButton) {
        searchTag = "Type"
        performSegue(withIdentifier: "goToPost", sender: self)
    }
    
    @IBAction func ratingPressed(_ sender: UIButton) {
        searchTag = "Rating"
        performSegue(withIdentifier: "goToPost", sender: self)
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! PostTableViewController
        destinationVC.searchBy = self.searchTag
    }
}
