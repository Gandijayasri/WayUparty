//
//  SelectMlPopupVC.swift
//  wayUparty
//
//  Created by Arun on 07/03/23.

//

import UIKit

var mlDetailsinfo:NSArray?

var mlValue = ""


class SelectMlPopupVC: UIViewController {
    
    @IBOutlet var mlList: UITableView!
    var selectedValue = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        mlList.register(UINib(nibName: "MLlistCell", bundle: nil), forCellReuseIdentifier: "MLlistCell")
        mlList.delegate = self
        mlList.dataSource = self
        mlList.reloadData()
    }

    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    
    

}


extension SelectMlPopupVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mlDetailsinfo?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mlList.dequeueReusableCell(withIdentifier: "MLlistCell") as! MLlistCell
        let quantity = "\((mlDetailsinfo?[indexPath.row] as AnyObject).object(forKey: "typeName") as? String ?? "")"
        cell.quantityLbl.text = quantity
     let actualprice = "Rs:\((mlDetailsinfo?[indexPath.row] as AnyObject).object(forKey: "typeActualPrice") as? String ?? "")"
        let offerValue = "Rs:\((mlDetailsinfo?[indexPath.row] as AnyObject).object(forKey: "typeOfferPrice") as? String ?? "")"
        cell.offerPriceLbl.text = offerValue
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: actualprice)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
        cell.actualPriceLbl.attributedText = attributeString
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let quantity = "\((mlDetailsinfo?[indexPath.row] as AnyObject).object(forKey: "typeName") as? String ?? "")"
        let offerValue = "Rs:\((mlDetailsinfo?[indexPath.row] as AnyObject).object(forKey: "typeOfferPrice") as? String ?? "")"
        
        selectedValue = "\(quantity) \(offerValue)"
        print(selectedValue)
        NotificationCenter.default.post(name: Notification.Name("MLNotification"), object: nil, userInfo: ["selectedValue": selectedValue])
        self.dismiss(animated: true,completion: nil)
    }
}
