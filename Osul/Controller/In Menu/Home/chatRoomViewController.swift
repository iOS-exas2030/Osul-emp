//
//  chatRoomViewController.swift


import UIKit
import Firebase
import FirebaseAuth
import Alamofire
import Kingfisher
import TransitionButton
import JSSAlertView

class chatRoomViewController: BaseVC, UITextFieldDelegate ,  UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    //MARK: - IBOutlets
    @IBOutlet weak var tableViewConst: NSLayoutConstraint!

    @IBOutlet weak var imgSelected: UIImageView!
    @IBOutlet weak var imgAlertView: UIView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var addButton: TransitionButton!
    @IBOutlet weak var messageTextView: UIView!
    @IBOutlet weak var bottomConst: NSLayoutConstraint!
    @IBOutlet weak var projectName: UILabel!
    @IBOutlet weak var levelName: UILabel!
    @IBOutlet weak var chatTextF: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    var projectname = ""
    var projectLevel = ""
    var docData : Data?
    var selectedImage = UIImageView()
    var imgURL : NSURL?
    var projectId = ""
    var levelId = ""
    lazy var imgData = Data()
    var timestamp : TimeInterval = 0.0
    var chatMessges = [messages]()
    var chatMessages2 = [ChatModelDatum]()
    var oneChatMessages : ChatModel?
    let formatter = DateFormatter()
    let date = Date()
    var Cons :Constants?
    var currentPage = 0
    var localFile : NSURL?
    //MARK: -status views
    var loaderView = UIView()
    var noDataView = UIView()
    var refresDatahBtn = TransitionButton()
    var refreshInterNetBtn = TransitionButton()
    var noInterNetView = UIView()
    var errorView = UIView()
    var refreshErrorBtn = TransitionButton()
    var addFBtn = TransitionButton()
    var empType = ""
   
    
    //MARK: - View Controller Builder
    override func viewDidLoad() {
        super.viewDidLoad()
        addAllViews()
        get_Messeges()
        print("job Type \( UserDefaults.standard.value(forKey: "jopType") as? String)")
        if UserDefaults.standard.value(forKey: "jopType") as? String == "3"{
            messageTextView.isHidden = false
        }else{
       messageTextView.isHidden = false
        }
        //getMessages()
        tableView.delegate = self
        tableView.dataSource = self
        chatTextF.delegate = self
        tableView.registerCellNib(cellClass: roomChatTableViewCell.self)
     //   setLongPress()
        projectName.text = projectname
        levelName.text = projectLevel
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHandler), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHandler), name: UIResponder.keyboardWillHideNotification, object: nil)
        tableView.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi));
    
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleMyNotification(_:)), name: NSNotification.Name(rawValue: "notificationName"), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getTokenReq()
    }
    @objc func handleMyNotification(_ sender: Notification) {
        print("ayaaa ios \(sender.userInfo)")
//        if let dict = sender.userInfo as NSDictionary? {
//            if let id = dict["messege"] as? String{
//                // do something with your image
//            }
//        }
        if AppDelegate.chatAppdelegate?.levelID == chatMessages2[0].levelID {
        self.chatMessages2.insert(AppDelegate.chatAppdelegate! , at: 0)
        self.tableView.insertRows(at: [IndexPath(row: 0 , section: 0)], with: .top)
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @IBAction func attatchmentButton(_ sender: UIButton) {
        AttachmentHandler.shared.showAttachmentActionSheet(vc: self, sender: sender)
        AttachmentHandler.shared.imagePickedBlock = { (data , picData ,img ) in
        /* get your image here */
            print("select \(data.lastPathComponent)")
           self.imgAlertView.isHidden = false
           self.imgSelected.image = img
           self.imgURL = data
           self.docData = picData
        }
        AttachmentHandler.shared.filePickedBlock = {(filePath) in
        /* get your file path url here */
            print("selectFile \(filePath)")
            do{
                self.postData(image:  try Data(contentsOf: filePath), fileName: filePath.lastPathComponent ?? "")
            }catch{
                print(error)
            }
        }
//        let image = UIImagePickerController()
//        image.delegate = self
//        image.sourceType = .photoLibrary
//        image.allowsEditing = false
//        self.present(image, animated: true){
//        }
    }
    func setLongPress(){
         let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
         lpgr.minimumPressDuration = 0.5
         lpgr.delaysTouchesBegan = true
         lpgr.delegate = self
        self.tableView.addGestureRecognizer(lpgr)
       }
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer?) {
        if gestureRecognizer?.state != .ended {
            return
        }
        let p = gestureRecognizer?.location(in: tableView)

        let indexPath = tableView.indexPathForRow(at: p ?? CGPoint.zero)
        if indexPath == nil {
            print("couldn't find index path")
        } else {
            // get the cell at indexPath (the one you long pressed)
            var cell: UITableViewCell? = nil
            if let indexPath = indexPath {
                cell = tableView.cellForRow(at: indexPath)
                print(indexPath.row)
                if self.chatMessages2[indexPath.row].senderID == UserDefaults.standard.value(forKey: "userId") as? String{
                    let alertview = JSSAlertView().warning(self,title: "تنبيه !",text: "هل تريد مسح الرسالة ؟",buttonText: "موافق",cancelButtonText: "إلغاء" )
                    alertview.addAction {
                       print("done")
                        self.delete_Messeges(id: self.chatMessages2[indexPath.row].id ?? "", messegeIndex: indexPath.row)
                    }
                    alertview.addCancelAction {
                        print("cancel")
                }
              }
            }
            // do stuff with the cell
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           
           if let image2 = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
             //  logo.image = image2
               imgData = image2.jpegData(compressionQuality: 0.2)!
               } else {
               }
//           let str = String(decoding: imgData, as: UTF8.self)
//           guard let url:URL = URL(string: str) else {return}
//           print("5lsna\(url)")
           if let imgUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL{
               let imgName = imgUrl.lastPathComponent
               let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
               let localPath = documentDirectory?.appending(imgName) ?? ""
                localFile = NSURL(fileURLWithPath: localPath)
             print("5lsna\(localFile)")
        }
        self.postData(image: imgData , fileName:  localFile?.lastPathComponent ?? "")
           dismiss(animated: true, completion: nil)
    }
    @objc func keyboardHandler(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let isKeyboard = notification.name == UIResponder.keyboardWillShowNotification
            self.view.frame.origin.y =  isKeyboard ? -keyboardSize.height + 100 : 88
        }
    }
    func scrollToTop(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    func getCurrentTimeStamp() -> String {
           print("\(Double(NSDate().timeIntervalSince1970 * 1000))")
            return "\(Double(NSDate().timeIntervalSince1970 * 1000))"
    }
    func sendChat(){
        guard let chatText = self.chatTextF.text ,chatText.isEmpty == false, let userId = Auth.auth().currentUser?.uid else {
            return
        }
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let result = formatter.string(from: date)
        let userName = UserDefaults.standard.value(forKey: "userName") as? String

        let dataArray: [String:Any ] =  ["isView": true,"message":chatText, "sender_id": userId , "sender_name" : userName!, "reciver_id" : levelId , "time" : result ] as [String : Any]

        let room = Constants.refs.databaseChats.child(levelId).childByAutoId()
        room.updateChildValues(dataArray)
        tableView.reloadData()
        chatTextF.text = ""
    }
    func getMessages(){
          guard  (Auth.auth().currentUser?.uid) != nil else {
               return
          }
          let ref = Constants.refs.databaseChats.child(levelId)
          ref.observe(.childAdded) { (snapshot) in
              print(snapshot)
              if let dictanory = snapshot.value as? [String: AnyObject]{
                  guard let isView = dictanory["isView"] as? Bool,
                     let masg = dictanory["message"] as? String,
                     let sender = dictanory["sender_id"] as? String,
                     let reciver = dictanory["reciver_id"] as? String,
                     let senderName = dictanory["sender_name"] as? String,
                     let time = dictanory["time"] as? String
                     else{
                          return
                     }
                     let message = messages(messageKey: snapshot.key, text: masg, senderId: sender, senderName: senderName,  reciverId: reciver, time: time)
                     self.chatMessges.append(message)
                     self.tableView.reloadData()
                     self.scrollToTop()
                     self.hideLoader(mainView: &self.loaderView)
               }
           }
      }
    
    @IBAction func refusedAction(_ sender: UIButton) {
        imgAlertView.isHidden = true
    }
    
    @IBAction func acceptAction(_ sender: UIButton) {
        do{
         self.postData(image: self.docData, fileName: self.imgURL?.lastPathComponent ?? "")
         imgAlertView.isHidden = true
        }catch{
            print(error)
        }
    }
    @IBAction func didSelectSendButton(_ sender: UIButton) {
        print("ios : \(docData)")
         if chatTextF.text != ""{
             self.postData(image: docData, fileName: "" )
         }
      }
      func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        chatTextF.resignFirstResponder()
        return true
      }
}
extension chatRoomViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages2.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let userId = UserDefaults.standard.value(forKey: "userId") as? String
        let myMessages = self.chatMessages2[indexPath.row]
        let cell = tableView.dequeue() as roomChatTableViewCell
        cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi));
        cell.messageTextfield.text = myMessages.message
        cell.userNameLabel.text = myMessages.senderName
        cell.timeTF.text = myMessages.createdAt
        if (myMessages.senderID == userId ){
            cell.setBubbleType(type: .outcoming)
        }else{
            cell.setBubbleType(type: .incoming)
        }
        let fullPath: String = myMessages.file ?? ""
        let fullPathArr = fullPath.split(separator: ".")
        let lastpath = fullPathArr.last
        if(myMessages.file == "" || myMessages.file?.length == 0 || myMessages.file == nil ){
            cell.messageTextfield.text = myMessages.message
            cell.chatView.isHidden = false
            cell.imgView.isHidden = true
        }else if (lastpath == "pdf"){
           cell.imgView.image = UIImage(named: "file")
           cell.chatView.isHidden = true
           cell.imgView.isHidden = false

        }else{
            print("images/\(myMessages.file)")
           let urlFull = Constants.baseURL2 + "images/\(myMessages.file ?? "" )"
           let url = URL(string: urlFull)
           cell.imgView.kf.indicatorType = .activity
           cell.imgView.kf.setImage(with: url)
           cell.chatView.isHidden = true
           cell.imgView.isHidden = false
        }
        return cell
    }
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chatTextF.endEditing(true)
        let myMessages = self.chatMessages2[indexPath.row]
        let fullPath: String = myMessages.file ?? ""
        let fullPathArr = fullPath.split(separator: ".")
        let lastpath = fullPathArr.last
        //print("sleep \(levelData?.data?.pdf![indexPath.row])")
        if lastpath == "pdf"{
            let view = self.storyboard?.instantiateViewController(withIdentifier: "DisplayPdfVC") as! DisplayPdfVC
            let fileName = myMessages.file
            view.stringurl =  Constants.baseURL2 + "images/\(fileName!)"
            self.navigationController?.pushViewController(view, animated: true)
        }else if lastpath == "jpeg"{
            let view = self.storyboard?.instantiateViewController(withIdentifier: "ImageDisplayVC") as! ImageDisplayVC
            let fileName = myMessages.file
            view.image =  Constants.baseURL2 + "images/\(fileName!)"
            self.navigationController?.pushViewController(view, animated: true)
            
        }else if lastpath == "png"{
            let view = self.storyboard?.instantiateViewController(withIdentifier: "ImageDisplayVC") as! ImageDisplayVC
            let fileName = myMessages.file
            view.image =  Constants.baseURL2 + "images/\(fileName!)"
            self.navigationController?.pushViewController(view, animated: true)
            
        }else if lastpath == "jpg"{
            let view = self.storyboard?.instantiateViewController(withIdentifier: "ImageDisplayVC") as! ImageDisplayVC
            let fileName = myMessages.file
            view.image =  Constants.baseURL2 + "images/\(fileName!)"
            self.navigationController?.pushViewController(view, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(oneChatMessages?.config?.totalRows ?? 0 > 10){
            if indexPath.row == (chatMessages2.count) - 1 {
                if(currentPage == (oneChatMessages?.config?.numLinks)! - 1){
                }else{
                    if chatMessages2.count >= 10 {
                        currentPage = currentPage + 1
                        get_Messeges()
                    }
                }
            }
        }
    }
}
//MARK: - Request
extension chatRoomViewController{
       func get_Messeges(){
            startAllAnimationBtn()
           
            if Reachability.connectedToNetwork() {
                NetworkClient.performRequest(ChatModel.self, router: .getChat(user_id: (UserDefaults.standard.value(forKey: "userId") as? String)!, level_id: levelId, project_id: projectId, type: "0", page: "\(currentPage)"), success: { [weak self] (models) in
                    //self?.chatMessages2 = models.data!
                    self?.oneChatMessages = models
                    print("models\( models)")
                     if(models.status == 1){
                        for data in models.data!{
                        let message = ChatModelDatum(id: data.id, senderID: data.senderID, senderName: data.senderName,type: data.type, message: data.message, projectID: data.projectID, levelID: data.levelID, file: data.file, createdAt: data.createdAt)
                            self?.chatMessages2.append(message)
                        }
                        self?.tableView.reloadData()
                        self?.hideAllViews()
                     }
                     else if (models.status == 0 ){
                        self?.hideAllViews()
                     }
                 }){ [weak self] (error) in
                    self?.hideAllViews()
                 }
            }
        }
        func postData(image: Data? , fileName : String ){
            addButton.startAnimation()
             
            let fullUrl :String = Constants.baseURL + "chat/SendMessage"
            let userId = UserDefaults.standard.value(forKey: "userId") as? String
             let username = UserDefaults.standard.value(forKey: "userName") as? String
            var params = ["level_id": self.levelId, "project_id": self.projectId , "sender_id" :userId!, "sender_name": username! ,  "type": "0" , "message" :self.chatTextF.text ?? ""] as [String : Any]

           AF.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in params {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
//            guard let img = image else{
//                return
//            }
            self.addButton.backgroundColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
            if(self.chatTextF.text == ""){
                print("wwwwwwwwwwwwwwww")
               // multipartFormData.append(img, withName: "file" , fileName: fileName, mimeType: "image/\(fileName)")
                let fullPathArr = fileName.split(separator: ".")
                var lastpath = fullPathArr.last
                print(lastpath)
                if lastpath == "png"{
                    if let img = image{
                        multipartFormData.append(img, withName: "file", fileName: "file.jpeg", mimeType: "image/jpeg")
                    }
                }else{
                    if let  img = image{
                        multipartFormData.append(img, withName: "file", fileName: fileName, mimeType: "image/\(fileName)")
                    }
                }
            }
            
           }, to: fullUrl, usingThreshold: UInt64.init(),method: .post, headers: nil) .responseJSON { response in
            switch response.result{
                case .success(let upload):
                    self.addButton.backgroundColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
//                   upload.uploadProgress(closure: { (Progress) in
//                     self.addButton.backgroundColor = #colorLiteral(red: 0.7607843137, green: 0, blue: 0.0431372549, alpha: 1)
//                      // self.progressView.progress = Float(Progress.fractionCompleted)
//                   print("Upload Progress: \(Progress.fractionCompleted)")
//                   })

                        print("Succesfully uploaded")
                      //  print(response.result.value!)
                    self.addButton.backgroundColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
                     do {
                    let Lists = try JSONDecoder().decode(ChatSendModel.self, from: response.data!)
                       
                    let message = ChatModelDatum(id: Lists.data?.id, senderID: Lists.data?.senderID, senderName: Lists.data?.senderName,type: Lists.data?.type, message: Lists.data?.message, projectID: Lists.data?.projectID, levelID: Lists.data?.levelID, file: Lists.data?.file, createdAt: Lists.data?.createdAt)
                        print("last : \(Lists.data?.file)")
                     //   self.chatMessages2.append(message)
                        self.chatMessages2.insert(message, at: 0)
                        self.tableView.insertRows(at: [IndexPath(row: 0 , section: 0)], with: .top)
                        
                        self.scrollToTop()
                        self.chatTextF.text = ""
                        params.removeAll()
                        self.addButton.stopAnimation()
                        self.addButton.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                    } catch let error{
                           print(error)
                        self.addButton.stopAnimation()
                        self.addButton.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                       }
                       if let err = response.error{
                           print(err)
                        self.addButton.stopAnimation()
                        self.addButton.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                            return
                       }
                    
                case .failure(let error):
                    print("Error in upload: \(error.localizedDescription)")
                    self.addButton.stopAnimation()
                    self.addButton.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                }
            }
        }
    func delete_Messeges(id :String, messegeIndex : Int){
         
        NetworkClient.performRequest(DeleteChatMessegeModel.self, router: .deleteMessage(id: id), success: { [weak self] (models) in

                 print("models\( models)")
                  if(models.status == 1){
                    self?.chatMessages2.remove(at: messegeIndex)
                    self?.view.makeToast("تم مسح الرسالة بنجاح", duration: 3.0, position: .bottom)
                    self?.tableView.reloadData()
                    
                  }
                  else if (models.status == 0 ){
                    // self?.hideAllViews()
                  }
              }){ [weak self] (error) in
                 //self?.hideAllViews()
              }
         
     }

}
//MARK: - Loader
extension chatRoomViewController{
    func addAllViews(){
        self.errorView(mainNoDataView : &self.errorView, refreshBtn : &self.refreshErrorBtn)
        self.noInterNetView(mainNoDataView : &self.noInterNetView, refreshBtn :  &self.refreshInterNetBtn)
        self.noDataView(mainNoDataView: &self.noDataView, labelData: "لا توجد طلبات جديده حاليا", refreshBtn: &self.refresDatahBtn, addStatus : 1, addFBtn : &addFBtn)
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
