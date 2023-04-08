import Foundation
import CoreLocation

protocol CompanyManagerDelegate {
    func didUpdateCompany(companyList:[CompanyData])
}

struct CompanyManager {
    let companyURL = "https://6429924debb1476fcc4c36b2.mockapi.io/company"
    var delegate: CompanyManagerDelegate?
    
    func performRequest() {
        if let url = URL(string: companyURL) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print("Error: \(error!)")
                    return
                }
                if let safeData = data {
                    if let companyList = self.parseJSON(safeData) {
                        self.delegate?.didUpdateCompany(companyList: companyList)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ companyData: Data) -> [CompanyData]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([CompanyData].self, from: companyData)
            return decodedData
        } catch {
            print("Error: \(error)")
            return nil
        }
    }
}
