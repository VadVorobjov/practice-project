//
//  ScrollViewProxy.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 14/04/2023.
//

import SwiftUI

extension ScrollViewProxy {
    func scrollWithAnimationTo<ID>(_ id: ID) where ID : Hashable {
        withAnimation {
            scrollTo(id)
        }
    }
}
