//
//  CellIdeaListView.swift
//  PerfectGiftCDiC
//
//  Created by Pablo Millan on 26/7/21.
//

import SwiftUI

struct CellIdeaListView: View {
    
        var idea: Ideas
        @State private var title = ""
        
        var body: some View {
            HStack(alignment: .center, spacing: 2){
                Spacer()
                Text("\(title)")
                    .font(.custom("marker Felt", size: 22))
                    .padding(5)
                    .minimumScaleFactor(0.3)
                Spacer()
            }
            .frame(height: 50)
            .onAppear{
                title = idea.ideaTitle ?? "No event title"
                print("celda \(title)")
            }
        }

}

struct CellIdeaListView_Previews: PreviewProvider {
    static var previews: some View {
        CellIdeaListView(idea: Ideas())
    }
}
