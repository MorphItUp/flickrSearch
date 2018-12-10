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
import MBProgressHUD

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
//    var imageArray = [UIImage]()
    let flickURL = "https://api.flickr.com/services/rest"
    var downloadURL:String = ""
    var downloadArray = [String]()
    var pageNo:Int = 0
    var numberCheck:Int = 14
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        collectionView.delegate = self
        
    }

    //MARK:- CollectionView Stubs
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return downloadArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "viewCell", for: indexPath) as! PhotoCell
        if !downloadArray.isEmpty{
            let urls = URL(string: downloadArray[indexPath.row])
            cell.imageView.kf.setImage(with: urls)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Item number \(indexPath.row) is selected")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // height is 584.0, width is 375.0
        return CGSize(width: 115 , height: 115 )
    }
  
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("in DisplayCell")
        print("IP \(indexPath.row)")
        print("DA \(downloadArray.count)")
        
        
        if indexPath.row == downloadArray.count - 1 {
            print("indexPath equals to ImageArray")
            pageNo = pageNo + 1
            request(lookFor: searchBar.text!)
        }
    }
    
    
    
    
    //MARK:- Alamofire request
    func request (lookFor : String){
        
        let parameters : [String : String] = [
            "method" : "flickr.photos.search",
            "api_key" : "636a6ee8a31fa8d13b6b2b260b105a60",
            "text" : lookFor,
            "format" : "json",
            "nojsoncallback" : "1",
            "per_page" : "20",
            "page" : String(pageNo),
            ]
        
//        showHUD(progressLabel: "Please wait...")
        
        Alamofire.request(flickURL, method: .get, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess{
                print("Got Flickr info")
                
                let photoJSON:JSON = JSON(response.result.value!)
                
                for i in 0..<20{
                
                let serverId = photoJSON["photos"]["photo"][i]["server"].stringValue
                let farmId = photoJSON["photos"]["photo"][i]["farm"].stringValue
                let Id = photoJSON["photos"]["photo"][i]["id"].stringValue
                let secret = photoJSON["photos"]["photo"][i]["secret"].stringValue
                self.downloadURL = "https://farm\(farmId).staticflickr.com/\(serverId)/\(Id)_\(secret).jpg"
                self.downloadArray.append(self.downloadURL)
                self.collectionView.reloadData()
                }
            }
        }
    }
    
    //MARK:- Test Button
    @IBAction func testButton(_ sender: UIButton) {
        request(lookFor: "Basketball")
        print(downloadArray)
        print("Button Pressed")
        collectionView.reloadData()
    }
    
    //MARK:- SearchBar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        print(searchBar.text!)
        deleteItems()
        request(lookFor: searchBar.text!)
        collectionView.reloadData()
    }
    
    //MARK:- Delete Cells for new Search
    func deleteItems(){
        downloadArray.removeAll()
    }
    
    //MARK:- ProgressHUD
    func showHUD(progressLabel : String){
        
        let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHUD.label.text = progressLabel
    }
    
    func dissmissHUD(isAnimated : Bool){
        MBProgressHUD.hide(for : self.view, animated: isAnimated)
    }
}

