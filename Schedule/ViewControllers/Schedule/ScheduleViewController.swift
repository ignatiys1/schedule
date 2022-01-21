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
    
    var refreshAlert: UIAlertController?
    
    var groupChanged = false
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
        
        if let currentGroup = currentGroup {
            title! += " \(currentGroup.name)"
        } else if let currentLecturer = currentLecturer {
            title! += " \(currentLecturer.fio)"
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSchedule))
        
        refreshAlert = UIAlertController(title: "Обновление...", message: nil, preferredStyle: .actionSheet)
        
        
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
        
        sleep(1)
        update()
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
        update()
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
        for schedule in favoritesSchedules {
            if schedule.studentGroup?.id == currentGroup?.id {
                for schItem in schedule.schedules {
                    if schItem.weekDay?.uppercased() == getWeekDay(for: calendar.selectedDate!) {
                        for (index,subj) in schItem.schedule.enumerated() {
                            for weekNum in subj.weekNumber {
                                if weekNum == 0 || weekNum == currentWeekNum {
                                    
                                    cell.setCell(for: subj)
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
            }
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let indexInFavorites = indexInFavorites else {
            return
        }
        
        var subjectToSend: Subject?
        var count = 0
        
        for schItem in favoritesSchedules[indexInFavorites].schedules {
            if schItem.weekDay?.uppercased() == getWeekDay(for: calendar.selectedDate!) {
                for (index,subj) in schItem.schedule.enumerated() {
                    for weekNum in subj.weekNumber {
                        if weekNum == 0 || weekNum == currentWeekNum {
                            
                            subjectToSend = subj
                            count += 1
                            break
                        }
                    }
                    if (count>indexPath.section) {
                        break
                    }
                }
            }
        }
        
        if let subjectToSend = subjectToSend {
            let VC = SubjectTableViewController()
            VC.subject = subjectToSend
            self.navigationController?.pushViewController(VC, animated: true)
        }
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
        refreshBegin(newtext: "Refresh",
                     refreshEnd: {(x:Int) -> () in
            self.update()
            self.refreshControl?.endRefreshing()
        })
    }
    
    func refreshBegin(newtext:String, refreshEnd: @escaping (Int) -> ()) {
        DispatchQueue.global(qos: .default).async(execute: {
            
            var indexToDelete: Int?
            if currentGroup != nil {
                for (index, schedule) in favoritesSchedules.enumerated() {
                    if schedule.studentGroup?.id == currentGroup?.id {
                        indexToDelete = index
                    }
                }
            }
            if let indexToDelete = indexToDelete {
                favoritesSchedules.remove(at: indexToDelete)
            }
            
            RequestManager.shared.loadSchedule(for: currentGroup!, completionHandler: { (url) in
                
                UserDefaults.standard.set(url.path, forKey: "favorite_url_path")
                UserDefaults.standard.synchronize()
                
                
                SetFavoritesSchedulesFromUrl()
                SaveFavoritesSchedules()
                
                DispatchQueue.main.async(execute: {
                    
                    refreshEnd(0)
                })
            })
        })
    }

}

//MARK: Update delegate
extension ScheduleViewController: UpdateProtocol {
    func update() {
        title = "Schedule"
        
        if let currentGroup = currentGroup {
            title! += " \(currentGroup.name)"
        }
        var favSc = favoritesSchedules
        if currentGroup != nil {
            for (index, schedule) in favoritesSchedules.enumerated() {
                if schedule.studentGroup?.id == currentGroup?.id {
                    indexInFavorites = index
                    tableView.reloadData()
                }
            }
        }
        refreshAlert?.dismiss(animated: true, completion: nil)
    }
    
    func startUpdating() {
        present(refreshAlert!, animated: true, completion: nil)
    }
    
}
