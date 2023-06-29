//
//  Resource.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/06/28.
//

import Foundation

struct Resource<T: Decodable> {
    var base: String
    var path: String
    var params: [String: String]
    var header: [String: String]
    var httpMethod: String
    var clientID: String?
    var clientSecret: String?
    
    var urlRequest: URLRequest? {
        var urlComponents = URLComponents(string: base + path)!
        let queryItems = params.map { (key: String, value: String) in
            URLQueryItem(name: key, value: value)
        }
        urlComponents.queryItems = queryItems
        
        var request = URLRequest(url: urlComponents.url!)
        header.forEach { (key: String, value: String) in
            request.addValue(value, forHTTPHeaderField: key)
        }
        request.httpMethod = httpMethod
        if let clientID = clientID, let clientSecret = clientSecret {
            let body = "grant_type=client_credentials&client_id=\(clientID)&client_secret=\(clientSecret)"
            request.httpBody = body.data(using: .utf8)
        }

        return request
    }
    
    init(base: String, path: String, params: [String: String] = [:], header: [String: String] = [:], httpMethod: String = "GET", clientID: String? = nil, clientSecret: String? = nil) {
        self.base = base
        self.path = path
        self.params = params
        self.header = header
        self.httpMethod = httpMethod
        self.clientID = clientID
        self.clientSecret = clientSecret
    }
}
