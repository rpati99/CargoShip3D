//
//  ContainerCell.swift
//  Cargo ship tracking app
//
//  Created by Rachit Prajapati on 25/04/21.
//

import UIKit


class ContainerCell: UICollectionViewCell {

    var containerInfo: Detail? {
        didSet {
            guard let containerInfo = containerInfo else { return }
            shipName.text = containerInfo.shipName
            shipType.text = containerInfo.shipType
            fromDetails.text = "\(containerInfo.portNameFrom), \(containerInfo.portCountryFrom)"
            toDetails.text = "\(containerInfo.portNameTo), \(containerInfo.portCountryTo)"
        }
    }
    
    
    private let shipName: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "InsaniburgerwithCheese", size: 40)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .black
        return label
        
    }()
    
    private let shipType: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "InsaniburgerwithCheese", size: 30)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .lightGray
        return label
    }()
    
    private let from: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "InsaniburgerwithCheese", size: 40)
        label.adjustsFontSizeToFitWidth = true
        label.text = "Source"
        label.textColor = .black
        return label
    }()
    
    private let fromDetails: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "InsaniburgerwithCheese", size: 30)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .lightGray
        return label
    }()
    
    private let to: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "InsaniburgerwithCheese", size: 40)
        label.adjustsFontSizeToFitWidth = true
        label.text = "Destination"
        label.textColor = .black
        return label
    }()
    
    private let toDetails: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "InsaniburgerwithCheese", size: 30)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .lightGray
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureCell() {
        backgroundColor = .white
       
        layer.cornerRadius = 15
    }
    
    private func setupUI() {
        let stack  = UIStackView(arrangedSubviews: [shipName, shipType, from, fromDetails, to, toDetails])
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fillProportionally
        contentView.addSubview(stack)
        stack.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 40, paddingRight: 10)
    }
}
