//
//  ViewController.swift
//  EventsModule
//
//  Created by Jasty Saran  on 23/12/20.
//

import UIKit

class EventsController: UIViewController {
    @IBOutlet weak var tableview:UITableView!
    @IBOutlet weak var noEventsImageView: UIImageView!
    var vendorUUID:String = ""
    let imageCache = NSCache<AnyObject, AnyObject>()
    var getEventListModel:GetEventListModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Events"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        geteventsList()
    }
    func geteventsList()  {
        GetEventListModelParser.GetEventsListModelAPI(vendorUUID: vendorUUID){(responce) in
            print(responce.getEventsmodel.first?.eventName ?? [])
            self.getEventListModel = responce.getEventsmodel.first
            DispatchQueue.main.async {
                if self.getEventListModel.eventName.count == 0{
                    self.noEventsImageView.isHidden = false
                    self.tableview.separatorStyle = .none
                    self.noEventsImageView.image = UIImage.init(named: "no_events.png")
                }else{
                    self.noEventsImageView.isHidden = true
                    
                }
                self.tableview.delegate = self
                self.tableview.dataSource = self
                self.tableview.reloadData()
               
            }
        }
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

extension EventsController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventsCards") as! EventsCards
        cell.dateLbl.text  = "\(self.getEventListModel.date[indexPath.row])"
        cell.dayLbl.text = self.getEventListModel.day[indexPath.row]
        cell.monthLbl.text = self.getEventListModel.month[indexPath.row]
        cell.timeLbl.text = self.getEventListModel.time[indexPath.row]
        let hostname = self.getEventListModel.eventHost[indexPath.row]
        let location = self.getEventListModel.eventLocation[indexPath.row]
        cell.eventLocationLbl.text = hostname + "," + location
        let contants = Constants()
        self.imageFromServerURL(URLString: contants.baseUrl + self.getEventListModel.eventImage[indexPath.row], placeHolder: UIImage.init(named: "noImg.png"), imageView: cell.eventImageView)
        cell.eventImageView.layer.masksToBounds = true
      
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getEventListModel.eventName.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 232
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var eventsRestuarentCon = EventsRestaurentsController()
        eventsRestuarentCon = self.storyboard?.instantiateViewController(withIdentifier: "EventsRestaurentsController") as! EventsRestaurentsController
        eventsRestuarentCon.eventUUID = self.getEventListModel.eventUUID[indexPath.row]
        eventsRestuarentCon.vendorUUID = self.vendorUUID
        self.navigationController?.pushViewController(eventsRestuarentCon, animated: true)
    }
}

class EventsCards:UITableViewCell{
    @IBOutlet weak var dayLbl:UILabel!
    @IBOutlet weak var dateLbl:UILabel!
    @IBOutlet weak var monthLbl:UILabel!
    @IBOutlet weak var roundedView:UIView!
    @IBOutlet weak var eventImageView:UIImageView!
    @IBOutlet weak var timeLbl:UILabel!
    @IBOutlet weak var eventLocationLbl:UILabel!
    
    override func awakeFromNib() {
        self.roundedView.layer.cornerRadius = 10

        
    }
}
