//
//  BeforeDesignVC.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 7/23/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import DropDown
import JSSAlertView
protocol beforeBackAction{
    func add(array : Level_DetailsDatum, controller: BeforeDesignVC)
}


class BeforeDesignVC: UIViewController {

//MARK: - IBOutlets
    
    @IBOutlet weak var addAnswerButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var answerTypeDropdown: DropDown!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var percentageTF: UITextField!
    @IBOutlet weak var writeAnswerTF: UITextField!
    
    //MARK: - Properties
    var add = [String]()
    var id = ""
    var levelid = ""
    var levelType = ""
    var ispdf = ""
    var chosenAnswer : String = ""
    var addNew = true
    var questionId : String? = nil
    var beforebBackDelegate : beforeBackAction?
    var all_level_details : Level_Details!
    var getDetails : GetDetailsLevel!
    var myNewView = UIView()
    var values: [String] = []
   // var answer = ""
//MARK: - View Controller Builder
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getTokenReq()
    }
    
    func config() {
        showLoader(mainView: &myNewView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.reloadData()
        answerTypeDropdown.selectedRowColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
        answerTypeDropdown.optionArray = ["كتابة نص", "اختياري","اختيار متعدد", "صورة","اختياري بنص"]
        answerTypeDropdown.rowHeight = 50
        answerTypeDropdown.didSelect{(selectedText , index ,id) in
            if selectedText == "كتابة نص" {
                self.questionId = "1"
                self.chosenAnswer =  "كتابة نص"
                self.tableView.isHidden = true
                self.writeAnswerTF.isHidden = true
                self.addAnswerButton.isHidden = true
                self.ispdf = "0"
            }else if selectedText == "اختياري"{
                self.questionId = "2"
                self.chosenAnswer = "اختياري"
                self.tableView.isHidden = false
                self.writeAnswerTF.isHidden = false
                self.addAnswerButton.isHidden = false
                self.ispdf = "0"
            }else if selectedText == "اختيار متعدد"{
                self.questionId = "3"
                self.chosenAnswer =  "اختيار متعدد"
                self.tableView.isHidden = false
                self.writeAnswerTF.isHidden = false
                self.addAnswerButton.isHidden = false
                self.ispdf = "0"
            }else if selectedText == "صورة"{
                self.questionId = "4"
                self.chosenAnswer =  "صورة"
                self.tableView.isHidden = true
                self.writeAnswerTF.isHidden = true
                self.addAnswerButton.isHidden = true
                self.ispdf = "1"
            }else if selectedText == "اختياري بنص"{
                self.questionId = "5"
                self.chosenAnswer =  "اختياري بنص"
                self.tableView.isHidden = false
                self.writeAnswerTF.isHidden = false
                self.addAnswerButton.isHidden = false
                self.ispdf = "0"
            }
        }
//        let checkBoxTap = UITapGestureRecognizer(target: self, action: #selector(checkBoxAction))
//        isPdfView.addGestureRecognizer(checkBoxTap)
        if addNew == true{
//            isPdfButton.isHidden = true
            self.hideLoader(mainView: &self.myNewView)
        }else {
             get_level_details_info(id: id)
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    //isPDF checkBox Action
//    @objc func checkBoxAction(){
//          if isPdfButton.isHidden == true {
//              isPdfButton.isHidden = false
//            ispdf = "1"
//
//          }else if isPdfButton.isHidden == false {
//              isPdfButton.isHidden = true
//            ispdf = "0"
//
//          }
//      }

    @IBAction func addButton(_ sender: UIButton) {
        
        if chosenAnswer == "كتابة نص"  {
            print("sayed1")
           JSSAlertView().info(self,title: "تنبيه !",text: "لا يمكنك كتابة اجبات الي سؤال نصي",buttonText: "موافق" )
        }else if chosenAnswer == "اختياري" && writeAnswerTF.text?.isEmpty == false{
           // self.getDetails?.data?.values?.append(writeAnswerTF.text!)
         //   tableView.insertRows(at: [IndexPath(row: (self.getDetails?.data?.values?.count ?? 0) - 1, section: 0)], with: .automatic)
          //  tableView.reloadData()
            self.values.append(writeAnswerTF.text ?? "")
            tableView.insertRows(at: [IndexPath(row: values.count - 1 , section: 0)], with: .automatic)
            print("sayed2 : \(self.getDetails?.data?.values?.count)")
            writeAnswerTF.text = ""
        }else if chosenAnswer == "اختيار متعدد" && writeAnswerTF.text?.isEmpty == false{
          //  self.getDetails?.data?.values?.append(writeAnswerTF.text!)
        //   tableView.insertRows(at: [IndexPath(row: (self.getDetails?.data?.values?.count ?? 0) - 1, section: 0)], with: .automatic)
          //  tableView.reloadData()
            self.values.append(writeAnswerTF.text ?? "")
            tableView.insertRows(at: [IndexPath(row: values.count - 1 , section: 0)], with: .automatic)
            print("sayed3 : \(self.getDetails?.data?.values?.count)")
            writeAnswerTF.text = ""
        }else if chosenAnswer == "صورة" {
         print("sayed4")
        JSSAlertView().info(self,title: "تنبيه !",text: "لا يمكنك كتابة اجابات الي صورة",
         buttonText: "موافق" )
        }else if chosenAnswer == "اختياري بنص" && writeAnswerTF.text?.isEmpty == false{
          //  self.getDetails?.data?.values?.append(writeAnswerTF.text!)
        //   tableView.insertRows(at: [IndexPath(row: (self.getDetails?.data?.values?.count ?? 0) - 1, section: 0)], with: .automatic)
          //  tableView.reloadData()
            self.values.append(writeAnswerTF.text ?? "")
            tableView.insertRows(at: [IndexPath(row: values.count - 1 , section: 0)], with: .automatic)
            print("sayed5 : \(self.getDetails?.data?.values?.count)")
            writeAnswerTF.text = ""
        }
    }
    @IBAction func saveButton(_ sender: UIButton) {
        validation()
    }
    func validation(){
          if(addressTF.text == ""){
              JSSAlertView().danger(self, title: "خطأ", text: "برجاء ادخال العنوان ", buttonText: "موافق")
          }else if(percentageTF.text == ""){
              JSSAlertView().danger(self, title: "خطأ", text: "برجاء ادخال نسبة المرحلة ", buttonText: "موافق")
          }else if(answerTypeDropdown.text == "" ){
              JSSAlertView().danger(self, title: "خطأ", text: "برجاء تحديد نوع الاجابة ", buttonText: "موافق")
          }else if(chosenAnswer == "اختياري" && values.count == 0){
               JSSAlertView().danger(self, title: "خطأ", text: "برجاء كتابة الاختيارات ", buttonText: "موافق")
          }else if(chosenAnswer == "اختيار متعدد" && values.count == 0){
               JSSAlertView().danger(self, title: "خطأ", text: "برجاء كتابة الاختيارات ", buttonText: "موافق")
          }else if(chosenAnswer == "اختياري بنص" && values.count == 0){
               JSSAlertView().danger(self, title: "خطأ", text: "برجاء كتابة الاختيارات ", buttonText: "موافق")
          }else if(addNew == true){
                add_level_details()
          }else{
                edit_level_details()
          }
      }
}
//MARK: - UITableView Delegate & DataSource
extension BeforeDesignVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // return getDetails?.data?.values?.count ?? 0
        if values.count == 0 {
            answerTypeDropdown.optionArray = ["كتابة نص", "اختياري","اختيار متعدد", "صورة","اختياري بنص"]
            return values.count ?? 0 
        }else{
            answerTypeDropdown.text = chosenAnswer
            answerTypeDropdown.optionArray = [ chosenAnswer ]
            
            return values.count ?? 0
            
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "beforeDesignCell", for: indexPath) as! beforeDesignCell
       // cell.answerTF.text = getDetails?.data?.values?[indexPath.row]
        cell.answerTF.text = values[indexPath.row]
       // self.getDetails?.data?.values?.append(answer)
        cell.deleteBut.addTarget(self, action: #selector(deleteRow(_ :)), for: .touchUpInside)
//        cell.delegate = self
//        cell.indexx = indexPath
        return cell
    }
    @objc func deleteRow(_ sender : UIButton){
        let point = sender.convert(CGPoint.zero, to: tableView)
        guard let indexpath = tableView.indexPathForRow(at: point) else {return}
      //  self.getDetails?.data?.values?.remove(at: indexpath.row)
        self.values.remove(at: indexpath.row)
        tableView.deleteRows(at: [indexpath], with: .left)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
}
//MARK: - Request
extension BeforeDesignVC {
    func get_level_details_info(id : String){
     NetworkClient.performRequest(GetDetailsLevel.self, router: .get_level_details_info(id: id), success: { [weak self] (models) in
        self?.getDetails = models
         print("models\( models)")
         if(models.status == 1){
            self?.addressTF.text = self?.getDetails?.data?.title
            self?.percentageTF.text = self?.getDetails?.data?.percent
//            if self?.getDetails?.data?.isPDF == "1" {
//                self?.ispdf = "1"
//                self?.isPdfButton.isHidden = false
//            }else if self?.getDetails?.data?.isPDF == "0" {
//                self?.ispdf = "0"
//                self?.isPdfButton.isHidden = true
//            }
            if self?.getDetails?.data?.questionType == "1"{
                self?.answerTypeDropdown.text = "كتابة نص"
                self?.chosenAnswer = "كتابة نص"
                self?.questionId = "1"
                self?.tableView.isHidden = true
                self?.writeAnswerTF.isHidden = true
                self?.addAnswerButton.isHidden = true
                self?.ispdf = "0"
            }else if self?.getDetails?.data?.questionType == "2"{
                self?.answerTypeDropdown.text = "اختياري"
                self?.chosenAnswer = "اختياري"
                self?.questionId = "2"
                self?.tableView.isHidden = false
                self?.writeAnswerTF.isHidden = false
                self?.addAnswerButton.isHidden = false
                self?.ispdf = "0"
            }else if self?.getDetails?.data?.questionType == "3"{
                self?.answerTypeDropdown.text = "اختيار متعدد"
                self?.chosenAnswer =  "اختيار متعدد"
                self?.questionId = "3"
                self?.tableView.isHidden = false
                self?.writeAnswerTF.isHidden = false
                self?.addAnswerButton.isHidden = false
                self?.ispdf = "0"
            }else if self?.getDetails?.data?.questionType == "4"{
                self?.answerTypeDropdown.text = "صورة"
                self?.chosenAnswer = "صورة"
                self?.questionId = "4"
                self?.tableView.isHidden = true
                self?.writeAnswerTF.isHidden = true
                self?.addAnswerButton.isHidden = true
                self?.ispdf = "1"
            }else if self?.getDetails?.data?.questionType == "5"{
                self?.answerTypeDropdown.text = "اختياري بنص"
                self?.chosenAnswer = "اختياري بنص"
                self?.questionId = "5"
                self?.tableView.isHidden = false
                self?.writeAnswerTF.isHidden = false
                self?.addAnswerButton.isHidden = false
                self?.ispdf = "0"
            }
            for i in self?.getDetails?.data?.values ?? []{
                self?.values.append(i)
            }
             self?.tableView.reloadData()
             self!.hideLoader(mainView: &self!.myNewView)
         }
         else if (models.status == 0 ){
            JSSAlertView().danger(self!, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
         }
     }){ [weak self] (error) in
            JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
        }
    }
    func add_level_details(){
        NetworkClient.performRequest(Level_Details.self, router: .add_level_details(title: addressTF.text!, level_id: levelid, percent: percentageTF.text! , is_pdf: ispdf, type: levelType, values: values, question_type: questionId!), success: { [weak self] (models) in
            self?.all_level_details = models
            print("models\( models)")
            if(models.status == 1){
                self?.beforebBackDelegate?.add(array:models.data[0], controller: self!)
                self?.navigationController?.popViewController(animated: true)
                JSSAlertView().success(self!,title: "حسنا",text: "تم الحفظ بنجاح")
            }
            else if (models.status == 0 ){
                JSSAlertView().danger(self!, title: "عذرا", text: models.arMsg, buttonText: "موافق")
            }
        }){ [weak self] (error) in
            JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
        }
    }
    func edit_level_details(){
        NetworkClient.performRequest(Level_Details.self, router: .edit_level_details(level_details_id: id, title:  addressTF.text!, level_id: levelid, percent:percentageTF.text!, is_pdf: ispdf, type: levelType, values: values, question_type: questionId!), success: { [weak self] (models) in
            self?.all_level_details = models
            print("models\( models)")
            if(models.status == 1){
                self?.beforebBackDelegate?.add(array:models.data[0], controller: self!)
                self?.navigationController?.popViewController(animated: true)
                JSSAlertView().success(self!,title: "حسنا",text: "تم الحفظ بنجاح")
            }
            else if (models.status == 0 ){
//                JSSAlertView().danger(self!, title: "عذرا", text: models.arMsg, buttonText: "موافق")
            }
        }){ [weak self] (error) in
            JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
        }
    }
}
