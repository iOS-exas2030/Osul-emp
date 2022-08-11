//
//  addAttachmentsVC.swift
//  AL-HHALIL
//
//  Created by apple on 8/24/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import JSSAlertView
class addAttachmentsVC: UIViewController {

    @IBOutlet weak var nameTF: UITextField!
    
    var ispdf = ""
    var id = ""
    var projectId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        dismiss(animated: true)
    }

//    func add_detail(){
//        NetworkClient.performRequest(MoreLevelDetailsModel.self, router: .add_detail(title: "sayed abdo", level_id: "2", percent: "50", is_pdf: "1", type: "2", values: ["ddfsdf","sdfsd"], question_type: "2", project_id: "14"), success: { [weak self] (models) in
//            print("models\( models)")
//            if(models.status == 1){
//                JSSAlertView().success(self!,title: "حسنا",text: "تم الحفظ بنجاح")
//                 self?.navigationController?.popViewController(animated: true)
//    
//            }
//            else if (models.status == 0 ){
//                JSSAlertView().danger(self!, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
//            }
//        }){ [weak self] (error) in
//        }
//    }
}
