//
//  EventsRestaurentsController.swift
//  EventsModule
//
//  Created by Jasty Saran  on 23/12/20.
//

import UIKit
import MarqueeLabel
class EventsRestaurentsController: UIViewController {
    @IBOutlet weak var tableView:UITableView!
    
    @IBOutlet var bookBtn: UIButton!
    
    
    let imageCache = NSCache<AnyObject, AnyObject>()
    var getEventDetailListModel:EventDetailsModel!
    var eventUUID:String = ""
    var vendorUUID:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        bookBtn.layer.cornerRadius = 22.5
        self.title = "Event Details"
        
        GetEventDetailModelParser.GetEventDetailAPI(eventUUID: eventUUID){(responce) in
           print(responce.eventDetailModel.first?.eventName ?? "invalid object from server")
            self.getEventDetailListModel = responce.eventDetailModel.first
            DispatchQueue.main.async {
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()
            }
        }
    }
    
    
    
    @IBAction func BookEventClickAction(_ sender: UIButton) {
        var timeSlotsCon = TimeSlotsController()
        timeSlotsCon = self.storyboard?.instantiateViewController(withIdentifier: "TimeSlotsController") as! TimeSlotsController
        timeSlotsCon.eventUUID = self.eventUUID
        timeSlotsCon.vendorUUID = self.vendorUUID
        self.navigationController?.pushViewController(timeSlotsCon, animated: true)
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
extension EventsRestaurentsController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailEventImageViewCell") as! DetailEventImageViewCell
            let constants = Constants()
            self.imageFromServerURL(URLString: constants.baseUrl + self.getEventDetailListModel.eventImage, placeHolder: UIImage.init(named: "noImg.png"), imageView: cell.detailImageView)
            cell.detailImageView.backgroundColor = UIColor.white
            cell.detailImageView.layer.cornerRadius = 10
    
            return cell
        }
        if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "locationAndTimeCell") as! locationAndTimeCell
            cell.eventTypeLbl.type = .leftRight
            cell.eventTypeLbl.speed = .rate(25)
            cell.eventTypeLbl.fadeLength = 10.0
            cell.eventTypeLbl.leadingBuffer = 10.0
            cell.eventTypeLbl.trailingBuffer = 10.0
            cell.eventTypeLbl.text = self.getEventDetailListModel.eventType
            cell.eventLocationLbl.text = self.getEventDetailListModel.eventHost + "," + self.getEventDetailListModel.address
            return cell
        }
        if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MoreInformationCell") as! MoreInformationCell
            cell.liveMusic.text = self.getEventDetailListModel.musicType
            cell.hoursLbl.text = self.getEventDetailListModel.duration
            cell.languagesLbl.text = self.getEventDetailListModel.language
            cell.ageLbl.text = self.getEventDetailListModel.age
            return cell
            
        }
        if indexPath.section == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MinimumPriceInformationCell") as! MinimumPriceInformationCell
            cell.minimumLblPrice.text = self.getEventDetailListModel.minimumStartingAmount
            return cell
            
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{return 239}
        if indexPath.section == 1{return 168}
        if indexPath.section == 2{return 216}
        if indexPath.section == 3{return 57}
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
}

class DetailEventImageViewCell:UITableViewCell{
    @IBOutlet weak var detailImageView:UIImageView!
}

class locationAndTimeCell:UITableViewCell{
    @IBOutlet weak var eventTypeLbl: MarqueeLabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var eventLocationLbl: UILabel!
}

class MoreInformationCell:UITableViewCell{
    @IBOutlet weak var liveMusic: UILabel!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var languagesLbl: UILabel!
    @IBOutlet weak var hoursLbl: UILabel!
}

class MinimumPriceInformationCell:UITableViewCell{
    @IBOutlet weak var minimumLblPrice: UILabel!
}
