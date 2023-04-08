import UIKit

//MARK: - Attributes validation

func validProductId(myId: Int, products: [Product]) -> Bool {
    for product in products {
        if product.id == myId {
            return true
        }
    }
    return false
}

func validPostId(myId: Int, posts: [Post]) -> Bool {
    for post in posts {
        if post.id == myId {
            return true
        }
    }
    return false
}

func validCompanyId(myId: Int, companies: [Company]) -> Bool {
    for company in companies {
        if company.id == myId {
            return true
        }
    }
    return false
}

func validTypeId(myId: Int, types: [ProductType]) -> Bool {
    for type in types {
        if type.id == myId {
            return true
        }
    }
    return false
}

func validOrderId(myId: Int, orders: [Order]) -> Bool {
    for order in orders {
        if order.id == myId {
            return true
        }
    }
    return false
}

func validRating(rating:Int) -> Bool{
    return rating >= 1 && rating <= 5
}

func validQuantity (quantity: Int)-> Bool {
    return quantity >= 0
}

//MARK: - Readline validation

func strToInt(str:String) -> Int{
    if let num = Int(str) {
        return num
    } else {
        return -1
    }
}

func strToDouble(str:String) -> Double{
    if let num = Double(str) {
        return num
    } else {
        return -1.0
    }
}

//MARK: - Alert

func popup(view: UIViewController, alert: UIAlertController){
    view.present(alert, animated: true, completion: nil)
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        alert.dismiss(animated: true, completion: nil)
    }
}

//MARK: - date format
func showDate(date:Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let dateStr = dateFormatter.string(from: date)
    return dateStr
}

//MARK: - get orders according to post IDs
func getOrdersByPosts(orders: [Order], posts: [Post]) -> [Order]{
    var result:[Order] = []
    for post in posts {
        for order in orders {
            if order.postId == post.id {
                result += [order]
            }
        }
    }
    return result
}
