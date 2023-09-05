//
//  PathHistoryItemView.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 27/08/2023.
//

import SwiftUI
import Thrive

struct PathHistoryItemView: View {
    private let model: CommandViewModel
    
    public init(model: CommandViewModel) {
        self.model = model
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack(spacing: 0) {
                    CircleButton(radius: 50, shadow: false) {}
                        .padding(.leading, 5)
                    
                    Text("20.12.2024")
                        .padding(.leading, 5)
                    Spacer()
                    
                    Text("Details")
                        .padding(.trailing, 5)
                    
                    Text(">")
                        .padding(.trailing, 5)
                        .bold()
                }
                .padding(.top, 5)
                
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 0) {
                        // Title
                        Text("Create Speciment")
                            .lineLimit(2)
                            .font(.title2)
                            .bold()
                            .padding(.bottom, 2)
                        
                        // Description
                        Text("Description of a one interesting doggy of a one interesting doggy")
                            .lineLimit(2)
                            .font(.system(.caption))
                    }
                    .frame(width: geometry.size.width * 0.5)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 0) {
                        // Criterias
                        Text("Criterias")
                            .bold()
                            .font(.caption2)
                            .padding(.bottom, 2)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            HStack(spacing: 5) {
                                Checkmark(isChecked: true)
                                Text("Doggies i happy")
                                    .lineLimit(1)
                                    .font(.caption)
                            }
                            
                            HStack(spacing: 5) {
                                Checkmark(isChecked: true)
                                Text("Doggies i happy and petted dsdadasd")
                                    .lineLimit(1)
                                    .font(.caption)
                            }
                        }
                    }
                    .frame(width: geometry.size.width * 0.3)
                    .padding(.trailing, 5)
                }.padding(.leading, 30)
            }
        }
        .frame(minHeight: 100)
    }
}

struct Checkmark: View {
    let isChecked: Bool
    
    var body: some View {
        Image(systemName: isChecked ? "checkmark.square.fill" : "square")
            .resizable()
            .frame(width: 18, height: 18)
        /// Value should be taken from a `Command`
            .foregroundColor(isChecked ? Color.black : Color.gray)
    }
}

struct PathHistoryItemView_Previews: PreviewProvider {
    static var previews: some View {
        PathHistoryItemView(
            model: CommandViewModel(
                command: Command(name: "Fernandoooooo", date: .init()))
        )
        .previewLayout(.sizeThatFits)
    }
}
