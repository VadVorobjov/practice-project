//
//  CommandCategoriesView.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 19/09/2023.
//

import Thrive
import SwiftUI

struct CommandCategoriesView: View {
    @State private var criterias: [Criteria]
    @State private var criteria: String
    @State private var listsContentWidth: CGFloat?
    
    public init(criterias: [Criteria], criteria: String) {
        self.criterias = criterias
        self.criteria = criteria
    }
    
    private func delete(_ id: UUID) {
        criterias.removeAll(where: { $0.id == id })
    }
    
    var body: some View {
        ZStack {
            customBackgroundView()
            VStack {
                ScrollView {
                    ForEach(criterias) { criteria in
                        CriteriaView(criteria: criteria, deleteAction: { id in
                            delete(id)
                        })
                        .frame(maxWidth: .infinity)
                    }
                    .padding()
                }
                .animation(.spring(), value: criterias)
                .frame(maxHeight: 200)
                
                TextFieldView(text: $criteria,
                              title: "Criteria",
                              placeholderText: "Enter criteria",
                              buttonTitle: "Add")
                .frame(maxWidth: listsContentWidth)
                .padding()
                
                Button("Add") {
                    criterias.append(Criteria(name: criteria, isChecked: false))
                }
                .buttonStyle(MainButtonStyle())
                .padding(.bottom)
            }
            .modifier(Elevation())
            .padding()
        }
    }
}

struct CommandCategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        let criterias = [
            Criteria(name: "Flamingo should enter the building Flamingo should enter the buildingFlamingo should enter the building", isChecked: false),
            Criteria(name: "Fernando", isChecked: false),
        ]
        
        return CommandCategoriesView(criterias: criterias, criteria: "")
            .previewLayout(.sizeThatFits)
    }
}

struct CriteriaView: View {
    let criteria: Criteria
    let deleteAction: (UUID) -> Void
    
    var body: some View {
        HStack {
            Checkmark(isChecked: criteria.isChecked)
            Text(criteria.name)
                .lineLimit(2)
            Spacer()
            Button {
                deleteAction(criteria.id)
            } label: {
                Image(systemName: "xmark.square.fill")
                    .font(.system(size: 20))
            }
            .foregroundColor(.black)
            
        }
        .padding(10)
        .background(Color.Background.secondary)
        .cornerRadius(8)
    }
}
