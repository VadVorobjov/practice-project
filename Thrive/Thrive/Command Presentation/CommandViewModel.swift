//
//  CommandViewModel.swift
//  Thrive
//
//  Created by Vadims Vorobjovs on 15/09/2023.
//

public class CommandViewModel: ObservableObject {
    private let command: Command
    
    public init(command: Command) {
        self.command = command
    }
    
    public lazy var commandName: String = {
        command.name
    }()
    
    public lazy var date: String = {
        formatedDate(date: command.date)
    }()
    
    public lazy var description: String = {
        command.description ?? ""
    }()
    
    private func formatedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
