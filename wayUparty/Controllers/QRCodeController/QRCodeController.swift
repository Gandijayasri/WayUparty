//
//  QRCodeController.swift
//  Orders
//
//  Created by Jasty Saran  on 05/11/20.
//

import UIKit

class QRCodeController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var qrImgUrl = String()
    var orderItemsParsable = String()
    var orderItemPricesParsable = String()
    var totalPrice = String()
    let imageCache = NSCache<AnyObject, AnyObject>()
    var orderStatus = String()
    var orderItemUUIDs = String()
    var cancelStatus = String()
    var rescheduleStatus = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.title = "Order QR Code"
        print(self.cancelStatus)
        print(self.rescheduleStatus)
        print(self.orderItemUUIDs)
    }
    

    func imageFromServerURL(URLString: String, placeHolder: UIImage?,imageView:UIImageView) {
     let imageViews = imageView
     imageViews.image = nil
        //If imageurl's imagename has space then this line going to work for this
        let imageServerUrl = URLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let cachedImage = imageCache.object(forKey: NSString(string: imageServerUrl)) {
          imageViews.image = cachedImage as? UIImage
            return
        }

        if let url = URL(string: imageServerUrl) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in

                //print("RESPONSE FROM API: \(response)")
                if error != nil {
                    print("ERROR LOADING IMAGES FROM URL: \(String(describing: error))")
                    DispatchQueue.main.async {
                        imageViews.image = placeHolder
                    }
                    return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                         self.imageCache.setObject(downloadedImage, forKey: NSString(string: imageServerUrl))
                            imageViews.image = downloadedImage
                        }
                    }
                }
            }).resume()
        }
    }

}

class QRCodeCell:UITableViewCell{
    @IBOutlet weak var qrImageView:UIImageView!
}

class DetailsHeaderCell:UITableViewCell{
    @IBOutlet weak var detailsLbl:UILabel!
}

class ItemsListCell:UITableViewCell{
    @IBOutlet weak var itemName:UILabel!
    @IBOutlet weak var itemPrice:UILabel!
    @IBOutlet weak var orederItemStatus: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var schheduleBtn:UIButton!
}

class OrderItemsTotalPriceCell:UITableViewCell{
    @IBOutlet weak var totalPrice:UILabel!
}


extension QRCodeController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
        let cell = tableView.dequeueReusableCell(withIdentifier: "QRCodeCell") as! QRCodeCell
            if  qrImgUrl == ""{
                cell.qrImageView.image = UIImage.init(named: "defaultQr.jpg")
            }
            else{
            let constants = Constants()
            self.imageFromServerURL(URLString: "\(constants.baseUrl)\(qrImgUrl)", placeHolder: UIImage.init(named: "defualtQr.jpg"), imageView: cell.qrImageView)
            }
        return cell
        case 1:
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsHeaderCell") as! DetailsHeaderCell
        return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemsListCell") as! ItemsListCell
            cell.orederItemStatus.layer.cornerRadius = 10
            cell.orederItemStatus.clipsToBounds = true
            let orderItems = self.orderItemsParsable.components(separatedBy: ",")
            let orderItemPrices = self.orderItemPricesParsable.components(separatedBy: ",")
            let orderItemStatus = self.orderStatus.components(separatedBy: ",")
           let status = orderItemStatus[indexPath.row]
            if status == "Pending"{cell.orederItemStatus.backgroundColor = UIColor.init(red: 199.0/255.0, green: 171.0/255.0, blue: 112.0/255.0, alpha: 1.0);cell.orederItemStatus.textColor = UIColor.black
                cell.cancelBtn.isHidden = false
            }
            if status == "Approved"{cell.orederItemStatus.backgroundColor = UIColor.init(red: 91.0/255.0, green: 194.0/255.0, blue: 105.0/255.0, alpha: 1.0);cell.orederItemStatus.textColor = UIColor.black
                cell.cancelBtn.isHidden = false
            }
            if status == "Canceled" {
                cell.orederItemStatus.backgroundColor = UIColor.init(red: 168.0/255.0, green: 63.0/255.0, blue: 63.0/255.0, alpha: 1.0);cell.orederItemStatus.textColor = UIColor.white
                cell.cancelBtn.isHidden = true
            }
            if self.cancelStatus == "Y"{cell.cancelBtn.isHidden = false}else{cell.cancelBtn.isHidden = true}
            if self.rescheduleStatus == "Y"{cell.schheduleBtn.isHidden = false}else{cell.schheduleBtn.isHidden = true}
            cell.orederItemStatus.text = status
           
            cell.itemName.text = orderItems[indexPath.row]
            cell.itemPrice.text = "₹ \(orderItemPrices[indexPath.row])"
            cell.cancelBtn.tag = indexPath.row
            cell.schheduleBtn.tag = indexPath.row
            cell.cancelBtn.addTarget(self, action: #selector(cancelOrderAction), for: .touchUpInside)
            cell.schheduleBtn.addTarget(self, action: #selector(rescheduleOrderAction), for: .touchUpInside)
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderItemsTotalPriceCell") as! OrderItemsTotalPriceCell
            cell.totalPrice.text = "₹ \(self.totalPrice)"
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2{
            let orderItems = self.orderItemsParsable.components(separatedBy: ",")
            return orderItems.count
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{return 370.0}
        if indexPath.section == 1{return 43.5}
        if indexPath.section == 2{return 80.0}
        if indexPath.section == 3{return 43.5}
        return 0
    }
    
    @objc func cancelOrderAction(_sender:UIButton){
        let uuids = orderItemUUIDs.components(separatedBy: ",")
        let orderItems = self.orderItemsParsable.components(separatedBy: ",")
        let uuid = uuids[_sender.tag]
        print(uuid)
        let alertController = UIAlertController(title: "Alert", message: "Do you want cancel the item.Charges may apply", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Cancel Item", style: UIAlertAction.Style.destructive) {
                UIAlertAction in
            let constants = Constants()
            CancelOrderParser.CancelOrderAPI(xUsername: constants.xUsername, xPassword: constants.xPassword, orderUUID: uuid){(canceled) in
                if canceled.addToCartModel.first?.responce == "ORDER_CANCELED"{
                    // Create the alert controller
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Message", message: "\(orderItems[_sender.tag]) has been cancelled", preferredStyle: .alert)
                      // Create the actions
                    let okAction = UIKit.UIAlertAction(title: "OK", style: UIKit.UIAlertAction.Style.default) {
                          UIAlertAction in
                        self.navigationController?.popViewController(animated: true)
                      }
                      // Add the actions
                      alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)}
                }else{
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Alert", message: "Server Message :\(canceled.addToCartModel.first?.responce ?? "I AM HIT")", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIKit.UIAlertAction(title: "Click", style: UIKit.UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    print(canceled.addToCartModel.first?.responce ?? "I AM HIT")
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Change mind", style: UIAlertAction.Style.default) {
                UIAlertAction in
                NSLog("Cancel Pressed")
            }
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
    }
    
    
    @objc func rescheduleOrderAction(_sender:UIButton){
        var rescheduleCon = RescheduleController()
        rescheduleCon = self.storyboard?.instantiateViewController(withIdentifier: "RescheduleController") as! RescheduleController
        let uuids = orderItemUUIDs.components(separatedBy: ",")
        let uuid = uuids[_sender.tag]
        print(uuid)
        rescheduleCon.orderItemUUID = uuid
        rescheduleCon.navCon = self.navigationController!
        self.present(rescheduleCon, animated: true, completion: nil)
    }
}
