
//

import Foundation
import Alamofire


//let userId = UserDefaults.standard.value(forKey: "userId") as? String
enum APIRouter: URLRequestConvertible {
    
    case getCompanySetting
    case login(username: String , password : String )
    case changepassword (phone: String,password : String)
    case forgetPassword(phone: String)
    case checkCode(phone : String, code : String)
    case editCompanySetting(title: String, description: String, phone1: String, phone2 :String, address1: String  , address2: String, email1: String, email2 : String , website : String, twitter: String, instagram: String, snapchat : String , facebook : String, logo: String)
    case get_all_users(currentPage : String)
    case get_user_info(id :String)
    case add_user(name: String,email: String,phone: String,password:String,jop_type: String,users_group: String,branche: String,state: String,address: String,is_active: String,msg : String)
    case edit_user(user_id:String, name: String,email: String,phone: String,jop_type: String,users_group: String,branche: String,state: String,address: String,is_active: String,msg : String)
    case remove_user(id : String)
    case get_all_clients(currentPage : String)
    case client_info(id :String)
    case add_client(name: String,email: String,phone: String,password:String,users_group: String,branche: String,state: String,address: String,is_active: String)
    case edit_client(client_id:String, name: String,email: String,phone: String,users_group: String,branche: String,state: String,address: String,msg: String,is_active: String, password:String, emp_id : String)
    case remove_clients(id :String)
    case get_all_states
    case addState(title : String)
    case edit_state(state_id :String,title : String)
    case remove_state(id :String)
    case stateInfo(id :String)
    case get_all_branches
    case brancheInfo(id :String)
    case add_branche(title :String,state :String,address :String,phone :String)
    case edit_branche(branche_id :String,title :String,state :String,address :String,phone :String)
    case remove_branche (id : String)
    case get_all_users_groups
    case users_group_info(id: String)
    case add_users_group(title :String,is_client_order :String,is_contracting :String,is_projects :String,is_report :String,is_financial :String,is_settings :String,isProgressTime:String)
    case edit_users_group(users_group_id :String,title :String,is_client_order :String,is_contracting :String,is_projects :String,is_report :String,is_financial :String,is_settings :String,isProgressTime:String)
    case remove_users_group(id :String)
    case get_all_contracts
    case get_contract_info(id :String)
    case add_contract(title :String,color :String)
    case edit_contract(contract_id :String,title :String,color :String)
    case remove_contract(id: String)
    case get_all_levels
    case get_level_info(id: String)
    case add_level(title :String,percent :String,contract_id :String,type :String)
    case edit_level(level_id :String,title :String,percent :String,contract_id :String,type :String)
    case remove_level(id: String)
    case get_level_by_contract(id: String)
    case get_all_level_detailss
    case add_level_details(title :String,level_id :String,percent :String,is_pdf :String,type :String,values : [String] ,question_type : String)
    case edit_level_details(level_details_id :String,title :String,level_id :String,percent :String,is_pdf :String,type :String,values : [String] ,question_type : String)
    case remove_level_details(id: String)
    case get_level_details_info(id: String)
    case get_level_details_by_level(id: String)
    case getAllNewClientOrder(currentPage : String)
    case newOrderDetails(id: String)
    case editOrderData(project_id: String,emp_id: String,phone: String,contract_id: String,lat: String,lng: String,name : String)
    case acceptNewOrder(emp_id: String,project_id: String)
    case cancelNewOrder(emp_id: String,project_id: String)
    case getAllContract(id:String,currentPage : String)
    case contractDetails(id: String)
    case editContractData(project_id: String,emp_id: String,phone: String,contract_id: String,lat: String,lng: String,name: String)
    case getAllProjectExplanation(id: String,currentPage : String)
    case explanationDetails(id: String)
    case addExplanation(title: String,comments: String,date: String,time: String,emp_id: String,project_id: String)
    case getAllProject(id: String,currentPage : String)
    case get_project_levels(projectId : String , empId : String)
    case get_level_details(levelId : String , empId : String)
    case get_one_level_detail(levelId : String)
    case add_detail(title : String ,level_id : String ,percent : String ,is_pdf : String ,type : String ,values : [String] ,question_type : String ,project_id : String,emp_id : String)
    case edit_details(title : String ,level_id : String ,percent : String ,is_pdf : String ,type : String ,values : [String] ,question_type : String ,project_id : String)
    case update_details(id:String, emp_id: String, state: String, answer : String, comment : String , pdf : [String])
    case send_revision(project_id : String ,emp_id : String ,client_id : String ,msg : String,type:String)
    case shareMainProjectSurvey(project_id : String ,client_id : String,contract_id : String,emp_id : String)
    case deleteProjectSurvey(project_id : String ,emp_id : String)
    case deletePriceOffer(project_id : String ,emp_id : String)
    case remove_paid_project(project_id : String ,emp_id : String)
    case send_paid_project(project_id : String ,emp_id : String ,contract_id : String,client_id : String)
    case remove_contract_template_data(project_id : String ,emp_id : String)
    case mailBox(id: String,currentPage : String)
    case oneMailBox(id: String)
    case get_assigned_users(level_id : String, state : String)
    case assign_user(emp : String, level_id : String, project_id : String,sender:String)
    case remove_assign_user(permission_id: String, emp_id : String)
    case send_contract(emp_id:String,project_id:String,client_id:String,type:String)
    case send_price(emp_id:String,project_id:String,client_id:String,type:String)
    case view_paid_project(id: String)
    case edit_paid_project(emp_id:String,project_id:String,paid:String,paid_down:String,paid_term:String)
    case financialGetProjects
    case financialGetIncomes(currentPage : String)
    case financialAddIncome(project_id:String,amount:String,details:String,type:String)
    case FinancialRemoveIncome(id: String)
    case FinancialGetOutcomes(currentPage : String)
    case FinancialAddOutcome(project_id:String,amount:String,details:String,type:String)
    case FinancialRemoveOutcome(id:String)
    case financialClientSearch(project_id:Int,date_in:String,date_out:String,page:String)
    case financialProjectSearch(project_id:Int,date_in:String,date_out:String,page:String)
    case financialEditIncome(editid:String,project_id:String,amount:String,details:String,type:String)
    case financialEditOutcome(editid:String,project_id:String,amount:String,details:String,type:String)
    case controllersGetAllComps(cat_id:String)
    case controllersGetComps_Info(sale_id: String)
    case controllersAdd_comps(com_name: String, percent: String,cat_id: String)
    case controllersEdit_comps(sale_id: String, com_name: String, percent: String)
    case controllersRemove_comps(sale_id: String)
    case reportGetClient(currentPage : String)
    case getArchiveProjectData(date_in:String,date_out:String,page:String)
    case reportGetExplan(project_id:String,emp_id : String,date_in:String,date_out:String,page:String)
    case projectArchiveProject(id:String)
    case get_mailbox_Details(mail_id:String, type:String )
    case projectAnswerQue(que_id:String,answer:String,emp_id : String,project_id:String)
    case profile(id :String, email :String , phone : String , name :String , address:String ,oldPassword : String , passsword: String)
    case AnswerQue(emp_id : String, project_id : String, answer : [AnyObject])
    case get_ProjectsSearchByName(title : String)
    case projectType
    case ProjectsSearch(project_type :String, contractType :String , to : String , from :String , progressTo:Int , progressFrom: Int,state: String)
    case TotalPaidProject(id : String)
    case fireBase_Type(user_id :String)
    case mailboxSendPaid(project_id :String, type :String , client_id : String , emp_id :String,price:String)
    case confirmStartProject(project_id :String, emp_id :String , confirm_date : String)
    case projectLevelViewToClient(level_id :String, type :String)
    case projectUpdateProgressTime(level_id :String, progress_time :String)
    case controllersSortLevels(id: [String])
    case controllersSortLevelsDetails(id: [String])
    case GetNotifcationCount(id : String)
    case edit_user_token(user_id :String,token_id:String)
    case addLevel(title : String ,percent : String ,contract_id : String ,type : String ,project_id : String, emp_id :String)
    case getAllUsersfilter
    case deleteLevel(level_id: String,project_id : String,emp_id : String)
    case getContractProjectSearch(search:String,page:String,user_id:String)
    case getAllUsersSearch(search:String,page:String)
    case getAllClientsSearch(search:String,page:String)
    case getAllCompsCategory
    case AddCategory(name : String)
    case EditCategory(id:String ,name : String)
    case RemoveCategory(id:String)
    case logOut(user_id:String)
    case getChat(user_id: String,level_id: String , project_id :String, type :String , page :String )
    case getToken(id:String)
    case deleteMessage(id :String)
    case getSmsLogs(config :String)
    case autoCompleteLevel(id :String)
    case deleteLevelDetails(id :String)
    case getALLClients
    case createProject(client_id :String , projectName :String , country :String , state :String , project_type : String , area : String , confirm_date : String , contract_id : String , created_by : String , lat : String , lng : String, addressType :String , adressLink: String)
    case DeleteProject( project_id :String)
    
    var method: HTTPMethod {
        switch self {
        case .changepassword, .editCompanySetting ,  .login , .checkCode ,.forgetPassword, .add_user , .edit_user , .add_client , .edit_client , .get_all_states , .addState , .edit_state, .add_branche, .edit_branche , .add_users_group, .edit_users_group, .add_contract, .edit_contract, .add_level, .edit_level, .add_level_details, .edit_level_details, .editOrderData, .acceptNewOrder, .cancelNewOrder, .getAllContract, .editContractData , .addExplanation, .add_detail,.edit_details, .update_details ,.send_revision, .assign_user, .send_contract, .send_price, .edit_paid_project, .financialAddIncome, .FinancialAddOutcome, .financialClientSearch, .financialProjectSearch,.financialEditIncome,.financialEditOutcome, .controllersAdd_comps, .controllersEdit_comps, .getArchiveProjectData, .reportGetExplan, .get_mailbox_Details , .projectAnswerQue , .profile, .AnswerQue, .get_ProjectsSearchByName, .ProjectsSearch, .fireBase_Type, .mailboxSendPaid, .confirmStartProject, .projectUpdateProgressTime, .projectLevelViewToClient, .controllersSortLevels, .controllersSortLevelsDetails, .edit_user_token , .addLevel, .deleteLevel, .getContractProjectSearch , .getAllUsersSearch, .getAllClientsSearch, .controllersGetAllComps , .AddCategory, .EditCategory, .logOut, .getChat, .deleteLevelDetails, .createProject, .DeleteProject:
            return .post
        case .getCompanySetting, .get_all_users, .get_user_info , .get_all_clients , .get_all_branches , .get_all_users_groups , .stateInfo , .remove_state, .brancheInfo , .remove_branche, .users_group_info, .remove_users_group , .remove_user, .client_info, .remove_clients, .get_all_contracts, .remove_contract, .get_contract_info, .get_all_levels, .remove_level, .get_level_info, .get_level_by_contract, .get_all_level_detailss, .remove_level_details, .get_level_details_info, .get_level_details_by_level, .getAllNewClientOrder, .newOrderDetails, .contractDetails, .getAllProjectExplanation, .explanationDetails, .getAllProject, .get_level_details, .get_project_levels ,.get_one_level_detail, .shareMainProjectSurvey, .deleteProjectSurvey, .deletePriceOffer, .remove_paid_project, .send_paid_project, .remove_contract_template_data, .mailBox, .oneMailBox, .get_assigned_users, .view_paid_project, .financialGetProjects, .financialGetIncomes, .FinancialRemoveIncome, .FinancialGetOutcomes, .FinancialRemoveOutcome, .controllersRemove_comps, .controllersGetComps_Info, .reportGetClient, .projectArchiveProject, .remove_assign_user , .projectType, .TotalPaidProject, .GetNotifcationCount, .getAllUsersfilter, .getAllCompsCategory,.RemoveCategory, .getToken, .deleteMessage, .getSmsLogs, .autoCompleteLevel, .getALLClients:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .login(let username,let password):
            return ["username":username , "password" : password]

        case .checkCode(let phone, let code):
            return ["phone_mail": phone , "ref_code" : code]
            
        case .forgetPassword(let phone):
                return ["phone_mail": phone]
            
        case .changepassword( let phone, let password):
            return ["phone_mail": phone,"password": password ]
            
        case .editCompanySetting(let title, let description,let phone1, let phone2,let address1, let address2, let email1, let email2, let website, let twitter,let instagram,let snapchat,let facebook,let logo):
            return ["title": title, "description": description, "phone1": phone1, "phone2" :phone2, "address1": address1, "address2": address2, "email1": email1, "email2" : email2, "website" : website,"twitter": twitter, "instagram": instagram, "snapchat": snapchat, "facebook" : facebook, "logo" : logo]
            
        case .add_user(let name,let email,let phone,let password,let jop_type,let users_group,let branche,let state,let address,let is_active, let msg):
            return ["name": name,"email": email,"phone": phone,"password":password,"jop_type": jop_type,"users_group": users_group,"branche": branche,"state": state,"address": address,"is_active": is_active,"msg": msg ]
            
        case .edit_user(let user_id,let name,let email,let phone,let jop_type,let users_group,let branche,let state,let address,let is_active, let msg):
            return ["user_id":user_id,"name": name,"email": email,"phone": phone,"jop_type": jop_type,"users_group": users_group,"branche": branche,"state": state,"address": address,"is_active": is_active,"msg": msg]
        
        case .add_client(let name,let email,let phone,let password,let users_group,let branche,let state,let address,let is_active):
            return ["name": name,"email": email,"phone": phone,"password":password,"users_group": users_group,"branche": branche,"state": state,"address": address,"is_active": is_active]
            
        case .edit_client(let client_id,let name,let email,let phone,let users_group,let branche,let state,let address,let msg,let is_active, let password,let emp_id):
            return ["client_id":client_id,"name": name,"email": email,"phone": phone,"users_group": users_group,"branche": branche,"state": state,"address": address,"msg" : msg,"is_active": is_active,"password":password,"emp_id":emp_id]
            
        case .addState(let title):
            return ["title":title ]
            
        case .edit_state(let state_id,let title):
            return ["state_id" : state_id ,"title":title ]
            
        case .add_branche(let title,let state,let address,let phone):
            return ["title" : title ,"state":state , "address" : address ,"phone":phone ]
            
        case .edit_branche(let branche_id,let title,let state,let address,let phone):
            return ["branche_id" : branche_id ,"title" : title ,"state":state , "address" : address ,"phone":phone ]
        
        case .add_users_group(let title,let is_client_order,let is_contracting,let is_projects,let is_report,let is_financial,let is_settings,let isProgressTime):
            return ["title":title,"is_client_order":is_client_order,"is_contracting":is_contracting,"is_projects":is_projects,"is_report":is_report,"is_financial":is_financial,"is_settings":is_settings,"is_progressTime":isProgressTime]
            
        case .edit_users_group(let users_group_id,let title,let is_client_order,let is_contracting,let is_projects,let is_report,let is_financial,let is_settings,let isProgressTime):
            return ["users_group_id":users_group_id,"title":title,"is_client_order":is_client_order,"is_contracting":is_contracting,"is_projects":is_projects,"is_report":is_report,"is_financial":is_financial,"is_settings":is_settings,"is_progressTime":isProgressTime]
            
        case .add_contract(let title,let color):
            return["title": title,"color": color]
        case .edit_contract(let contract_id,let title,let color):
            return["contract_id": contract_id,"title": title,"color": color]
        case .add_level(let title,let percent,let contract_id,let type):
            return["title": title,"percent": percent,"contract_id": contract_id,"type": type]
        case .edit_level(let level_id,let title,let percent,let contract_id,let type):
            return["level_id":level_id,"title": title,"percent": percent,"contract_id": contract_id,"type": type]
       case .add_level_details(let title,let level_id,let percent,let is_pdf,let type ,let values , let question_type):
            return["title":title,"level_id": level_id,"percent": percent,"is_pdf": is_pdf,"type": type,"values":values,"question_type":question_type]
        case .edit_level_details(let level_details_id,let title,let level_id,let percent,let is_pdf,let type,let values , let question_type):
            return["level_details_id":level_details_id,"title":title,"level_id": level_id,"percent": percent,"is_pdf": is_pdf,"type": type, "values":values,"question_type":question_type]
        case .editOrderData(let project_id,let emp_id,let phone,let contract_id,let lat,let lng,let name):
            return["project_id":project_id,"emp_id":emp_id,"phone":phone,"contract_id":contract_id,"lat":lat,"lng":lng,"name":name]
        case .acceptNewOrder(let emp_id,let project_id):
            return["emp_id":emp_id,"project_id":project_id]
        case.cancelNewOrder(let emp_id,let project_id):
            return["emp_id":emp_id,"project_id":project_id]
        case .editContractData(let project_id,let emp_id,let phone,let contract_id,let lat,let lng,let name):
            return["project_id":project_id,"emp_id":emp_id,"phone":phone,"contract_id":contract_id,"lat":lat,"lng":lng,"name":name]
        case .addExplanation(let title,let comments,let date,let time,let emp_id,let project_id):
            return["title":title, "comments":comments, "date":date, "time":time, "emp_id":emp_id, "project_id":project_id]
        case .add_detail(let title,let level_id,let percent,let is_pdf,let type,let values,let question_type,let project_id,let emp_id):
            return["title":title,"level_id":level_id,"percent":percent,"is_pdf":is_pdf,"type":type,"values":values,"question_type":question_type,"project_id":project_id,"emp_id":emp_id]
            
        case .edit_details(let title,let level_id,let percent,let is_pdf,let type,let values,let question_type,let project_id):
            return["title":title,"level_id":level_id,"percent":percent,"is_pdf":is_pdf,"type":type,"values":values,"question_type":question_type,"project_id":project_id]
        case .update_details(_,let emp_id, let state , let answer, let comment,let pdf):
          return ["emp_id":emp_id,"state":state,"answer":answer,"comment":comment,"Pdf":pdf]
        case .send_revision(let project_id,let emp_id,let client_id,let msg,let type):
            return ["project_id":project_id,"emp_id":emp_id,"client_id":client_id,"msg":msg,"type":type]
        case .assign_user(let emp, let level_id, let project_id,let sender):
            return ["emp_id": emp, "level_id" : level_id, "project_id": project_id,"sender":sender]
        case .send_contract(let emp_id,let project_id,let client_id,let type):
            return ["emp_id":emp_id,"project_id":project_id,"client_id":client_id,"type":type]
        case .send_price(let emp_id,let project_id,let client_id,let type):
            return ["emp_id":emp_id,"project_id":project_id,"client_id":client_id,"type":type]
        case .edit_paid_project(let emp_id,let project_id,let paid,let paid_down,let paid_term):
            return ["emp_id":emp_id,"project_id":project_id,"paid":paid,"paid_down":paid_down,"paid_term":paid_term]
        case .financialAddIncome(let project_id,let amount,let details,let type):
             return ["project_id":project_id,"amount":amount,"details":details,"type":type]
        case .FinancialAddOutcome(let project_id,let amount,let details,let type):
            return ["project_id":project_id,"amount":amount,"details":details,"type":type]
        case .financialClientSearch(let project_id,let date_in,let date_out,let page):
            return ["project_id":project_id,"date_in":date_in,"date_out":date_out,"page":page]
        case .financialProjectSearch(let project_id,let date_in,let date_out,let page):
            return ["project_id":project_id,"date_in":date_in,"date_out":date_out,"page":page]
        case .financialEditIncome(let editid,let project_id,let amount,let details,let type):
            return ["editid":editid,"project_id":project_id,"amount":amount,"details":details,"type":type]
        case .financialEditOutcome(let editid,let project_id,let amount,let details,let type):
            return ["editid":editid,"project_id":project_id,"amount":amount,"details":details,"type":type]
        case .controllersAdd_comps(let com_name, let percent,let cat_id):
            return ["com_name":com_name,"percent":percent,"cat_id":cat_id]
        case .controllersEdit_comps(let sale_id, let com_name, let percent):
            return ["sale_id":sale_id,"com_name":com_name,"percent":percent]
        case .getArchiveProjectData(let date_in,let date_out,let page):
            return ["date_in":date_in,"date_out":date_out,"page":page]
        case .reportGetExplan(let project_id,let emp_id,let date_in,let date_out,let page):
            return ["project_id":project_id,"emp_id":emp_id,"date_in":date_in,"date_out":date_out,"page":page]
        case .get_mailbox_Details(let mail_id , let type):
            return ["mail_id":mail_id, "type" : type]
        case .projectAnswerQue(let que_id,let answer,let emp_id,let project_id):
            return ["que_id":que_id,"answer":answer,"emp_id":emp_id,"project_id":project_id]
        
        case .profile(let id, let email, let phone, let name, let address,let oldPassword , let passsword):
            return ["user_id": id, "email": email, "phone": phone, "name": name, "address": address,"oldPassword":oldPassword, "password": passsword]
        case .AnswerQue(let emp_id, let project_id, let answer):
            return ["emp_id": emp_id, "project_id": project_id, "answers": answer]
        case .get_ProjectsSearchByName(let title):
            return ["title": title]
        case .ProjectsSearch(let project_type,let contractType,let to,let from,let progressTo,let progressFrom,let state):
            return ["project_type":project_type,"contractType":contractType,"to":to,"from":from,"progressTo":progressTo ,"progressFrom":progressFrom,"state":state]
        case .fireBase_Type(let user_id):
            return ["user_id": user_id]
        case .mailboxSendPaid(let project_id,let type,let client_id,let emp_id,let price):
            return ["project_id":project_id,"type":type,"client_id":client_id,"emp_id":emp_id,"price":price]
        case .confirmStartProject(let project_id,let emp_id,let confirm_date):
            return ["project_id":project_id,"emp_id":emp_id,"confirm_date":confirm_date]
        case .projectLevelViewToClient(let level_id,let type):
            return ["level_id":level_id,"type":type]
        case .projectUpdateProgressTime(let level_id,let progress_time):
            return ["level_id":level_id,"progress_time":progress_time]
        case .controllersSortLevels(let id):
            return ["id" : id]
        case .controllersSortLevelsDetails(let id):
            return ["id" : id]
        case .edit_user_token(let user_id, let token_id):
            return [ "user_id" : user_id , "token_id" : token_id]
        case .addLevel(let title, let percent, let contract_id, let type, let project_id, let emp_id):
            return ["title": title, "percent": percent, "contract_id": contract_id, "type": type, "project_id": project_id, "emp_id": emp_id]
        case .deleteLevel(let level_id,let project_id,let emp_id):
            return ["level_id":level_id,"project_id":project_id,"emp_id":emp_id]
        case .getContractProjectSearch(let search,let page,let user_id):
            return ["search":search,"page":page,"user_id":user_id]
        case .getAllUsersSearch(let search,let page):
            return ["search":search,"page":page]
        case .getAllClientsSearch(let search,let page):
            return ["search":search,"page":page]
        case .controllersGetAllComps(let cat_id):
            return ["cat_id":cat_id]
        case .AddCategory(let name):
            return ["name":name]
        case .EditCategory(let id,let name):
            return ["id":id , "name":name]
        case .logOut(let user_id):
            return ["user_id":user_id]
        case .getChat(let user_id, let level_id, let project_id, let type, let page):
            return ["user_id": user_id, "level_id": level_id, "project_id": project_id, "type": type, "page": page]
       
        case .createProject(let client_id, let projectName, let country, let state, let project_type, let area, let confirm_date, let contract_id, let created_by, let lat, let lng, let addressType, let adressLink):
            return ["client_id" : client_id, "projectName": projectName, "country": country, "state": state, "project_type": project_type, "area": area, "confirm_date": confirm_date, "contract_id": contract_id, "created_by": created_by, "lat": lat, "lng": lng , "address_type":addressType,"address_link": adressLink]
        case .DeleteProject(let project_id):
            return ["project_id" : project_id]
        default:
            return nil
        }
    }
    
    var path: String {
        switch self{
        case .login:
            return "controllers/users_login2"
        case .getCompanySetting :
            return "controllers/get_setting"
        case .forgetPassword:
            return "controllers/user_forgetpass"
        case .checkCode :
            return "controllers/user_forgetcode"
        case .changepassword:
            return "controllers/user_forgetnewpass"
        case .editCompanySetting:
            return "controllers/edit_setting"
        case .get_all_users(let currentPage):
            return "controllers/get_all_users/\(currentPage)"
        case .get_user_info(let id):
            return "controllers/get_user_info/\(id)"
        case .add_user:
            return "controllers/add_user"
        case .edit_user:
            return "controllers/edit_user"
        case .remove_user(let id):
            return "controllers/remove_user/\(id)"
        case .get_all_clients(let currentPage):
            return "controllers/get_all_clients/\(currentPage)"
        case .client_info(let id):
            return "controllers/get_client_info/\(id)"
        case .add_client:
            return "controllers/add_client"
        case .edit_client:
            return "controllers/edit_client"
        case .remove_clients(let id):
            return "controllers/remove_client/\(id)"
        case .get_all_states:
            return "controllers/get_all_states"
        case .addState:
            return "controllers/add_state"
        case .edit_state:
            return "controllers/edit_state"
        case .remove_state(let id):
            return "controllers/remove_state/\(id)"
        case .stateInfo(let id):
            return "controllers/get_state_info/\(id)"
        case .get_all_branches:
            return "controllers/get_all_branches"
        case .brancheInfo(let id):
            return "controllers/get_branche_info/\(id)"
        case .add_branche:
            return "controllers/add_branche"
        case .edit_branche:
            return "controllers/edit_branche"
        case .remove_branche(let id):
            return "controllers/remove_branche/\(id)"
        case .get_all_users_groups:
            return "controllers/get_all_users_groups"
        case .users_group_info(let id):
            return "controllers/get_users_group_info/\(id)"
        case .add_users_group:
            return "controllers/add_users_group"
        case .edit_users_group:
            return "controllers/edit_users_group"
        case .remove_users_group(let id):
            return "controllers/remove_users_group/\(id)"
        case .get_all_contracts:
            return "controllers/get_all_contracts"
        case .get_contract_info(let id):
            return "controllers/get_contract_info/\(id)"
        case .add_contract:
             return "controllers/add_contract"
        case .edit_contract:
            return "controllers/edit_contract"
        case .remove_contract(let id):
            return "controllers/remove_contract/\(id)"
        case .get_all_levels:
            return "controllers/get_all_levels"
        case .add_level:
            return "controllers/add_level"
        case .edit_level:
            return "controllers/edit_level"
        case .remove_level(let id):
            return "controllers/remove_level/\(id)"
        case .get_level_info(let id):
            return "controllers/get_level_info/\(id)"
        case .get_level_by_contract(let id):
            return "controllers/get_level_by_contract/\(id)"
        case .get_all_level_detailss:
            return "controllers/get_all_level_detailss"
        case .add_level_details:
                return "controllers/add_level_details"
        case .edit_level_details:
            return "controllers/edit_level_details"
        case .remove_level_details(let id):
            return "controllers/remove_level_details/\(id)"
        case .get_level_details_info(let id):
            return "controllers/get_level_details_info/\(id)"
        case .get_level_details_by_level(let id):
            return "controllers/get_level_details_by_level/\(id)"
        case .getAllNewClientOrder(let currentPage):
            return "emp_project/get_new_project/\(currentPage)"
        case .newOrderDetails(let id):
            return "emp_project/view_new_project/\(id)"
        case .editOrderData:
            return "emp_project/edit_new_project/"
        case .acceptNewOrder:
             return "emp_project/accept_new_project/"
        case .cancelNewOrder:
            return "emp_project/cancel_new_project/"
        case .getAllContract(let id,let currentPage):
            return "emp_project/get_contract_project/\(id)/\(currentPage)"
        case .contractDetails(let id):
            return "emp_project/view_contract_project/\(id)"
        case .editContractData:
            return "emp_project/edit_contract_project/"
        case .getAllProjectExplanation(let id,let currentPage):
            return "emp_project/get_all_explan_project/\(id)/\(currentPage)"
        case .explanationDetails(let id):
            return "emp_project/view_explan/\(id)"
        case .addExplanation:
            return "emp_project/add_explan/"
        case .getAllProject(let id,let currentPage):
            return "project/get_projects2/\(id)/\(currentPage)"
        case .get_project_levels(let projectId,let empId):
            return "project/get_project_levels/\(projectId)/\(empId)"
        case .get_level_details(let levelId,let empId):
            return "project/get_level_details/\(levelId)/\(empId)"
        case .add_detail:
            return "project/add_detail"
        case .get_one_level_detail(let levelId):
                return "project/get_detail/\(levelId)"
        case .edit_details:
            return "project/editDetail/\(AppDelegate.LevelID!)"
        case .update_details(let id):
                return "project/update_Detail/\(id)"
        case .send_revision:
            return "emp_project/send_revision/"
        case .shareMainProjectSurvey(let project_id,let client_id,let contract_id,let emp_id):
            return "emp_project/send_client_quest2/\(project_id)/\(client_id)/\(contract_id)/\(emp_id)"
        case .deleteProjectSurvey(let project_id,let emp_id):
            return "emp_project/remove_quest_data/\(project_id)/\(emp_id)"
        case .deletePriceOffer(let project_id,let emp_id):
            return "emp_project/remove_price_data/\(project_id)/\(emp_id)"
        case .remove_paid_project(let project_id,let emp_id):
            return "emp_project/remove_paid_project/\(project_id)/\(emp_id)"
        case .send_paid_project(let project_id,let emp_id,let contract_id,let client_id):
            return "emp_project/send_paid_project/\(project_id)/\(client_id)/\(contract_id)/\(emp_id)"
        case .remove_contract_template_data(let project_id,let emp_id):
            return "emp_project/remove_template_data/\(project_id)/\(emp_id)"
        case .mailBox(let id,let currentPage):
            return "mailbox/get_user_mailbox/\(id)/\(currentPage)"
        case .oneMailBox(let id):
            return "mailbox/get_mailbox/\(id)"
        case .get_assigned_users(let id,let state):
            return "project/get_assigned_users/\(id)/\(state)"
        case .assign_user:
            return "project/assign_user"
        case .remove_assign_user(let permission_id, let emp_id):
        return "project/remove_assign_user/\(permission_id)/\(emp_id)"
        case .send_contract:
            return "mailbox/send_contract"
        case .send_price:
            return "mailbox/send_price"
        case .view_paid_project(let id):
            return "emp_project/view_paid_project/\(id)"
        case .edit_paid_project:
            return "emp_project/edit_paid_project"
        case .financialGetProjects:
            return "financial/get_projects"
        case .financialGetIncomes(let currentPage):
            return "financial/get_incomes/\(currentPage)"
        case .financialAddIncome:
            return "financial/add_income"
        case .FinancialRemoveIncome(let id):
            return "financial/remove_income/\(id)"
        case .FinancialGetOutcomes(let currentPage):
            return "financial/get_outcomes/\(currentPage)"
        case .FinancialAddOutcome:
            return "financial/add_outcome"
        case .FinancialRemoveOutcome(let id):
            return "financial/remove_outcome/\(id)"
        case .financialClientSearch:
            return "financial/client_search"
        case .financialProjectSearch:
            return "financial/project_search"
        case .financialEditIncome:
            return "financial/edit_income/"
        case .financialEditOutcome:
            return "financial/edit_outcome/"
        case .controllersGetAllComps:
            return "controllers/get_all_comps"
        case .controllersAdd_comps:
            return "controllers/add_comps"
        case .controllersEdit_comps:
             return "controllers/edit_comps"
        case .controllersRemove_comps(let sale_id):
            return "controllers/remove_comps/\(sale_id)"
        case .controllersGetComps_Info(let sale_id):
            return "controllers/get_comps_info/\(sale_id)"
        case .reportGetClient(let currentPage):
            return "report/get_client/\(currentPage)"
        case .getArchiveProjectData:
            return "report/get_data_projects"
        case .reportGetExplan:
            return "report/get_explan"
        case .projectArchiveProject(let id):
            return "project/archive_project/\(id)"
        case .get_mailbox_Details:
            return "mailbox/get_mailbox"
        case .projectAnswerQue:
            return "project/answer_que/"
        case .profile:
            return "controllers/edit_userProfile"
        case.AnswerQue:
            return "project/answer_que2"
        case .get_ProjectsSearchByName:
            return "project/get_ProjectsSearchByName"
        case .projectType:
            return "project/se_project_type"
        case .ProjectsSearch:
            return "project/get_ProjectsSearch"
        case .TotalPaidProject(let id):
            return "project/TotalPaidProject/\(id)"
        case .fireBase_Type :
            return "controllers/edit_user_firebase_Type"
        case .mailboxSendPaid:
            return "mailbox/send_Paid"
        case .confirmStartProject:
            return "emp_project/confirmProject"
        case .projectLevelViewToClient:
            return "project/LevelViewToClient"
        case .projectUpdateProgressTime:
            return "project/UpdateProgressTime"
        case .controllersSortLevels:
            return "controllers/SortLevels"
        case .controllersSortLevelsDetails:
            return "controllers/SortLevelDetails"
        case .GetNotifcationCount(let id):
            return "controllers/GetNotifcationCount/\(id)"
        case .edit_user_token :
            return "controllers/edit_user_token_id"
        case .getAllUsersfilter :
            return "controllers/get_all_usersfilter"
        case .addLevel :
            return "project/add_level"
        case .deleteLevel :
            return "project/deleteLevel"
        case .getContractProjectSearch:
            return "emp_project/get_contract_projectSearch"
        case .getAllUsersSearch:
            return "controllers/get_all_usersSearch"
        case .getAllClientsSearch:
            return "controllers/get_all_clientsSearch"
        case .getAllCompsCategory:
            return "controllers/get_all_comps_category"
        case .AddCategory:
            return "controllers/add_comps_category"
        case .EditCategory:
            return "controllers/edit_comps_category"
        case .RemoveCategory(let id):
            return "controllers/remove_comps_category/\(id)"
        case .logOut:
            return "controllers/logout_user"
        case .getChat:
            return "chat/GetMessage"
        case .getToken(let id):
            return "controllers/getToken/\(id)"
        case .deleteMessage(let id):
            return "chat/deleteMessage/\(id)"
        case .getSmsLogs(let config):
            return "smslogs/getLogs/\(config)"
        case .autoCompleteLevel(let id):
            return "project/AutoCompleteLevel/\(id)"
        case .deleteLevelDetails(let id):
            return "project/delete_levelDetails/\(id)"
        case .getALLClients:
            return "report/get_all_clients2"
        case .createProject:
            return "project/Create_Project"
        case .DeleteProject:
            return "project/DeleteProject"
        }
    }
    
    var encoding: ParameterEncoding{
        switch self{
        default:
            return URLEncoding.default
        }
    }
    
//    var headers: HTTPHeaders {
//        switch self {
//        case .teachers:
//            let head = HTTPHeaderField.acceptType
//            return  [HTTPHeaderField.acceptType : ""]
//        default:
//            return nil
//        }
//
//    }
//    var AuthRequired: Bool {
//         switch self {
//         case .login:
//             return true
//         default:
//             return false
//         }
//     }
    
    func asURLRequest() throws -> URLRequest {
        let url1 = URL(string: "\(Constants.baseURL)")
        let urlWithPath = url1.flatMap { URL(string: $0.absoluteString + path) }
        let url = try Constants.baseURL.asURL().appendingPathComponent(path)
        var request = URLRequest(url: urlWithPath ?? url )
        request.httpMethod = method.rawValue
//      if(AuthRequired){
//            if(AuthManager.loggedIn) {
//                request.addValue(AuthManager.authKey(), forHTTPHeaderField: HTTPHeaderField.authentication.rawValue)
//            }
//        }
        print("sayed \(url)")

        if let parameters = parameters {
            var  jsonData = NSData()
            do {
                jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) as NSData
            } catch {
                print(error.localizedDescription)
            }
            // Common Headers
            request.setValue("\(jsonData.length)", forHTTPHeaderField: "Content-Length")
            request.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
            request.httpBody = jsonData as Data
            
            return try JSONEncoding.default.encode(request)
            //return try JSONEncoding.default.encode(request,with:parameters)
        }
        return request
    }
}
