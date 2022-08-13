//
//  smsLogsVC.swift
//  AL-HHALIL
//
//  Created by apple on 1/12/21.
//  Copyright © 2021 Sayed Abdo. All rights reserved.
//

import UIKit
import TransitionButton
class smsLogsVC: BaseVC {
    
    
    @IBOutlet weak var segmentFinancial: UISegmentedControl!
    
    @IBOutlet weak var totalContract: UITextField!
    @IBOutlet weak var totalPaied: UITextField!
    @IBOutlet weak var totalNotPaied: UITextField!
    @IBOutlet weak var mainInfoView: UIView!
    @IBOutlet weak var mailClaimView: UIView!
    var getProject : FinancialProject?
    var smslog = [SMSLogsModelDatum]()
    var allsmslogs : SMSLogsModel?
    var names = [String]()
    var seletectedProject = ""
    var projectId = ""
    var clientId = ""
    var refreshControl = UIRefreshControl()
    var loaderView = UIView()
    var noDataView = UIView()
    var refresDatahBtn = TransitionButton()
    var refreshInterNetBtn = TransitionButton()
    var noInterNetView = UIView()
    var errorView = UIView()
    var refreshErrorBtn = TransitionButton()
    var addFBtn = TransitionButton()
    var firstSelect = 0
    var currentPage = 0
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var projectNameLabel2: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.tableView.delegate = self
        self.tableView.dataSource = self
         getAllProjectSMS()
        // Do any additional setup after loading the view.

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @IBAction func sendClaimAction(_ sender: Any) {
       // mailboxSendPaidReq()
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
extension smsLogsVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("sms.count : \(smslog.count)")
        return smslog.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExplanationsCell", for: indexPath) as! ExplanationsCell
        print("sms.count15 : \(smslog.count)")
        cell.ExplanationsNameLabel.text = smslog[indexPath.row].datumDescription
        cell.dateLabel.text = smslog[indexPath.row].createdAt
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
      if(allsmslogs?.config?.totalRows ?? 0 > 10){
            if indexPath.row == (smslog.count) - 1 {
                if(currentPage == (allsmslogs?.config?.numLinks)! - 1){
                }else{
                    if smslog.count >= 10 {
                       currentPage = currentPage + 1
                       getAllProjectSMS()
                   }
                }
            }
        }
    }
}
//MARK: - Request
extension smsLogsVC{
    
    @objc func getAllProjectSMS(){
        startAllAnimationBtn()
        if Reachability.connectedToNetwork() {
            NetworkClient.performRequest(SMSLogsModel.self, router: .getSmsLogs(config: "\(currentPage)"), success: { [weak self] (models) in
                self?.refreshControl.endRefreshing()
                if(models.status == 1){
                    self?.allsmslogs = models
                    for explanationCounter in models.data!{
                        self?.smslog.append(explanationCounter)
                    }
                    self?.tableView.reloadData()
                    self?.totalContract.text = "\(models.smsLimit ?? 0)"
                    self?.totalPaied.text = "\(models.smsUsed ?? 0)"
                    self?.totalNotPaied.text = "\((models.smsLimit ?? 0) - (models.smsUsed ?? 0) )"
                    self?.hideAllViews()
                }
                else if (models.status == 0 ){
                     self?.hideAllViews()
                     self?.noDataView.isHidden = false
                     self?.refresDatahBtn.addTarget(self, action: #selector(self?.getAllProjectSMS), for: UIControl.Event.touchUpInside)
                }
            }){ [weak self] (error) in
                     self?.hideAllViews()
                     self?.errorView.isHidden = false
                     self?.refreshErrorBtn.addTarget(self, action: #selector(self?.getAllProjectSMS), for: UIControl.Event.touchUpInside)
            }
        }else{
           hideAllViews()
           noInterNetView.isHidden = false
           self.refreshInterNetBtn.addTarget(self, action: #selector(self.getAllProjectSMS), for: UIControl.Event.touchUpInside)
        }
    }
    
}
//MARK: - Loader
extension smsLogsVC{
    func addAllViews(){
        self.errorView(mainNoDataView : &self.errorView, refreshBtn : &self.refreshErrorBtn)
        self.noInterNetView(mainNoDataView : &self.noInterNetView, refreshBtn :  &self.refreshInterNetBtn)
        self.noDataView(mainNoDataView: &self.noDataView, labelData: "لا توجد رسائل حاليا", refreshBtn: &self.refresDatahBtn, addStatus : 0, addFBtn : &addFBtn)
        self.showLoader(mainView: &loaderView)
        self.getTokenReq()
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
