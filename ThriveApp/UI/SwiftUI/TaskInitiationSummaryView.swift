//
//  TaskInitiationSummaryView.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 04/04/2023.
//

import SwiftUI

struct TaskInitiationSummaryView: View {
    var body: some View {
        VStack {
            
            ZStack {
                Rectangle()
                    .foregroundColor(Color("Background"))
                    .ignoresSafeArea()
                
                VStack {
                    VStack(alignment: .center) {
                        Text("Task name").bold()
                        
                        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
                            .lineLimit(3)
                            .offset(y: 5)
                    }
                    .padding(.horizontal, 25.0)
                    .frame(maxHeight: screenSize.height / 3)

                    InitiationButtonSwiftUI(label: "Initiate") {
                        print("Initiation has began")
                    }.frame(height: screenSize.height / 3)
                    
                    Spacer().frame(height: screenSize.height / 3)
                }.padding()
            }
        }
    }
}

struct TaskInitiationSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        TaskInitiationSummaryView()
    }
}
