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
    
    var swipeLeft: UISwipeGestureRecognizer!
    var swipeRight: UISwipeGestureRecognizer!
    
    var refreshControl: UIRefreshControl?
    var indexInFavorites: Int?
    

    
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
        //table.bounces = false
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
        
        
        refreshControl = UIRefreshControl()
        refreshControl!.attributedTitle = NSAttributedString(string: "Updating...")
        refreshControl!.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: idScheduleCell)
        tableView.addSubview(refreshControl!)
        
        setConstraints()
        createSwipeRecognizer()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if currentGroup != nil {
            for (index, schedule) in favoritesSchedules.enumerated() {
                if schedule.studentGroup?.id == currentGroup?.id {
                    indexInFavorites = index
                    self.refreshControl?.endRefreshing()
                    tableView.reloadData()
                    
                }
            }
        }
    }
    
    //MARK: Swipe recognizer
    func createSwipeRecognizer() {
        
        swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        swipeUp.direction = .up
        swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        swipeDown.direction = .down
        
        swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        swipeLeft.direction = .left
        swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        swipeRight.direction = .right
        
        
        calendar.addGestureRecognizer(swipeUp)
        calendar.addGestureRecognizer(swipeDown)
        
        
        tableView.addGestureRecognizer(swipeLeft)
        tableView.addGestureRecognizer(swipeRight)
        
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
        self.viewWillAppear(true)
    }
    
}


//MARK: TableView delegates
extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let indexInFavorites = indexInFavorites else {
            return 0
        }
        var count = 0
        
        for schItem in favoritesSchedules[indexInFavorites].schedules {
            if schItem.weekDay?.uppercased() == getWeekDay(for: calendar.selectedDate!) {
                for subj in schItem.schedule {
                    for weekNum in subj.weekNumber {
                        if weekNum == 0 || weekNum == currentWeekNum {
                            count += 1
                            break
                        }
                    }
                }
            }
        }
        return count
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: idScheduleCell, for: indexPath) as! ScheduleTableViewCell
        guard let indexInFavorites = indexInFavorites else {
            return cell
        }
        
        var count = 0;
        for schItem in favoritesSchedules[indexInFavorites].schedules {
            if schItem.weekDay?.uppercased() == getWeekDay(for: calendar.selectedDate!) {
                for (index,subj) in schItem.schedule.enumerated() {
                    for weekNum in subj.weekNumber {
                        if weekNum == 0 || weekNum == currentWeekNum {
                            cell.lessonName.text = subj.subject
                            cell.teacherName.text = subj.employee[0].fio
                            cell.lessonTime.text = subj.lessonTime
                            cell.lessonClass.text = subj.auditory[0]
                            switch subj.lessonType {
                            case SubjectTypes.LK.rawValue: cell.backgroundColor = .green
                            case SubjectTypes.LR.rawValue: cell.backgroundColor = .red
                            case SubjectTypes.PZ.rawValue: cell.backgroundColor = .yellow
                            default: break
                            }
                            count += 1
                            break
                        }
                    }
                    if (count>indexPath.section) {
                        return cell
                    }
                
                }
            }
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func getWeekDay(for date: Date) -> String {
        let calendarCurrent = Calendar.current
        let component = calendarCurrent.dateComponents([.weekday], from: date)
        
        guard let weekDay = component.weekday else {
            return ""
        }
        switch weekDay {
        case 2: return "ПОНЕДЕЛЬНИК"
        case 3: return "ВТОРНИК"
        case 4: return "СРЕДА"
        case 5: return "ЧЕТВЕРГ"
        case 6: return "ПЯТНИЦА"
        case 7: return "СУББОТА"
        case 1: return "ВОСКРЕСЕНЬЕ"
        default: return ""
        }
        
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
        case swipeLeft:
            calendar.select(calendar.selectedDate?.addingTimeInterval(86400.0))
            viewWillAppear(true)
        case swipeRight:
            calendar.select(calendar.selectedDate?.addingTimeInterval(-86400.0))
            viewWillAppear(true)
        default: break
        }
    }
    
    @objc func addSchedule () {
        let searchVC = SearchViewController()
        searchVC.delegateUpdate = self
        navigationController?.pushViewController(searchVC, animated: true)
    }

    @objc func refresh() {
        self.viewWillAppear(true)
    }

}

//MARK: Update delegate
extension ScheduleViewController: UpdateProtocol {
    func update() {
        self.viewWillAppear(true)
    }
}
