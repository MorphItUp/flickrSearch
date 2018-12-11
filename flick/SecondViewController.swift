//
//  SecondViewController.swift
//  
//
//  Created by Mohamed Gedawy on 12/10/18.
//

import UIKit
import Kingfisher

class SecondViewController: UINavigationController {
    
    
    @IBOutlet weak var secondImageView: UIImageView!
    
    var downloadURLPassedOver = URL(string: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        secondImageView.image = UIImage(imageee)
        print("\(downloadURLPassedOver)")
    }
    

}
