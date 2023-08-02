//
//  ExpandableView.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 01/08/2023.
//

import SwiftUI

struct ExpandableView<Content: View>: View {
    let title: String
    let content: () -> Content

    @State private var expanded = false
        
    var body: some View {
        VStack {
            Button {
                withAnimation {
                    expanded.toggle()
                }
            } label: {
                Image("chevron.up")
                    .rotationEffect(.degrees(expanded ? 180 : 0))
                Text(title)
                    .font(.system(size: 18, weight: .medium))
            }
            .buttonStyle(.plain)
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.Label.primary)
            
            if expanded {
                HStack {
                    content()
                        .padding(.top, 5)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
        .background(Color.Background.Elevation.primary)
        .cornerRadius(10)
    }
}

struct ExtensibleView_Previews: PreviewProvider {
    static var previews: some View {
        ExpandableView(title: "Desciption", content: {
            Text("Some description")
        })
        .previewLayout(.sizeThatFits)

        ExpandableView(title: "Desciption", content: {
            Text("Some description")
        })
        .previewLayout(.sizeThatFits)
        .preferredColorScheme(.dark)
    }
}
