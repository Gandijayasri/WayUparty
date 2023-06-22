//
//  ViewController.swift
//  WayuPartyPackages
//
//  Created by Jasty Saran  on 21/10/20.
//

import UIKit
import AwaitToast
class PackagesController: UIViewController {
    var packageName = String()
    var itemsOffered = NSArray()
    var menuItem = NSArray()
    var menuItemUUID = NSArray()
    var menuItemsList = NSArray()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(itemsOffered)
        self.title = "\(self.packageName) Package"
        packagesCoreDelgate()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
}

class PackageHeaderCell:UITableViewCell{
    @IBOutlet weak var packageTitle: UILabel!
    @IBOutlet weak var itemsToSelectLbl: UILabel!
}

class PackageCategoryCell:UITableViewCell{
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var packageCategoryTitle: UILabel!
}

class ConfirmPackageCell:UITableViewCell{
    @IBOutlet weak var confirmBtn : UIButton!
}

extension PackagesController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        let countToReturnSections = self.menuItem as? Array<String>
        return countToReturnSections!.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let countToReturnSections = self.menuItem as? Array<String>
        if section == countToReturnSections!.count {return 1}
        else{
        let innerMenuItems = self.menuItemsList
        let itemNames = innerMenuItems.value(forKey: "itemName") as? NSArray
        let returnCount = itemNames?.object(at: section) as? Array<String>
        return returnCount?.count ?? 0}
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let countToReturnSections = self.menuItem as? Array<String>
        if indexPath.section == countToReturnSections!.count{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmPackageCell") as! ConfirmPackageCell
            cell.confirmBtn.addTarget(self, action: #selector(confirmPackageAction), for: .touchUpInside)
            return cell
        }
        else{
        let cell = tableView.dequeueReusableCell(withIdentifier: "PackageCategoryCell") as! PackageCategoryCell
        cell.checkBtn.addTarget(self, action: #selector(checkBtnAction), for: .touchUpInside)
        let innerMenuItems = self.menuItemsList
        let itemNames = innerMenuItems.value(forKey: "itemName") as? NSArray
        let returnCount = itemNames?.object(at: indexPath.section) as? Array<String>
        cell.packageCategoryTitle.text = returnCount?[indexPath.row]
        let countToReturnSections = self.menuItem as? Array<String>
        let itemsArray = packagesDict["\(countToReturnSections?[indexPath.section] ?? "error: -> key not initialized")"] as? Array<Bool>
        let check = itemsArray?[indexPath.row]
        if check == true{cell.checkBtn.isSelected = true}
        else{cell.checkBtn.isSelected = false}
            return cell}
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 63
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let countToReturnSections = self.menuItem as? Array<String>
        if section == countToReturnSections!.count{
           return nil
        }else{
        let cell = tableView.dequeueReusableCell(withIdentifier: "PackageHeaderCell") as! PackageHeaderCell
        let itemsoffered = self.itemsOffered as? Array<String>
        cell.itemsToSelectLbl.text = "Select any \(itemsoffered?[section] ?? "") items"
        let countToReturnSections = self.menuItem as? Array<String>
        cell.packageTitle.text = countToReturnSections?[section]
            return cell}
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let countToReturnSections = self.menuItem as? Array<String>
        if section == countToReturnSections!.count{return 0}
        else{return 73}
    }
    
    @objc func checkBtnAction(_sender:UIButton){
        guard let cell = _sender.superview?.superview as? PackageCategoryCell else{return}
        let indexPath = self.tableView.indexPath(for: cell)
        let countToReturnSections = self.menuItem as? Array<String>
        var itemsArray = packagesDict["\(countToReturnSections?[indexPath!.section] ?? "error: -> key not initialized")"] as? Array<Bool>
        if _sender.isSelected == true{
            _sender.isSelected = false
            itemsArray?[indexPath!.row] = false
        }
        else{
            _sender.isSelected = true
             itemsArray?[indexPath!.row] = true
        }
        let numberOfTrue = itemsArray?.reduce(0) { $0 + ($1 ? 1 : 0) }
        print(numberOfTrue ?? 0)
        let itemsOffered = self.itemsOffered as? Array<String>
        var finalItemsOffered = Int((itemsOffered?[indexPath!.section])!)
        finalItemsOffered = finalItemsOffered! + 1
        if numberOfTrue == finalItemsOffered{
            for i in 0..<itemsArray!.count{
                let boolValue = itemsArray![i]
                if boolValue == true{
                    itemsArray![indexPath!.row] = false
                    break
                }
             }
            let toast = Toast.default(text: "You can seclet only \(finalItemsOffered!-1) items", direction: .bottom)
            toast.show()
        }
        packagesDict["\(countToReturnSections?[indexPath!.section] ?? "error: -> key not initialized")"] = itemsArray
        self.tableView.reloadData()
    }
    
    @objc func packagesCoreDelgate(){
        if packagesDict.keys.isEmpty{
            var boolArray = Array<Bool>()
            var uuidsArray = Array<String>()
            var tempDict: [String: Any] = [:]
            var tempUUIDict:[String:Any] = [:]
             let countToReturnSections = self.menuItem as? Array<String>
             let innerMenuItems = self.menuItemsList
            let itemNames = innerMenuItems.value(forKey: "itemName") as? NSArray
            let itemUUids = innerMenuItems.value(forKey: "itemUUID") as? NSArray
             for i in 0..<countToReturnSections!.count{
                 for _ in 0..<itemNames!.count{
                      let lastCount = itemNames?[i] as? Array<String>
                      let uuidsCount  = itemUUids?[i] as? Array<String>
                        for k in 0..<lastCount!.count{
                            let uuid = (uuidsCount?[k])!
                        uuidsArray.append(uuid)
                           boolArray.append(false)
                       }
                     tempDict["\(countToReturnSections?[i] ?? "no key from server")"] = boolArray
                    tempUUIDict["\(countToReturnSections?[i] ?? "no key from server")"] = uuidsArray
                    boolArray.removeAll()
                    uuidsArray.removeAll()
                 }
             }
             print(tempUUIDict)
             packagesDict = tempDict
             packagesUUIDict = tempUUIDict
        }else{
            
        }
       
    }
    
    @objc func confirmPackageAction(){
        var menuUUids = Array<String>()
        let countToReturnSections = self.menuItem as? Array<String>
        let innerMenuItems = self.menuItemsList
        let itemNames = innerMenuItems.value(forKey: "itemName") as? NSArray
        let itemsoffered = self.itemsOffered as? Array<String>
        for i in 0..<itemsoffered!.count{
            let returnCount = itemNames?.object(at: i) as? Array<String>
            let itemsArray = packagesDict["\(countToReturnSections?[i] ?? "error: -> key not initialized")"] as? Array<Bool>
            let itemsUuidArray = packagesUUIDict["\(countToReturnSections?[i] ?? "error: -> key not initialized")"] as? Array<String>
            for j in 0..<returnCount!.count{
                let check = itemsArray![j]
                let uuid = itemsUuidArray![j]
                if check == true{
                    menuUUids.append(uuid)
                }
            }
        }
       
        print(menuUUids)
        packageMenuItems = menuUUids.joined(separator:",")
        print(packageMenuItems)
        self.navigationController?.popViewController(animated: true)
    }
}

