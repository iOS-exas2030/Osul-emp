//
//  receiptVC.swift
//  AL-HHALIL
//
//  Created by apple on 8/22/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import JSSAlertView
import TransitionButton

class receiptVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addNewView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var AllReceipt = [FinancialIncomeDatum]()
    var Receipt : FinancialIncomeModel?
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var ReceiptNumber: UITextField!
    @IBOutlet weak var totalPrice: UITextField!
    var totalPriceValue : Double = 0
    
    var reqesrType : Int!
    var refreshControl = UIRefreshControl()
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
       
    }
    override func viewWillAppear(_ animated: Bool) {
         self.getTokenReq()
         config()
    }
    func config(){
          
          addAllViews()
          self.tableView.delegate = self
          self.tableView.dataSource = self
          tableView.registerHeaderNib(cellClass: receiptTitleCell.self)
          
        
          if(reqesrType == 1){
             reloadVC()
             refreshControl.addTarget(self, action: #selector(reloadVC), for: UIControl.Event.valueChanged)
            
             titleLabel.text = "الحسابات الماليه / سندات القبض"
             addFBtn.addTarget(self, action: #selector(addNewButton), for: UIControl.Event.touchUpInside)
          }else{
             reloadVC()
             refreshControl.addTarget(self, action: #selector(reloadVC), for: UIControl.Event.valueChanged)
             
             titleLabel.text = "الحسابات الماليه / سندات الصرف"
             addFBtn.addTarget(self, action: #selector(addNewButton), for: UIControl.Event.touchUpInside)
         }
         tableView.addSubview(refreshControl)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func reloadVC(){
        if(reqesrType == 1){
            AllReceipt.removeAll()
            self.tableView.reloadData()
            currentPage = 0
            getFinancialIncome()
        }else{
            AllReceipt.removeAll()
            self.tableView.reloadData()
            currentPage = 0
            FinancialGetOutcomesReq()
        }
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @IBAction func addNewButton(_ sender: UIButton) {
        let view = self.storyboard?.instantiateViewController(withIdentifier: "receiptDetailsVC") as! receiptDetailsVC
        view.addNew = true
        view.reqesrType = reqesrType
        self.hideAllViews()
        self.navigationController?.pushViewController(view, animated: true)
    }
    
}
extension receiptVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
         let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "receiptTitleCell") as! receiptTitleCell
         return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
      return 70
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  AllReceipt.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "receiptCell", for: indexPath) as! receiptCell
        cell.indexNumberLabel.text = "\(AllReceipt[indexPath.row].id)"
        cell.dateLabel.text = "\(self.getDateFromTimeStamp(timeStamp : Double(AllReceipt[indexPath.row].date)!))"
        cell.projecctNameLabel.text = "\(AllReceipt[indexPath.row].projectName)"
        cell.priceLacel.text = "\(AllReceipt[indexPath.row].amount)"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let view = self.storyboard?.instantiateViewController(withIdentifier: "receiptDetailsVC") as! receiptDetailsVC
        view.oneReceipt = AllReceipt[indexPath.row]
        view.reqesrType = reqesrType
        self.navigationController?.pushViewController(view, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(Receipt?.config?.totalRows ?? 0 > 10){
            if indexPath.row == (AllReceipt.count) - 1 {
                if(currentPage == (Receipt?.config?.numLinks)! - 1){
                }else{
                    currentPage = currentPage + 1
                    if(reqesrType == 1){
                        getFinancialIncome()
                    }else{
                        FinancialGetOutcomesReq()
                    }
                }
            }
        }
    }
}
//MARK: - Requests
extension receiptVC{
    @objc func getFinancialIncome(){
        startAllAnimationBtn()
        if Reachability.connectedToNetwork() {
            NetworkClient.performRequest(FinancialIncomeModel.self, router: .financialGetIncomes(currentPage: "\(currentPage)"), success: { [weak self] (models) in
                self?.refreshControl.endRefreshing()
                self?.Receipt = models
                if(models.status == 1){
                    for receiptCounter in models.data{
                        self?.AllReceipt.append(receiptCounter)
                    }
                    self!.totalPrice.text = "\(models.total ?? 0)"
                    self!.tableView.reloadData()
                    self!.ReceiptNumber.text = "\(models.config?.totalRows ?? 0)"
                    self!.hideAllViews()
                }
                else if (models.status == 0 ){
                    self!.hideAllViews()
                    self!.noDataView.isHidden = false
                    self?.refresDatahBtn.addTarget(self, action: #selector(self?.FinancialGetOutcomesReq), for: UIControl.Event.touchUpInside)
                }
            }){ [weak self] (error) in
                    self!.hideAllViews()
                    self!.errorView.isHidden = false
                    self?.refreshErrorBtn.addTarget(self, action: #selector(self?.FinancialGetOutcomesReq), for: UIControl.Event.touchUpInside)
            }
        }else{
                    hideAllViews()
                    noInterNetView.isHidden = false
                    self.refreshInterNetBtn.addTarget(self, action: #selector(self.FinancialGetOutcomesReq), for: UIControl.Event.touchUpInside)
        }
    }
    @objc func FinancialGetOutcomesReq(){
            startAllAnimationBtn()
            if Reachability.connectedToNetwork() {
                NetworkClient.performRequest(FinancialIncomeModel.self, router: .FinancialGetOutcomes(currentPage: "\(currentPage)"), success: { [weak self] (models) in
                    self?.refreshControl.endRefreshing()
                    self?.Receipt = models
                    if(models.status == 1){
                        for receiptCounter in models.data{
                            self?.AllReceipt.append(receiptCounter)
                        }
                        self!.totalPrice.text = "\(models.total ?? 0)"
                        self!.tableView.reloadData()
                        self!.ReceiptNumber.text = "\(models.config?.totalRows ?? 0)"
                        self!.hideAllViews()
                    }
                    else if (models.status == 0 ){
                        self!.hideAllViews()
                        self!.noDataView.isHidden = false
                        self?.refresDatahBtn.addTarget(self, action: #selector(self?.FinancialGetOutcomesReq), for: UIControl.Event.touchUpInside)
                    }
                }){ [weak self] (error) in
                        self!.hideAllViews()
                        self!.errorView.isHidden = false
                        self?.refreshErrorBtn.addTarget(self, action: #selector(self?.FinancialGetOutcomesReq), for: UIControl.Event.touchUpInside)
                }
            }else{
                        hideAllViews()
                        noInterNetView.isHidden = false
                        self.refreshInterNetBtn.addTarget(self, action: #selector(self.FinancialGetOutcomesReq), for: UIControl.Event.touchUpInside)
            }
    }
}
//MARK: - Loader
extension receiptVC {
    func addAllViews(){
        self.errorView(mainNoDataView : &self.errorView, refreshBtn : &self.refreshErrorBtn)
        self.noInterNetView(mainNoDataView : &self.noInterNetView, refreshBtn :  &self.refreshInterNetBtn)
        self.noDataView(mainNoDataView: &self.noDataView, labelData: "لا توجد سندات حاليا", refreshBtn: &self.refresDatahBtn, addStatus : 0, addFBtn : &addFBtn)
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
