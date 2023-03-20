//
//  HomeViewController.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 14/03/2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    private lazy var button: InitiationButton = {
        let button = InitiationButton(frame: CGRectMake(0, 0, 150, 150))
        button.setTitle("Initiate", for: .normal)
        button.addTarget(self, action: #selector(initiateTask), for: .touchUpInside)
        view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 150).isActive = true
        button.widthAnchor.constraint(equalToConstant: 150).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.addSubview(button)
    }
    
    // MARK: Actions

    @objc func initiateTask() {
        print("Initiate task")
    }
}
