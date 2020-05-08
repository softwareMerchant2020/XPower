//
//  Points.swift
//  XPower
//
//  Created by Sangeetha Gengaram on 3/12/20.
//  Copyright © 2020 Sangeetha Gengaram. All rights reserved.
//

import Foundation
struct Points:Codable {
    let Description:String
    let Point:Int
}
struct PointsList:Codable {
    var pointsList:[Points]?
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        pointsList = try values.decodeIfPresent([Points].self, forKey: .pointsList)
    }
}
struct TaskList: Codable {
    let count: Int
    let tasksList: [TasksList]?
    let username: String

    enum CodingKeys: String, CodingKey {
        case count = "Count"
        case tasksList = "TasksList"
        case username = "Username"
    }
}

// MARK: - TasksList
struct TasksList: Codable {
    let task: String

    enum CodingKeys: String, CodingKey {
        case task = "Task"
    }
}
struct RecentDeed: Codable {
    let date, deed: String
}
struct SchoolPoints: Codable {
    let totalpoints: Int
}

// MARK: User PRogress points

struct ProgressPoints {
    var allMonths: [Month]?
    
}
struct Month {
    let name:String
    let progress:Int
}
struct UserProgress: Codable {
    let jan, feb, mar, apr: Int
    let may, jun, jul, aug: Int
    let sep, oct, nov, dec: Int
    let maxPoint: Int
    let error: String

    enum CodingKeys: String, CodingKey {
        case jan = "Jan"
        case feb = "Feb"
        case mar = "Mar"
        case apr = "Apr"
        case may = "May"
        case jun = "Jun"
        case jul = "Jul"
        case aug = "Aug"
        case sep = "Sep"
        case oct = "Oct"
        case nov = "Nov"
        case dec = "Dec"
        case maxPoint = "MaxPoint"
        case error = "Error"
    }
}
