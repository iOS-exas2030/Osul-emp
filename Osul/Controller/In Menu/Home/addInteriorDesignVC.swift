//
//  addInteriorDesignVC.swift
//  AL-HHALIL
//
//  Created by apple on 8/26/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import JSSAlertView
class addInteriorDesignVC: UIViewController {
    
    var addData : MoreLevelDetailsModel1?
    @IBOutlet weak var attachView: UIView!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var commentTF: UITextView!
    @IBOutlet weak var checkButton: UIButton!
    var ispdf = ""
    var id = ""
    var projectId = ""
    let date = Date()
    let formatter = DateFormatter()
    var result = ""
    override func viewDidLoad() {
        super.viewDidLoad()
         checkButton.isHidden = true
         let checkBoxTap = UITapGestureRecognizer(target: self, action: #selector(checkBoxAction))
         attachView.addGestureRecognizer(checkBoxTap)
      let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
      tap.cancelsTouchesInView = false
      view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getTokenReq()
    }
    @objc func dismissKeyboard() {
             view.endEditing(true)
       }
    //isPDF checkBox Action
    @objc func checkBoxAction(){
        if checkButton.isHidden == true {
            checkButton.isHidden = false
            ispdf = "1"
        }else{
            checkButton.isHidden = true
            ispdf = "0"
        }
    }

    @IBAction func saveButton(_ sender: UIButton) {
        add_detail()
    }
    
    func add_detail(){
        let userId = UserDefaults.standard.value(forKey: "userId") as? String
        NetworkClient.performRequest(MoreLevelDetailsModel1.self, router: .add_detail(title:  titleTF.text ?? "", level_id:  id , percent: "", is_pdf: ispdf, type: "", values: [""], question_type: "", project_id: projectId, emp_id: userId!), success: { [weak self] (models) in
            print("models\( models)")
            self?.addData = models
            if(models.status == 1){
                JSSAlertView().success(self!,title: "حسنا",text: "تم الحفظ بنجاح")
                 self?.navigationController?.popViewController(animated: true)
            }
            else if (models.status == 0 ){
                JSSAlertView().danger(self!, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
            }
        }){ [weak self] (error) in
          //  JSSAlertView().danger(self!, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
            JSSAlertView().success(self!,title: "حسنا",text: "تم الحفظ بنجاح")
            self?.navigationController?.popViewController(animated: true)
        }
    }
}
