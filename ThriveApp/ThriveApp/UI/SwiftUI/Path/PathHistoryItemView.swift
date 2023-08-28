//
//  PathHistoryItemView.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 27/08/2023.
//

import SwiftUI

struct PathHistoryItemView: View {
    @State private var isChecked = true
    
    var body: some View {
        HStack(spacing: 20) {
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Criterias")
                    .font(.title3)
                    .bold()
                    .padding(.bottom, 2)
                HStack {
                    Checkmark(isChecked: $isChecked)
                    Text(("Fill printer"))
                        .font(.system(.callout))
                }
                HStack {

                }
                Text("Empty store")
                    
            }
            
            CircleButton(radius: 185, shadow: false) {}
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Name")
                    .font(.system(.title3))
                    .bold()
                Text("Description")
            }
        }
    }
}

struct Checkmark: View {
    @Binding var isChecked: Bool
    
    var body: some View {
        Button(action: {
            isChecked.toggle()
        }) {
            Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                .resizable()
                .frame(width: 18, height: 18)
            /// Value should be taken from a `Command`
                .foregroundColor(isChecked ? Color.black : Color.gray)
        }
    }
}

struct PathHistoryItemView_Previews: PreviewProvider {
    static var previews: some View {
        PathHistoryItemView()
            .previewLayout(.sizeThatFits)
    }
}
