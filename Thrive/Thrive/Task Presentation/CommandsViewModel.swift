//
//  CommandsViewModel.swift
//  Thrive
//
//  Created by Vadims Vorobjovs on 10/08/2023.
//

import Foundation

public class CommandsViewModel: ObservableObject {
    private let loader: CommandLoader

    @Published public var commands: [Command] = []
    
    public init(loader: CommandLoader) {
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
public class CommandCreateViewModel: ObservableObject {
    private let loader: CommandSave
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
