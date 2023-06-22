//
//  InfoView.swift
//  wayUparty
//
//  Created by Arun  on 03/05/23.
//  Copyright © 2023 Jasty Saran . All rights reserved.
//

import UIKit

class InfoView: UIViewController {

    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var titleView: UIView!
    
    @IBOutlet weak var infolist: UITableView!
    var modelDict = [String: Any]()
    override func viewDidLoad() {
        super.viewDidLoad()

       setuiElements()
        registertableCell()
    }
    

    func setuiElements() {
        bgView.layer.cornerRadius = 10
        bgView.layer.borderWidth = 1
        bgView.layer.borderColor = UIColor.white.cgColor
        titleView.roundCorners([.bottomLeft,.bottomRight], radius: 17.5)
        
    }
    func registertableCell()  {
        infolist.register(UINib(nibName: "InfoCell", bundle: nil), forCellReuseIdentifier: "InfoCell")
        infolist.delegate = self
        infolist.dataSource = self
        infolist.reloadData()
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
}


extension InfoView:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = infolist.dequeueReusableCell(withIdentifier: "InfoCell") as! InfoCell
        cell.costlbl.text = "\(self.modelDict["costForTwoPeople"] as? Int ?? 0)"
        cell.capacityLbl.text = "\(self.modelDict["vendorCapacity"] as? Int ?? 0)"
        cell.yearLbl.text = "\(self.modelDict["establishedYear"] as? Int ?? 0)"
        cell.itemsLbl.text = "\(self.modelDict["bestSellingItems"] as? String ?? "")"
        cell.emailLbl.text = "\(self.modelDict["vendorEmail"] as? String ?? "")"
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 281
    }
    
    
}
