//
//  ViewController.swift
//  flick
//
//  Created by Mohamed Gedawy on 12/6/18.
//  Copyright © 2018 Mohamed Gedawy. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
//import SDWebImage
import Kingfisher

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    var imageArray = [UIImage]()
    let flickURL = "https://api.flickr.com/services/rest"
    var downloadURL:String = ""
    var downloadArray = [String]()
    var testURL = URL(string: "https://r.hswstatic.com/w_907/gif/tesla-cat.jpg")
    var testURL2 = [String]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        request(lookFor: "Basketball")
        searchBar.delegate = self
        collectionView.delegate = self
        
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return downloadArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "viewCell", for: indexPath) as! PhotoCell

//        request(lookFor: "Basketball")
//        cell.imageView.sd_setImage(with: URL(string: downloadURL))
        
//        testURL2.append("https://www.washingtonpost.com/resizer/rmmBUcybIzdfzbuOeeybgskFYko=/480x0/arc-anglerfish-washpost-prod-washpost.s3.amazonaws.com/public/CCWE4SVKQQI6RGT5ZUYFAT7ZAI.jpg")
//        testURL2.append("https://r.hswstatic.com/w_907/gif/tesla-cat.jpg")
        
//        let url = URL(string: downloadArray[indexPath.row])
//        let data = try? Data(contentsOf: url!)
//        var asd = UIImage(data: data!)
//        imageArray.append(asd!)
        
//        if !downloadArray.isEmpty{
//            getImages(indexPath: indexPath)
//            cell.imageView.image = imageArray[indexPath.row]
//        }
        if !downloadArray.isEmpty{
        let urls = URL(string: downloadArray[indexPath.row])
        cell.imageView.kf.setImage(with: urls)
        }
        
//        collectionView.reloadData()
        
//        cell.imageView.sd_setImage(with: URL(string : downloadURL))
//        cell.imageView.kf.setImage(with: testURL)
//        testURL = URL(string : "https://www.washingtonpost.com/resizer/rmmBUcybIzdfzbuOeeybgskFYko=/480x0/arc-anglerfish-washpost-prod-washpost.s3.amazonaws.com/public/CCWE4SVKQQI6RGT5ZUYFAT7ZAI.jpg")
//        cell.imageView.kf.setImage(with: testURL)
        
        return cell
        
    }
    
    
    
//    func getImages(indexPath : IndexPath){
//
////        testURL2.append("https://www.washingtonpost.com/resizer/rmmBUcybIzdfzbuOeeybgskFYko=/480x0/arc-anglerfish-washpost-prod-washpost.s3.amazonaws.com/public/CCWE4SVKQQI6RGT5ZUYFAT7ZAI.jpg")
////        testURL2.append("https://r.hswstatic.com/w_907/gif/tesla-cat.jpg")
//
//        let urls = URL(string: downloadArray[indexPath.row])
//        do{
//            let data = try Data(contentsOf: urls!)
//            var asd = UIImage(data: data)
//            imageArray.append(asd!)
//        }catch{
//            print("empty array...\(error)")
//        }
//
//    }
    
    
    func request (lookFor : String){
        
        let parameters : [String : String] = [
            "method" : "flickr.photos.search",
            "api_key" : "636a6ee8a31fa8d13b6b2b260b105a60",
            "text" : lookFor,
            "format" : "json",
            "nojsoncallback" : "1",
            ]
        
        Alamofire.request(flickURL, method: .get, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess{
                print("Got Flickr info")
//                print(JSON(response.result.value))
                
                let photoJSON:JSON = JSON(response.result.value!)
                
                for i in 0..<90{
                
                let serverId = photoJSON["photos"]["photo"][i]["server"].stringValue
                let farmId = photoJSON["photos"]["photo"][i]["farm"].stringValue
                let Id = photoJSON["photos"]["photo"][i]["id"].stringValue
                let secret = photoJSON["photos"]["photo"][i]["secret"].stringValue
                
                self.downloadURL = "https://farm\(farmId).staticflickr.com/\(serverId)/\(Id)_\(secret).jpg"
                
                self.downloadArray.append(self.downloadURL)
//                print(self.downloadArray)
                self.collectionView.reloadData()
                }
            }
        }
    }
    
    @IBAction func testButton(_ sender: UIButton) {
        request(lookFor: "Basketball")
        print(downloadArray)
        print("Button Pressed")
        collectionView.reloadData()
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(searchBar.text!)
        request(lookFor: searchBar.text!)
        collectionView.reloadData()
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // height and width is 584.0
        return CGSize(width: 180 , height: 170 )
    }
}

