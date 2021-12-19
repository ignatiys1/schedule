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
        return table
    }()
    let idSearchCell = "idSearchCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        title  = "Search"
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchCell.self, forCellReuseIdentifier: idSearchCell)
        
        searchField.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        
        setConstraints()
    }
    
}

//MARK: TableView delegates
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lecturerForShow.count + groupsForShow.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: idSearchCell, for: indexPath) as! SearchCell
        
        cell.backgroundColor = .gray
        
        if indexPath.row <= groupsForShow.count-1 {
            cell.typeName.text = "Group:"
            cell.justName.text = groupsForShow[indexPath.row].name
        } else {
            cell.typeName.text = "Lecturer:"
            cell.justName.text = lecturerForShow[indexPath.row - groupsForShow.count].fio
        }
        
        
        
        return cell
        
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
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
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
}
