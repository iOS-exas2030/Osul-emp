




import Foundation

struct AppModel<T: Decodable>: Decodable {
    var status: statusEnum?
    var data: T?
    var message: String?
    
    enum statusEnum: String, Decodable {
        case fail = "fail"
        case success = "success"
    }
}
