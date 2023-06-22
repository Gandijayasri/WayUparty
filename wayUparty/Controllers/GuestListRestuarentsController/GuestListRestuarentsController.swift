//
//  GuestListRestuarentsController.swift
//  wayUparty
//
//  Created by Jasty Saran  on 05/01/21.
//  Copyright © 2021 Jasty Saran . All rights reserved.
//

import UIKit

class GuestListRestuarentsController: UIViewController {
    var guestListModel:GuestListModel!
    @IBOutlet weak var collectionView: UICollectionView!
    let imageCache = NSCache<AnyObject, AnyObject>()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Guest Entry list"
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        let userUUID = UserDefaults.standard.object(forKey: "userUUID") as? String ?? ""
        GuestListParser.getGuestListAPI(userUUID: userUUID){(responce)in
            self.guestListModel = responce.guestListModel.first
            DispatchQueue.main.async {
                if responce.guestListModel.first?.club.count == 1{self.collectionView.configureForPeekingDelegate(scrollDirection: .horizontal)}
                else{self.collectionView.configureForPeekingDelegate(scrollDirection: .vertical)}
                self.collectionView.reloadData()
            }
        }
        
        // Do any additional setup after loading the view.
    }
}

class GuestListRestuarentCell:UICollectionViewCell{
    @IBOutlet weak var imageView:UIImageView!
    @IBOutlet weak var restaurentName:UILabel!
    @IBOutlet weak var locationLbl:UILabel!
    @IBOutlet weak var shawdowView:UIView!
    static let isEnabledAllowsUserInteractionWhileHighlightingCard = true
    var disabledHighlightedAnimation = false

       func resetTransform() {
           transform = .identity
       }

       func freezeAnimations() {
           disabledHighlightedAnimation = true
           layer.removeAllAnimations()
       }

       func unfreezeAnimations() {
           disabledHighlightedAnimation = false
       }

       override func awakeFromNib() {
//        if UIScreen.main.bounds.size.width == 375{
//            resImageViewWidthConstraint.constant = 355
//        }
           shawdowView.layer.cornerRadius = 20
           shawdowView.layer.masksToBounds = true
           backgroundColor = .clear
//           layer.shadowColor = UIColor.lightGray.cgColor
//           layer.shadowOpacity = 1.5
//           layer.shadowOffset = .init(width: 2, height: 2)
//           layer.shadowRadius = 25
       }

       // Make it appears very responsive to touch
       override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           super.touchesBegan(touches, with: event)
           animate(isHighlighted: true)
       }

       override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
           super.touchesEnded(touches, with: event)
           animate(isHighlighted: false)
       }

       override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
           super.touchesCancelled(touches, with: event)
           animate(isHighlighted: false)
       }

       private func animate(isHighlighted: Bool, completion: ((Bool) -> Void)?=nil) {
           if disabledHighlightedAnimation {
               return
           }
        let animationOptions: UIView.AnimationOptions = HomeCollection.isEnabledAllowsUserInteractionWhileHighlightingCard
           ? [.allowUserInteraction] : []
           if isHighlighted {
               UIView.animate(withDuration: 0.5,
                              delay: 0,
                              usingSpringWithDamping: 1,
                              initialSpringVelocity: 0,
                              options: animationOptions, animations: {
                               self.transform = .init(scaleX: 0.96, y: 0.96)
               }, completion: completion)
           } else {
               UIView.animate(withDuration: 0.5,
                              delay: 0,
                              usingSpringWithDamping: 1,
                              initialSpringVelocity: 0,
                              options: animationOptions, animations: {
                               self.transform = .identity
               }, completion: completion)
           }
       }
    
}
//
extension GuestListRestuarentsController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if guestListModel != nil{return self.guestListModel.club.count}
        else{return 0}
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GuestListRestuarentCell", for: indexPath) as! GuestListRestuarentCell
        if guestListModel != nil{
            cell.restaurentName.text = self.guestListModel.club[indexPath.item]
            cell.locationLbl.text = self.guestListModel.clubLocation[indexPath.item]
            let constants = Constants()
            let imgURL =  constants.baseUrl + self.guestListModel.clubImage[indexPath.row]
            self.imageFromServerURL(URLString: imgURL, placeHolder: UIImage.init(named: "noImg.png"), imageView: cell.imageView)
            return cell
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if UIScreen.main.bounds.size.width == 428 {
            return UIEdgeInsets.init(top: 10, left: 15, bottom: 10, right: 0)

        }
        if UIScreen.main.bounds.size.width == 375 {
            return UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)

        }
        else{
            return UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var gueslistDetailCon = GuestListDetailController()
        gueslistDetailCon = self.storyboard?.instantiateViewController(identifier: "GuestListDetailController") as! GuestListDetailController
        gueslistDetailCon.guestUUID = self.guestListModel.guestUUID[indexPath.item]
        self.navigationController?.pushViewController(gueslistDetailCon, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIScreen.main.bounds.size.width == 375{
            return CGSize(width: 172, height: 228)
            
        }
        if UIScreen.main.bounds.size.width == 414 {
            return CGSize(width: 185, height: 228)
            
        }
        else {
            return CGSize(width: 200, height: 228)
            
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
