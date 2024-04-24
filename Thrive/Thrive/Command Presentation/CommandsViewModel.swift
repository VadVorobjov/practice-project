//
//  CommandsViewModel.swift
//  Thrive
//
//  Created by Vadims Vorobjovs on 10/08/2023.
//

import Foundation

public class CommandsViewModel: ObservableObject {
    private let loader: CommandLoad

    @Published public var commands: [Command] = []
    
    public init(loader: CommandLoad) {
        self.loader = loader
    }
    
    public func loadCommands() {
        loader.load { [weak self] result in
            if let commands = try? result.get() {
              DispatchQueue.main.async {
                self?.commands = commands
              }
            }
        }
    }
}

// TODO: composer should initialize and provide initial value
