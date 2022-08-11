//
//  FinancialClaimVC.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 10/15/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import JSSAlertView

class FinancialClaimVC: UIViewController {
    
    

    @IBOutlet weak var projectDropDwon: DropDown!
    
    @IBOutlet weak var segmentFinancial: UISegmentedControl!
    
    @IBOutlet weak var totalContract: UITextField!
    @IBOutlet weak var totalPaied: UITextField!
    @IBOutlet weak var totalNotPaied: UITextField!
    @IBOutlet weak var mainInfoView: UIView!
    @IBOutlet weak var mailClaimView: UIView!
    var getProject : FinancialProject?
    
    var names = [String]()
    var seletectedProject = ""
    var projectId = ""
    var clientId = ""
    
    var firstSelect = 0
    
    @IBOutlet weak var claimMassage: UITextView!
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var projectNameLabel2: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        financialGetProject()
        mainInfoView.isHidden = true
        mailClaimView.isHidden = true
        segmentFinancial.isHidden = true
        
        claimMassage.borderWidth = 0.5
        claimMassage.borderColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
        claimMassage.layer.cornerRadius = 12
        claimMassage.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)

        // Do any additional setup after loading the view.
        self.projectDropDwon.didSelect{(selectedText , index ,id) in
            
            if(self.firstSelect == 0){
                self.mainInfoView.isHidden = false
                self.mailClaimView.isHidden = false
                self.segmentFinancial.isHidden = false
                self.firstSelect = 1
            }
            self.seletectedProject = self.getProject?.data?.projects?[index].id ?? ""
            self.projectNameLabel.text = self.getProject?.data?.projects?[index].name ?? ""
            self.projectNameLabel2.text = self.getProject?.data?.projects?[index].name ?? ""
            self.TotalPaidProjectReq()
            self.projectId = self.getProject?.data?.projects?[index].id ?? ""
            self.clientId = self.getProject?.data?.projects?[index].clientID ?? ""
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getTokenReq()
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @IBAction func sendClaimAction(_ sender: Any) {
        mailboxSendPaidReq()
    }
    
    @IBAction func segmantAction(_ sender: Any) {
        
        if(segmentFinancial.selectedSegmentIndex == 0){
            mainInfoView.isHidden = false
            mailClaimView.isHidden = true
            
        }
        if(segmentFinancial.selectedSegmentIndex == 1){
            mainInfoView.isHidden = true
            mailClaimView.isHidden = false
        }
    }
    
}
extension FinancialClaimVC{
    func financialGetProject(){
            NetworkClient.performRequest(FinancialProject.self, router: .financialGetProjects, success: { [weak self] (models) in
                self?.getProject = models
                print("models\( models.data)")
                if(models.status == 1){
                    for projests in (models.data?.projects)! {
                        self?.names.append(projests.name ?? "")
                    }
                    self?.projectDropDwon.optionArray = self?.names ?? [""]
                    self?.projectDropDwon.rowHeight = 50
                }
                else if (models.status == 0 ){
                    JSSAlertView().danger(self!, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
                }
            }){ [weak self] (error) in
                JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
            }
    }
    func TotalPaidProjectReq(){
            NetworkClient.performRequest(TotalPaidProjectModel.self, router: .TotalPaidProject(id: seletectedProject), success: { [weak self] (models) in
                print("models\( models.data)")
                if(models.status == 1){
                    self?.totalContract.text = models.data?[0].paid
                    self?.totalPaied.text = "\(models.data?[0].paidDown ?? 0)"
                    self?.totalNotPaied.text = "\(models.data?[0].paidTerm ?? 0)"
                }
                else if (models.status == 0 ){
                    JSSAlertView().danger(self!, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
                }
            }){ [weak self] (error) in
                JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
            }
    }
    func mailboxSendPaidReq(){
        let userId = UserDefaults.standard.value(forKey: "userId") as? String
        NetworkClient.performRequest(status2Model.self, router: .mailboxSendPaid(project_id: projectId, type: "3", client_id: clientId, emp_id: userId! ?? "", price: claimMassage.text), success: { [weak self] (models) in
                print("models\( models.data)")
                if(models.status == 1){
                    
                    JSSAlertView().success(self!,title: "حسنا",text: models.arMsg, buttonText: "موافق")
                    self?.claimMassage.text = ""
                }
                else if (models.status == 0 ){
                    JSSAlertView().danger(self!, title: "عذرا", text: models.arMsg, buttonText: "موافق")
                }
            }){ [weak self] (error) in
                JSSAlertView().danger(self!, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
            }
    }
}
