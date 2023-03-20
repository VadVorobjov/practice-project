//
//  InitiateButton.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 15/03/2023.
//

import UIKit

class InitiationButton: UIButton {
    
    var title: String? {
        get { return title(for: .normal) ?? nil }
        set { setTitle(newValue, for: .normal) }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .black
        
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 22.0)
        
        layer.cornerRadius = frame.size.width / 2.0
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSizeMake(1.0, 1.0)
        layer.shadowColor = UIColor.hex(0xDE3D3D).cgColor
        layer.shadowOpacity = 0.5
    }
    
}
