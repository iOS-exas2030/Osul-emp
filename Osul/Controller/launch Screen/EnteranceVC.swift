//
//  EnteranceVC.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 7/8/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//


import UIKit
import Spring
import SnapKit

class EnteranceVC: UIViewController {
    
    @IBOutlet weak var img1: SpringImageView!
    @IBOutlet weak var img2: SpringImageView!
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
//        img1.snp.makeConstraints { (make) in
//            make.width.height.equalTo(100)
//            make.centerY.equalTo(self.view).inset(-40)
//            make.centerX.equalTo(self.view)
//        }
//        
//        img2.snp.makeConstraints { (make) in
////            make.left.bottom.right.equalTo(self.view)
//            make.height.equalTo(100)
//            make.width.equalTo(150)
//            make.centerY.equalTo(self.view).inset(60)
//            make.centerX.equalTo(self.view)
//        }
        
        Animations.slideDown(view: img1)
        Animations.slideUp(view: img2)
        
        timer = Timer.scheduledTimer(withTimeInterval: 4,repeats: false,block:{_ in
            self.timer.invalidate()
            //let view = self.storyboard?.instantiateViewController(withIdentifier: "LogInVC") as! LogInVC
            //self.navigationController?.pushViewController(view, animated: true)
           
            print("qqqq : \(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)")
            
            
            self.updateRoot()
        })
    }
}
