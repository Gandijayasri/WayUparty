//
//  TimeSlotsController.swift
//  EventsModule
//
//  Created by Jasty Saran  on 24/12/20.
//

import UIKit

class TimeSlotsController: UIViewController {
    var buttonClickableAssist = Array<Bool>()
    @IBOutlet weak var collectionView: UICollectionView!
    let regularFont = UIFont.systemFont(ofSize: 16)
    let boldFont = UIFont.boldSystemFont(ofSize: 16)
    var eventTimeSlots:EventTimeSlotsModel!
    var eventUUID:String = ""
    var timeSlot:String = ""
    var vendorUUID:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Event Time Slots"
        EventTimeSlotsParser.EventTimeSlotAPI(evetnUUID: eventUUID){(responce) in
            print(responce.eventTimeSlotModel.first?.eventDate ?? "")
            let timeslots = responce.eventTimeSlotModel.first?.timeSlots.value(forKey: "timeSlot") as? Array<String> ?? []
            self.eventTimeSlots = responce.eventTimeSlotModel.first
            for _ in 0..<timeslots.count{
                self.buttonClickableAssist.append(false)
            }
            DispatchQueue.main.async {
                self.collectionView.delegate = self
                self.collectionView.dataSource = self
                self.collectionView.reloadData()
            }
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func continueBtn(_ sender: UIButton) {
        let redAppearance = YBTextPickerAppearanceManager.init(
               pickerTitle         : "Select Category",
               titleFont           : boldFont,
               titleTextColor      : UIColor.init(red: 186.0/255.0, green: 156.0/255.0, blue: 93.0/255.0, alpha: 1.0),
               titleBackground     : UIColor.black,
               searchBarFont       : regularFont,
               searchBarPlaceholder: "Search Type",
               closeButtonTitle    : "Cancel",
               closeButtonColor    : .systemRed,
               closeButtonFont     : regularFont,
               doneButtonTitle     : "Okay",
               doneButtonColor     : UIColor.init(red: 74.0/255.0, green: 157.0/255.0, blue: 100.0/255.0, alpha: 1.0),
               doneButtonFont      : boldFont,
               checkMarkPosition   : .Right,
               itemCheckedImage    : UIImage(named:"checkmark"),
               itemUncheckedImage  : UIImage(named:"dry"),
               itemColor           : .black,
               itemFont            : regularFont
           )
        var arrGender = Array<String>()
        GetEventCategoriesListParser.GetEventCategoriesAPI(eventUUID: "cy1anqml"){(responce) in
            DispatchQueue.main.async {
                arrGender = responce.getEventCategoryModel.first?.categoryName ?? ["no object"]
                let picker = YBTextPicker.init(with: arrGender, appearance: redAppearance,onCompletion: { (selectedIndexes, selectedValues) in
                if let selectedValue = selectedValues.first{
                print(selectedValue)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    if self.timeSlot != ""{
                        var ticketBookingCon = EventTicketBookingController()
                        ticketBookingCon = self.storyboard?.instantiateViewController(identifier: "EventTicketBookingController") as! EventTicketBookingController
                        ticketBookingCon.eventUUID = self.eventUUID
                        ticketBookingCon.categoryType = selectedValue
                        ticketBookingCon.timeSlot = self.timeSlot
                        ticketBookingCon.vendorUUID = self.vendorUUID
                        self.navigationController?.pushViewController(ticketBookingCon, animated: true)
                    }else{
                        let alert = UIAlertController(title: "Message", message: "Please select time slot and proceed", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                }else{
                print("selction")
                }},
                onCancel: {
                print("Cancelled")
                })
                
             picker.show(withAnimation: .FromBottom)
            }
        }
    }
}

class TimeSlotsCollectionViewCell:UICollectionViewCell{
    @IBOutlet weak var timeSlotBtn: UIButton!
    override func awakeFromNib() {
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.black.cgColor
      
    }
}

class TimeSlotsTitleCollectionViewCell:UICollectionViewCell{
    @IBOutlet weak var titleLbl:UILabel!
}

extension TimeSlotsController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{ return 1}
        else{
            let timeslots = self.eventTimeSlots.timeSlots.value(forKey: "timeSlot") as? Array<String> ?? []
            return timeslots.count
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeSlotsTitleCollectionViewCell", for:indexPath) as! TimeSlotsTitleCollectionViewCell
            cell.titleLbl.text = self.eventTimeSlots.eventDate
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeSlotsCollectionViewCell", for: indexPath) as! TimeSlotsCollectionViewCell
            let check = buttonClickableAssist[indexPath.item]
            let timeslots = self.eventTimeSlots.timeSlots.value(forKey: "timeSlot") as? Array<String> ?? []
            cell.timeSlotBtn.setTitle(timeslots[indexPath.item], for: .normal)
            if check == true{
                cell.backgroundColor = UIColor.init(red: 210.0/255.0, green: 184.0/255.0, blue: 131.0/255.0, alpha: 1.0)
                cell.timeSlotBtn.setTitleColor(UIColor.white, for: .normal)
            }else{
                cell.backgroundColor = UIColor.white
                cell.timeSlotBtn.setTitleColor(UIColor.black, for: .normal)
            }
            cell.timeSlotBtn.tag = indexPath.item
            cell.timeSlotBtn.addTarget(self, action: #selector(timeSlotBtnClicked), for: .touchUpInside)
            return cell
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0{
            if UIScreen.main.bounds.size.height == 926.0{return UIEdgeInsets.init(top: 5, left: -35, bottom: 5, right: 0)}
            else{return UIEdgeInsets.init(top: 5, left: 0, bottom: 5, right: 0)}
        }
        else{
            return UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0{return CGSize(width: 375, height: 62)}
        else{
            return CGSize(width: 78, height: 39)
        }
      
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0{return 1}
        else{return 10}
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0{return 0.2}
        else{return 10}
    }
    
    @objc func timeSlotBtnClicked(_sender:UIButton){
        buttonClickableAssist.removeAll()
        let timeslots = self.eventTimeSlots.timeSlots.value(forKey: "timeSlot") as? Array<String> ?? []
        for _ in 0..<timeslots.count{
            buttonClickableAssist.append(false)
        }
        if _sender.isSelected == true{
            buttonClickableAssist[_sender.tag] = false
        }else{
            buttonClickableAssist[_sender.tag] = true
        }
        timeSlot = timeslots[_sender.tag]
        print(buttonClickableAssist)
        self.collectionView.reloadData()
    }
}
