//
//  tryViewController.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 7/15/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit

class tryViewController: UIViewController {
    var all_Users  = [Employee]()
    var user_info : Employee!
    var all_Client : Client!
    var all_states : States!
    var all_branche : Branche!
    var all_users_groups : UserGroup!
    var get_all_contract : Contracts!
    var get_all_level : Levels!
    var all_level_details : Level_Details!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  get_all_users()
      //  get_user_info(id: "4")
     //   add_user_info()
     //   edit_user_info()
     //   get_all_clients()
    //    add_clients()
    //    edit_clients()
     //   get_all_status()
    //     add_status()
    //    edit_status()
      //  get_all_branche()
    //    add_branche()
     //   edit_branche()
      //  get_all_users_groups()
     //   add_users_groups()
      //  edit_users_groups()
     //   remove_user_info(id : "1")
      //  add_user_info()
      //  add_clients()
       // get_clients_info()
      //  remove_clients_info()
      //  get_status_info(id : "24")
     //   remove_status_info(id : "24")
      //  get_branche_info(id : "9")
      //  remove_branche_info(id : "9")
       // get_all_contracts()
       // add_contracts()
     //   edit_contracts()
      //  remove_contracts()
    //    get_contract_info()
     //   get_all_levels()
    //    add_levels()
     //   edit_level()
    //    remove_level()
     //   get_level_info()
   //     get_level_by_contract()
     //   get_all_level_details()
      //  add_level_details()
     //   edit_level_details()
    //    remove_level_details()
     //   get_level_details_info()
    //    get_level_details_by_level()
       // getAllNewClientOrder()
     //   getnewOrderDetails()
      //  editOrderData()
     //   acceptNewOrder()
     //   cancelNewOrder()
      //  getAllContract()
      //  contractDetails()
      //  editContractData()
     //   getAllProjectExplanation()
     //   explanationDetails()
     //   addExplanation()
     //   getAllProject()
     //   get_project_levels()
      //  get_level_details()
     //   add_detail()
       // get_assigned_users(LevelId: "2")
       // New_assigned_users(LevelId: "4")
      //  getAllProject()
      //  financialGetProject()
       // getFinancialIncome()
     //   FinancialAddIncomeReq()
     //   FinancialRemoveIncomeReq()
     //   FinancialGetOutcomesReq()
      //  FinancialAddOutcomeReq()
       // FinancialRemoveOutcomeReq()
     //   financialClientSearchReq()
       // financialProjectSearchReq()
        // Do any additional setup after loading the view.
    }
    
    func get_all_users_groups(){
        NetworkClient.performRequest(UserGroup.self, router: .get_all_users_groups, success: { [weak self] (models) in
            self?.all_users_groups = models
            print("models\( models)")
            if(models.status == 1){
              let model = models.data[0]
            }
            else if (models.status == 0 ){
            }
        }){ [weak self] (error) in
            }
    }
//    func add_users_groups(){
//        NetworkClient.performRequest(UserGroup.self, router: .add_users_group(title: "qweqwe", is_client_order: "1", is_contracting: "1", is_projects: "1", is_report: "1", is_financial: "1", is_settings: "1"), success: { [weak self] (models) in
//            self?.all_users_groups = models
//            print("models\( models)")
//            if(models.status == 1){
//              let model = models.data[0]
//            }
//            else if (models.status == 0 ){
//            }
//        }){ [weak self] (error) in
//            }
//    }
    
//    func edit_users_groups(){
//        NetworkClient.performRequest(UserGroup.self, router: .edit_users_group(users_group_id: "7", title: "wwww", is_client_order: "1", is_contracting: "1", is_projects: "1", is_report: "1", is_financial: "1", is_settings: "1"), success: { [weak self] (models) in
//            self?.all_users_groups = models
//            print("models\( models)")
//            if(models.status == 1){
//              let model = models.data[0]
//            }
//            else if (models.status == 0 ){
//            }
//        }){ [weak self] (error) in
//            }
//    }
    func remove_users_groups_info(id : String){
        NetworkClient.performRequest(UserGroup.self, router: .remove_users_group(id: id), success: { [weak self] (models) in
                  self?.all_users_groups = models
                  print("models\( models)")
                  if(models.status == 1){
                    let model = models.data[0]
                  }
                  else if (models.status == 0 ){
                  }
              }){ [weak self] (error) in
                  }
          }
    func get_users_groups_info(id : String){
        NetworkClient.performRequest(UserGroup.self, router: .users_group_info(id: id), success: { [weak self] (models) in
               self?.all_users_groups = models
               print("models\( models)")
               if(models.status == 1){
                 let model = models.data[0]
               }
               else if (models.status == 0 ){
               }
           }){ [weak self] (error) in
               }
       }
}
// user
extension tryViewController{
//    func get_all_users(){
//           NetworkClient.performRequest(Employee.self, router: .get_all_users, success: { [weak self] (models) in
//               self?.all_Users = [models]
//               print("models\( models)")
//               if(models.status == 1){
//                   let model = models.data[0]
//               }
//               else if (models.status == 0 ){
//               }
//           }){ [weak self] (error) in
//           }
//       }
       func get_user_info(id : String){
                 NetworkClient.performRequest(Employee.self, router: .get_user_info(id: id), success: { [weak self] (models) in
                     self?.user_info = models
                     print("models\( models)")
                     if(models.status == 1){
                       let model = models.data[0]
                     }
                     else if (models.status == 0 ){
                     }
                 }){ [weak self] (error) in
                     }
         }
       func add_user_info(){
        NetworkClient.performRequest(Employee.self, router: .add_user(name: "sayed1515", email: "sayed15555156@gmail.com", phone: "12345615157896", password: "1234561515", jop_type: "1", users_group: "1", branche: "1", state: "1", address: "add15", is_active: "1", msg: "1515"), success: { [weak self] (models) in
                 self?.user_info = models
                 print("models\( models)")
                 if(models.status == 1){
                   let model = models.data[0]
                 }
                 else if (models.status == 0 ){
                 }
             }){ [weak self] (error) in
            }
        }
//       func edit_user_info(){
//        NetworkClient.performRequest(Employee.self, router: .edit_user(user_id: "11", name: "sayed123999558", email: "sayed123999@gmail.com", phone: "123", password: "12345699", jop_type: "1", users_group: "1", branche: "1", state: "1", address: "add", is_active: "1", msg: ""), success: { [weak self] (models) in
//                self?.user_info = models
//                print("models\( models)")
//                if(models.status == 1){
//                  let model = models.data[0]
//                }
//                else if (models.status == 0 ){
//                }
//            }){ [weak self] (error) in
//           }
//       }
    func remove_user_info(id : String){
            NetworkClient.performRequest(Employee.self, router: .remove_user(id: id), success: { [weak self] (models) in
                self?.user_info = models
                print("models\( models)")
                if(models.status == 1){
                  let model = models.data[0]
                }
                else if (models.status == 0 ){
                }
            }){ [weak self] (error) in
                }
    }
}
// client
extension tryViewController{
//    func get_all_clients(){
//        NetworkClient.performRequest(Client.self, router: .get_all_clients, success: { [weak self] (models) in
//            self?.all_Client = models
//            print("models\( models)")
//            if(models.status == 1){
//              let model = models.data[0]
//            }
//            else if (models.status == 0 ){
//            }
//        }){ [weak self] (error) in
//            }
//    }
    
    func add_clients(){
        NetworkClient.performRequest(Client.self, router: .add_client(name: "sss sayed88", email: "sayed777995588@gmail.com", phone: "569855599969856", password: "56955555856888", users_group: "1", branche: "1", state: "1", address: "vzdfadsf", is_active: "1"), success: { [weak self] (models) in
            self?.all_Client = models
            print("models\( models)")
            if(models.status == 1){
              let model = models.data[0]
            }
            else if (models.status == 0 ){
            }
        }){ [weak self] (error) in
            }
    }
//    func edit_clients(){
//        NetworkClient.performRequest(Client.self, router: .edit_client(client_id: "8", name: "sayed", email: "sayed7779918@gmail.com", phone: "5698599969856", password: "5698568", users_group: "1", branche: "1", state: "1", address: "vzdfadsf", msg: "18", is_active: "1"), success: { [weak self] (models) in
//            self?.all_Client = models
//            print("models\( models)")
//            if(models.status == 1){
//              let model = models.data[0]
//            }
//            else if (models.status == 0 ){
//            }
//        }){ [weak self] (error) in
//            }
//    }
    
    func get_clients_info(id : String){
        NetworkClient.performRequest(Client.self, router: .client_info(id: id), success: { [weak self] (models) in
            self?.all_Client = models
            print("models\( models)")
            if(models.status == 1){
              let model = models.data[0]
            }
            else if (models.status == 0 ){
            }
        }){ [weak self] (error) in
            }
    }
    func remove_clients_info(){
        NetworkClient.performRequest(Client.self, router: .remove_clients(id: "9"), success: { [weak self] (models) in
            self?.all_Client = models
            print("models\( models)")
            if(models.status == 1){
              let model = models.data[0]
            }
            else if (models.status == 0 ){
            }
        }){ [weak self] (error) in
            }
    }

}
// status
extension tryViewController{
    func get_all_status(){
           NetworkClient.performRequest(States.self, router: .get_all_states, success: { [weak self] (models) in
               self?.all_states = models
               print("models\( models)")
               if(models.status == 1){
                 let model = models.data[0]
               }
               else if (models.status == 0 ){
               }
           }){ [weak self] (error) in
               }
       }
       func add_status(){
           NetworkClient.performRequest(States.self, router: .addState(title: "zzzzz"), success: { [weak self] (models) in
               self?.all_states = models
               print("models\( models)")
               if(models.status == 1){
                 let model = models.data[0]
               }
               else if (models.status == 0 ){
               }
           }){ [weak self] (error) in
               }
       }
       func edit_status(){
           NetworkClient.performRequest(States.self, router: .edit_state(state_id: "3", title: "qqqqq"), success: { [weak self] (models) in
               self?.all_states = models
               print("models\( models)")
               if(models.status == 1){
                 let model = models.data[0]
               }
               else if (models.status == 0 ){
               }
           }){ [weak self] (error) in
               }
       }
    func get_status_info(id : String){
        NetworkClient.performRequest(States.self, router: .stateInfo(id: id), success: { [weak self] (models) in
            self?.all_states = models
            print("models\( models)")
            if(models.status == 1){
              let model = models.data[0]
            }
            else if (models.status == 0 ){
            }
        }){ [weak self] (error) in
            }
    }
    
    func remove_status_info(id : String){
        NetworkClient.performRequest(States.self, router: .remove_state(id: id), success: { [weak self] (models) in
            self?.all_states = models
            print("models\( models)")
            if(models.status == 1){
              let model = models.data[0]
            }
            else if (models.status == 0 ){
            }
        }){ [weak self] (error) in
            }
    }
}
// branche
extension tryViewController{
    func get_all_branche(){
         NetworkClient.performRequest(Branche.self, router: .get_all_branches, success: { [weak self] (models) in
             self?.all_branche = models
             print("models\( models)")
             if(models.status == 1){
               let model = models.data[0]
             }
             else if (models.status == 0 ){
             }
         }){ [weak self] (error) in
             }
     }
     func add_branche(){
         NetworkClient.performRequest(Branche.self, router: .add_branche(title: "zzzasdasd", state: "1", address: "asdasd", phone: "asdas"), success: { [weak self] (models) in
             self?.all_branche = models
             print("models\( models)")
             if(models.status == 1){
               let model = models.data[0]
             }
             else if (models.status == 0 ){
             }
         }){ [weak self] (error) in
             }
     }
     func edit_branche(){
         NetworkClient.performRequest(Branche.self, router: .edit_branche(branche_id: "8", title: "ttttttttt", state: "1", address: "asdasd", phone: "asdas"), success: { [weak self] (models) in
             self?.all_branche = models
             print("models\( models)")
             if(models.status == 1){
               let model = models.data[0]
             }
             else if (models.status == 0 ){
             }
         }){ [weak self] (error) in
             }
     }
    func get_branche_info(id : String){
        NetworkClient.performRequest(Branche.self, router: .brancheInfo(id: id), success: { [weak self] (models) in
            self?.all_branche = models
            print("models\( models)")
            if(models.status == 1){
              let model = models.data[0]
            }
            else if (models.status == 0 ){
            }
        }){ [weak self] (error) in
            }
    }
    func remove_branche_info(id : String){
        NetworkClient.performRequest(Branche.self, router: .remove_branche(id: id), success: { [weak self] (models) in
            self?.all_branche = models
            print("models\( models)")
            if(models.status == 1){
              let model = models.data[0]
            }
            else if (models.status == 0 ){
            }
        }){ [weak self] (error) in
            }
    }
}
// contracts
extension tryViewController{
    func get_all_contracts(){
        NetworkClient.performRequest(Contracts.self, router: .get_all_contracts, success: { [weak self] (models) in
            self?.get_all_contract = models
            print("models\( models)")
            if(models.status == 1){
              let model = models.data[0]
            }
            else if (models.status == 0 ){
            }
        }){ [weak self] (error) in
            }
    }
    func add_contracts(){
        NetworkClient.performRequest(Contracts.self, router: .add_contract(title: "sayed", color: "#FFFFFF"), success: { [weak self] (models) in
            self?.get_all_contract = models
            print("models\( models)")
            if(models.status == 1){
              let model = models.data[0]
            }
            else if (models.status == 0 ){
            }
        }){ [weak self] (error) in
            }
    }
    func edit_contracts(){
        NetworkClient.performRequest(Contracts.self, router: .edit_contract(contract_id: "5",title: "Sayed Abdo", color: "#000000"), success: { [weak self] (models) in
            self?.get_all_contract = models
            print("models\( models)")
            if(models.status == 1){
              let model = models.data[0]
            }
            else if (models.status == 0 ){
            }
        }){ [weak self] (error) in
            }
    }
    func remove_contracts(){
        NetworkClient.performRequest(Contracts.self, router: .remove_contract(id: "5"), success: { [weak self] (models) in
            self?.get_all_contract = models
            print("models\( models)")
            if(models.status == 1){
          //    let model = models.data[0]
            }
            else if (models.status == 0 ){
            }
        }){ [weak self] (error) in
            }
    }
    
    func get_contract_info(){
        NetworkClient.performRequest(Contracts.self, router: .get_contract_info(id: "2"), success: { [weak self] (models) in
            self?.get_all_contract = models
            print("models\( models)")
            if(models.status == 1){
          //    let model = models.data[0]
            }
            else if (models.status == 0 ){
            }
        }){ [weak self] (error) in
            }
    }
    
}
// Levels
extension tryViewController{
    
    
    func get_all_levels(){
        NetworkClient.performRequest(Levels.self, router: .get_all_levels, success: { [weak self] (models) in
            self?.get_all_level = models
            print("models\( models)")
            if(models.status == 1){
              let model = models.data[0]
            }
            else if (models.status == 0 ){
            }
        }){ [weak self] (error) in
            }
    }
    func add_levels(){
        NetworkClient.performRequest(Levels.self, router: .add_level(title: "sayed sayed", percent: "60", contract_id: "1", type: "1"), success: { [weak self] (models) in
            self?.get_all_level = models
            print("models\( models)")
            if(models.status == 1){
              let model = models.data[0]
            }
            else if (models.status == 0 ){
            }
        }){ [weak self] (error) in
            }
    }
    func edit_level(){
        NetworkClient.performRequest(Levels.self, router: .edit_level(level_id: "1", title: "مرحلة التصميم2", percent: "60", contract_id: "2", type: "1"), success: { [weak self] (models) in
            self?.get_all_level = models
            print("models\( models)")
            if(models.status == 1){
              let model = models.data[0]
            }
            else if (models.status == 0 ){
            }
        }){ [weak self] (error) in
            }
    }
    func remove_level(){
        NetworkClient.performRequest(Levels.self, router: .remove_level(id: "4"), success: { [weak self] (models) in
            self?.get_all_level = models
            print("models\( models)")
            if(models.status == 1){
            //  let model = models.data[0]
            }
            else if (models.status == 0 ){
            }
        }){ [weak self] (error) in
            }
    }
    func get_level_info(){
        NetworkClient.performRequest(Levels.self, router: .get_level_info(id: "3"), success: { [weak self] (models) in
            self?.get_all_level = models
            print("models\( models)")
            if(models.status == 1){
            //  let model = models.data[0]
            }
            else if (models.status == 0 ){
            }
        }){ [weak self] (error) in
        }
    }
   func get_level_by_contract(){
        NetworkClient.performRequest(Levels.self, router: .get_level_by_contract(id: "2"), success: { [weak self] (models) in
            self?.get_all_level = models
            print("models\( models)")
            if(models.status == 1){
            //  let model = models.data[0]
            }
            else if (models.status == 0 ){
            }
        }){ [weak self] (error) in
        }
    }
}
// Level_Details
extension tryViewController{
    func get_all_level_details(){
        NetworkClient.performRequest(Level_Details.self, router: .get_all_level_detailss, success: { [weak self] (models) in
            self?.all_level_details = models
            print("models\( models)")
            if(models.status == 1){
            //  let model = models.data[0]
            }
            else if (models.status == 0 ){
            }
        }){ [weak self] (error) in
        }
    }
    
    func add_level_details(){
        NetworkClient.performRequest(Level_Details.self, router: .add_level_details(title: "sayed ", level_id: "12", percent: "50", is_pdf: "1", type: "1 ", values: ["aa"], question_type: "1"), success: { [weak self] (models) in
            self?.all_level_details = models
            print("models\( models)")
            if(models.status == 1){
            //  let model = models.data[0]
            }
            else if (models.status == 0 ){
            }
        }){ [weak self] (error) in
        }
    }
    func edit_level_details(){
        NetworkClient.performRequest(Level_Details.self, router: .edit_level_details(level_details_id: "3", title: "sayed ", level_id: "12", percent: "100", is_pdf: "1", type: "1 ", values: ["aa"], question_type: "1"), success: { [weak self] (models) in
            self?.all_level_details = models
            print("models\( models)")
            if(models.status == 1){
            //  let model = models.data[0]
            }
            else if (models.status == 0 ){
            }
        }){ [weak self] (error) in
        }
    }
    func remove_level_details(){
        NetworkClient.performRequest(Level_Details.self, router: .remove_level_details(id: "3"), success: { [weak self] (models) in
            self?.all_level_details = models
            print("models\( models)")
            if(models.status == 1){
            //  let model = models.data[0]
            }
            else if (models.status == 0 ){
            }
        }){ [weak self] (error) in
        }
    }
    
    func get_level_details_info(){
        NetworkClient.performRequest(Level_Details.self, router: .get_level_details_info(id: "2"), success: { [weak self] (models) in
            self?.all_level_details = models
            print("models\( models)")
            if(models.status == 1){
            //  let model = models.data[0]
            }
            else if (models.status == 0 ){
            }
        }){ [weak self] (error) in
        }
    }
    
    
    func get_level_details_by_level(){
        NetworkClient.performRequest(Level_Details.self, router: .get_level_details_info(id: "1"), success: { [weak self] (models) in
            self?.all_level_details = models
            print("models\( models)")
            if(models.status == 1){
            //  let model = models.data[0]
            }
            else if (models.status == 0 ){
            }
        }){ [weak self] (error) in
        }
    }
    
}
//client order
extension tryViewController{
//    func getAllNewClientOrder(){
//        NetworkClient.performRequest(ClinetOrder.self, router: .getAllNewClientOrder, success: { [weak self] (models) in
//            print("models\( models)")
//            if(models.status == 1){
//            //  let model = models.data[0]
//            }
//            else if (models.status == 0 ){
//            }
//        }){ [weak self] (error) in
//        }
//    }
    func getnewOrderDetails(){
        NetworkClient.performRequest(OrderData.self, router: .newOrderDetails(id: "14"), success: { [weak self] (models) in
            print("models\( models)")
            if(models.status == 1){
            //  let model = models.data[0]
            }
            else if (models.status == 0 ){
            }
        }){ [weak self] (error) in
        }
    }
    func editOrderData(){
        NetworkClient.performRequest(OrderData.self, router: .editOrderData(project_id: "14", emp_id: "3", phone: "01065778840", contract_id: "2", lat: "31.3", lng: "31.3", name: "fsfsd"), success: { [weak self] (models) in
            print("models\( models)")
            if(models.status == 1){
            //  let model = models.data[0]
            }
            else if (models.status == 0 ){
            }
        }){ [weak self] (error) in
        }
    }
    func acceptNewOrder(){
        NetworkClient.performRequest(statusModel.self, router: .acceptNewOrder(emp_id: "3", project_id: "14"), success: { [weak self] (models) in
            print("models\( models)")
            if(models.status == 1){
            //  let model = models.data[0]
            }
            else if (models.status == 0 ){
            }
        }){ [weak self] (error) in
        }
    }
    func cancelNewOrder(){
        NetworkClient.performRequest(statusModel.self, router: .cancelNewOrder(emp_id: "3", project_id: "14"), success: { [weak self] (models) in
            print("models\( models)")
            if(models.status == 1){
            //  let model = models.data[0]
            }
            else if (models.status == 0 ){
            }
        }){ [weak self] (error) in
        }
    }

}
//contract
extension tryViewController{
    
//    func getAllContract(){
//        NetworkClient.performRequest(ContractModel.self, router: .getAllContract(id: userId!), success: { [weak self] (models) in
//            print("models\( models)")
//            if(models.status == 1){
//            //  let model = models.data[0]
//            }
//            else if (models.status == 0 ){
//            }
//        }){ [weak self] (error) in
//        }
//    }
    
    func contractDetails(){
        NetworkClient.performRequest(ContractDetails.self, router: .contractDetails(id : "14"), success: { [weak self] (models) in
            print("models\( models)")
            if(models.status == 1){
            //  let model = models.data[0]
            }
            else if (models.status == 0 ){
            }
        }){ [weak self] (error) in
        }
    }
    
    func editContractData(){
        NetworkClient.performRequest(OrderData.self, router: .editContractData(project_id: "14", emp_id: "3", phone: "01065778840", contract_id: "2", lat: "31.3", lng: "31.3", name: "5555"), success: { [weak self] (models) in
            print("models\( models)")
            if(models.status == 1){
            //  let model = models.data[0]
            }
            else if (models.status == 0 ){
            }
        }){ [weak self] (error) in
        }
    }
}
// explanation
extension tryViewController{
//    func getAllProjectExplanation(){
//        NetworkClient.performRequest(ExplanationModel.self, router: .getAllProjectExplanation(id: "14"), success: { [weak self] (models) in
//            print("models\( models)")
//            if(models.status == 1){
//            //  let model = models.d1ata[0]
//            }
//            else if (models.status == 0 ){
//            }
//        }){ [weak self] (error) in
//        }
//    }
    func explanationDetails(){
        NetworkClient.performRequest(ExplanationDetails.self, router: .explanationDetails(id: "3"), success: { [weak self] (models) in
            print("models\( models)")
            if(models.status == 1){
            //  let model = models.data[0]
            }
            else if (models.status == 0 ){
            }
        }){ [weak self] (error) in
        }
    }
    func addExplanation(){
        NetworkClient.performRequest(statusModel.self, router: .addExplanation(title: "sayed abdo", comments: "sayed 123", date: "2020-08-14", time: "08:13:16", emp_id: "3", project_id: "14"), success: { [weak self] (models) in
            print("models\( models)")
            if(models.status == 1){
            //  let model = models.data[0]
            }
            else if (models.status == 0 ){
            }
        }){ [weak self] (error) in
        }
    }
}
//project Home
extension tryViewController{
    
//    func getAllProject(){
//        NetworkClient.performRequest(ProjectModel.self, router: .getAllProject(id: "4"), success: { [weak self] (models) in
//            print("models\( models)")
//            if(models.status == 1){
//            //  let model = models.d1ata[0]
//            }
//            else if (models.status == 0 ){
//            }
//        }){ [weak self] (error) in
//        }
//    }
    func get_project_levels(){
        NetworkClient.performRequest(ProjectLevelsModel.self, router: .get_project_levels(projectId: "14", empId: "6"), success: { [weak self] (models) in
            print("models\( models)")
            if(models.status == 1){
            //  let model = models.d1ata[0]
            }
            else if (models.status == 0 ){
            }
        }){ [weak self] (error) in
        }
    }
    func get_level_details(){
        NetworkClient.performRequest(LevelDetailsModel.self, router: .get_level_details(levelId: "2", empId: "4"), success: { [weak self] (models) in
            print("models\( models)")
            if(models.status == 1){
            //  let model = models.d1ata[0]
            }
            else if (models.status == 0 ){
            }
        }){ [weak self] (error) in
        }
    }
    
//    func add_detail(){
//        NetworkClient.performRequest(status1Model.self, router: .add_detail(title: "sayed abdo", level_id: "2", percent: "50", is_pdf: "1", type: "2", values: ["ddfsdf","sdfsd"], question_type: "2", project_id: "14"), success: { [weak self] (models) in
//            print("models\( models)")
//            if(models.status == 1){
//            //  let model = models.d1ata[0]
//            }
//            else if (models.status == 0 ){
//            }
//        }){ [weak self] (error) in
//        }
//    }
//    func get_assigned_users(LevelId : String){
//        NetworkClient.performRequest(AssignModel.self, router: .get_assigned_users(level_id: LevelId), success: { [weak self] (models) in
//           //  self?.assign = models
//            print("models\( models.data)")
//             if(models.status == 1){
//            
//             }
//             else if (models.status == 0 ){
//             }
//         }){ [weak self] (error) in
//         }
//     }
    
    
//    func New_assigned_users(LevelId : String){
//        NetworkClient.performRequest(statusModel.self, router: .assign_user( emp: "6", level_id: "2", project_id: "14"), success: { [weak self] (models) in
//          //  self?.assign = models
//           print("models\( models.data)")
//            if(models.status == 1){
//            }
//            else if (models.status == 0 ){
//            }
//        }){ [weak self] (error) in
//        }
//    }
}
// financial
extension tryViewController{

    func financialGetProject(){
        NetworkClient.performRequest(FinancialProject.self, router: .financialGetProjects, success: { [weak self] (models) in
            print("models\( models.data)")
            if(models.status == 1){
            }
            else if (models.status == 0 ){
            }
        }){ [weak self] (error) in
        }
    }
//    func getFinancialIncome(){
//        NetworkClient.performRequest(FinancialIncomeModel.self, router: .financialGetIncomes, success: { [weak self] (models) in
//            print("models\( models.data)")
//            if(models.status == 1){
//            }
//            else if (models.status == 0 ){
//            }
//        }){ [weak self] (error) in
//        }
//    }
    func FinancialAddIncomeReq(){
        NetworkClient.performRequest(FinancialAddIncome.self, router: .financialAddIncome(project_id: "14", amount: "2", details: "no no", type: "1"), success: { [weak self] (models) in
            print("models\( models.data)")
            if(models.status == 1){
            }
            else if (models.status == 0 ){
            }
        }){ [weak self] (error) in
        }
    }
    
    func FinancialRemoveIncomeReq(){
        NetworkClient.performRequest(statusModel.self, router: .FinancialRemoveIncome(id: "1"), success: { [weak self] (models) in
            print("models\( models.data)")
            if(models.status == 1){
            }
            else if (models.status == 0 ){
            }
        }){ [weak self] (error) in
        }
    }
//    func FinancialGetOutcomesReq(){
//        NetworkClient.performRequest(FinancialOutcomes.self, router: .FinancialGetOutcomes, success: { [weak self] (models) in
//            print("models\( models.data)")
//            if(models.status == 1){
//            }
//            else if (models.status == 0 ){
//            }
//        }){ [weak self] (error) in
//        }
//    }
    func FinancialAddOutcomeReq(){
        NetworkClient.performRequest(FinancialAddIncome.self, router: .FinancialAddOutcome(project_id: "14", amount: "2", details: "no no", type: "1"), success: { [weak self] (models) in
            print("models\( models.data)")
            if(models.status == 1){
            }
            else if (models.status == 0 ){
            }
        }){ [weak self] (error) in
        }
    }
    func FinancialRemoveOutcomeReq(){
       NetworkClient.performRequest(statusModel.self, router: .FinancialRemoveOutcome(id: "2"), success: { [weak self] (models) in
            print("models\( models.data)")
            if(models.status == 1){
            }
            else if (models.status == 0 ){
            }
        }){ [weak self] (error) in
        }
    }
    
//    func financialClientSearchReq(){
//       NetworkClient.performRequest(financialClientSearchModel.self, router: .financialClientSearch(project_id: 14, date_in: "2020-09-10", date_out: "2020-09-15"), success: { [weak self] (models) in
//            print("models\( models.data)")
//            if(models.status == 1){
//            }
//            else if (models.status == 0 ){
//            }
//        }){ [weak self] (error) in
//        }
//    }
    
//    func financialProjectSearchReq(){
//       NetworkClient.performRequest(FinancialProjectSearchModel.self, router: .financialProjectSearch(project_id: 14, date_in: "2020-09-10", date_out: "2020-09-15"), success: { [weak self] (models) in
//            print("models\( models.data)")
//            if(models.status == 1){
//            }
//            else if (models.status == 0 ){
//            }
//        }){ [weak self] (error) in
//        }
//    }
}
