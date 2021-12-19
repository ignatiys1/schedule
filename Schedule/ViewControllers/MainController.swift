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
let dateFormatter = DateFormatter()



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
