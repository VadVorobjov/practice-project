//
//  ExtensibleView.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 01/08/2023.
//

import SwiftUI

struct ExtensibleView<Content: View>: View {
    let title: String
    let content: () -> Content

    @State private var extended = false
        
    var body: some View {
        VStack {
            Button {
                withAnimation {
                    extended.toggle()
                }
            } label: {
                Image("chevron.up")
                    .rotationEffect(.degrees(extended ? 180 : 0))
                Text(title)
                    .font(.system(size: 18, weight: .medium))
            }
            .buttonStyle(.plain)
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.Label.primary)
            
            if extended {
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
        ExtensibleView(title: "Desciption", content: {
            Text("Some description")
        })
        .previewLayout(.sizeThatFits)

        ExtensibleView(title: "Desciption", content: {
            Text("Some description")
        })
        .previewLayout(.sizeThatFits)
        .preferredColorScheme(.dark)
    }
}
