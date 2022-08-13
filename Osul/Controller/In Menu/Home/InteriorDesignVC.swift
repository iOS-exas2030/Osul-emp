//
//  InteriorDesignVC.swift
//  AL-HHALIL
//
//  Created by apple on 7/16/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import JSSAlertView
import TransitionButton


class InteriorDesignVC: BaseVC {
     
    
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var assignView: UIView!
    @IBOutlet weak var chatView: UIView!
    @IBOutlet weak var progressTimeView: UIView!
    @IBOutlet weak var titleName: UILabel!
    @IBOutlet weak var chatNotification: UIImageView!
    var projectAtt = [ProjectAttachment]()
    var levelData : LevelDetailsModel?
    var id = ""
    var result = ""
    var jobType = ""
    var projectId = ""
    var projectName = ""
    var levelName = ""
    var autoComplete = ""
    var projectStatus = ""
    
    //status views
    var loaderView = UIView()
    var noDataView = UIView()
    var refresDatahBtn = TransitionButton()
    var refreshInterNetBtn = TransitionButton()
    var noInterNetView = UIView()
    var errorView = UIView()
    var refreshErrorBtn = TransitionButton()
    var addFBtn = TransitionButton()
    
    var days = [String]()
 
    override func viewDidLoad() {
        super.viewDidLoad()
           config()
    }
    override func viewWillAppear(_ animated: Bool) {
        getTokenReq()
        if levelData?.data.count == 0 {
             addAllViews()
             config()
        }else{
            hideAllViews()
            config()
        }
    }
    func config(){
         
         self.tableView.delegate = self
         self.tableView.dataSource = self
         get_level_details()        
        titleName.text = levelName
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(editLevel))
        editView.addGestureRecognizer(tap)
        let tap2: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chatLevel))
        chatView.addGestureRecognizer(tap2)
        let tap3: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(assignLevel))
        assignView.addGestureRecognizer(tap3)
         if UserDefaults.standard.value(forKey: "jopType") as? String == "1"{
             completeButton.isHidden = true
         }else{
             completeButton.isHidden = false
         }
        if autoComplete == "1"{
            completeButton.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            completeButton.setTitle("مرحلة مكتملة", for: .normal)
        }else{
            completeButton.backgroundColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
            completeButton.setTitle("غير مكتملة", for: .normal)
        }
        addFBtn.addTarget(self, action: #selector(editLevel), for: UIControl.Event.touchUpInside)
        
        print("sayed : \(jobType)")
        if jobType == "1"{
            editView.isHidden = true
        }else{
            editView.isHidden = false
        }
        let tap4: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(progress))
        progressTimeView.addGestureRecognizer(tap4)
        
      }
    @objc func progress (){
        let view = self.storyboard?.instantiateViewController(withIdentifier: "ProgressTimeVC") as! ProgressTimeVC
        view.delegate = self
        view.ProgressTime = levelData?.progressTime ?? ""
        view.levelID = (levelData?.data[0].levelID)!
       // self.navigationController?.pushViewController(view, animated: true)
        self.present(view, animated: true, completion: nil)
    }
    @objc func editLevel(){
        let view = self.storyboard?.instantiateViewController(withIdentifier: "addInteriorDesignVC") as! addInteriorDesignVC
        view.id = id
        view.projectId = projectId
        self.navigationController?.pushViewController(view, animated: true)
    }
    @objc func chatLevel (){
       let view = self.storyboard?.instantiateViewController(withIdentifier: "chatRoomViewController") as! chatRoomViewController
        view.levelId = (levelData?.data[0].levelID)!
        view.projectname = self.projectName
        view.projectLevel = self.levelName
        view.empType = (levelData?.data[0].type)!
        view.projectId = (levelData?.data[0].projectID)!
       self.navigationController?.pushViewController(view, animated: true)
    }
    @objc func assignLevel (){
        let view = self.storyboard?.instantiateViewController(withIdentifier: "assignEmployeVC") as! assignEmployeVC
        view.LevelId = levelData?.data[0].levelID ?? ""
        view.projectId = projectId
        view.projectStatus = projectStatus
        view.projectLevel = self.levelName
        self.navigationController?.pushViewController(view, animated: true)
    }
    @IBAction func completedAction(_ sender: UIButton) {
        completedLevel()
    }
    
}
extension InteriorDesignVC: ProjectTimeDelegate{
func reload() {
    self.get_level_details()
    print("ayaaaaaaa????")
}
}
extension InteriorDesignVC : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if levelData?.data.count == 0 {
            return 1
        }else{
        return levelData?.data.count ?? 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as interiorCell
            cell.nameTF.text = levelData?.data[indexPath.row].title
            cell.dateTF.text = levelData?.data[indexPath.row].date
       
        if levelData?.data[indexPath.row].state == "0"{
            cell.achievementButton.setImage(#imageLiteral(resourceName: "wrong"), for: .normal)
        }else if levelData?.data[indexPath.row].state == "1"{
            cell.achievementButton.setImage(#imageLiteral(resourceName: "right"), for: .normal)
        }
        if levelData?.data[indexPath.row].isPDF == "1" || levelData?.data[indexPath.row].pdf?.count != 0 {
            cell.attachmentButton.setImage(#imageLiteral(resourceName: "clip"), for: .normal)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let view = self.storyboard?.instantiateViewController(withIdentifier: "projectDetailsVC") as! projectDetailsVC
        view.date = result
        view.projectId = (levelData?.data[0].projectID)!
        view.id = (levelData?.data[indexPath.row].id)!
        view.levelid = (levelData?.data[0].levelID)!
        view.levelName = (levelData?.data[0].title)!
        view.percentage = (levelData?.data[0].percent)!
        self.navigationController?.pushViewController(view, animated: true)
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 50.0
//    }
}
extension InteriorDesignVC {
    @objc func get_level_details(){
       
        startAllAnimationBtn()
        let userId = UserDefaults.standard.value(forKey: "userId") as? String
        if Reachability.connectedToNetwork() {
            NetworkClient.performRequest(LevelDetailsModel.self, router: .get_level_details(levelId: id, empId: userId!), success: { [weak self] (models) in
                print("models\( models)")
                self?.levelData = models
                if(models.status == 1){
                    self?.hideAllViews()
                    self?.tableView.reloadData()
                    if models.chatIsRead == "0"{
                        self?.chatNotification.isHidden = false
                    }else{
                        self?.chatNotification.isHidden = true
                    }
                    print("wwwwwwwwwww")
                }
                else if (models.status == 2 ){
                    self?.chatView.isUserInteractionEnabled = false
                    self?.assignView.isUserInteractionEnabled = false
                    self?.progressTimeView.isUserInteractionEnabled = false
//                    JSSAlertView().danger(self!, title: "عذرا", text: models.arMsg, buttonText: "موافق")

                   self?.hideAllViews()
                   self?.noDataView.isHidden = false
                   self?.refresDatahBtn.addTarget(self, action: #selector(self?.get_level_details), for: UIControl.Event.touchUpInside)
                }

            }){ [weak self] (error) in
                self?.hideAllViews()
                self?.errorView.isHidden = false
                self?.refreshErrorBtn.addTarget(self, action: #selector(self?.get_level_details), for: UIControl.Event.touchUpInside)
            }
            }else{
                hideAllViews()
                noInterNetView.isHidden = false
                self.refreshInterNetBtn.addTarget(self, action: #selector(self.get_level_details), for: UIControl.Event.touchUpInside)
            }
    }
    func completedLevel(){
        NetworkClient.performRequest(DeleteChatMessegeModel.self, router: .autoCompleteLevel(id: id), success: { [weak self] (models) in
                if(models.status == 1){
                   print(models.arMsg)
                    JSSAlertView().success(self!,title: "حسنا",text: models.arMsg)
                }
                else if (models.status == 0 ){
                    JSSAlertView().danger(self!, title: "عذرا", text: models.arMsg, buttonText: "موافق")
                    print(models.arMsg)
                }
           }){ [weak self] (error) in
            }
    }
}
//MARK: - Loader
extension InteriorDesignVC{

    func addAllViews(){
        self.errorView(mainNoDataView : &self.errorView, refreshBtn : &self.refreshErrorBtn)
        self.noInterNetView(mainNoDataView : &self.noInterNetView, refreshBtn :  &self.refreshInterNetBtn)
        self.noDataView(mainNoDataView: &self.noDataView, labelData: "لا يوجد بيانات بالمرحله حاليا", refreshBtn: &self.refresDatahBtn, addStatus : 0, addFBtn : &addFBtn)
        self.showLoader(mainView: &loaderView)
       // startAllAnimationBtn()
    }
    func hideAllViews(){
        self.hideLoader(mainView: &self.loaderView)
        self.hideNoDataView( mainNoDataView : &self.noDataView)
        self.hideNoInterNetView( mainNoInterNetView : &self.noInterNetView)
        self.hideErrorView( mainNoInterNetView : &self.errorView)
        stopAllAnimationBtn()
    }
    func stopAllAnimationBtn(){
        self.refresDatahBtn.stopAnimation(animationStyle: .shake, revertAfterDelay: 2, completion:nil)
        self.refreshErrorBtn.stopAnimation(animationStyle: .shake, revertAfterDelay: 2, completion:nil)
        self.refreshInterNetBtn.stopAnimation(animationStyle: .shake, revertAfterDelay: 2, completion:nil)
    }
    func startAllAnimationBtn(){
        refreshInterNetBtn.startAnimation()
        refresDatahBtn.startAnimation()
        refreshErrorBtn.startAnimation()
    }
}
