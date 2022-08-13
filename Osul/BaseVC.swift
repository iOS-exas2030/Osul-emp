//
//  BaseVC.swift
//  Osul
//
//  Created by apple on 13/08/2022.
//  Copyright © 2022 Sayed Abdo. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import TransitionButton
import JSSAlertView

class BaseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func noDataView(mainNoDataView : inout UIView, labelData : String , refreshBtn : inout TransitionButton, addStatus : Int, addFBtn : inout TransitionButton){
        
        mainNoDataView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        mainNoDataView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.view.addSubview(mainNoDataView)
        
           
        let labelNoData = UILabel(frame: CGRect(x: 0, y: self.view.center.y - 180, width: self.view.frame.width, height: 80))
        labelNoData.text = labelData
        labelNoData.textColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
        labelNoData.font = UIFont(name:"STC-Bold", size: 22.0)
        labelNoData.textAlignment = .center
        labelNoData.numberOfLines = 0
        mainNoDataView.addSubview(labelNoData)
        
        refreshBtn = TransitionButton(frame: CGRect(x: self.view.center.x - 70, y: self.view.center.y - 110, width: 140, height: 40))
        refreshBtn.setTitle("تحديث", for: .normal)
        refreshBtn.titleLabel?.text = "nnnn"
        refreshBtn.setImage(#imageLiteral(resourceName: "lunch2"), for: .normal)
        refreshBtn.setTitleColor(#colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1), for: .selected)
        refreshBtn.titleLabel?.textColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
        refreshBtn.clipsToBounds = false
        //refreshBtn.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
       // refreshBtn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        refreshBtn.borderWidth = 1
     //   refreshBtn.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        refreshBtn.layer.cornerRadius = 5
        
       // refreshBtn.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        mainNoDataView.addSubview(refreshBtn)
        
        addFBtn = TransitionButton(frame: CGRect(x: self.view.frame.width - 80, y: self.view.frame.height - 90, width: 80, height: 80))
        addFBtn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        addFBtn.setImage(UIImage(named: "addicon"), for: .normal)
        mainNoDataView.addSubview(addFBtn)
        
        
        if(addStatus == 1){
            addFBtn.isHidden = true
        }else{
            addFBtn.isHidden = false
        }
        
        let logoImage = UIImageView(frame: CGRect(x: self.view.center.x - 60, y: self.view.center.y - 290, width: 120, height: 120))
        logoImage.image = UIImage(named: "loaderIcon1")
        logoImage.contentMode = .scaleToFill
        mainNoDataView.addSubview(logoImage)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
