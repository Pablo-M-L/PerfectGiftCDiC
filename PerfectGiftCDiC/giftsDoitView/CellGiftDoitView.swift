//
//  CellGiftDoitView.swift
//  PerfectGiftCDiC
//
//  Created by pablo millan lopez on 19/8/21.
//

import SwiftUI

struct CellGiftDoitView: View {
    var idea: Ideas
    @State private var title = ""
    @State private var reasonGift = ""
    @State private var giftDate = Date()
    
    var body: some View {
        HStack{
        VStack(alignment: .leading,spacing: 2){
            Text("\(title)")
                .font(.custom("marker Felt", size: 18))
                .lineLimit(1)
                .minimumScaleFactor(0.3)
            Text("\(reasonGift)")
                .font(.custom("marker Felt", size: 18))
                .lineLimit(1)
                .minimumScaleFactor(0.3)
            Text("\(giftDate, formatter: itemFormatter)")
                .font(.custom("marker Felt", size: 18))
                .lineLimit(1)
                .minimumScaleFactor(0.3)
        }
            Spacer()
        }
        .padding(.leading, 10)
        .padding(.vertical,3)
        .frame(height: 80)
        .onAppear{
            title = idea.ideaTitle ?? NSLocalizedString("notitleEvent", comment: "")
            reasonGift = idea.eventTitleIdea ?? NSLocalizedString("noReason", comment: "")
            giftDate = idea.fechaQueRegalo ?? Date()
        }
    }
    
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        //formatter.timeStyle = .medium
        return formatter
    }()
}

//struct CellGiftDoitView_Previews: PreviewProvider {
//    static var previews: some View {
//        CellGiftDoitView()
//    }
//}
