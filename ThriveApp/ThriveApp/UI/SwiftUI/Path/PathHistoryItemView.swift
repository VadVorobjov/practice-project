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
      VStack {
        FirstHistoryView(model: model)
          .padding(EdgeInsets(top: 10,
                              leading: 10,
                              bottom: 0,
                              trailing: 10))
        
        SecondHistoryRow(model: model)
          .padding(EdgeInsets(top: 0,
                               leading: 10,
                               bottom: 10,
                               trailing: 10))
      }
      .modifier(Elevation(color: .Elevation.primary, radius: 15))
      
      .padding(.horizontal, 5)
      .padding(.vertical, 5)
    }
}

struct Checkmark: View {
    let isChecked: Bool
    
    var body: some View {
        Image(systemName: isChecked ? "checkmark.square.fill" : "square")
            .resizable()
            .frame(width: 18, height: 18)
            .foregroundColor(isChecked ? Color.black : Color.gray)
    }
}

struct PathHistoryItemView_Previews: PreviewProvider {
    static var previews: some View {
        PathHistoryItemView(
            model: CommandViewModel(
                command: Command(name: "Walk da Dog", date: .init()))
        )
        .previewLayout(.sizeThatFits)
    }
}

struct LabelWithDescriptionView: View {
    let text: String
    let description: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(text)
                    .lineLimit(2)
                    .font(.title2)
                    .bold()
                
                Text(description)
                    .lineLimit(2)
                    .font(.system(.caption))
            }
            Spacer()
        }
    }
}

struct CategoriesView: View {
    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
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
    }
}

struct IndicatorView: View {
    var body: some View {
        Circle()
            .fill(
                LinearGradient(gradient: Gradient(colors: [
                    Color(hex: 0x118824, alpha: 100),
                    Color(hex: 0xAEEAB7, alpha: 100)]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing))
            .frame(width: 25, height: 25)
    }
}

struct SecondHistoryRow: View {
  let model: CommandViewModel
  
  var body: some View {
    HStack(alignment: .top) {
      LabelWithDescriptionView(text: model.commandName, description: model.description)
      
      Spacer()
    }
  }
}

struct FirstHistoryView: View {
  let model: CommandViewModel

  var body: some View {
    HStack(spacing: 5) {
      Text(model.date)
      
      Spacer()
    }
  }
}
