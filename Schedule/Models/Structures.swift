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

struct SomeSchedule: Decodable, Encodable {
    
var employee: Lecturer?
    var studentGroup: Group?
    var schedules: [ScheduleItem] = []
    
    
    var tomorrowDate: Date?
    var tomorrowSchedules: [ScheduleItem] = []
    
    var todayDate: Date?
    var todaySchedules: [Subject] = []
   
    var examSchedules: [ScheduleItem] = []
    
    
    var currentWeekNumber: Int?
    var dateStart: Date?
    var dateEnd: Date?
    var sessionStart: Date?
    var sessionEnd: Date?
    
}

struct ScheduleItem : Decodable, Encodable {
    var weekDay: String?
    var schedule: [Subject] = []
}


struct Subject : Decodable, Encodable {
   
    var weekNumber : [Int] = []
    var studentGroup : [String] = []
    var studentGroupInformation : [String] = []
    var numSubgroup: Int?
    var auditory: [String] = []
    var lessonTime: String?
    var startLessonTime: String?
    var endLessonTime: String?
    var gradebookLesson : String?
    var subject: String?
    var note: String?
    var lessonType: String?
    var employee: [Lecturer] = []
    var studentGroupModelList: String? =  nil
    var zaoch: Bool = false
    var gradebookLessonlist: String? = nil
    
    
    
}
