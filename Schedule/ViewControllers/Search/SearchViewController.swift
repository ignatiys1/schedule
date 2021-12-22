//
//  SearchViewController.swift
//  Schedule
//
//  Created by Ignat Urbanovich on 19.12.21.
//

import Foundation
import UIKit

class SearchViewController: UIViewController {
    
    var groupsForShow: [Group] = []
    var lecturerForShow: [Lecturer] = []
    var delegateUpdate: UpdateProtocol?
    
    let searchField : UITextField = {
        let field = UITextField()
        
        field.textAlignment = .center
        field.placeholder = "Search Group/Lecturer"
        field.font = .avenirNext30
        //field.backgroundColor = .blue
        field.textColor = .black
        
        field.translatesAutoresizingMaskIntoConstraints = false
        // button.backgroundColor = .blue
        return field
    }()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.bounces = false
        table.separatorStyle = .singleLine
        table.separatorColor = .gray
        table.layer.cornerRadius = 10
        table.backgroundColor = #colorLiteral(red: 0.9400000572, green: 0.9400000572, blue: 0.9400000572, alpha: 1)
        return table
    }()
    let idSearchCell = "idSearchCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9400000572, green: 0.9400000572, blue: 0.9400000572, alpha: 1)
        title  = "Search"
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(longPressGestureRecognizer:)))
        longPressRecognizer.minimumPressDuration = 0.5
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchCell.self, forCellReuseIdentifier: idSearchCell)
        tableView.addGestureRecognizer(longPressRecognizer)
        
        
        searchField.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        
        setConstraints()
    }
    
}

//MARK: TableView delegates
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if lecturerForShow.count > 0 || groupsForShow.count > 0 {
            return lecturerForShow.count + groupsForShow.count
        } else {
            return favoritesGroups.count + favoritesLecturers.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: idSearchCell, for: indexPath) as! SearchCell
        
        if lecturerForShow.count > 0 || groupsForShow.count > 0 {
            if indexPath.row <= groupsForShow.count-1 {
                cell.typeName.text = "Group:"
                cell.justName.text = groupsForShow[indexPath.row].name
            } else {
                cell.typeName.text = "Lecturer:"
                cell.justName.text = lecturerForShow[indexPath.row - groupsForShow.count].fio
            }
        } else {
            if indexPath.row <= favoritesGroups.count-1 {
                cell.typeName.text = "Group:"
                cell.justName.text = favoritesGroups[indexPath.row].name
            } else {
                cell.typeName.text = "Lecturer:"
                cell.justName.text = favoritesLecturers[indexPath.row - favoritesGroups.count].fio
            }
            
        }
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
        if lecturerForShow.count > 0 || groupsForShow.count > 0 {
            
            if indexPath.row <= groupsForShow.count-1 {
                
                for group in favoritesGroups {
                    if group.id == groupsForShow[indexPath.row].id {
                        self.navigationController?.popViewController(animated: true)
                        return
                    }
                }
                favoritesGroups.append(groupsForShow[indexPath.row])
                currentGroup = groupsForShow[indexPath.row]
                RequestManager.shared.loadSchedule(for: currentGroup!, completionHandler: {urlPath in
                    
                    UserDefaults.standard.set(urlPath.path, forKey: "favorite_url_path")
                    UserDefaults.standard.synchronize()
                    
                    
                    SetFavoritesSchedulesFromUrl()
                    SaveFavoritesSchedules()
                    self.delegateUpdate?.update()
                })
                currentLecturer = nil
            } else {
                for lector in favoritesLecturers {
                    if lector.id == lecturerForShow[indexPath.row - groupsForShow.count].id {
                        self.navigationController?.popViewController(animated: true)
                        return
                    }
                }
                favoritesLecturers.append(lecturerForShow[indexPath.row - groupsForShow.count])
                currentGroup = nil
                currentLecturer = lecturerForShow[indexPath.row - groupsForShow.count]
                
            }
            SaveFavorites()
        } else {
            
            if indexPath.row <= favoritesGroups.count-1 {
                currentGroup = favoritesGroups[indexPath.row]
                RequestManager.shared.loadSchedule(for: favoritesGroups[indexPath.row], completionHandler: {urlPath in
                    
                    UserDefaults.standard.set(urlPath.path, forKey: "favorite_url_path")
                    UserDefaults.standard.synchronize()
                    
                    
                    SetFavoritesSchedulesFromUrl()
                    SaveFavoritesSchedules()
                    self.delegateUpdate?.update()
                })
                currentLecturer = nil
            } else {
                currentGroup = nil
                currentLecturer = favoritesLecturers[indexPath.row - favoritesGroups.count]
                
            }
            
            
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delButton = UITableViewRowAction(style: .normal, title: "Del", handler: {rowAction, indexPath in
            if !(self.lecturerForShow.count > 0 || self.groupsForShow.count > 0) {
                
                if indexPath.row <= favoritesGroups.count-1 {
                    if currentGroup?.id == favoritesGroups[indexPath.row].id {
                        currentGroup = nil
                    }
                    favoritesGroups.remove(at: indexPath.row)
                    
                } else {
                    if currentLecturer?.id == favoritesLecturers[indexPath.row - favoritesGroups.count].id {
                        currentLecturer = nil
                    }
                    favoritesLecturers.remove(at: indexPath.row - favoritesGroups.count)
                }
                
            }
            SaveFavorites()
            self.tableView.reloadData()
        })
        delButton.backgroundColor = .red
        
        
        return [delButton]
        
    }
    
    
}



//MARK: Constraints

extension SearchViewController {
    
    func setConstraints() {
        
        view.addSubview(searchField)
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: view.topAnchor, constant: 90),
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),
            searchField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
        
    }
    
}

//MARK: Actions
extension SearchViewController {
    @objc func textFieldDidChange(textfield: UITextField) {
        
        lecturerForShow = []
        groupsForShow = []
        
        if textfield.text != "" && textfield.text != nil{
            for group in groups {
                if group.name.starts(with: textfield.text!) {
                    groupsForShow.append(group)
                }
            }
            for lector in lecturers {
                if (lector.firstName?.uppercased().starts(with: textfield.text!.uppercased()) ?? false) ||
                    (lector.lastName?.uppercased().starts(with: textfield.text!.uppercased()) ?? false)  {
                    lecturerForShow.append(lector)
                }
            }
        }
        tableView.reloadData()
    }
    
    @objc func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {
            
            let touchPoint = longPressGestureRecognizer.location(in: self.view)
            print(touchPoint)
            if let indexPath = self.tableView.indexPathForRow(at: touchPoint) {
                if !(lecturerForShow.count > 0 || groupsForShow.count > 0) {
                    if indexPath.row <= favoritesGroups.count-1 {
                        favoritesGroups.remove(at: indexPath.row)
                    } else {
                        favoritesLecturers.remove(at: indexPath.row - favoritesGroups.count)
                    }
                    tableView.reloadData()
                }
            }
        }
    }
}

//MARK: DelegateProtocol

protocol UpdateProtocol {
    func update()
}
