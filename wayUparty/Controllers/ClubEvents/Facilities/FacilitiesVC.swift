//
//  FacilitiesVC.swift
//  wayUparty
//
//  Created by Arun  on 04/05/23.
//  Copyright © 2023 Jasty Saran . All rights reserved.
//

import UIKit

class FacilitiesVC: UIViewController {

    @IBOutlet weak var facilitiesList: UITableView!
    var facilities = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        facilitiesList.delegate = self
        facilitiesList.dataSource = self
    }
    

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
}



class FacilitiesCell: UITableViewCell {
    @IBOutlet weak var titleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}


extension FacilitiesVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return facilities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = facilitiesList.dequeueReusableCell(withIdentifier: "FacilitiesCell") as! FacilitiesCell
       cell.titleLbl.text = facilities[indexPath.row] as? String ?? ""
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
}
