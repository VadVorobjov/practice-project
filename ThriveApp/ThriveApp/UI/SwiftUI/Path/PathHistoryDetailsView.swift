//
//  PathHistoryDetailsView.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 11/04/2024.
//

import SwiftUI
import Thrive

struct PathHistoryDetailsView: View {
  let model: CommandViewModel
    
  var body: some View {
    VStack {
      Text(model.commandName)
        .font(.title)
        .padding()

      Text(model.date)

      Text(model.description)
        .padding()
      
      Spacer()
    }
    .navigationTitle(model.commandName)
  }
}
