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
            HStack(spacing: 0) {
                Button {
                    withAnimation { expanded.toggle() }
                } label: {
                    Image("chevron.up")
                        .rotationEffect(.degrees(expanded ? 180 : 0))
                    Text(title)
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.Label.primary)
                }
                .buttonStyle(.plain)
            }
            .frame(maxWidth: .infinity, maxHeight: 40, alignment: .leading)
            
            if expanded {
                HStack {
                    content()
                        .padding(.bottom, 10)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.horizontal, 15)
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
