//
//  OffersListVC.swift
//  wayUparty
//
//  Created by Arun on 11/04/23.
//  Copyright © 2023 Jasty Saran . All rights reserved.
//

import UIKit
enum OfferListPickerAnimation:String{
    case FromBottom
    case Fade
}

enum OfferListCheckMarkPosition:String{
    case Left
    case Right
}
struct OfferListAppearanceManager{
    
    var pickerTitle : String?
    var titleFont : UIFont?
    var titleTextColor : UIColor?
    var titleBackground : UIColor?
    
//    var searchBarFont : UIFont?
//    var searchBarPlaceholder : String?
    
    var closeButtonTitle : String?
    var closeButtonColor : UIColor?
    var closeButtonFont : UIFont?
    
    var doneButtonTitle : String?
    var doneButtonColor : UIColor?
    var doneButtonFont : UIFont?
    
    var checkMarkPosition : OfferListCheckMarkPosition?
    var itemCheckedImage : UIImage?
    var itemUncheckedImage : UIImage?
    var itemColor : UIColor?
    var itemFont : UIFont?
    
}



class OffersListVC: UIViewController {
    
    
    
    @IBOutlet weak var titleLabel: UILabel!
   // @IBOutlet weak var txtSearch: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    
    
    //MARK:- Constants
    let animationDuration = 0.3
    let shadowAmount:CGFloat = 0.6
    let shadowColor = UIColor.black
    
    var arrAllValues = [OfferListDataModel]()
    var arrValues = [OfferListDataModel]()
    
    var selectedValues = [OfferListDataModel]()
    
    var preSelectedValues = [String]()
    
    var allowMultipleSelection = false
    var tapToDismiss = true
    var animation = OfferListPickerAnimation.FromBottom
    var appearanceManager : OfferListAppearanceManager?
    
    var completionHandler : ((_ selectedIndexes:[Int], _ selectedValues:[String])->Void)?
    var cancelHandler : (()->Void)?
    
    
    
    init (
        with items : [String],
        appearance : OfferListAppearanceManager?,
        onCompletion : @escaping (_ selectedIndexes:[Int], _ selectedValues:[String]) -> Void,
        onCancel : @escaping () -> Void
        ){
        
        super.init(nibName: "OffersListVC", bundle: nil)
        
        for (index,textItem) in items.enumerated(){
            let dataModel = OfferListDataModel.init(textItem, index)
            arrAllValues.append(dataModel)
        }
        
        self.arrValues = arrAllValues.map{$0}
        
        self.appearanceManager = appearance
        
        self.completionHandler = onCompletion
        self.cancelHandler = onCancel
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func show(withAnimation animationType:OfferListPickerAnimation){
        self.animation = animationType
        if let topController = UIApplication.topViewController() {
            var shouldAnimate = false
            if animation == .FromBottom{
                shouldAnimate = true
            }
            topController.present(self, animated: shouldAnimate, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupLayout()
    }
    
    func setupLayout(){
        tableView.register(UINib.init(nibName: "OfferTableCell", bundle: nil), forCellReuseIdentifier: "OfferTableCell")
        
        if animation == .Fade{
            self.view.alpha = 0
        }
        
        selectedValues = arrAllValues.filter{
            preSelectedValues.contains($0.title)
        }
        
        
        
        if let appearance = self.appearanceManager{
            if let pTitle = appearance.pickerTitle{
                titleLabel.text = pTitle
            }
            
            if let tFont = appearance.titleFont{
                titleLabel.font = tFont
            }
            
            if let tBGColor = appearance.titleBackground{
                titleLabel.backgroundColor = tBGColor
            }
            
            if let tColor = appearance.titleTextColor{
                titleLabel.textColor = tColor
            }
            
//            if let sFont = appearance.searchBarFont{
//                if let textFieldInsideSearchBar = txtSearch.value(forKey: "searchField") as? UITextField{
//                    textFieldInsideSearchBar.font = sFont
//                }
//            }
//
//            if let sPlaceholder = appearance.searchBarPlaceholder{
//                txtSearch.placeholder = sPlaceholder
//            }
            
            if let cBtnTitle = appearance.closeButtonTitle{
                btnClose.setTitle(cBtnTitle, for: .normal)
            }
            
            if let cBtnColor = appearance.closeButtonColor{
                btnClose.setTitleColor(cBtnColor, for: .normal)
            }
            
            if let cBtnFont = appearance.closeButtonFont{
                btnClose.titleLabel?.font = cBtnFont
            }
            
            if let dBtnTitle = appearance.doneButtonTitle{
                btnDone.setTitle(dBtnTitle, for: .normal)
            }
            
            if let dBtnColor = appearance.doneButtonColor{
                btnDone.setTitleColor(dBtnColor, for: .normal)
            }
            
            if let dBtnFont = appearance.doneButtonFont{
                btnDone.titleLabel?.font = dBtnFont
            }
        }
        
        
    }
    @IBAction func closeAction(_ sender: Any) {
        cancelHandler?()
        closePicker()
    }
    
    @IBAction func doneAction(_ sender: Any) {
        
        let indexes = selectedValues.map{$0.identity!}
        let values = selectedValues.map{$0.title!}
        completionHandler?(indexes, values)
        
        closePicker()
    }
    func closePicker(){
        UIView.animate(withDuration: animationDuration, animations: {
           
            if self.animation == .Fade{
                self.view.alpha = 0
            }
            
        }) { (completed) in
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    

    @IBAction func dismissPicker(_ sender: UIButton) {
        self.dismiss(animated: true,completion: nil)
    }
    
}

extension OffersListVC : UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0{
            arrValues = arrAllValues.map{ $0 }
        }else{
            
            arrValues = arrAllValues.filter{
                $0.title.lowercased().contains(searchText.lowercased())
            }
            
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
}

extension OffersListVC : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OfferTableCell", for: indexPath) as! OfferTableCell
        
        let dataModel = arrValues[indexPath.row]
        
        
        cell.lblItem.text = dataModel.title
        
        var chkImage:UIImage? = nil
        
        if selectedValues.contains(dataModel)
        {
            chkImage = #imageLiteral(resourceName: "YBTextPicker_checked.png")
        }else{
            chkImage = #imageLiteral(resourceName: "YBTextPicker_unchecked.png")
        }
        
        
        if let appearance = self.appearanceManager{
            if let itFont = appearance.itemFont{
                cell.lblItem.font = itFont
            }
            if let itColor = appearance.itemColor{
                cell.lblItem.textColor = itColor
            }
            
            if let itCheckedImage = appearance.itemCheckedImage{
                if selectedValues.contains(dataModel)
                {
                    chkImage = itCheckedImage
                }
            }
            if let itUncheckedImage = appearance.itemUncheckedImage{
                if selectedValues.contains(dataModel) == false
                {
                    chkImage = itUncheckedImage
                }
            }
            if let checkMarkPosition = appearance.checkMarkPosition{
                let checkMarkWidth:CGFloat = 20.0
                if checkMarkPosition == .Left{
                    cell.widthOfImgLeadingCheck.constant = checkMarkWidth
                }
            }
        }
        
        
        cell.imgLeadingCheck.image = chkImage
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrValues.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if allowMultipleSelection == false {
            selectedValues = [OfferListDataModel]()
        }

        let dataModel = arrValues[indexPath.row]
        if selectedValues.contains(dataModel){
            selectedValues.removeAll{ $0 == dataModel }
        }else{
            selectedValues.append(dataModel)
        }
        
        var cellsToReload = [IndexPath]()
        if allowMultipleSelection == false {
            cellsToReload = tableView.indexPathsForVisibleRows!
            //RELOAD ALL VISIBLE CELLS SO THAT PREVIOUSLY SELECTED CELL GETS DE-SELECTED
        }else{
            cellsToReload = [indexPath]
            //SELECT OR DE-SELECT CURRENT CELL (NO NEED TO RELOAD OTHER CELLS)
        }
        tableView.reloadRows(at: cellsToReload, with: .fade)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 61
    }
}

