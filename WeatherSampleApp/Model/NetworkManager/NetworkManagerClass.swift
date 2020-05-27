//
//  NetworkManagerClass.swift
//  SampleTask
//
//  Created by sunilreddy on 24/05/20.
//  Copyright © 2020 Sample. All rights reserved.
//

import Foundation
enum QTHttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
enum QTHttpError: Error {
    case networkError
    case custom(message: String)
}
class ResponseHandler {
    
    enum NetworkResponse: String {
        case success
        case invalidRequest = "Invalid request - cannot be fulfilled"
        case badRequest = "Server failed to fulfil the request"
        case failed = "Network request failed."
        case noData = "Response returned with no data to decode."
        case unableToDecode = "We could not decode the response."
    }
    
    enum Result<String> {
        case success
        case failure(String)
    }
    
    class func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String> {
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.invalidRequest.rawValue + " Status Code: \(response.statusCode)")
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue + " Status Code: \(response.statusCode)")
        default: return .failure(NetworkResponse.failed.rawValue + " Status Code: \(response.statusCode)")
        }
    }
}


class ApiDataManagerClass:NSObject
{
    //singleton object class
    static let shared = ApiDataManagerClass()
    private override init(){
    }
    //Common Get method using jsonserialization
    func commonGetMethodUsingJsonSerialization(urlString:String,postBody:[String:Any]?,callback:@escaping (Data?, Any?, Error?) -> Void) -> ()
    {
        //Check Internet
        guard Reachability.isConnectedToNetwork()  else {
            callback(nil, nil, QTHttpError.custom(message: "No Internet connection"))
            return
        }
        guard let request = buildRequest(with: urlString,
                                         httpMethod: .get,
                                         param: postBody) else {
                                            // callback(nil, nil, QTHttpError.badRequest as Error)
                                            return
        }
        URLSession.shared.dataTask(with: request, completionHandler:{ data, response, error  in
            if error != nil {
                callback(nil, nil, error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                callback(nil, nil, QTHttpError.custom(message: "No response received"))
                return
            }
            let result = ResponseHandler.handleNetworkResponse(httpResponse)
            switch result {
            case .success:
                callback(data, response, nil)
            case .failure(let message):
                print("API Failure Log: " + message)
                callback(nil, nil, QTHttpError.custom(message: message))
            }
        }).resume()
        
        
        
    }
    
    private func buildRequest(with urlString: String,
                              httpMethod: QTHttpMethod,
                              param: [String: Any]?) -> URLRequest? {
        var paramStr = ""
        if let param = param {
            for (key, value) in param {
                paramStr +=  "\(key)=\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
                paramStr += "&"
            }
            
            let idx = paramStr.lastIndex(of: "&")!
            paramStr.remove(at: idx)
            paramStr = "?\(paramStr)"
        }
        let checkUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlStr = "\(checkUrl)\(paramStr)"
        guard let url = URL(string: urlStr) else {
            return nil
        }
        print("Final url = \(url)")
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        return request
    }
}
