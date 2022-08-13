//
//  ProjectAttachmentsVC.swift
//  AL-HHALIL
//
//  Created by apple on 7/15/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import JSSAlertView
import TransitionButton

class ProjectAttachmentsVC: BaseVC {
    var projectAtt = [ProjectAttachment]()
    var levelData : LevelDetailsModel?
    var addData : MoreLevelDetailsModel?
    @IBOutlet weak var progressTimeView: UIView!
    @IBOutlet weak var addAttachmentView: UIView!
    @IBOutlet weak var chatView: UIView!
    @IBOutlet weak var assignView: UIView!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var attachTF: UITextField!
    @IBOutlet weak var titlleName: UILabel!
    @IBOutlet weak var chatNotification: UIImageView!
    @IBOutlet weak var completeButton: UIButton!
    
     var result = ""
     var jobType = ""
    var projectName = ""
    var levelName = ""
    var projectId = ""
    var header = ["الموظف","مرفق","الانجاز","اسم المرفق","م" ]
    var id = ""
    var projectStatus = ""
    var autoComplete = ""
    //status views
    var loaderView = UIView()
    var noDataView = UIView()
    var refresDatahBtn = TransitionButton()
    var refreshInterNetBtn = TransitionButton()
    var noInterNetView = UIView()
    var errorView = UIView()
    var refreshErrorBtn = TransitionButton()
    var addFBtn = TransitionButton()
    

    override func viewDidLoad() {
        super.viewDidLoad()
         get_level_details()
    }
    override func viewWillAppear(_ animated: Bool) {
        config()
        getTokenReq()
    }
    func config(){
        addAllViews()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        if UserDefaults.standard.value(forKey: "jopType") as? String == "1"{
            completeButton.isHidden = true
        }else{
            completeButton.isHidden = false
        }
        titlleName.text = levelName
        tableView.registerHeaderNib(cellClass: projectAttachmentTitleCell.self)
        get_level_details()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(editLevel))
        editView.addGestureRecognizer(tap)
        let tap2: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chatLevel))
            chatView.addGestureRecognizer(tap2)
        let tap3: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(assignLevel))
        assignView.addGestureRecognizer(tap3)
        let tap4: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NotificationReviewViewHide))
        addAttachmentView.addGestureRecognizer(tap4)
        if jobType == "1"{
            editView.isHidden = true
        }else{
            editView.isHidden = false
        }
        addFBtn.addTarget(self, action: #selector(editLevel), for: UIControl.Event.touchUpInside)
        
        let tap٥: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(progress))
        progressTimeView.addGestureRecognizer(tap٥)
        if autoComplete == "1"{
            completeButton.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            completeButton.setTitle("مرحلة مكتملة", for: .normal)
        }else{
            completeButton.backgroundColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
            completeButton.setTitle("غير مكتملة", for: .normal)
        }
    }
    @objc func progress (){
        let view = self.storyboard?.instantiateViewController(withIdentifier: "ProgressTimeVC") as! ProgressTimeVC
        view.delegate = self
        view.ProgressTime = levelData?.progressTime ?? ""
        view.levelID = (levelData?.data[0].levelID)!
       // self.navigationController?.pushViewController(view, animated: true)
        self.present(view, animated: true, completion: nil)
    }
    @objc func editLevel (){
        addAttachmentView.isHidden = false
  //      addAttachmentView.resignFirstResponder()
        hideAllViews()
    }
    @objc func chatLevel (){
        let view = self.storyboard?.instantiateViewController(withIdentifier: "chatRoomViewController") as! chatRoomViewController
        view.levelId = (levelData?.data[0].levelID)!
        view.projectname = self.projectName
        view.projectLevel = self.levelName
        view.projectId = (levelData?.data[0].projectID)!
        view.empType = (levelData?.data[0].type)!
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
    @objc func  NotificationReviewViewHide (){
         addAttachmentView.isHidden = true
         //textView.text = "كتابه نص ٫٫٫"
        // textView.textColor = UIColor.lightGray
     }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        addAttachmentView.isHidden = true
    }
    @IBAction func sendNewButton(_ sender: UIButton) {
        add_detail()
    }
    @IBAction func completedAction(_ sender: UIButton) {
        completedLevel()
    }
    
}
extension ProjectAttachmentsVC: ProjectTimeDelegate{
func reload() {
    self.get_level_details()
    print("ayaaaaaaa????")
}
}
extension ProjectAttachmentsVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "projectAttachmentTitleCell") as! projectAttachmentTitleCell
            return headerCell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
      return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return levelData?.data.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "projectAttachmentCell", for: indexPath) as! projectAttachmentCell
        cell.attachmentNumber.text = "\(indexPath.row + 1)"
        cell.attachmentName.text = levelData?.data[indexPath.row].title
        cell.attachmentEmployeeName.text = levelData?.data[indexPath.row].date

        if levelData?.data[indexPath.row].state == "0"{
            cell.attachmentDone.setImage(#imageLiteral(resourceName: "wrong"), for: .normal)
        }else if levelData?.data[indexPath.row].state == "1"{
            cell.attachmentDone.setImage(#imageLiteral(resourceName: "right"), for: .normal)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let view = self.storyboard?.instantiateViewController(withIdentifier: "projectDetailsVC") as! projectDetailsVC
        view.date = result
        view.id = (levelData?.data[indexPath.row].id)!
        view.projectId = (levelData?.data[indexPath.row].projectID)!
        view.levelid = (levelData?.data[indexPath.row].levelID)!
        view.levelName = (levelData?.data[indexPath.row].title)!
        view.percentage = (levelData?.data[indexPath.row].percent)!
     
        self.navigationController?.pushViewController(view, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
}
extension ProjectAttachmentsVC {
    @objc func get_level_details(){
        startAllAnimationBtn()
        if Reachability.connectedToNetwork() {
            let userId = UserDefaults.standard.value(forKey: "userId") as? String
            NetworkClient.performRequest(LevelDetailsModel.self, router: .get_level_details(levelId: id, empId: userId!), success: { [weak self] (models) in
                self?.levelData = models
                print("models\( models)")
                if(models.status == 1){
                    self?.tableView.reloadData()
                    self?.hideAllViews()
                    if models.chatIsRead == "0"{
                        self?.chatNotification.isHidden = false
                    }else{
                        self?.chatNotification.isHidden = true
                    }
                }
                else if (models.status == 2 ){
                   self?.chatView.isUserInteractionEnabled = false
                   self?.assignView.isUserInteractionEnabled = false
                   self?.progressTimeView.isUserInteractionEnabled = false
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

    func add_detail(){
        let userId = UserDefaults.standard.value(forKey: "userId") as? String
        NetworkClient.performRequest(MoreLevelDetailsModel.self, router: .add_detail(title: attachTF.text ?? "", level_id: id , percent: "", is_pdf: "", type: "", values: [""], question_type: "", project_id: projectId ?? "", emp_id: userId!), success: { [weak self] (models) in
            print("models\( models)")
            self?.addData = models
            if(models.status == 1){
                JSSAlertView().success(self!,title: "حسنا",text: models.arMsg, buttonText: "موافق")
                self?.addAttachmentView.isHidden = true
                self?.get_level_details()
               // self?.tableView.reloadData()
            }
            else if (models.status == 0 ){
                JSSAlertView().danger(self!, title: "عذرا", text: models.arMsg, buttonText: "موافق")
            }
        }){ [weak self] (error) in
        }
    }
}
//MARK: - Loader
extension ProjectAttachmentsVC{
    func addAllViews(){
        self.errorView(mainNoDataView : &self.errorView, refreshBtn : &self.refreshErrorBtn)
        self.noInterNetView(mainNoDataView : &self.noInterNetView, refreshBtn :  &self.refreshInterNetBtn)
        self.noDataView(mainNoDataView: &self.noDataView, labelData: "لا يوجد بيانات بالمرحله حاليا", refreshBtn: &self.refresDatahBtn, addStatus : 0, addFBtn : &addFBtn)
        self.showLoader(mainView: &loaderView)
        startAllAnimationBtn()
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
