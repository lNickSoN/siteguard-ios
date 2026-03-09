import Alamofire
import Foundation

class APIClient {
    static let shared = APIClient()
    
    private let baseURL = "https://api.siteguard.best/api/v1"
    private var accessToken: String?
    
    private init() {}
    
    func setToken(_ token: String) {
        self.accessToken = token
    }
    
    func request<T: Decodable>(
        _ endpoint: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        var headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        if let token = accessToken {
            headers["Authorization"] = "Bearer \(token)"
        }
        
        AF.request(
            "\(baseURL)\(endpoint)",
            method: method,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        )
        .validate()
        .responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
