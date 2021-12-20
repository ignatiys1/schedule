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

var currentGroup: Group?
var currentLecturer: Lecturer?

class MainController: UINavigationController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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

func SaveFavorites() {
    let favoritesGroupsData = try! encoder.encode(favoritesGroups)
    let favoritesLecturersData = try! encoder.encode(favoritesLecturers)
    
    UserDefaults.standard.set(favoritesGroupsData, forKey: "favGroups_array")
    UserDefaults.standard.set(favoritesLecturersData, forKey: "favLecturers_array")
    UserDefaults.standard.synchronize()
}
