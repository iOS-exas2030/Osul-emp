//
//  MeetUpVC.swift
//  AL-HHALIL
//
//  Created by apple on 7/16/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import JSSAlertView
import TransitionButton
import LabelSwitch
import BSImagePicker
import Photos
import Alamofire
import Kingfisher
import MobileCoreServices

class MeetUpVC: BaseVC , UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var chatView: UIView!
    @IBOutlet weak var assignView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var progressTimeView: UIView!
    @IBOutlet weak var titleName: UILabel!
    
    @IBOutlet weak var chatNotification: UIImageView!
    @IBOutlet weak var saveBtn: TransitionButton!
    
    @IBOutlet weak var completeButton: UIButton!
    
    var textAnswer = ""
    var array = [AnyObject]()
    var ids = [String]()
    var answerModel = [String : Any]()
    var answers = [AnswerDamn]()
    var levelData : LevelDetailsModel?
    var autoComplete = ""
    var id = ""
    var projectId : String!
    var projectName = ""
    var levelName = ""
    var meetUpFirstQID = ""
    var projectStatus = ""
     var pdf = ""
    var otherAnswer = ""
    
    
    var fullAnswerArray = [String]()
    var fullAnswer = [String]()
    var check: [String] = []
    var dataAnswers = [""]
    var QuestionModel :Ques2Model?
    var allAnswers  = [[String]]()
    var pic : [String] = []
    var val = ""
  //  var cells = [meetUpFirstCell]()
    
    let imagePicker = ImagePickerController()
    var selectedImage = [PHAsset]()
    var photosSelected = [UIImage]()
  //  var imagePickedBlock: ((URL) -> Void)?
    
    //status views
    var loaderView = UIView()
    var noDataView = UIView()
    var refresDatahBtn = TransitionButton()
    var refreshInterNetBtn = TransitionButton()
    var noInterNetView = UIView()
    var errorView = UIView()
    var refreshErrorBtn = TransitionButton()
    var addFBtn = TransitionButton()
  //  let imagePicker = UIImagePickerController()
    var docData : Data?
    
    //
    var image = UIImagePickerController()
    lazy var imgData = Data()
    var selectedImageNew = UIImageView()
    var qID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        let tap4: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(progress))
        progressTimeView.addGestureRecognizer(tap4)
        get_level_details()
    }

    @objc func progress (){
        let view = self.storyboard?.instantiateViewController(withIdentifier: "ProgressTimeVC") as! ProgressTimeVC
        view.delegate = self
        view.ProgressTime = levelData?.progressTime ?? ""
        view.levelID = (levelData?.data[0].levelID)!
       // self.navigationController?.pushViewController(view, animated: true)
        self.present(view, animated: true, completion: nil)
    }
    @objc func dismissKeyboard() {
             view.endEditing(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        config()
        getTokenReq()
    }
    func config(){
        addAllViews()
        tableView.delegate = self
        tableView.dataSource = self
        get_level_details()
       if UserDefaults.standard.value(forKey: "jopType") as? String == "1"{
           completeButton.isHidden = true
       }else{
           completeButton.isHidden = false
       }
        titleName.text = levelName
        let tap2: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chatLevel))
        chatView.addGestureRecognizer(tap2)
        let tap3: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(assignLevel))
        assignView.addGestureRecognizer(tap3)
        if autoComplete == "1"{
            completeButton.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            completeButton.setTitle("مرحلة مكتملة", for: .normal)
        }else{
            completeButton.backgroundColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
            completeButton.setTitle("غير مكتملة", for: .normal)
        }
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
          self.navigationController?.pushViewController(view, animated: true)
    }
    
    @IBAction func completedAction(_ sender: UIButton) {
        completedLevel()
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        saveBtn.startAnimation()
        for (index, _) in (levelData?.data.enumerated())!{
            for i in 0...allAnswers.count-1 {
                let singleAnswer = ["answer" : allAnswers[i] , "question_id" : ids[i] , "otherAnswer": otherAnswer]as [String : Any]
                array.append(singleAnswer as AnyObject)
                print("eh ya 205ra \(otherAnswer)")
            }
        }
        for (index, _) in (levelData?.data.enumerated())!{
            if levelData?.data[index].questionType == "1" {
                let singleAnswer = ["answer" : [levelData?.data[index].answer] , "question_id" : levelData?.data[index].id, "otherAnswer": ""] as [String : Any]
                  array.append(singleAnswer as AnyObject)
            }
       }
        answerQues()
    }
}
extension MeetUpVC: ProjectTimeDelegate{
    func reload() {
        self.get_level_details()
    }
}
extension MeetUpVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return levelData?.data.count ?? 0
    }
    func textViewDidChange(_ textView: UITextView) {
        for (index, element) in (levelData?.data.enumerated())!{
            if levelData?.data[index].questionType == "1" {
                if("\(textView.tag)" == levelData?.data[index].id){
                    levelData?.data[index].answer = textView.text
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if levelData?.data[indexPath.row].questionType == "1" {
           let cell = tableView.dequeue() as meetUpFirstCell
            cell.answerTF.delegate = self
            cell.answerTF.tag = Int((levelData?.data[indexPath.row].id)!)!
            cell.questionLabel.text = levelData?.data[indexPath.row].title
            cell.answerTF.text = levelData?.data[indexPath.row].answer
             return cell
        }else if levelData?.data[indexPath.row].questionType == "2"{
            let cell = tableView.dequeue() as meetUpSecondCell
            cell.questionLabel.text = levelData?.data[indexPath.row].title
            cell.values = (levelData?.data[indexPath.row].values)!
            let fullAnswer = self.levelData?.data[indexPath.row].answer ?? ""
            cell.myanswers = fullAnswer
            cell.qId = levelData?.data[indexPath.row].id ?? ""
            cell.answerDelegate = self
            cell.yourAnswerTF.isHidden = true
            cell.otherAnswerView.isHidden = true
            cell.cellTableView.reloadData()
            return cell
        }else if levelData?.data[indexPath.row].questionType == "3"{
            let cell = tableView.dequeue() as meetUpSecondCell
            cell.questionLabel.text = levelData?.data[indexPath.row].title
            cell.values = (levelData?.data[indexPath.row].values)!
            let fullAnswer = self.levelData?.data[indexPath.row].answer ?? ""
            cell.myanswers = fullAnswer
            cell.qId = levelData?.data[indexPath.row].id ?? ""
            cell.answerDelegate = self
            cell.yourAnswerTF.isHidden = true
            cell.otherAnswerView.isHidden = true
            cell.cellTableView.reloadData()
            return cell
        }else if levelData?.data[indexPath.row].questionType == "5"{
            let cell = tableView.dequeue() as meetUpSecondCell
            cell.questionLabel.text = levelData?.data[indexPath.row].title
            cell.values = (levelData?.data[indexPath.row].values)!
            let fullAnswer = self.levelData?.data[indexPath.row].answer ?? ""
            cell.myanswers = fullAnswer
            cell.qId = levelData?.data[indexPath.row].id ?? ""
            cell.answerDelegate = self
            cell.yourAnswerTF.delegate = self
             cell.yourAnswerTF.text = self.levelData?.data[indexPath.row].otherAnswer
             cell.otherAnswerView.isHidden = false
           // self.otherAnswer.append(cell.yourAnswerTF.text ?? "")
            if self.levelData?.data[indexPath.row].otherAnswer == "" || self.levelData?.data[indexPath.row].otherAnswer == nil {
                cell.yourAnswerTF.isHidden = true
                cell.checkButton.isHidden = true
                cell.yourAnswerTF.text = self.levelData?.data[indexPath.row].otherAnswer
            }else{
                cell.yourAnswerTF.isHidden = false
                cell.otherAnswerView.isHidden = false
                cell.checkButton.isHidden = false
            }
            return cell
        }else{
            let cell = tableView.dequeue() as meetUpThirdCell
            cell.questionLabel.text = levelData?.data[indexPath.row].title
            val = levelData?.data[indexPath.row].img ?? ""
            //cell.values = [val]
            let url = URL(string: Constants.baseURL2 + "images/\(levelData?.data[indexPath.row].img ?? "")" )
            cell.imageQues.kf.indicatorType = .activity
            cell.imageQues.kf.setImage(with: url)
            cell.imageQues.tag = indexPath.row
            let tapImage: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            cell.imageQues.addGestureRecognizer(tapImage)
            
            cell.selectAction = { sender in
//                AttachmentHandler.shared.showAttachmentActionSheet2(vc: self, sender: sender)
//                AttachmentHandler.shared.imagePickedBlock = { (image) in
//                /* get your image here */
//                    print("select \(image.lastPathComponent)")
//                    do{
//                        self.docData =  try Data(contentsOf: image)
//                       // self.pdf = image.lastPathComponent
//                        self.postData(image: self.docData, quesID: (self.levelData?.data[indexPath.row].id)! )
//
//                    }catch{
//                            print(error)
//                    }
//                }
                
                let image = UIImagePickerController()
                image.delegate = self
                image.sourceType = .photoLibrary
                image.allowsEditing = false
                self.present(image, animated: true){
                }
                self.qID = (self.levelData?.data[indexPath.row].id)!
              //  self.postData(image: self.imgData, quesID: (self.levelData?.data[indexPath.row].id)! )
            }
            return cell
        }
    }

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let imgView = tapGestureRecognizer.view as! UIImageView
        let view = self.storyboard?.instantiateViewController(withIdentifier: "ImageDisplayVC") as! ImageDisplayVC
        view.image =  Constants.baseURL2 + "images/\(levelData?.data[imgView.tag].img ?? "")"
        self.navigationController?.pushViewController(view, animated: true)
    }
    func convertAssetToImages(id :String) -> Void {
        if selectedImage.count != 0{
             for i in 0..<selectedImage.count{
                let manager = PHImageManager.default()
                let option = PHImageRequestOptions()
                var thumbnail = UIImage()
                option.isSynchronous = true
                manager.requestImage(for: selectedImage[i], targetSize: CGSize(width: 600, height: 600), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
                           thumbnail = result!
                })
                docData = thumbnail.jpegData(compressionQuality: 0.2)! as Data
               let newImage = UIImage(data: docData!)
               self.photosSelected.append(newImage! as UIImage)
               }
             postData(image: docData, quesID: id )
        }
        print("complete photo array \(self.photosSelected)")
    }
    @objc func viewImage(sender:UITapGestureRecognizer){
        let view = self.storyboard?.instantiateViewController(withIdentifier: "ImageDisplayVC") as! ImageDisplayVC
        let fileName = val
        view.image =  Constants.baseURL2 + "images/\(fileName)"
        self.navigationController?.pushViewController(view, animated: true)
    }
}


extension MeetUpVC :answerDel{
    func yourtext(tf: String) {
        self.otherAnswer = tf
    }

    func add(sender: LabelSwitch, tag: Int, id:String, answerTF: UITextField) {
           var each = [String]()
           for (index, element) in (levelData?.data.enumerated())!{
              if levelData?.data[index].questionType == "2" || levelData?.data[index].questionType == "5" {
                for (counter, i) in allAnswers.enumerated(){
                    each = i
                    if ids[counter] == id{
                        print("qqqq : \(id)")
                     if self.check.count != (self.levelData?.data[index].values?.count ?? 0) && i.isEmpty == true{
                            if sender.curState == .R {
                                print("yes")
                                print(tag)
                               each.insert("yes", at: tag)
                            }else if sender.curState == .L {
                                print("No")
                                print(tag)
                                each.insert("no", at: tag)
                            }
                     }else{
                        if sender.curState == .R {
                            print("yes")
                            print(tag)
                            each.remove(at: tag)
                            each.insert("yes", at:tag)
                        }else if sender.curState == .L {
                            print("No")
                            print(tag)
                            each.remove(at: tag)
                            each.insert("no", at: tag)
                        }
//                        if sender.curState == .R {
//                            print("yes")
//                            print(tag)
//                            //sender.curState = .R
//                           // each.remove(at: tag)
//                           // each.insert("yes", at:tag)
//                            each.removeAll()
//                            for (Rcounter, element) in i.enumerated() {
//                                if(Rcounter == Int(tag)){
//                                    each.insert("yes", at:Rcounter)
//
//                                }else{
//                                    each.insert("no", at: Rcounter)
//
//                                }
//                            }
//                        }else if sender.curState == .L {
//                            print("No")
//                            //sender.curState = .R
//                            print(tag)
//                            each.remove(at: tag)
//                            each.insert("no", at: tag)
//                        }
//                        if sender.curState == .R {
//                            print("yes")
//                            print(tag)
//                            each.remove(at: tag)
//                            each.insert("yes", at:tag)
//                        }else if sender.curState == .L {
//                            print("No")
//                            print(tag)
//                            each.remove(at: tag)
//                            each.insert("no", at: tag)
//                        }
                    }
                    print("aya\(each)")
                    print("aya 2 \(each.last)")
//                        let indexPath = IndexPath(item: index, section: 0)
//                        tableView.beginUpdates()
//                        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
//                        tableView.endUpdates()
                    allAnswers[counter] = each
                }
            }
          }
            ///
         else if levelData?.data[index].questionType == "3"{
                for (counter, i) in allAnswers.enumerated(){
                        each = i
                        if ids[counter] == id{
                            print("qqqq : \(id)")
                         if self.check.count != (self.levelData?.data[index].values?.count ?? 0) && i.isEmpty == true{
                                if sender.curState == .R {
                                    print("yes")
                                    print(tag)
                                   each.insert("yes", at: tag)
                                }else if sender.curState == .L {
                                    print("No")
                                    print(tag)
                                    each.insert("no", at: tag)
                                }
                         }else{
                            if sender.curState == .R {
                                print("yes")
                                print(tag)
                                each.remove(at: tag)
                                each.insert("yes", at:tag)
                            }else if sender.curState == .L {
                                print("No")
                                print(tag)
                                each.remove(at: tag)
                                each.insert("no", at: tag)
                            }
                        }
                        print("aya\(each)")
                        print("aya 3 \(each.last)")

                        allAnswers[counter] = each
                    }
                }
          }
        }
         print("answers eh \(allAnswers)")
    }
}

extension MeetUpVC: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {        
        //textAnswer = textField.text ?? ""
        for (index, element) in (levelData?.data.enumerated())!{
          if levelData?.data[index].questionType == "1" {
            textAnswer = textField.text ?? ""
            return true
          }else if levelData?.data[index].questionType == "5"{
            otherAnswer = textField.text ?? ""
            return true
          }
            
        }
        return true
    }

}
extension MeetUpVC : textFieldDelegete{
    func delegate(TF: String) {
        self.textAnswer = TF
    }
}
extension MeetUpVC {
        @objc func get_level_details(){
            self.fullAnswerArray.removeAll()
            startAllAnimationBtn()
            if Reachability.connectedToNetwork() {
                let userId = UserDefaults.standard.value(forKey: "userId") as? String
                NetworkClient.performRequest(LevelDetailsModel.self, router: .get_level_details(levelId: id, empId: userId!), success: { [weak self] (models) in
                    print("models\( models)")
                    self?.levelData = models
                    if(models.status == 1){
                        if models.chatIsRead == "0" {
                            self?.chatNotification.isHidden = false
                        }else if models.chatIsRead == "1" {
                            self?.chatNotification.isHidden = true
                        }
                        for (index, _) in (self?.levelData?.data.enumerated())!{
                            if self?.levelData?.data[index].questionType == "2" || self?.levelData?.data[index].questionType == "3" || self?.levelData?.data[index].questionType == "5"{
                                self?.ids.append(self?.levelData?.data[index].id ?? "")
                                let fullAnswer = self?.levelData?.data[index].answer ?? ""
                                if fullAnswer == "" {
                                    for(i, _) in (models.data[index].values?.enumerated())!{
                                         if self?.fullAnswerArray.count != i + 1{
                                             self?.fullAnswerArray.append("no")
                                         }else{
                                            print("equal")
                                        }
                                        print("full1\(self?.fullAnswerArray ?? [""])")
                                    }
                                    print("full\(self?.fullAnswerArray ?? [""])")
                                    self?.allAnswers.append(self?.fullAnswerArray ?? [""])
                                    self?.fullAnswerArray.removeAll()
                                }else{
                                   self?.fullAnswerArray = fullAnswer.split(separator: "|").map(String.init)
                                   print("full\(self?.fullAnswerArray ?? [""])")
                                   self?.allAnswers.append(self?.fullAnswerArray ?? [""])
                                }
                                 self?.fullAnswerArray.removeAll()
                            }
                        }
                        self?.tableView.reloadData()
                        self?.hideAllViews()
                        print("wwwww : \(self?.allAnswers)")
                    }
                    else if (models.status == 2 ){
                       self?.hideAllViews()
                        self?.chatView.isUserInteractionEnabled = false
                        self?.assignView.isUserInteractionEnabled = false
                        self?.progressTimeView.isUserInteractionEnabled = false
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
        func postData(image: Data? , quesID : String){

            let fullUrl :String = Constants.baseURL+"project/Add_Image_Details"
            let params = ["detail_id": quesID] as [String : Any]
           AF.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in params {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
               multipartFormData.append(image!, withName: "file" , fileName: "fileName.jpg", mimeType: "image/jpg")
           }, to: fullUrl, usingThreshold: UInt64.init(), method: .post, headers: nil) .responseJSON { response in
            switch response.result{
                case .success(let upload):
                    
//                    upload.uploadProgress(closure: { (Progress) in
//                      // self.progressView.progress = Float(Progress.fractionCompleted)
//                   print("Upload Progress: \(Progress.fractionCompleted)")
//                   })
                        print("Succesfully uploaded")
                        print(response.result)
                        self.get_level_details()
                        //JSSAlertView().success(self,title: "حسنا",text: "تم الحفظ بنجاح")
                        //   self.navigationController?.popViewController(animated: true)
                        if let err = response.error{
                           print(err)
                           JSSAlertView().danger(self, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
                            return
                        }
                
                case .failure(let error):
                    print("Error in upload: \(error.localizedDescription)")
                   // onError?(error)
                }
            }
        }
    
    func answerQues() {
        print(array)
        let userId = UserDefaults.standard.value(forKey: "userId") as? String
        NetworkClient.performRequest(Ques2Model.self, router: .AnswerQue(emp_id: userId!, project_id: projectId, answer: array), success: { [weak self] (models) in
            print("models\( models.data)")
            self?.QuestionModel = models
            if(models.status == 1){
                JSSAlertView().success(self!,title: "حسنا",text: models.arMsg, buttonText: "موافق")
                self?.navigationController?.popViewController(animated: true)
                self?.saveBtn.stopAnimation()
                self?.get_level_details()
            }
            else if (models.status == 0 ){
                JSSAlertView().danger(self!, title: "عذرا", text: models.arMsg, buttonText: "موافق")
                self?.saveBtn.stopAnimation()
            }
        }){ [weak self] (error) in
            self?.saveBtn.stopAnimation()
        }
    }
}
//MARK: - Loader
extension MeetUpVC{
    func addAllViews(){
        self.errorView(mainNoDataView : &self.errorView, refreshBtn : &self.refreshErrorBtn)
        self.noInterNetView(mainNoDataView : &self.noInterNetView, refreshBtn :  &self.refreshInterNetBtn)
        self.noDataView(mainNoDataView: &self.noDataView, labelData: "لا يوجد بيانات بالمرحله حاليا", refreshBtn: &self.refresDatahBtn, addStatus : 1, addFBtn : &addFBtn)
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
extension MeetUpVC{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           if let image2 = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
              // logo.image = image2
               selectedImageNew.image = image2
               imgData = image2.jpegData(compressionQuality: 0.2)!
            self.postData(image: self.imgData, quesID: qID )
           dismiss(animated: true, completion: nil)
        }
    }
}
