//
//  SudjectTableViewController.swift
//  Schedule
//
//  Created by Ignat Urbanovich on 20.01.22.
//

import UIKit

class SubjectTableViewController: UITableViewController {

    var subject: Subject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.bounces = false
        tableView.register(SubjectTableViewCell.self, forCellReuseIdentifier: "subjectCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.sectionFooterHeight = 10
        tableView.backgroundColor = #colorLiteral(red: 0.9400000572, green: 0.9400000572, blue: 0.9400000572, alpha: 1)
        
        if let _ = subject {
            
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 2
        case 1: return 2
        case 2: return 2
        default: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = #colorLiteral(red: 0.9400000572, green: 0.9400000572, blue: 0.9400000572, alpha: 1)
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subjectCell", for: indexPath) as? SubjectTableViewCell
        
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell?.isImage = false
                cell?.label.text = "Предмет"
                cell?.label2.text = subject?.subject
            case 1:
                cell?.isImage = false
                cell?.label.text = "Тип"
                cell?.label2.text = subject?.lessonType
            default: break
            }
        case 1:
            switch indexPath.row {
            case 0:
                cell?.isImage = false
                cell?.label.text = "Время"
                cell?.label2.text = subject?.lessonTime
            case 1:
                cell?.isImage = false
                cell?.label.text = "Аудитория"
                cell?.label2.text = subject?.auditory[0]
            default: break
            }
        case 2:
            switch indexPath.row {
            case 0:
                cell?.isImage = false
                cell?.label.text = "Препод"
                cell?.label2.text = subject?.employee[0].fio
            case 1:
                cell?.isImage = false
                cell?.label.text = "Звание"
                cell?.label2.text = subject?.employee[0].degree
            default: break
            }
       default: break
        }

    
        return cell!
    }
    
}
