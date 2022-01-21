//
//  SubjectTableViewCell.swift
//  Schedule
//
//  Created by Ignat Urbanovich on 20.01.22.
//

import UIKit

class SubjectTableViewCell: UITableViewCell {

    
    let label: UILabel = UILabel(text: "", font: .avenirNext20, textAlignment: .left)
    let label2: UILabel = UILabel(text: "", font: .avenirNextDemiBold20, textAlignment: .right)
    let image: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    
    
    var isImage = false {
        didSet {
                label2.isHidden = isImage
                label.isHidden = isImage
                image.isHidden = !isImage
        }
    }
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.layer.cornerRadius = 10
        self.selectionStyle = .none
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
       
        label2.isHidden = isImage
        label.isHidden = isImage
        image.isHidden = !isImage
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.05, execute: {
            self.setConstraints()
        })
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
}

//MARK: Constraints

extension SubjectTableViewCell {
    
    func setConstraints() {
        
        let topStackView = UIStackView(arrangedSubviews: [label, label2], axis: .horizontal, spacing: 10, distribution: .fillEqually)
                
        self.addSubview(topStackView)
        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            topStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            topStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor,  constant: -5),
            topStackView.heightAnchor.constraint(equalToConstant: 25)
        ])
    
        self.addSubview(image)
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            image.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            image.widthAnchor.constraint(equalToConstant: 100),
            image.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}

