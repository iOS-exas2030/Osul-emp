//
//  CompanyServicesVC.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 8/23/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//



import UIKit
import JSSAlertView
import TransitionButton

class CompanyServicesVC: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var CompanyServicesTableView: UITableView!
    @IBOutlet weak var addCompanyServicesView: UIView!
    //MARK: - Properties
   // var explanations = [ExplanationModelDatum]()
   // var companies = ["شركه اي شي","شركات الوجهات الخارجيه","شركه الديكورات","شركه الاسمت","شركه السيراميك","شركه الرخام"]
   // var dis_degree = ["50","10","84","15","30","25"]
    var companies : CompanyOffersModel?
    var projectId : String!
    var AllCompany = [CompanyOffersModelDatum]()
    var catId = ""
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
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        config()
    }
    func config(){
        addAllViews()
        addFBtn.addTarget(self, action: #selector(addCompanyServices), for: UIControl.Event.touchUpInside)
        self.CompanyServicesTableView.delegate = self
        self.CompanyServicesTableView.dataSource = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addCompanyServices))
        addCompanyServicesView.addGestureRecognizer(tap)
        controllersGetAllCompsReq()
        self.getTokenReq()

    }
    @objc func addCompanyServices(){
        let view = self.storyboard?.instantiateViewController(withIdentifier: "AddCompanyServicesVC") as! AddCompanyServicesVC
        view.addNew = true
        view.catId =  catId
        hideAllViews()
        self.navigationController?.pushViewController(view, animated: true)
    }
}
//MARK: - UITableView Delegate & DataSource
extension CompanyServicesVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AllCompany.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExplanationsCell", for: indexPath) as! ExplanationsCell
        cell.dateLabel.text =  AllCompany[indexPath.row].percent! + "  %  "
        cell.ExplanationsNameLabel.text = AllCompany[indexPath.row].comName
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // CompanyCategoryVC
        let view = self.storyboard?.instantiateViewController(withIdentifier: "AddCompanyServicesVC") as! AddCompanyServicesVC
       // view.currentExplanation = explanations[indexPath.row]
        view.addNew = false
        view.companydis_degree = companies?.data?[indexPath.row].percent ?? ""
        view.companyName = companies?.data?[indexPath.row].comName ?? ""
        view.id = AllCompany[indexPath.row].id!
        self.navigationController?.pushViewController(view, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
}
//MARK: - Request
extension CompanyServicesVC{
    @objc func controllersGetAllCompsReq(){
        startAllAnimationBtn()
        if Reachability.connectedToNetwork() {
            NetworkClient.performRequest(CompanyOffersModel.self, router: .controllersGetAllComps(cat_id: catId), success: { [weak self] (models) in
                print("models\( models.data)")
                self?.companies = models
                if(models.status == 1){
                    self?.AllCompany = models.data!
                    self?.CompanyServicesTableView.reloadData()
                    self?.hideAllViews()
                }
                else if (models.status == 0 ){
                    self?.hideAllViews()
                    self?.noDataView.isHidden = false
                    self?.refresDatahBtn.addTarget(self, action: #selector(self?.controllersGetAllCompsReq), for: UIControl.Event.touchUpInside)
                }
            }){ [weak self] (error) in
                    self?.hideAllViews()
                    self?.errorView.isHidden = false
                    self?.refreshErrorBtn.addTarget(self, action: #selector(self?.controllersGetAllCompsReq), for: UIControl.Event.touchUpInside)
              }
        }else{
                    hideAllViews()
                    noInterNetView.isHidden = false
                    self.refreshInterNetBtn.addTarget(self, action: #selector(self.controllersGetAllCompsReq), for: UIControl.Event.touchUpInside)
        }
    }
    
}

//MARK: - Loader
extension CompanyServicesVC{
    func addAllViews(){
        self.errorView(mainNoDataView : &self.errorView, refreshBtn : &self.refreshErrorBtn)
        self.noInterNetView(mainNoDataView : &self.noInterNetView, refreshBtn :  &self.refreshInterNetBtn)
        self.noDataView(mainNoDataView: &self.noDataView, labelData: "لا توجد خصومات للشركات حاليا", refreshBtn: &self.refresDatahBtn, addStatus : 0, addFBtn : &addFBtn)
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
