//
//  ScheduleViewController.swift
//  Schedule
//
//  Created by Ignat Urbanovich on 18.12.21.
//

import Foundation
import UIKit
import FSCalendar

class ScheduleViewController: UIViewController {
    
    var calendarHeight: NSLayoutConstraint!
    var swipeUp: UISwipeGestureRecognizer!
    var swipeDown: UISwipeGestureRecognizer!
    
    private var calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.translatesAutoresizingMaskIntoConstraints = false
        return calendar
    }()
    
    let showHideButton : UIButton = {
        let button = UIButton()
        
        button.setTitle("Open calendar", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .avenirNextDemiBold14
        button.translatesAutoresizingMaskIntoConstraints = false
        // button.backgroundColor = .blue
        return button
    }()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.bounces = false
        table.separatorStyle = .none
        table.sectionFooterHeight = 10
        table.backgroundColor = #colorLiteral(red: 0.9400000572, green: 0.9400000572, blue: 0.9400000572, alpha: 1)
        return table
    }()
    let idScheduleCell = "idScheduleCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9400000572, green: 0.9400000572, blue: 0.9400000572, alpha: 1)
        title = "Schedule"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSchedule))
        
        
        
        calendar.delegate = self
        calendar.dataSource = self
        calendar.scope = .week
        calendar.select(.now)
        
        showHideButton.addTarget(self, action: #selector(showHideButtonTapped), for: .touchUpInside)
        showHideButton.isHidden = true
        
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: idScheduleCell)
        
        setConstraints()
        createSwipeRecognizer()
        
    }
    
    //MARK: Swipe recognizer
    func createSwipeRecognizer() {
        
        swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        swipeUp.direction = .up
        swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        swipeDown.direction = .down
        
        calendar.addGestureRecognizer(swipeUp)
        calendar.addGestureRecognizer(swipeDown)
        
    }
    
    
}

//MARK: Constraints

extension ScheduleViewController {
    
    func setConstraints() {
        view.addSubview(calendar)
        
        
        calendarHeight = NSLayoutConstraint(item: calendar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)
        
        calendar.addConstraint(calendarHeight)
        
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: view.topAnchor, constant: 90),
            calendar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            calendar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
            //calendar.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        
        view.addSubview(showHideButton)
        NSLayoutConstraint.activate([
            showHideButton.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 0),
            showHideButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            showHideButton.widthAnchor.constraint(equalToConstant: 150),
            showHideButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
        
    }
    
}



//MARK: FSCalendar delegates
extension ScheduleViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeight.constant = bounds.height
        view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        
        
    }
    
}


//MARK: TableView delegates
extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: idScheduleCell, for: indexPath) as! ScheduleTableViewCell
        
        //cell.textLabel?.text = "Hello"
        cell.backgroundColor = .blue
        
        return cell
        
    }
    
    
    
        func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            let headerView = UIView()
            headerView.backgroundColor = UIColor.clear
            return headerView
        }
    
}


//MARK: Actions
extension ScheduleViewController {
    
    @objc func showHideButtonTapped() {
        
        switch calendar.scope {
        case .week:
            calendar.setScope(.month, animated: true)
            showHideButton.setTitle("Close calendar", for: .normal)
        case .month:
            calendar.setScope(.week, animated: true)
            showHideButton.setTitle("Open calendar", for: .normal)
        default: break
        }
        
        
    }
    
    
    @objc func swipeAction(swipe: UISwipeGestureRecognizer) {
        switch swipe {
        case swipeUp:
            if calendar.scope == .month {
                calendar.setScope(.week, animated: true)
                showHideButton.setTitle("Open calendar", for: .normal)
            }
        case swipeDown:
            if calendar.scope == .week {
                calendar.setScope(.month, animated: true)
                showHideButton.setTitle("Close calendar", for: .normal)
            }
        default: break
        }
    }
    
    
    @objc func addSchedule () {
        let searchVC = SearchViewController()
        navigationController?.pushViewController(searchVC, animated: true)
    }
}
