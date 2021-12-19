//
//  RequestManager.swift
//  Schedule
//
//  Created by Ignat Urbanovich on 19.12.21.
//

import Foundation

class RequestManager {
    
    let base = "https://journal.bsuir.by/api/v1"

    let lecturers = "/employees"
    let groups = "/groups"
    
    static var shared: RequestManager = {
        let instance = RequestManager()
        
        return instance
    }()
    
    private init() {
        
      
    }
    
    func loadGroups(completionHandler: ((_ filePath: URL)->Void)?) {
        let urlGroups = URL(string: base+groups)
        let session = URLSession(configuration: .default)

        let downTask = session.downloadTask(with: urlGroups!) {(urlFile,response,error) in
            guard let urlFile = urlFile else {
                return
            }
            let path = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]+"/groups.json"

            let urlPath = URL(fileURLWithPath: path)

            try? FileManager.default.copyItem(at: urlFile, to: urlPath)

            completionHandler?(urlPath)


        }
        downTask.resume()
    }
    
    
    func loadLecturers(completionHandler: ((_ filePath: URL)->Void)?) {
        let url = URL(string: base+lecturers)
        let session = URLSession(configuration: .default)
        
        let downTask = session.downloadTask(with: url!) {(urlFile,response,error) in
            guard let urlFile = urlFile else {
                return
            }
            let path = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]+"/lecturers.json"

            let urlPath = URL(fileURLWithPath: path)
            
            try? FileManager.default.copyItem(at: urlFile, to: urlPath)
            
            completionHandler?(urlPath)
        }

        
        downTask.resume()
    }
}
