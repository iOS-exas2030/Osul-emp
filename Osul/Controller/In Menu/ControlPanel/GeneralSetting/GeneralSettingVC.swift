//
//  GeneralSettingVC.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 7/22/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import JSSAlertView
import TransitionButton
import Kingfisher
import Alamofire
class GeneralSettingVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate {
    
    //MARK: - IBOutlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var phone1TextField: UITextField!
    @IBOutlet weak var phone2TextField: UITextField!
    @IBOutlet weak var address1TextField: UITextField!
    @IBOutlet weak var address2TextField: UITextField!
    @IBOutlet weak var email1TextField: UITextField!
    @IBOutlet weak var email2TextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var twitterTextField: UITextField!
    @IBOutlet weak var instgramTextField: UITextField!
    @IBOutlet weak var snapChatTextField: UITextField!
    @IBOutlet weak var faceBookTextField: UITextField!
    @IBOutlet weak var saveBtn: TransitionButton!
    
    @IBOutlet weak var logo: UIImageView!
    
    //MARK: - Properties
    var image = UIImagePickerController()
    var selectedImagestatus = false
    var currentImageName = ""
    var CompanySettingDate : CompanySettingModel!
    lazy var imgData = Data()
    
    @IBOutlet weak var mainScrollView : UIScrollView!
    @IBOutlet weak var mainView: UIView!
    
    //status views
    var loaderView = UIView()
    var noDataView = UIView()
    var refresDatahBtn = TransitionButton()
    var refreshInterNetBtn = TransitionButton()
    var noInterNetView = UIView()
    var errorView = UIView()
    var refreshErrorBtn = TransitionButton()
    var addFBtn = TransitionButton()

    
    //MARK: - View Controller Builder
    override func viewDidLoad() {
        super.viewDidLoad()
        //  Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        config()
    }
    func config(){
        addAllViews()
        self.getTokenReq()
        saveBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        nameTextField.delegate = self
        descriptionTextField.delegate = self
        phone1TextField.delegate = self
        phone2TextField.delegate = self
        address1TextField.delegate = self
        address2TextField.delegate = self
        email1TextField.delegate = self
        email2TextField.delegate = self
        websiteTextField.delegate = self
        twitterTextField.delegate = self
        instgramTextField.delegate = self
        snapChatTextField.delegate = self
        faceBookTextField.delegate = self
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.firstButtontapped))
        logo.isUserInteractionEnabled = true
        logo.addGestureRecognizer(tap1)
        getCompanySetting()
    }
    @objc func dismissKeyboard() {
       view.endEditing(true)
    }
    @objc func firstButtontapped(){
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = .photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true){
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           if let image2 = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
               logo.image = image2
               imgData = image2.jpegData(compressionQuality: 0.2)!
               selectedImagestatus = true
               } else {
               }
           dismiss(animated: true, completion: nil)
    }
    @IBAction func addAction(_ sender: Any) {
        updateInfo()
    }
    func updateInfo(){
        let Email1Address = email1TextField.text
        let isEmail1AddressValid = isValidEmailAddress(emailAddressString: Email1Address!)
        
        let Email2Address = email2TextField.text
        let isEmail2AddressValid = isValidEmailAddress(emailAddressString: Email2Address!)
       
        if(nameTextField.text == ""){
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء ادخال اسم المؤسسه ", buttonText: "موافق")
        }else if(descriptionTextField.text == ""){
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء ادخال الوصف ", buttonText: "موافق")
        }else if(phone1TextField.text == ""){
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء ادخال رقم الجوال الأول ", buttonText: "موافق")
        }else if(phone1TextField.text?.count != 9){
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء ادخال رقم جوال مكون من ٩ رقم", buttonText: "موافق")
        }else if(phone2TextField.text == ""){
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء ادخال رقم الجوال الثاني ", buttonText: "موافق")
        }else if(phone2TextField.text?.count != 9){
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء ادخال رقم جوال مكون من ٩ رقم", buttonText: "موافق")
        }else if(address1TextField.text == ""){
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء ادخال العنوان الاول ", buttonText: "موافق")
        }else if(address2TextField.text == ""){
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء ادخال العنوان الثانى ", buttonText: "موافق")
        }else if(email1TextField.text == ""){
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء ادخال الإميل الإول ", buttonText: "موافق")
        }else if !isEmail1AddressValid
            {
                JSSAlertView().danger(self,title: "خطأ",text: "برجاء كتابه البريد الالكترونى بطريقه صحيحه😞😞",buttonText: "موافق")
                return
        }
        else if(email2TextField.text == ""){
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء ادخال الإميل الثاني ", buttonText: "موافق")
        }else if !isEmail2AddressValid
            {
                JSSAlertView().danger(self,title: "خطأ",text: "برجاء كتابه البريد الالكترونى بطريقه صحيحه😞😞",buttonText: "موافق")
                return
            }
        else if(websiteTextField.text == ""){
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء ادخال الموقع الإلكترونى ", buttonText: "موافق")
        }else if(twitterTextField.text == ""){
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء ادخال تويتر ", buttonText: "موافق")
        }else if(instgramTextField.text == ""){
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء ادخال الانستجرام ", buttonText: "موافق")
        }else if(snapChatTextField.text == ""){
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء ادخال الاسناب شات ", buttonText: "موافق")
        }else if(snapChatTextField.text == ""){
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء ادخال الفيس بوك ", buttonText: "موافق")
        }else{
            saveBtn.startAnimation()
            if(selectedImagestatus == true){
                uploadImage()
            }else{
                editData(imageName : currentImageName)
            }
        }
    }
}
//MARK: - UITextFieldDelegate
extension GeneralSettingVC{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField == nameTextField){
            nameTextField.layer.borderColor = #colorLiteral(red: 0.4763007164, green: 0.2721414864, blue: 0.625670135, alpha: 0.8470588235) //your color
            nameTextField.layer.borderWidth = 1.0
        }else if(textField == descriptionTextField){
            descriptionTextField.layer.borderColor = #colorLiteral(red: 0.4763007164, green: 0.2721414864, blue: 0.625670135, alpha: 0.8470588235) //your color
            descriptionTextField.layer.borderWidth = 1.0
        }else if(textField == phone1TextField){
            phone1TextField.layer.borderColor = #colorLiteral(red: 0.4763007164, green: 0.2721414864, blue: 0.625670135, alpha: 0.8470588235) //your color
            phone1TextField.layer.borderWidth = 1.0
        }else if(textField == phone2TextField){
            phone2TextField.layer.borderColor = #colorLiteral(red: 0.4763007164, green: 0.2721414864, blue: 0.625670135, alpha: 0.8470588235) //your color
            phone2TextField.layer.borderWidth = 1.0
        }else if(textField == address1TextField){
            address1TextField.layer.borderColor = #colorLiteral(red: 0.4763007164, green: 0.2721414864, blue: 0.625670135, alpha: 0.8470588235) //your color
            address1TextField.layer.borderWidth = 1.0
        }else if(textField == address2TextField){
            address2TextField.layer.borderColor = #colorLiteral(red: 0.4763007164, green: 0.2721414864, blue: 0.625670135, alpha: 0.8470588235) //your color
            address2TextField.layer.borderWidth = 1.0
        }else if(textField == email1TextField){
            email1TextField.layer.borderColor = #colorLiteral(red: 0.4763007164, green: 0.2721414864, blue: 0.625670135, alpha: 0.8470588235) //your color
            email1TextField.layer.borderWidth = 1.0
        }else if(textField == email2TextField){
            email2TextField.layer.borderColor = #colorLiteral(red: 0.4763007164, green: 0.2721414864, blue: 0.625670135, alpha: 0.8470588235) //your color
            email2TextField.layer.borderWidth = 1.0
        }else if(textField == websiteTextField){
            websiteTextField.layer.borderColor = #colorLiteral(red: 0.4763007164, green: 0.2721414864, blue: 0.625670135, alpha: 0.8470588235) //your color
            websiteTextField.layer.borderWidth = 1.0
        }else if(textField == twitterTextField){
            twitterTextField.layer.borderColor = #colorLiteral(red: 0.4763007164, green: 0.2721414864, blue: 0.625670135, alpha: 0.8470588235) //your color
            twitterTextField.layer.borderWidth = 1.0
        }else if(textField == instgramTextField){
            instgramTextField.layer.borderColor = #colorLiteral(red: 0.4763007164, green: 0.2721414864, blue: 0.625670135, alpha: 0.8470588235) //your color
            instgramTextField.layer.borderWidth = 1.0
        }else if(textField == snapChatTextField){
            snapChatTextField.layer.borderColor = #colorLiteral(red: 0.4763007164, green: 0.2721414864, blue: 0.625670135, alpha: 0.8470588235) //your color
            snapChatTextField.layer.borderWidth = 1.0
        }else if(textField == faceBookTextField){
            faceBookTextField.layer.borderColor = #colorLiteral(red: 0.4763007164, green: 0.2721414864, blue: 0.625670135, alpha: 0.8470588235) //your color
            faceBookTextField.layer.borderWidth = 1.0
        }
    }
    //
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == nameTextField){
            nameTextField.layer.borderWidth = 0.0
        }else if(textField == descriptionTextField){
            descriptionTextField.layer.borderWidth = 0.0
        }else if(textField == phone1TextField){
            phone1TextField.layer.borderWidth = 0.0
        }else if(textField == phone2TextField){
            phone2TextField.layer.borderWidth = 0.0
        }else if(textField == address1TextField){
            address1TextField.layer.borderWidth = 0.0
        }else if(textField == address2TextField){
            address2TextField.layer.borderWidth = 0.0
        }else if(textField == email1TextField){
            email1TextField.layer.borderWidth = 0.0
        }else if(textField == email2TextField){
            email2TextField.layer.borderWidth = 0.0
        }else if(textField == websiteTextField){
            websiteTextField.layer.borderWidth = 0.0
        }else if(textField == twitterTextField){
            twitterTextField.layer.borderWidth = 0.0
        }else if(textField == instgramTextField){
            instgramTextField.layer.borderWidth = 0.0
        }else if(textField == snapChatTextField){
            snapChatTextField.layer.borderWidth = 0.0
        }else if(textField == faceBookTextField){
            faceBookTextField.layer.borderWidth = 0.0
        }
    }
    //
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == nameTextField){
            textField.resignFirstResponder()
            descriptionTextField.becomeFirstResponder()
        }else if(textField == descriptionTextField){
            textField.resignFirstResponder()
            phone1TextField.becomeFirstResponder()
        }else if(textField == phone1TextField){
            textField.resignFirstResponder()
            phone2TextField.becomeFirstResponder()
        }else if(textField == phone2TextField){
            textField.resignFirstResponder()
            address1TextField.becomeFirstResponder()
        }else if(textField == address1TextField){
            textField.resignFirstResponder()
            address2TextField.becomeFirstResponder()
        }else if(textField == address2TextField){
            textField.resignFirstResponder()
            email1TextField.becomeFirstResponder()
        }else if(textField == email1TextField){
            textField.resignFirstResponder()
            email2TextField.becomeFirstResponder()
        }else if(textField == email2TextField){
            textField.resignFirstResponder()
            websiteTextField.becomeFirstResponder()
        }else if(textField == websiteTextField){
            textField.resignFirstResponder()
            twitterTextField.becomeFirstResponder()
        }else if(textField == twitterTextField){
            textField.resignFirstResponder()
            instgramTextField.becomeFirstResponder()
        }else if(textField == instgramTextField){
            textField.resignFirstResponder()
            snapChatTextField.becomeFirstResponder()
        }else if(textField == snapChatTextField){
            textField.resignFirstResponder()
            faceBookTextField.becomeFirstResponder()
        }else if(textField == faceBookTextField){
            self.view.endEditing(true)
        }
        return true
    }
}
//MARK: -  Request
extension GeneralSettingVC{
    func editData(imageName : String){
                let formatter: NumberFormatter = NumberFormatter()
                formatter.locale = NSLocale(localeIdentifier: "EN") as Locale?
                let final1 = formatter.number(from: phone1TextField.text!)
                let final2 = formatter.number(from: phone2TextField.text!)
        
                NetworkClient.performRequest(CompanySettingModel.self, router: .editCompanySetting(title:
                    self.nameTextField.text!,
                    description: self.descriptionTextField.text!,
                    phone1: "966" + "\(final1!)",
                    phone2: "966" + "\(final2!)",
                    address1: self.address1TextField.text!,
                    address2: self.address2TextField.text!,
                    email1: self.email1TextField.text!,
                    email2: self.email2TextField.text!,
                    website: self.websiteTextField.text!,
                    twitter: self.twitterTextField.text!,
                    instagram: self.instgramTextField.text!,
                    snapchat: self.snapChatTextField.text!,
                    facebook: self.faceBookTextField.text!,
                    logo:  imageName), success: { [weak self] (models) in
                    self?.CompanySettingDate = models
                    if(models.status == 1){
                        DispatchQueue.main.async(execute: { () -> Void in
                          self!.saveBtn.stopAnimation(animationStyle: .normal, completion: {
                                JSSAlertView().success(self!,title: "حسنا",text: "تم الحفظ بنجاح")
                          })
                        })
                    }
                    else if (models.status == 0 ){
                        DispatchQueue.main.async(execute: { () -> Void in
                          self!.saveBtn.stopAnimation(animationStyle: .shake, completion: {
                                 JSSAlertView().danger(self!, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
                              })
                          })
                    }
                }){ [weak self] (error) in
                     DispatchQueue.main.async(execute: { () -> Void in
                       self!.saveBtn.stopAnimation(animationStyle: .shake, completion: {
                                JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
                           })
                       })
                   }
    }
    func uploadImage(){
        let params = ["imgfile": logo!] as [String : Any]
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            multipartFormData.append(self.imgData, withName: "imgfile", fileName: "fileName.jpg", mimeType: "image/jpg")
        }, to: Constants.baseURL + "controllers/upload_photo", usingThreshold: UInt64.init(),  method: .post, headers: nil).responseJSON{ (response) in
            switch response.result {
            case .success(let upload):
//                upload.uploadProgress(closure: { (Progress) in
//                print("Upload Progress: \(Progress.fractionCompleted)")
//                })
    
                   print("Succesfully uploaded")
                   print(response)
                    do {
                        let Lists = try JSONDecoder().decode(ImagesModel.self, from: response.data!)
                        let model = Lists.data[0]
                        print("sayed \(model.imgfile)")
                        print(Lists)
                        let imageRresponseName = model.imgfile
                        self.editData(imageName : imageRresponseName)
                        
                    } catch let error{
                        print(error)
                    }
                    if response.error != nil{
                        print("error")
                        return
                    }
              
            case .failure(let error):
                DispatchQueue.main.async(execute: { () -> Void in
                    self.saveBtn.stopAnimation(animationStyle: .shake, completion: {
                        JSSAlertView().danger(self, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
                    })
                })
                print("Error in upload: \(error.localizedDescription)")
                print("wrong")
            }
        }
    }
    @objc func getCompanySetting(){
        startAllAnimationBtn()
        if Reachability.connectedToNetwork() {
            NetworkClient.performRequest(CompanySettingModel.self, router: .getCompanySetting, success: { [weak self] (models) in
                self?.CompanySettingDate = models
                print("models\( models)")
                if(models.status == 1){
                    let model = models.data?[0]
                    self?.nameTextField.text = model?.title!
                    self?.descriptionTextField.text = model?.datumDescription!
                    let str = model?.phone1
                    let index = str?.index((str?.endIndex)!, offsetBy: -9)
                    let mySubstring = str?.suffix(from: index!)
                    print(mySubstring)
                    self?.phone1TextField.text = String(mySubstring!)
                   
                    let str1 = model?.phone2!
                    let index1 = str1?.index((str1?.endIndex)!, offsetBy: -9)
                    let mySubstring1 = str?.suffix(from: index1!)
                    print(mySubstring1)
                    self?.phone2TextField.text = String(mySubstring1!)
                    
                    self?.address1TextField.text = model?.address1!
                    self?.address2TextField.text = model?.address2!
                    self?.email1TextField.text = model?.email1!
                    self?.websiteTextField.text = model?.website!
                    self?.email2TextField.text = model?.email2!
                    self?.twitterTextField.text = model?.twitter!
                    self?.instgramTextField.text = model?.instagram!
                    self?.snapChatTextField.text = model?.snapchat!
                    self?.faceBookTextField.text = model?.facebook!
                    let dateArr = model?.logo!.split(separator: "/")
                    self!.currentImageName = "\(dateArr?.last! ?? "")"
                    if model?.logo! != "" {
                      //  let urlString = URLs.BasePhoto + "avatars/thumbs/" + avatar
                        let url = URL(string: model?.logo ?? "")
                        self?.logo.kf.indicatorType = .activity
                        self?.logo.kf.setImage(with: url)
                    } else {
                        self?.logo.image = UIImage(named: "loaderIcon")
                    }
                    self!.hideAllViews()
                }
                else if (models.status == 0 ){
                    self!.hideAllViews()
                    self!.noDataView.isHidden = false
                    self?.refresDatahBtn.addTarget(self, action: #selector(self?.getCompanySetting), for: UIControl.Event.touchUpInside)
                }
            }){ [weak self] (error) in
                    self!.hideAllViews()
                    self!.errorView.isHidden = false
                    self?.refreshErrorBtn.addTarget(self, action: #selector(self?.getCompanySetting), for: UIControl.Event.touchUpInside)
                }
            }else{
                  hideAllViews()
                  noInterNetView.isHidden = false
                  self.refreshInterNetBtn.addTarget(self, action: #selector(self.getCompanySetting), for: UIControl.Event.touchUpInside)
            }
    }
}

//MARK: - Loader
extension GeneralSettingVC {
    func addAllViews(){
        self.errorView(mainNoDataView : &self.errorView, refreshBtn : &self.refreshErrorBtn)
        self.noInterNetView(mainNoDataView : &self.noInterNetView, refreshBtn :  &self.refreshInterNetBtn)
        self.noDataView(mainNoDataView: &self.noDataView, labelData: "الاعدادات قيد التحديث", refreshBtn: &self.refresDatahBtn, addStatus : 1, addFBtn : &addFBtn)
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
