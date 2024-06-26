//
//  CommandCreateViewModel.swift
//  Thrive
//
//  Created by Vadims Vorobjovs on 24/04/2024.
//

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
