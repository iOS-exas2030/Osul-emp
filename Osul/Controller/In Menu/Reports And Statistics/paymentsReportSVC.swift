//
//  paymentsReportSVC.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 8/27/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import JSSAlertView
import TransitionButton

class paymentsReportSVC: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var totalPaidLabel: UILabel!
    @IBOutlet weak var totalRemainLabel: UILabel!
 
    //MARK: - Properties
    var paymentsReportArr = [paymentsReportsModelDatum]()
    var allPaymentsReport : paymentsReportsModel?
    var header = ["نوع المشروع","تاريخ الطلب","اسم العميل","م"]
    var refreshControl = UIRefreshControl()
    var myNewView = UIView()
    var totalPaid = 0.0
    var totalRemain = 0.0
    var currentPage = 0
    
    
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
        // Do any additional setup after loading the view.
        config()
    }
    override func viewWillAppear(_ animated: Bool) {
        getTokenReq()
    }
    func config(){
        addAllViews()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.registerHeaderNib(cellClass: newOrderTitleCell.self)
        refreshControl.addTarget(self, action: #selector(reloadVC), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        reportGetClientReq()
    }
    @objc func reloadVC(){
        paymentsReportArr.removeAll()
        self.tableView.reloadData()
        currentPage = 0
        reportGetClientReq()
    }
}
//MARK: - UITableView Delegate & DataSource
extension paymentsReportSVC : UITableViewDelegate , UITableViewDataSource{
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentsReportArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "paymentsReportsCell", for: indexPath) as! paymentsReportsCell
            cell.projectName.text = paymentsReportArr[indexPath.row].proName
            cell.totlaPatmentLabel.text = "\(paymentsReportArr[indexPath.row].paid)" + " ريال "
            cell.totalNotType.text = "\(paymentsReportArr[indexPath.row].remain)" + " ريال "
            return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(allPaymentsReport?.config?.totalRows ?? 0 > 10){
            if indexPath.row == (paymentsReportArr.count) - 1 {
                if(currentPage == (allPaymentsReport?.config?.numLinks)! - 1){
                }else{
                    currentPage = currentPage + 1
                    reportGetClientReq()
                }
            }
        }
    }
}
//MARK: - Requests
extension paymentsReportSVC{
    @objc func reportGetClientReq(){
        startAllAnimationBtn()
        if Reachability.connectedToNetwork() {
            NetworkClient.performRequest(paymentsReportsModel.self, router: .reportGetClient(currentPage: "\(currentPage)"), success: { [weak self] (models) in
                print("models\( models)")
                self!.refreshControl.endRefreshing()
                self?.allPaymentsReport = models
                if(models.status == 1){
                    for totalCounter in models.data{
                        self?.totalPaid += Double(totalCounter.paid)
                        self?.totalRemain += Double(totalCounter.remain)
                        self?.paymentsReportArr.append(totalCounter)
                    }
                    self!.tableView.reloadData()
                    self!.totalPaidLabel.text =  "\(self!.totalPaid) ريال"
                    self!.totalRemainLabel.text =  "\(self!.totalRemain) ريال"
                    self!.hideAllViews()
                }
                else if (models.status == 0 ){
                    self!.hideAllViews()
                    self!.noDataView.isHidden = false
                    self?.refresDatahBtn.addTarget(self, action: #selector(self?.reportGetClientReq), for: UIControl.Event.touchUpInside)
                }
            }){ [weak self] (error) in
                    self!.hideAllViews()
                    self!.errorView.isHidden = false
                    self?.refreshErrorBtn.addTarget(self, action: #selector(self?.reportGetClientReq), for: UIControl.Event.touchUpInside)
            }
        }else{
           hideAllViews()
           noInterNetView.isHidden = false
           self.refreshInterNetBtn.addTarget(self, action: #selector(self.reportGetClientReq), for: UIControl.Event.touchUpInside)
        }
    }
}
//MARK: - Loader
extension paymentsReportSVC{
    func addAllViews(){
        self.errorView(mainNoDataView : &self.errorView, refreshBtn : &self.refreshErrorBtn)
        self.noInterNetView(mainNoDataView : &self.noInterNetView, refreshBtn :  &self.refreshInterNetBtn)
        self.noDataView(mainNoDataView: &self.noDataView, labelData: "تفاصيل العقد غير متاحه حاليا", refreshBtn: &self.refresDatahBtn, addStatus : 1, addFBtn : &addFBtn)
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
