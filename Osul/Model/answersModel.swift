//
//  answersModel.swift
//  AL-HHALIL
//// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let profileModel = try? newJSONDecoder().decode(ProfileModel.self, from: jsonData)

import Foundation

// MARK: - ProfileModel
struct answerModel{
    let empID, projectID: String?
    let answers: [AnswerDamn]?
}

// MARK: - Answer
//struct AnswerDamn: Codable{
//    let answer: [String] = []
//    let questionID: String = ""
//
//    enum CodingKeys: String, CodingKey {
//        case answer
//        case questionID = "question_id"
//    }
//}
class AnswerDamn {
    var answer:[String] = [""]
    var question_id : String = ""
    
    init(answer : [String] , question_id : String ){
        
        self.answer = answer
        self.question_id = question_id
   
    }

}
