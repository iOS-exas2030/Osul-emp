//
//  ExplanationsVC.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 8/13/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import JSSAlertView
import TransitionButton

class ExplanationsVC: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var explanationTableView: UITableView!
    @IBOutlet weak var addExplanationView: UIView!
    //MARK: - Properties
    var explanations = [ExplanationModelDatum]()
    var allExplanations : ExplanationModel?
    var projectId : String!
    var refreshControl = UIRefreshControl()
    var myNewView = UIView()
    
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


    //MARK: - View Controller Builder
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
        self.explanationTableView.delegate = self
        self.explanationTableView.dataSource = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addExplanation))
        addExplanationView.addGestureRecognizer(tap)
        getAllProjectExplanation()
        refreshControl.addTarget(self, action: #selector(reloadVC), for: UIControl.Event.valueChanged)
        explanationTableView.addSubview(refreshControl)
    }
    @objc func reloadVC(){
        explanations.removeAll()
        self.explanationTableView.reloadData()
        currentPage = 0
        getAllProjectExplanation()
    }
    @objc func addExplanation(){
        let view = self.storyboard?.instantiateViewController(withIdentifier: "AddExplanationVC") as! AddExplanationVC
        view.addNew = true
        view.fromAll = true
        view.projectId = projectId
        self.navigationController?.pushViewController(view, animated: true)
    }
    
}
//MARK: - UITableView Delegate & DataSource
extension ExplanationsVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("explanations.count : \(explanations.count)")
        return explanations.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExplanationsCell", for: indexPath) as! ExplanationsCell
        print("explanations.count15 : \(explanations.count)")
        cell.ExplanationsNameLabel.text = explanations[indexPath.row].title
        cell.dateLabel.text = explanations[indexPath.row].date
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let view = self.storyboard?.instantiateViewController(withIdentifier: "AddExplanationVC") as! AddExplanationVC
        view.ExplanationContract = explanations[indexPath.row]
        view.addNew = false
        view.fromAll = true
        self.navigationController?.pushViewController(view, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
      if(allExplanations?.config?.totalRows ?? 0 > 10){
            if indexPath.row == (explanations.count) - 1 {
                if(currentPage == (allExplanations?.config?.numLinks)! - 1){
                }else{
                    if explanations.count >= 10 {
                       currentPage = currentPage + 1
                       getAllProjectExplanation()
                   }
                }
            }
        }
    }
}
//MARK: - Request
extension ExplanationsVC{
    
    @objc func getAllProjectExplanation(){
        startAllAnimationBtn()
        if Reachability.connectedToNetwork() {
            NetworkClient.performRequest(ExplanationModel.self, router: .getAllProjectExplanation(id: projectId, currentPage: "\(currentPage)"), success: { [weak self] (models) in
                self?.refreshControl.endRefreshing()
                if(models.status == 1){
                    self?.allExplanations = models
                    for explanationCounter in models.data{
                        self?.explanations.append(explanationCounter)
                    }
                    self?.explanationTableView.reloadData()
                    self?.hideAllViews()
                }
                else if (models.status == 0 ){
                     self?.hideAllViews()
                     self?.noDataView.isHidden = false
                     self?.refresDatahBtn.addTarget(self, action: #selector(self?.getAllProjectExplanation), for: UIControl.Event.touchUpInside)
                }
            }){ [weak self] (error) in
                     self?.hideAllViews()
                     self?.errorView.isHidden = false
                     self?.refreshErrorBtn.addTarget(self, action: #selector(self?.getAllProjectExplanation), for: UIControl.Event.touchUpInside)
            }
        }else{
           hideAllViews()
           noInterNetView.isHidden = false
           self.refreshInterNetBtn.addTarget(self, action: #selector(self.getAllProjectExplanation), for: UIControl.Event.touchUpInside)
        }
    }
    
}
//MARK: - Loader
extension ExplanationsVC{
    func addAllViews(){
        self.errorView(mainNoDataView : &self.errorView, refreshBtn : &self.refreshErrorBtn)
        self.noInterNetView(mainNoDataView : &self.noInterNetView, refreshBtn :  &self.refreshInterNetBtn)
        self.noDataView(mainNoDataView: &self.noDataView, labelData: "لا توجد شروحات حاليا", refreshBtn: &self.refresDatahBtn, addStatus : 0, addFBtn : &addFBtn)
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
