//
//  ScheduleVC.swift
//  wayUparty
//
//  Created by Arun  on 04/05/23.
//  Copyright © 2023 Jasty Saran . All rights reserved.
//

import UIKit

class ScheduleVC: UIViewController {
    var workHoursArr = NSArray()
    
    @IBOutlet weak var scheduleList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(workHoursArr)
        scheduleList.delegate = self
        scheduleList.dataSource = self
        scheduleList.reloadData()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    

}


class SchedulelistCell: UITableViewCell {
    
    @IBOutlet weak var dayLbl: UILabel!
    
    @IBOutlet weak var startLbl: UILabel!
    
    @IBOutlet weak var endLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}


extension ScheduleVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workHoursArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = scheduleList.dequeueReusableCell(withIdentifier: "SchedulelistCell") as! SchedulelistCell
        let day = (self.workHoursArr[indexPath.row] as AnyObject).value(forKey: "workingDay") as? String ?? ""
        let start = (self.workHoursArr[indexPath.row] as AnyObject).value(forKey: "startTime") as? String ?? ""
        let end = (self.workHoursArr[indexPath.row] as AnyObject).value(forKey: "endTime") as? String ?? ""
        cell.dayLbl.text = day
        cell.startLbl.text = start
        cell.endLbl.text = end
        
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
