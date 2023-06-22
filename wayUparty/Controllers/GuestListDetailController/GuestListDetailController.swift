//
//  GuestListDetailController.swift
//  wayUparty
//
//  Created by Jasty Saran  on 05/01/21.
//  Copyright © 2021 Jasty Saran . All rights reserved.
//

import UIKit

class GuestListDetailController: UIViewController {
    @IBOutlet weak var tableView:UITableView!
    var adressHeight:CGFloat = 0.0
    var descriptionHeight:CGFloat = 0.0
    var guestUUID = String()
    var qrImageUrl = String()
    var restaurentDetailImageUrl = String()
    let imageCache = NSCache<AnyObject, AnyObject>()
    var clubname = String()
    var adress = String()
    var descp = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        self.title = "Details"
        GuestListDetailParser.GuestListDetailParserAPI(guestUUID: guestUUID){(responce) in
            DispatchQueue.main.async {
                self.adressHeight = self.heightForView(text: responce.guestListDetailModel.first?.clubLocation ?? " ", font: UIFont.systemFont(ofSize: 13.0), width: UIScreen.main.bounds.size.width -  15)
                self.descriptionHeight = self.heightForView(text: responce.guestListDetailModel.first?.description ?? " ", font: UIFont.systemFont(ofSize: 13.0), width: UIScreen.main.bounds.size.width -  15)
            self.qrImageUrl = responce.guestListDetailModel.first?.qrCode ?? " "
            self.restaurentDetailImageUrl  = responce.guestListDetailModel.first?.clubImage ?? ""
            self.adress = responce.guestListDetailModel.first?.clubLocation ?? ""
            self.descp = responce.guestListDetailModel.first?.description ?? ""
            self.clubname = responce.guestListDetailModel.first?.club ?? ""
                print(self.descp)
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()
            }
        }
    }
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 20, y: 11, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
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

class GuestListDetailImageCell:UITableViewCell{
    @IBOutlet weak var imageViewDetail:UIImageView!
}

class GuestRestaurentNameCell:UITableViewCell{
    @IBOutlet weak var restuarentNameCell:UILabel!
}
class GuestRestuarentAdressCell:UITableViewCell{
    @IBOutlet weak var adressLbl:UILabel!
}
class GuestRestuarentDescriptionLbl:UITableViewCell{
    @IBOutlet weak var descriptionLbl:UILabel!
}

class QRImageCell:UITableViewCell{
    @IBOutlet weak var qrImagrView:UIImageView!
}

extension GuestListDetailController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "GuestListDetailImageCell") as! GuestListDetailImageCell
            let constants = Constants()
            self.imageFromServerURL(URLString: constants.baseUrl+self.restaurentDetailImageUrl, placeHolder: UIImage.init(named: "noImg.png"), imageView: cell.imageViewDetail)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "GuestRestuarentAdressCell") as! GuestRestuarentAdressCell
            cell.adressLbl.text = self.clubname
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "GuestRestuarentAdressCell") as! GuestRestuarentAdressCell
            cell.adressLbl.frame = CGRect.init(x: 20, y: 11, width: UIScreen.main.bounds.size.width - 15, height: self.adressHeight)
            cell.adressLbl.text = self.adress
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "GuestRestuarentDescriptionLbl") as! GuestRestuarentDescriptionLbl
            cell.descriptionLbl.frame = CGRect.init(x: 20, y: 11, width: UIScreen.main.bounds.size.width - 15, height: self.descriptionHeight)
            cell.descriptionLbl.text = self.descp
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "QRImageCell") as! QRImageCell
            let constants = Constants()
            self.imageFromServerURL(URLString:constants.baseUrl+self.qrImageUrl, placeHolder: UIImage.init(named: "noImg.png"), imageView: cell.qrImagrView)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 215.0
        case 1:
            return 43.5
        case 2:
            if adressHeight < 43.5{return 43.5}
            else{return adressHeight + 15}
        case 3:
            if descriptionHeight < 43.5{return 43.5}
            else{return descriptionHeight + 15}
        case 4:
            return 304.0
        default:
            return 0
        }
    }
}
