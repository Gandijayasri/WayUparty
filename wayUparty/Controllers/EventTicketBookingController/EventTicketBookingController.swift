//
//  EventTicketBookingController.swift
//  EventsModule
//
//  Created by Jasty Saran  on 26/12/20.
//

import UIKit
import Stepperier
import Razorpay
//rzp_test_frTSP8jWD932Xq
class EventTicketBookingController: UIViewController {
    var finalTicketCount = Int()
    var total = Int()
    var paymentId : String  = ""
    var razorpayObj : RazorpayCheckout? = nil
    var razorPayOrderID = String()
    var razorpayTestKey:String = "rzp_test_frTSP8jWD932Xq"
    var eventUUID:String = ""
    var timeSlot:String = ""
    var categoryType:String = ""
    var ticketType:String = ""
    var vendorUUID:String = ""
    @IBOutlet weak var tableView:UITableView!
    var supportArrayBtn = Array<Bool>()
    var supportValues = Array<Int>()
    var getEventTicketList:GetEventTicketsList!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Ticket Booking"
        GetEventTicketListParser.GetEventTicketListAPI(eventUUID: "cy1anqml", categoryType: "stag"){(responce) in
            
            let count = responce.getEventTicketList.first?.eventUUID.count ?? 0
            self.getEventTicketList = responce.getEventTicketList.first
            for i in 0..<count{
                self.supportArrayBtn.append(false)
                self.supportValues.append(responce.getEventTicketList.first?.maxBookingAllowed[i] ?? 0)
            }
            DispatchQueue.main.async {
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func proceedAction(_ sender: UIButton) {
        print(finalTicketCount)
        print(total)
        self.placeOrder(_sender: sender)
    }
    
    @objc func placeOrder(_sender:UIButton){
        self.loadingIndicator()
        let constants = Constants()
        let paymentInfo = ["cartAmount":"\(total)","currency":"INR"]
        GenerateOrderIDParser.RazorpayGenerateOrderAPI(xUsername: constants.xUsername,xPassword: constants.xPassword,patymentInfo: paymentInfo){(responce) in
            isAnimationFalse = true
            let orderId = responce.getOrderIdModel?.first?.orderId ?? String()
            self.razorPayOrderID = orderId
            DispatchQueue.main.async {
                self.showPaymentForm(orderId: orderId)
            }
        }
    }
}

class EventTicketBookingCell:UITableViewCell{
    @IBOutlet weak var ticketType:UILabel!
    @IBOutlet weak var stepperView:Stepperier!
    @IBOutlet weak var addBtn:UIButton!
    @IBOutlet weak var supportView: UIView!
}

extension EventTicketBookingController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getEventTicketList.eventUUID.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventTicketBookingCell") as! EventTicketBookingCell
        cell.supportView.layer.cornerRadius = 20
        let check =  supportArrayBtn[indexPath.row]
        if check == true{cell.addBtn.isHidden = true}
        else{cell.addBtn.isHidden = false}
        cell.addBtn.tag = indexPath.row
        cell.stepperView.tag = indexPath.row
        cell.addBtn.addTarget(self, action: #selector(addBtnAction), for: .touchUpInside)
        cell.stepperView.addTarget(self, action:#selector(stepperViewAction), for: .valueChanged)
        cell.ticketType.text = self.getEventTicketList.ticketType[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    @objc func addBtnAction(_sender:UIButton){
        self.supportArrayBtn.removeAll()
        for _ in 0..<self.getEventTicketList.eventUUID.count{
            supportArrayBtn.append(false)
        }
        if _sender.isSelected == true{self.supportArrayBtn[_sender.tag] = false}
        else{self.supportArrayBtn[_sender.tag] = true}
        finalTicketCount = supportValues[_sender.tag]
        total = finalTicketCount*self.getEventTicketList.ticketAmount[_sender.tag]
        ticketType = self.getEventTicketList.ticketType[_sender.tag]
        print(total)
        self.tableView.reloadData()
    }
    
    @objc func stepperViewAction(_steperier:Stepperier){
        self.supportValues.removeAll()
        for i in 0..<self.getEventTicketList.eventUUID.count{
            self.supportValues.append(self.getEventTicketList.maxBookingAllowed[i])
        }
        let observableValue = self.getEventTicketList.maxBookingAllowed[_steperier.tag]
        if _steperier.value > observableValue{
            _steperier.value = _steperier.value-1
            let alert = UIAlertController(title: "Message", message: "You have reached the maximum ticket booking for \(self.getEventTicketList.ticketType[_steperier.tag]) type", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        print(_steperier.value)
        self.supportValues[_steperier.tag] = _steperier.value
        print(self.supportValues)
    }
    
    func loadingIndicator(){
        isAnimationFalse = false
        var loadingSupport = LoadingSupport()
        loadingSupport = self.storyboard?.instantiateViewController(withIdentifier: "LoadingSupport") as! LoadingSupport
        addChild(loadingSupport)
        self.view.addSubview(loadingSupport.view)
    }
}

extension EventTicketBookingController : RazorpayPaymentCompletionProtocol{
    func onPaymentError(_ code: Int32, description str: String) {
        print(str)
        print(code)
    }
    
    func onPaymentSuccess(_ payment_id: String) {
        self.loadingIndicator()
        _ = String()
        let userUUID = UserDefaults.standard.object(forKey: "userUUID") as? String
        print(userUUID ?? "No user Id available")
        let cartData = ["vendorUUID":self.vendorUUID,"userUUID":userUUID ?? "nothing to develop","paymentId":payment_id,"orderId":"\(self.razorPayOrderID)","signature":"", "eventUUID":self.eventUUID, "ticketType":self.ticketType,"categoryType":self.categoryType, "ticketAmount":total,"quantity":finalTicketCount,"timeslot":self.timeSlot,"currency":"INR"] as [String : Any]
        print(cartData)
        let constants = Constants()
        PlaceEventOrderParser.PlaceEventOrderAPI(xuserName: "\(constants.xUsername)", password: "\(constants.xPassword)", eventOrderData: cartData as [String : Any]){(responce) in
            isAnimationFalse = true
            let result = responce.addToCartModel.first?.responce
            if result == "SUCCESS"{
                DispatchQueue.main.async {
                    tabBarScreen = "orders"
                }
            }
        }
    }
    
    internal func showPaymentForm(orderId:String){
        let paisaTotal = total * 100
        razorpayObj = RazorpayCheckout.initWithKey(razorpayTestKey, andDelegate: self)
        let userEmail = UserDefaults.standard.object(forKey: "userEmail") as? String ?? ""
        let userMobile = UserDefaults.standard.object(forKey: "userMobile") as? String ?? ""
        let options: [String:Any] = [
                    "amount": "\(paisaTotal)",
                    "currency": "INR",
                    "description": "Party Your Way",
                    "orderId":"\(orderId)",
                    "image": "http://aws.wayuparty.com/resources/img/logo.png",
                    "name": "wayUparty",
                    "prefill": [
                        "contact": "\(userMobile)",
                        "email": "\(userEmail)"
                    ],
                    "theme": [
                        "color": "#cfb376"
                      ]
                ]
        razorpayObj?.open(options, displayController: self)
    }
    
}
