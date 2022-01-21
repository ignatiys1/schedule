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
    let lessonClass: UILabel = UILabel(text: "305-4", font: .avenirNext20, textAlignment: .right)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.layer.cornerRadius = 10
        self.selectionStyle = .default
        DispatchQueue.main.asyncAfter(deadline: .now()+0.05, execute: {
            self.setConstraints()
        })
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell(for subject: Subject) {
        self.lessonName.text = subject.subject
        self.teacherName.text = subject.employee[0].fio
        self.lessonTime.text = subject.lessonTime
        self.lessonClass.text = subject.auditory[0]
        switch subject.lessonType {
        case SubjectTypes.LK.rawValue:
            self.backgroundColor = .green
            self.lessonName.textColor = .black
            self.teacherName.textColor = .black
            self.lessonTime.textColor = .black
            self.lessonClass.textColor = .black
        case SubjectTypes.LR.rawValue:
            self.backgroundColor = #colorLiteral(red: 0.6674007773, green: 0.2184914649, blue: 0.2151004076, alpha: 1)
            self.lessonName.textColor = .white
            self.teacherName.textColor = .white
            self.lessonTime.textColor = .white
            self.lessonClass.textColor = .white
        case SubjectTypes.PZ.rawValue:
            self.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            self.lessonName.textColor = .black
            self.teacherName.textColor = .black
            self.lessonTime.textColor = .black
            self.lessonClass.textColor = .black
        default: break
        }
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

