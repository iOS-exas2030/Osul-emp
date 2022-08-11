
//

import Foundation
import Alamofire

struct NetworkClient {
    
    typealias onSuccess<T> = ((T) -> ())
    typealias onFailure = ( (_ error: Error) -> ())
   
    // object parameter is added here so the T generic param can infer the type
    // All objects must conform to "Decodable" protocol
    static func performRequest<T>(_ object: T.Type, router: APIRouter, success: @escaping onSuccess<T>, failure: @escaping onFailure) where T: Decodable{
            AF.request(router).responseJSON { (response) in
                do {
                    let Lists = try JSONDecoder().decode(T.self, from: response.data!)
                    print(Lists)
                    success(Lists)
                } catch let error{
                    failure(error)
                    print(error)
                }
        }
    }
}

//class MyRequestAdapter: Alamofire.RequestAdapter {
//  func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (AFResult<URLRequest>) -> Void {
//    var adaptedRequest = urlRequest // because `urlRequest` is a parameter and parameters are not mutable
//    
//    // INSERT MISSING CODE HERE: Read the `token` from somewhere,
//    // either from memory (e.g. a network manager singleton) or
//    // from some secure location on disk (e.g. shared keychain).
//    let token = <Your Token>
//    adaptedRequest.headers.update(.authorization(bearerToken: token))
//    completion(.success(adaptedRequest))
//  }
//}
