//
//  MainLoader.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 9/13/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

// note: view object is from my previous tutorial, with autoresizing masks disabled
import UIKit
import NVActivityIndicatorView
import TransitionButton
import JSSAlertView

 extension UIViewController{
    func showLoader( mainView : inout UIView){
       //  getTokenReq()
         mainView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
          mainView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
          self.view.addSubview(mainView)
          
         // let loaderView = NVActivityIndicatorView()
          let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: self.view.center.x - 40, y: self.view.center.y - 124, width: 80, height: 80), type: .lineScale, color: #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1), padding: 0)
          
          activityIndicatorView.startAnimating()
        //  self.view.addSubview(activityIndicatorView)
          mainView.addSubview(activityIndicatorView)
        let logoImage = UIImageView(frame: CGRect(x: self.view.center.x - 60, y: self.view.center.y - 290, width: 120, height: 120))
        logoImage.image = UIImage(named: "loaderIcon1")
        logoImage.contentMode = .scaleToFill
       // logoImage.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        mainView.addSubview(logoImage)
    }
    func hideLoader( mainView : inout UIView){
        mainView.isHidden = true
    }
//    var timer = Timer()
//    func hideLoaderWithTimer( mainView : inout UIView){
//        timer = Timer.scheduledTimer(withTimeInterval: 5,repeats: false,block:{_ in
//            timer.invalidate()
//            mainView.isHidden = true
//        })
//    }
    func getDateFromTimeStamp(timeStamp : Double) -> String {
        let date = NSDate(timeIntervalSince1970: timeStamp)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return dateString
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
    func hideNoDataView( mainNoDataView : inout UIView){
        mainNoDataView.isHidden = true
    }
    ///
    
    func noInterNetView(mainNoDataView : inout UIView, refreshBtn : inout TransitionButton){
        mainNoDataView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        mainNoDataView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.view.addSubview(mainNoDataView)
        
           
        let labelNoData = UILabel(frame: CGRect(x: 0, y: self.view.center.y - 180, width: self.view.frame.width, height: 80))
        labelNoData.text = "فشل الاتصال بالانترنت"
        labelNoData.textColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
        labelNoData.font = UIFont(name:"STC-Bold", size: 22.0)
        labelNoData.textAlignment = .center
        labelNoData.numberOfLines = 0
        mainNoDataView.addSubview(labelNoData)
        
        refreshBtn = TransitionButton(frame: CGRect(x: self.view.center.x - 70, y: self.view.center.y - 110, width: 140, height: 40))
        refreshBtn.setTitle("تحديث", for: .normal)
        refreshBtn.backgroundColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
        refreshBtn.borderWidth = 1
     //   refreshBtn.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        refreshBtn.layer.cornerRadius = 5
        refreshBtn.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        mainNoDataView.addSubview(refreshBtn)
        
         let logoImage = UIImageView(frame: CGRect(x: self.view.center.x - 60, y: self.view.center.y - 290, width: 120, height: 120))
         logoImage.image = UIImage(named: "loaderIcon1")
         logoImage.contentMode = .scaleToFill
         mainNoDataView.addSubview(logoImage)
        
    }
    func hideNoInterNetView( mainNoInterNetView : inout UIView){
        mainNoInterNetView.isHidden = true
    }
    ///
    
    func errorView(mainNoDataView : inout UIView, refreshBtn : inout TransitionButton){
        mainNoDataView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        mainNoDataView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.view.addSubview(mainNoDataView)
        
           
        let labelNoData = UILabel(frame: CGRect(x: 0, y: self.view.center.y - 180, width: self.view.frame.width, height: 80))
        labelNoData.text = "حدث خطأ ما"
        labelNoData.textColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
        labelNoData.font = UIFont(name:"STC-Bold", size: 22.0)
        labelNoData.textAlignment = .center
        labelNoData.numberOfLines = 0
        mainNoDataView.addSubview(labelNoData)
        
        refreshBtn = TransitionButton(frame: CGRect(x: self.view.center.x - 70, y: self.view.center.y - 110, width: 140, height: 40))
        refreshBtn.setTitle("تحديث", for: .normal)
        refreshBtn.backgroundColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
        refreshBtn.borderWidth = 1
     //   refreshBtn.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        refreshBtn.layer.cornerRadius = 5
        refreshBtn.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        mainNoDataView.addSubview(refreshBtn)
        
         let logoImage = UIImageView(frame: CGRect(x: self.view.center.x - 60, y: self.view.center.y - 290, width: 120, height: 120))
         logoImage.image = UIImage(named: "loaderIcon1")
         logoImage.contentMode = .scaleToFill
         mainNoDataView.addSubview(logoImage)
    }
    func hideErrorView( mainNoInterNetView : inout UIView){
        mainNoInterNetView.isHidden = true
    }
    func getTokenReq(){
        NetworkClient.performRequest(GetTokenModel.self, router: .getToken(id: (UserDefaults.standard.value(forKeyPath: "userId")! as? String)!), success: { [weak self] (models) in
            
            print("models\( models)")
            if(models.status == 1){
              
             //   let token =  UserDefaults.standard.value(forKeyPath: "Token")! ?? ""
                print("sss" + AppDelegate.token)
                if(AppDelegate.token == models.token!){
                 //   print("aaa : " + "\(token as? String ?? "")")
                    print("bbb : " + "\(models.token!)")
                    print("1111111111")
                  //  self?.updateApp()
                    print("sayed  : \(UIViewController.getVersion())")
                }else{
                    let alertview = JSSAlertView().success(self!,title: "تنبيه !!",text: "تم اعاده الدخول من جهاز اخر", buttonText: "أعاده تسجيل الدخول")
                    alertview.addAction {
                       let view = self?.storyboard?.instantiateViewController(withIdentifier: "LogInVC") as! LogInVC
                       self?.navigationController?.pushViewController(view, animated: true)
                    }
                }
            }
            else if (models.status == 0 ){
               
            }
        }){ [weak self] (error) in
               
            }
    }
    func updateApp(){
        
        let mainNoDataView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        mainNoDataView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.view.addSubview(mainNoDataView)
        
           
        let labelNoData = UILabel(frame: CGRect(x: 0, y: self.view.center.y - 180, width: self.view.frame.width, height: 150))
        labelNoData.text = "نشكركم على استخدام التطبيق الخاص بمجموعه الخليل برجاء التحديث الي اخر نسخه من التطبيق"
        labelNoData.textColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
        labelNoData.font = UIFont(name:"STC-Bold", size: 22.0)
        labelNoData.textAlignment = .center
        labelNoData.numberOfLines = 0
        mainNoDataView.addSubview(labelNoData)
        
        let refreshBtn = UIButton(frame: CGRect(x: self.view.center.x - 70, y: self.view.center.y - 50, width: 140, height: 40))
        refreshBtn.setTitle("حدث الإن", for: .normal)
        refreshBtn.backgroundColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
        refreshBtn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        refreshBtn.borderWidth = 1
     //   refreshBtn.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        refreshBtn.layer.cornerRadius = 5
       // refreshBtn.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        refreshBtn.addTarget(self, action: #selector(openAppStore), for: UIControl.Event.touchUpInside)
        mainNoDataView.addSubview(refreshBtn)
        
        
        let logoImage = UIImageView(frame: CGRect(x: self.view.center.x - 60, y: self.view.center.y - 290, width: 120, height: 120))
        logoImage.image = UIImage(named: "loaderIcon1")
        logoImage.contentMode = .scaleToFill
        mainNoDataView.addSubview(logoImage)
    }
    
    @objc func openAppStore(){
        if let url = URL(string: "https://apps.apple.com/us/app/alkhalil-emp/id1529382845") {
            UIApplication.shared.open(url)
        }
    }
    class func getVersion() -> String {
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return "no version info"
        }
        return version
    }
}
