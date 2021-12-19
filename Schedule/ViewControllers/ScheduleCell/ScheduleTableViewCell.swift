//
//  ScheduleTableViewCell.swift
//  Schedule
//
//  Created by Ignat Urbanovich on 18.12.21.
//

import Foundation
import UIKit

class ScheduleTableViewCell: UITableViewCell {
    
    let lessonName: UILabel = UILabel(text: "Lesson", font: .avenirNextDemiBold20, textAlignment: .left)
    let teacherName: UILabel = UILabel(text: "Teacher", font: .avenirNext20, textAlignment: .right)
    let lessonTime: UILabel = UILabel(text: "08:00", font: .avenirNext20, textAlignment: .left)
    let lessonClass: UILabel = UILabel(text: "305-4", font: .avenirNext20, textAlignment: .left)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        DispatchQueue.main.asyncAfter(deadline: .now()+0.05, execute: {
            self.setConstraints()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

//MARK: Constraints

extension ScheduleTableViewCell {
    
    func setConstraints() {
        
        let topStackView = UIStackView(arrangedSubviews: [lessonName, teacherName], axis: .horizontal, spacing: 10, distribution: .fillEqually)
        
        self.addSubview(topStackView)
        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            topStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            topStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor,  constant: -5),
            topStackView.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        self.addSubview(lessonTime)
        NSLayoutConstraint.activate([
            lessonTime.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            lessonTime.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            lessonTime.widthAnchor.constraint(equalToConstant: 100),
            lessonTime.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        self.addSubview(lessonClass)
        NSLayoutConstraint.activate([
            lessonClass.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            lessonClass.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            lessonClass.widthAnchor.constraint(equalToConstant: 100),
            lessonClass.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
}

