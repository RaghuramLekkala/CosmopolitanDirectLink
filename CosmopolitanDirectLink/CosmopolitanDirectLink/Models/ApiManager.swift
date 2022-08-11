//
//  ApiManager.swift
//  IOSChatBot
//
//  Created by Raghuram on 24/05/22.
//

import Foundation

class ApiManager{
    let queue = DispatchQueue(label: "concurrentQueue", attributes: .concurrent)
    let decoder = JSONDecoder()
    
    static var cid = ""
    static var tokenVal: String?
    static var streamUrl: String?
    
    //MARK: - Refresh token api
    func post(endpoint:String, token: String, handler:@escaping ()->()) {
        if let url = URL(string: K.apiBaseURL + endpoint){
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: request){ (data: Data?, response: URLResponse?, error: Error?)  in
                if error != nil{
                    print("error \(error!)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    print("Error with the response, unexpected status code: \(String(describing: response))")
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(nil, forKey: "token")
                        ApiManager.cid = ""
                        ApiManager.tokenVal = nil
                        UserDefaults.standard.messagesData = []
                        UserDefaults.standard.actionsData = []
                        UserDefaults.standard.attachmentsData = []
                    }
                    return
                }
                if let safeData = data {
                    do {
                        let decodedData =  try self.decoder.decode(ResponseType.self,  from: safeData)
                        ApiManager.cid = decodedData.conversationId
                        ApiManager.tokenVal = decodedData.token
                        handler()
                    } catch  {
                        print("Error in token refresh: \(error)")
                        UserDefaults.standard.set(nil, forKey: "token")
                        ApiManager.cid = ""
                        ApiManager.tokenVal = nil
                        UserDefaults.standard.messagesData = []
                        UserDefaults.standard.actionsData = []
                        UserDefaults.standard.attachmentsData = []
                    }
                }
            }
            task.resume()
        }
    }
    
    //Generate Token
    func post(endpoint:String, callBack:@escaping (String)->()) {
        if let url = URL(string: K.apiBaseURL + endpoint){
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue( "Bearer \(K.token)", forHTTPHeaderField: "Authorization")
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: request){ (data: Data?, response: URLResponse?, error: Error?)  in
                if error != nil{
                    print("error \(error!)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    print("Error with the response, unexpected status code: \(String(describing: response))")
                    return
                }
                if let safeData = data {
                    do {
                        let decodedData =  try self.decoder.decode(ResponseType.self,  from: safeData)
                        callBack(decodedData.token)
                        ApiManager.cid = decodedData.conversationId
                        ApiManager.tokenVal = decodedData.token
                    } catch  {
                        print("Error in generate token: \(error)")
                    }
                }
            }
            task.resume()
        }
    }
    
    func post(endpoint:String,token: String, callBack:@escaping (String)->()) {
        if let url = URL(string: K.apiBaseURL + endpoint){
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?)  in
                if error != nil{
                    print("error \(error!)")
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    print("Error with the response, unexpected status code: \(String(describing: response))")
                    return
                }
                if let safeData = data {
                    do {
                        let decodedData =  try self.decoder.decode(ConversationType.self,  from: safeData)
                        callBack(decodedData.streamUrl)
                        ApiManager.streamUrl = decodedData.streamUrl
                    } catch  {
                        print("Error in streamUrl : \(error)")
                    }
                }
            }
            task.resume()
        }
    }
    
    func post(endpoint:String,token: String, body: [String: Any]) {
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
                if let url = URL(string: K.apiBaseURL + endpoint){
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpBody = jsonData
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?)  in
                if error != nil{
                    print("error \(error!)")
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    print("Error with the response, unexpected status code: \(String(describing: response))")
                    return
                }
                if let safeData = data {
                    do {
                        let decodedData =  try self.decoder.decode(SentResponseType.self,  from: safeData)
                        print(decodedData.id)
                    } catch  {
                        print("Error Json data: \(error)")
                    }
                }
            }
            task.resume()
                    
        }

    }
}
