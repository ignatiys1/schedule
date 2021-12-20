//
//  SearchCell.swift
//  Schedule
//
//  Created by Ignat Urbanovich on 19.12.21.
//

import Foundation
import UIKit

class SearchCell: UITableViewCell {
    
    let typeName: UILabel = UILabel(text: "Type:", font: .avenirNext30, textAlignment: .left)
    let justName: UILabel = UILabel(text: "Name", font: .avenirNext30, textAlignment: .right)
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
       
        DispatchQueue.main.asyncAfter(deadline: .now()+0.05, execute: {
            self.setConstraints()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

//MARK: Constraints

extension SearchCell {
    
    func setConstraints() {
        
        let topStackView = UIStackView(arrangedSubviews: [typeName, justName], axis: .horizontal, spacing: 10, distribution: .fillEqually)
        
        self.addSubview(topStackView)
        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            topStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            topStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor,  constant: -5),
            topStackView.heightAnchor.constraint(equalToConstant: 25)
        ])
        
       
    }
}
