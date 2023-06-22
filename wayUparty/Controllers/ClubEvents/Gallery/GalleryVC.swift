//
//  GalleryVC.swift
//  wayUparty
//
//  Created by Arun  on 04/05/23.
//  Copyright © 2023 Jasty Saran . All rights reserved.
//https://wayuparty.com/ws/getVendorInfo?vendorUUID=9lqUDak5

import UIKit

class GalleryVC: UIViewController {

    @IBOutlet weak var galleryList: UITableView!
    var galleryArr = NSArray()
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        galleryList.delegate = self
        galleryList.dataSource = self
        galleryList.reloadData()
        
    }
    

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    

}


class GalleryCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let color = UIColor(red: 243/255, green: 194/255, blue: 69/255, alpha: 1)
        imgView.layer.borderColor = color.cgColor
        imgView.layer.borderWidth = 1
    }

    
}



extension GalleryVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return galleryArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = galleryList.dequeueReusableCell(withIdentifier: "GalleryCell") as! GalleryCell
        let constants = Constants()
        let img = galleryArr[indexPath.row]
        let imageUrl = "\(constants.baseUrl)\(img)"
        
        
        self.imageFromServerURL(URLString: imageUrl, placeHolder: UIImage(named: " "), imageView: cell.imgView)
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
    
    
}
extension GalleryVC{
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
                            let imageData = downloadedImage.jpegData(compressionQuality: 0.20)
                            imageViews.image = UIImage(data: imageData!)
                        }
                    }
                }
            }).resume()
        }
    }
}
