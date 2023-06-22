//
//  EventsBanner.swift
//  wayUparty
//
//  Created by Arun  on 03/05/23.
//  Copyright © 2023 Jasty Saran . All rights reserved.
//

import UIKit
import FSPagerView

class EventsBanner: UICollectionViewCell {
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        }
    }
    let imageCache = NSCache<AnyObject, AnyObject>()
    var slidesArr = NSArray()
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}


extension EventsBanner:FSPagerViewDataSource,FSPagerViewDelegate{
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.slidesArr.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.layer.masksToBounds = true
        cell.imageView?.layer.cornerRadius = 20
        
        let imageurl = self.slidesArr[index]
        let constants = Constants()
        let slideImgurl = "\(constants.baseUrl)\(imageurl)"
        self.imageFromServerURL(URLString: slideImgurl, placeHolder: UIImage(named: ""), imageView: cell.imageView!)
        
        return cell
    }
    
    
}


extension EventsBanner{
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
