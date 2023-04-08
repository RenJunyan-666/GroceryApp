//
//  PostDetailViewController.swift
//  GroceryApp
//
//  Created by Junyan Ren on 3/27/23.
//

import UIKit
import CoreData

class PostDetailViewController: UIViewController {
    @IBOutlet weak var postIdLabel: UILabel!
    @IBOutlet weak var productIdLabel: UILabel!
    @IBOutlet weak var companyIdLabel: UILabel!
    @IBOutlet weak var typeIdLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var logoView: UIImageView!
    var selectedPostId: Int32 = 1
    
    let request: NSFetchRequest<Post> = Post.fetchRequest()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPost()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadPost()
    }
    
    @IBAction func updatePressed(_ sender: UIButton) {
        performSegue(withIdentifier: "updatePost", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! UpdatePostViewController
        destinationVC.postId = selectedPostId
    }
    
    //MARK: - model operation methods
    func loadPost(){
        request.predicate = NSPredicate(format: "id == \(selectedPostId)")
        do {
            let curPost = try context.fetch(request)[0]
            postIdLabel.text = "Post ID \(curPost.id)"
            productIdLabel.text = "Product ID: \(curPost.productId)"
            companyIdLabel.text = "Company ID: \(curPost.companyId)"
            typeIdLabel.text = "Type ID: \(curPost.productTypeId)"
            priceLabel.text = "$\(curPost.price)"
            descriptionLabel.text = "\(curPost.describle!)"
            dateLabel.text = "\(showDate(date: curPost.postedDate!))"
            if let safeLogo = curPost.company?.logo {
                let url = URL(string: String(data: safeLogo, encoding: .utf8) ?? "")
                if url != nil {
                    logoView.load(url: url!)
                } else {
                    logoView.image = UIImage(data: safeLogo)
                }
            }
        } catch {
            print("Error: \(error)")
        }
    }
}

