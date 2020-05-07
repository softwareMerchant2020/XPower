//
//  XpowerDataClient.swift
//  XPower
//
//  Created by Sangeetha Gengaram on 3/10/20.
//  Copyright © 2020 Sangeetha Gengaram. All rights reserved.
//

import Foundation
import UIKit

let rest = RestManager()

struct XpowerDataClient {
    func loginWithUsernameAndPassword(paramterDic:Dictionary<String,Any>, completionHandler: @escaping (UserInfo? , loginFailed?)->()) {
        var jsonData:UserInfo?
        guard let url = URL(string: BASE_URL + USER_SERVICE_URL + AUTHENTICATION_PATH) else { return }
        rest.httpBodyParameters.addAllBodyParameters(dic: paramterDic)
        rest.makePostRequest(toURL: url) { (results, success) in
            if success {
                if let data = results.data {
               let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    jsonData = try decoder.decode(UserInfo.self, from: data)
                     completionHandler(jsonData, nil)
                } catch  {
                    do {
                       let loginFailData = try decoder.decode(loginFailed.self, from: data)
                        completionHandler(nil,loginFailData)
                        } catch  {
                          print("error decoding dta:\(error)")
                        }
                    }
                }
            }
        }
    }
    func signUpUser(parameters:Dictionary<String,Any>, completionHandler: @escaping (String)->()) {
        guard let url = URL(string: BASE_URL + USER_SERVICE_URL + CREATE_ACCOUNT)
               else
              {
               return
        }
        rest.httpBodyParameters.addAllBodyParameters(dic: parameters)
        rest.makePostRequest(toURL: url) { (results, success) in
            if success
            {
                if let data = results.data {
                let jsonData = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String , Any>
                  completionHandler(jsonData["Result"] as! String)
                 }
            }
        }
    }
    func resetPasswordforMailId(mailId:String, completionHandler: @escaping (String) ->())  {
        let url = URL(string: BASE_URL + USER_SERVICE_URL + RESET_PASSWORD)!
        rest.httpBodyParameters.add(value: Utilities.currentUserName(), forKey: "Username")
        rest.makePostRequest(toURL: url) { (results, success) in
            if success
            {
                if let data = results.data {
                               let responseData = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String , String>
                               completionHandler(responseData["Result"] ?? "")
                               }
            }
        }
    }
    func getDeedsAndPoints(completionHandler: @escaping ([Points]) -> ()) {
        var pointsData:[Points]?
        let url = URL(string: BASE_URL + POINT_SERVICE_URL + POINTS_TABLE)!
        rest.makeRequest(toURL: url, withHttpMethod: .get) { (results) in
            if results.response?.httpStatusCode == 200 {
                if let data = results.data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                pointsData = try decoder.decode(Array<Points>.self, from: data)
                completionHandler(pointsData!)
                } catch  {
                print("error decoding dta:\(error)")
                }
                }
            }
        }
    }
    
    func getFavouriteDeeds(completionHandler: @escaping (TaskList) -> ()) {
        var favTasks:TaskList?
        
        let url = URL(string: BASE_URL + POINT_SERVICE_URL + GET_FAVORITE_TASK)!
        rest.httpBodyParameters.add(value: Utilities.currentUserName(), forKey: USER_NAME)
        rest.makePostRequest(toURL: url) { (results, success) in
            if success
            {
                if let data = results.data {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    do {
                        favTasks = try decoder.decode(TaskList.self, from: data)
                        completionHandler(favTasks!)
                        
                    } catch  {
                        print("error decoding dta:\(error)")
                    }
                }
            }
        }
    }
    func addDeed(deed:String, completionHandler :  @escaping (String)->()) {
        let date:Date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let dateString:String = dateFormatter.string(from: date)
        let url = URL(string: BASE_URL + POINT_SERVICE_URL + ADD_DEEDS)!
        rest.httpBodyParameters.add(value: Utilities.currentUserName(), forKey: "user")
        rest.httpBodyParameters.add(value: deed, forKey: "deed")
        rest.httpBodyParameters.add(value: dateString, forKey: "date")
        rest.makePostRequest(toURL: url) { (results, success) in
            if success
            {
                if let data = results.data {
                    let jsonData = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String , Any>
                    completionHandler(jsonData["Result"] as! String)
                }
            }
        }
        
    }
    func setFavoutiteTask(taskDescription:String,isFavorite:Bool, completionHandler :  @escaping (String)->()) {
        let url = URL(string: BASE_URL + POINT_SERVICE_URL + SET_FAVORITE_TASK)!
        rest.httpBodyParameters.add(value: Utilities.currentUserName(), forKey: "Username")
        rest.httpBodyParameters.add(value: taskDescription, forKey: "Task")
        rest.httpBodyParameters.add(value: isFavorite , forKey: "isFavorite")
        rest.makePostRequest(toURL: url, completionHandler: { (results, success) in
            if success
            {
                if let data = results.data {
                  let jsonData = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String , Any>
                    completionHandler(jsonData["Result"] as! String)
                    
                }
            }
        })
    }
    func getRecentDeeds(completionHandler: @escaping ([RecentDeed]) -> ()) {
        var recentDeeds:[RecentDeed]?
        
        let url = URL(string: BASE_URL + POINT_SERVICE_URL + RECENT_DEEDS)!
        rest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        rest.httpBodyParameters.add(value: Utilities.currentUserName(), forKey: "Username")
        rest.makePostRequest(toURL: url) { (results, success) in
            if success
            {
                if let data = results.data {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    do {
                        recentDeeds = try decoder.decode([RecentDeed].self, from: data)
                        completionHandler(recentDeeds!)
                        
                    } catch  {
                        print("error decoding dta:\(error)")
                    }
                }
            }
        }
    }
    
    func getSchoolPoints(schoolName:String, completionHandler : @escaping (SchoolPoints) -> ()) {
        let url = URL(string: BASE_URL + POINT_SERVICE_URL + SCHOOL_POINTS)!
        rest.httpBodyParameters.add(value: schoolName, forKey: SCHOOL_NAME)
        rest.makePostRequest(toURL: url) { (results, success) in
            if success
            {
                if let data = results.data {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    do {
                        let schPoints:SchoolPoints = try decoder.decode(SchoolPoints.self, from: data)
                        completionHandler(schPoints)
                    } catch  {
                        print("error decoding dta:\(error)")
                    }
                }
            }
        }
    }
    func getFriendList(completionHandler : @escaping (FriendList) -> ()) {
        let url = URL(string: BASE_URL + USER_SERVICE_URL + GET_FRIEND_LIST)!
        rest.httpBodyParameters.add(value: Utilities.currentUserName(), forKey: "Username")
        rest.makePostRequest(toURL: url) { (results, success) in
            if let data = results.data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let friendList:FriendList = try decoder.decode(FriendList.self, from: data)
                    completionHandler(friendList)
                } catch  {
                    print("error decoding dta:\(error)")
                }
            }
        }
    }
    func getFriendRequestList(completionHandler :  @escaping (FriendRequests) -> ()) {
        let url = URL(string: BASE_URL + USER_SERVICE_URL + GET_FRIEND_REQUEST_LIST)!
        rest.httpBodyParameters.add(value: Utilities.currentUserName(), forKey: "Username")
        rest.makePostRequest(toURL: url, completionHandler: { (results, success) in
            if success
            {
                if let data = results.data {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    do {
                        let friendReqs:FriendRequests = try decoder.decode(FriendRequests.self, from: data)
                        completionHandler(friendReqs)
                    } catch  {
                        print("error decoding dta:\(error)")
                    }
                }
            }
        })
    }
    func respondToFriendRequest(receiverName:String, status:Int, completionHandler :  @escaping (String)->()) {
        let url = URL(string: BASE_URL + USER_SERVICE_URL + RESPOND_TO_REQUEST)!
        rest.httpBodyParameters.add(value: Utilities.currentUserName(), forKey: "Sender")
        rest.httpBodyParameters.add(value: receiverName, forKey: "Reciever")
        rest.httpBodyParameters.add(value: status, forKey: "Status")
        
        rest.makePostRequest(toURL: url) { (results, success) in
            if success {
                if let data = results.data {
                    let jsonData = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String,String>
                    completionHandler(jsonData["Result"] ?? "")
                   }
                   }
               }
    }
    func addFriendRequest(receiverName:String, completionHandler :  @escaping (String)->()) {
        let url = URL(string: BASE_URL + USER_SERVICE_URL + ADD_FRIEND_REQUEST)!
        rest.httpBodyParameters.add(value: Utilities.currentUserName(), forKey: "Sender")
        rest.httpBodyParameters.add(value: receiverName, forKey: "Reciever")
        
        rest.makePostRequest(toURL: url) { (results, success) in
            if success {
                if let data = results.data {
                    let jsonData = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String,String>
                    completionHandler(jsonData["Result"] ?? "")
                   }
                   }
               }
        
    }
    func changePasswordWith(newPassword:String, completionHandler: @escaping (String)->()) {
        let url = URL(string: BASE_URL + USER_SERVICE_URL + CHANGE_PASSWORD)!

        rest.httpBodyParameters.add(value: Utilities.currentUserName(), forKey: "Sender")
        rest.httpBodyParameters.add(value: newPassword, forKey: PASSWORD)
        rest.makePostRequest(toURL: url) { (results, success) in
            if success {
                if let data = results.data {
                    let jsonData = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String,String>
                    completionHandler(jsonData["Result"] ?? "")
                   }
                   }
               }
    }
    func toggleTouchId(touchId:Bool, completionHandler: @escaping (String) -> ())  {
        let url = URL(string: BASE_URL + USER_SERVICE_URL + TOGGLE_TOUCH_ID)!
            rest.httpBodyParameters.add(value: Utilities.currentUserName(), forKey: "Sender")
            rest.httpBodyParameters.add(value: touchId, forKey: TOUCH_ID_ON)
        
            rest.makePostRequest(toURL: url) { (results, success) in
                if success {
                    if let data = results.data {
                        let jsonData = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String,String>
                        completionHandler(jsonData["Result"] ?? "")
                       }
                }
            }
    }
    func getMessagesFrom(receiverName:String, completionHandler: @escaping (Conversation) -> ()) {
//        let date:Date = Date()
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let dateString:String = "1970/01/01 00:00:00"
        let url = URL(string: BASE_URL + CHAT_SERVICE_URL + GET_MESSAGES)!
        rest.httpBodyParameters.add(value: Utilities.currentUserName(), forKey: "Sender")
        rest.httpBodyParameters.add(value: receiverName, forKey: "Reciever")
        rest.httpBodyParameters.add(value: dateString, forKey: "DateAndTime")
        rest.makePostRequest(toURL: url) { (results, success) in
            if success {
                if let data = results.data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                        let conversationMsg:Conversation = try decoder.decode(Conversation.self, from: data)
                           completionHandler(conversationMsg)
                    } catch  {
                           print("error decoding dta:\(error)")
                    }
                }
            }
        }
    }
    func sendMessage(receiverName:String, message:String, completionHandler: @escaping (String) -> ()) {
        let date:Date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let dateString:String = dateFormatter.string(from: date)
        let url = URL(string: BASE_URL + CHAT_SERVICE_URL + SEND_MESSAGE)!
        rest.httpBodyParameters.add(value: Utilities.currentUserName(), forKey: "Sender")
        rest.httpBodyParameters.add(value: receiverName, forKey: "Reciever")
        rest.httpBodyParameters.add(value: message, forKey: "Message")
        rest.httpBodyParameters.add(value: dateString, forKey: "DateAndTime")
        
        rest.makePostRequest(toURL: url) { (results, success) in
            if success {
                if let data = results.data {
                    let jsonData = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String,String>
                        completionHandler(jsonData["Result"] ?? "")
                    }
            }
        }
    }
    func getUserProgress(completionHandler: @escaping (ProgressPoints) ->()) {
       
        let url = URL(string: BASE_URL + POINT_SERVICE_URL + GET_USER_PROGRESS)!
        rest.httpBodyParameters.add(value: Utilities.currentUserName(), forKey: "Username")
        rest.makePostRequest(toURL: url) { (results, success) in
            if success {
                if let data = results.data {
                    let jsonData = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String,Any>
                    let progressPoints:ProgressPoints = self.modelProgressPoints(dic: jsonData)
                    completionHandler(progressPoints)
                }
            }
        }
    }
    func modelProgressPoints(dic:Dictionary<String,Any>) -> ProgressPoints {
        var progress:ProgressPoints?
        var months:[Month] = [Month]()
        
        let month1:Month = Month(name: "Jan", progress: dic["Jan"] as! Int)
        months.append(month1 )
        
        let month2:Month = Month(name: "Feb", progress: dic["Feb"] as! Int)
        months.append(month2)
        let month3:Month = Month(name: "Mar", progress: dic["Mar"] as! Int)
        months.append(month3)
        let month4:Month = Month(name: "Apr", progress: dic["Apr"] as! Int)
        months.append(month4)
        let month5:Month = Month(name: "May", progress: dic["May"] as! Int)
       months.append(month5)
        let month6:Month = Month(name: "Jun", progress: dic["Jun"] as! Int)
        months.append(month6)
        let month7:Month = Month(name: "Jul", progress: dic["Jul"] as! Int)
       months.append(month7)
        let month8:Month = Month(name: "Aug", progress: dic["Aug"] as! Int)
        months.append(month8)
        let month9:Month = Month(name: "Sep", progress: dic["Sep"] as! Int)
        months.append(month9)
        let month10:Month = Month(name: "Oct", progress: dic["Oct"] as! Int)
        months.append(month10)
        let month11:Month = Month(name: "Nov", progress: dic["Nov"] as! Int)
       months.append(month11)
        let month12:Month = Month(name: "Dec", progress: dic["Dec"] as! Int)
        months.append(month12)
        progress = ProgressPoints(allMonths: months)
        return progress!
    }
    func getUserDailyPoints(completionHandler: @escaping (Int) -> ()) {
        let url = URL(string: BASE_URL + POINT_SERVICE_URL + GET_DAILY_POINTS)!
        rest.httpBodyParameters.add(value: Utilities.currentUserName(), forKey: "Username")
        rest.makePostRequest(toURL: url) { (results, success) in
        if success {
                if let data = results.data {
                    let jsonData = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String,Int>
                    completionHandler(jsonData["totalpoints"] ?? 0)
                }
        }
    }
    }
    func getTotalSchoolPoints(completionHandler: @escaping (Int) -> ()) {
        let url = URL(string: BASE_URL + POINT_SERVICE_URL + GET_TOTAL_SCHOOL_POINTS)!
        rest.httpBodyParameters.add(value: Utilities.currentUserSchoolName(), forKey: "SchoolName")
        
        rest.makePostRequest(toURL: url) { (results, success) in
                if success {
                    if let data = results.data {
                        let jsonData = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String,Int>
                        completionHandler(jsonData["totalpoints"] ?? 0)
                       }
                }
        }
    }
}