//
//  Structures.swift
//  Schedule
//
//  Created by Ignat Urbanovich on 19.12.21.
//

import Foundation

struct Group: Decodable, Encodable{
   
    
    var name = ""
    var facultyId : Int?
    var facultyName: String?
    var specialityDepartmentEducationFormId : Int?
    var specialityName: String?
    var course: Int?
    var id = 0
    var calendarId: String?
}

struct Lecturer: Decodable,  Encodable {
    var firstName: String?
    var lastName: String?
    var middleName: String?
    var degree: String?
    var rank: String?
    var photoLink : String?
    var calendarId : String?
    var academicDepartment: [String] = []
    var urlId : String?
    var fio : String?
    
    var id = 0
    
}


