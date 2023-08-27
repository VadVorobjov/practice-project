//
//  CommandViewModel.swift
//  Thrive
//
//  Created by Vadims Vorobjovs on 10/08/2023.
//

import Foundation

public class CommandViewModel: ObservableObject {
    @Published private(set) var isProcessing = false
    @Published public var commands: [Command] = []

    private let loader: LocalCommandLoader
    
    public init(loader: LocalCommandLoader) {
        self.loader = loader
    }
    
    func loadCommands() {
        isProcessing = true
        loader.load { [weak self] result in
            if let commands = try? result.get() {
                self?.commands = commands
            }
            self?.isProcessing = false
        }
    }
    
    func saveCommand(_ command: Command) {
        isProcessing = true
        loader.save(command) { [weak self] result in
            if case .success = result {
                // Save completed successfull
                // onSave closure?
            }
            self?.isProcessing = false
        }
    }
}

// TODO: composer should initialize and provide initial value
public class CommandCreateViewModel: ObservableObject {
    let loader: CommandSave
    @Published public var commandName: String
    @Published public var commandDescription: String
    
    public init(loader: CommandSave, commandName: String = "", commandDescription: String = "") {
        self.loader = loader
        self.commandName = commandName
        self.commandDescription = commandDescription
    }
    
    public var commandDescriptionIsEmpty: Bool {
        commandDescription.isEmpty        
    }
    
    public var command: Command {
        return Command(name: commandName, date: .init())
    }
    
    public func save(completion: @escaping (CommandSave.SaveResult) -> Void) {
        let command = Command(name: commandName,
                              description: commandDescription,
                              date: .init())
        loader.save(command, completion: completion)
    }
}
