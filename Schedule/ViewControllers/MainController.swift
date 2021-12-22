//
//  ViewController.swift
//  Schedule
//
//  Created by Ignat Urbanovich on 18.12.21.
//

import UIKit
   
var groups: [Group]  = []
var lecturers: [Lecturer]  = []

let decoder = JSONDecoder()
let encoder = JSONEncoder()
let dateFormatter = DateFormatter()

var favoritesGroups: [Group]  = []
var favoritesLecturers: [Lecturer]  = []
var favoritesSchedules: [SomeSchedule] = []


var currentGroup: Group?
var currentLecturer: Lecturer?

var currentWeekNum: Int?

class MainController: UINavigationController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if lecturers.isEmpty {
            SetLecturersArray()
        }
        if groups.isEmpty {
            SetGroupsArray()
        }
        
        if favoritesGroups.isEmpty {
            SetFavoritesGroups()
        }
        
        if favoritesLecturers.isEmpty {
            SetFavoritesLecturers()
        }
        if favoritesSchedules.isEmpty {
            SetFavoritesSchedulesFromArray()
        }
        
        currentWeekNum = UserDefaults.standard.object(forKey: "currentWeekNum") as? Int
        if !favoritesGroups.isEmpty {
            currentGroup = favoritesGroups[0]
        }
        
        RequestManager.shared.loadGroups(completionHandler: { (url) in
            UserDefaults.standard.set(url.path, forKey: "groupsFile_url_path")
            UserDefaults.standard.synchronize()
            
            SetGroupsArray()
            
        })
        
        RequestManager.shared.loadLecturers(completionHandler: { (url) in
            UserDefaults.standard.set(url.path, forKey: "lecturersFile_url_path")
            UserDefaults.standard.synchronize()
            
            
            SetLecturersArray()
            
        })
        
        RequestManager.shared.loadCurrentWeekNum(completionHandler: { (url) in
            UserDefaults.standard.set(url.path, forKey: "weekNum_url_path")
            UserDefaults.standard.synchronize()
            
            
            SetWeekNum()
            
        })
        
        
        viewControllers = [ScheduleViewController()]
        
    }
    
    
    
    
}


func SetLecturersArray() {
    
    guard let url = UserDefaults.standard.object(forKey: "lecturersFile_url_path") else {
        return
    }
    
    let data = try? Data(contentsOf: URL(fileURLWithPath: url as! String))
    
    if data == nil {
        return
    }
    do {
        lecturers = try decoder.decode([Lecturer].self, from: data!)
    } catch {
        print(error)
    }
    
    
}

func SetGroupsArray() {
    
    guard let url = UserDefaults.standard.object(forKey: "groupsFile_url_path") else {
        return
    }
    
    let data = try? Data(contentsOf: URL(fileURLWithPath: url as! String))
    
    if data == nil {
        return
    }
    do {
        groups = try decoder.decode([Group].self, from: data!)
    } catch {
        print(error)
    }
    
    
}

func SetFavoritesGroups() {
    let data = UserDefaults.standard.object(forKey: "favGroups_array")
    
    
    if data == nil {
        return
    }
    
    favoritesGroups = try! decoder.decode([Group].self, from: data! as! Data)
    
}

func SetFavoritesLecturers() {
    
    let data = UserDefaults.standard.object(forKey: "favLecturers_array")
    
    if data == nil {
        return
    }
    favoritesLecturers = try! decoder.decode([Lecturer].self, from: data! as! Data)
    
}

func SetFavoritesSchedulesFromArray() {
    let data = UserDefaults.standard.object(forKey: "favoritesSchedules_array")
    
    
    if data == nil {
        return
    }
    
    favoritesSchedules = try! decoder.decode([SomeSchedule].self, from: data! as! Data)
    
}
func SetFavoritesSchedulesFromUrl() {
    
    guard let url = UserDefaults.standard.object(forKey: "favorite_url_path") else {
        return
    }
    
    let data = try? Data(contentsOf: URL(fileURLWithPath: url as! String))
    
    if data == nil {
        return
    }

    do {
        favoritesSchedules.append(try decoder.decode(SomeSchedule.self, from: data!))
    } catch {
        print(error)
    }
    
    
}


func SetWeekNum() {
    
    guard let url = UserDefaults.standard.object(forKey: "weekNum_url_path") else {
        return
    }
    
    let data = try? Data(contentsOf: URL(fileURLWithPath: url as! String))
    
    if data == nil {
        return
    }
    //var newWeekNum = currentWeekNum
    let stringInt = String.init(data: data!, encoding: String.Encoding.utf8)
    currentWeekNum = Int.init(stringInt ?? "")
    
    if let currentWeekNum = currentWeekNum {
        UserDefaults.standard.set(currentWeekNum, forKey: "currentWeekNum")
        UserDefaults.standard.synchronize()
    }
    
    
    
}


func SaveFavorites() {
    let favoritesGroupsData = try! encoder.encode(favoritesGroups)
    let favoritesLecturersData = try! encoder.encode(favoritesLecturers)
    
    UserDefaults.standard.set(favoritesGroupsData, forKey: "favGroups_array")
    UserDefaults.standard.set(favoritesLecturersData, forKey: "favLecturers_array")
    UserDefaults.standard.synchronize()
}

func SaveFavoritesSchedules() {
    let favoritesSchedulesData = try! encoder.encode(favoritesSchedules)
    
    
    UserDefaults.standard.set(favoritesSchedulesData, forKey: "favoritesSchedules_array")
    UserDefaults.standard.synchronize()
}
