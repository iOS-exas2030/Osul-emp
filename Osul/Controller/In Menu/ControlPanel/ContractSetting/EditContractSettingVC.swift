//
//  EditContractSettingVC.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 7/21/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import JSSAlertView

class EditContractSettingVC: UIViewController , UIPopoverPresentationControllerDelegate,UITextFieldDelegate{


    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cottractNameTextField: UITextField!
    @IBOutlet weak var selectColor: UIButton!
    @IBOutlet weak var addNewContract: UIButton!
    @IBOutlet weak var editorDeleteContract: UIView!
   // let popColor : ColorPickerViewController?
    var newContract = true
    var detailsContract : Contracts?
    var id = ""
    var hexString = ""
    
    
    @IBOutlet weak var contractView: UIView!
    @IBOutlet weak var priceOfferView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        config()
    }
    func config(){
        if (newContract == true){
            titleLabel.text = "أعدادات التعاقدات / اضافه عقد جديد"
            editorDeleteContract.isHidden = true
            contractView.isHidden = true
            priceOfferView.isHidden = true
        }
        if(newContract == false){
            titleLabel.text = "إعدادات التعاقدات / تعديل"
            addNewContract.isHidden = true
            get_contract_info(id: id)
        }
        cottractNameTextField.delegate = self
        addNewContract.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        let tap1: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap1.cancelsTouchesInView = false
        view.addGestureRecognizer(tap1)
        self.getTokenReq()
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    // Generate popover on button press
    @IBAction func colorPickerButton(_ sender: UIButton) {
        let popoverVC = storyboard?.instantiateViewController(withIdentifier: "colorPickerPopover") as! ColorPickerViewController
        popoverVC.modalPresentationStyle = .popover
        popoverVC.preferredContentSize = CGSize(width: 284, height: 446)
        if let popoverController = popoverVC.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = CGRect(x: 0, y: 0, width: 85, height: 30)
            popoverController.permittedArrowDirections = .any
            popoverController.delegate = self
            popoverVC.delegate = self
        }
        present(popoverVC, animated: true, completion: nil)
    }
    // Override the iPhone behavior that presents a popover as fullscreen
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        // Return no adaptive presentation style, use default presentation behaviour
        return .none
    }
    func setButtonColor (_ color: UIColor) {
        selectColor.backgroundColor = color
    }
    @IBAction func editContractButton(_ sender: UIButton) {
        if(cottractNameTextField.text == ""){
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء ادخال اسم العقد اولا ", buttonText: "موافق")
        }else if(hexString == ""){
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء تحديد لون العقد ", buttonText: "موافق")
        }else{
            edit_contracts(id: id, title: cottractNameTextField.text ?? "", Color: "#\(hexString)")
        }
    }
    @IBAction func deleteContractButton(_ sender: UIButton) {
        let alertview = JSSAlertView().warning(self,title: "تنبيه !",text: "هل تريد الحذف ؟",
                        buttonText: "موافق",cancelButtonText: "إلغاء" )
        alertview.addAction {
            self.remove_contracts(id: self.id)
        }
        alertview.addCancelAction {
            print("cancel")
        }
    }
    @IBAction func addNewContractButton(_ sender: UIButton) {
        if(cottractNameTextField.text == ""){
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء ادخال اسم العقد اولا ", buttonText: "موافق")
        }else if(hexString == ""){
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء تحديد لون العقد ", buttonText: "موافق")
        }else{
            add_contracts(title: cottractNameTextField.text ?? "", Color: "#\(hexString)" )
        }
    }
    
    @IBAction func openPriceOfferAction(_ sender: Any) {
        let view = self.storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
        view.urlRequest =  Constants.baseURL2 + "admins/page/edit_price/\(id)"
        self.navigationController?.pushViewController(view, animated: true)
    }
    @IBAction func openContractAction(_ sender: Any) {
        let view = self.storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
        view.urlRequest =  Constants.baseURL2 + "admins/page/edit_template/\(id)"
        self.navigationController?.pushViewController(view, animated: true)
    }
    
}
//MARK: -Request
extension EditContractSettingVC{
    func get_contract_info(id : String){
        NetworkClient.performRequest(Contracts.self, router: .get_contract_info(id: id), success: { [weak self] (models) in
          self?.detailsContract = models
            if(models.status == 1){
              self?.cottractNameTextField.text = self?.detailsContract?.data[0].title
              self!.hexString = (self?.detailsContract?.data[0].color)!
              self!.hexString = String(self!.hexString.dropFirst())
              let color = UIColor(hexString: (self?.detailsContract?.data[0].color ?? ""))
              self?.selectColor.backgroundColor = color
              }
            else if (models.status == 0 ){
              JSSAlertView().danger(self!, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
            }
        }){ [weak self] (error) in
              JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
            }
    }
    func add_contracts(title: String, Color : String){
        NetworkClient.performRequest(Contracts.self, router: .add_contract(title: title, color: Color), success: { [weak self] (models) in
            self?.detailsContract = models
            if(models.status == 1){
              self?.navigationController?.popViewController(animated: true)
              JSSAlertView().success(self!,title: "حسنا",text: "تم الاضافة بنجاح")
            }
            else if (models.status == 0 ){
              JSSAlertView().danger(self!, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
            }
        }){ [weak self] (error) in
            JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
          }
      }
      func edit_contracts(id :String, title :String, Color :String){
          NetworkClient.performRequest(Contracts.self, router: .edit_contract(contract_id: id,title: title, color: Color), success: { [weak self] (models) in
              self?.detailsContract = models
              if(models.status == 1){
                self?.navigationController?.popViewController(animated: true)
                  JSSAlertView().success(self!,title: "حسنا",text: "تم الحفظ بنجاح")
              }
              else if (models.status == 0 ){
                  JSSAlertView().danger(self!, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
              }
          }){ [weak self] (error) in
                  JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
              }
      }
      func remove_contracts(id : String){
          NetworkClient.performRequest(Contracts.self, router: .remove_contract(id: id), success: { [weak self] (models) in
              self?.detailsContract = models
              if(models.status == 1){
              self?.navigationController?.popViewController(animated: true)
                  JSSAlertView().success(self!,title: "حسنا",text: "تم الحذف بنجاح")
              }
              else if (models.status == 0 ){
                JSSAlertView().danger(self!, title: "عذرا", text: models.arMsg, buttonText: "موافق")
              }
          }){ [weak self] (error) in
                  JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
              }
      }
}
//MARK: - UITextFieldDelegate
extension EditContractSettingVC{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField == cottractNameTextField){
            cottractNameTextField.layer.borderColor = #colorLiteral(red: 0.4763007164, green: 0.2721414864, blue: 0.625670135, alpha: 0.8470588235) //your color
            cottractNameTextField.layer.borderWidth = 1.0
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == cottractNameTextField){
            cottractNameTextField.layer.borderWidth = 0.0
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
