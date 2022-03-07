//
//  CellEventListView.swift
//  PerfectGiftCDiC
//
//  Created by pablo on 8/7/21.
//

import SwiftUI

struct CellEventListView: View {
    
    var event: Event
    @State private var title = ""
    @State private var date = Date()
    @State private var imgEvent = UIImage(imageLiteralResourceName: "logoPerfectgift")
    @State private var eventSelected: EventeSelected = EventeSelected.birthday
    
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    Image(uiImage: imgEvent)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:70, height: 70)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(.white, lineWidth: 3))
                    
                    Spacer()
                    
                    VStack{
                        Text("\(title)")
                        Text("\(date, formatter: itemFormatter)")
                    }
                    .font(.custom("marker Felt", size: 18))
                    .lineLimit(1)
                    .minimumScaleFactor(0.3)
                    
                    Spacer()
                    
                    if eventSelected == .birthday || eventSelected == .anniversary{
                        VStack{
                            Text(String(calcularAnyosCumplidos(dateEvent: event.dateEvent ?? Date())) + "º")
                                .font(.custom("marker Felt", size: 22))
                            Text(" \(eventSelected.rawValue)")
                                .font(.custom("marker Felt", size: 9))
                        }
                        .padding(5)
                        .lineLimit(1)
                        .minimumScaleFactor(0.3)
                        .background(Color("background2"))
                        .cornerRadius(8)
                    }
                }
            }.padding(.horizontal, 10)
        }.frame(height: 100)
        .onAppear{
            title = event.titleEvent ?? "No event title"
            
            switch event.typeEvent{
            case "BirthDay":
                eventSelected = .birthday
                imgEvent = UIImage(imageLiteralResourceName: "birthIcon")
                date = getNextDayEvent(date: event.dateEvent ?? Date())
            case "Special Day":
                eventSelected = .specialDay
                imgEvent = UIImage(imageLiteralResourceName: "specialIcon")
                date = event.dateEvent ?? Date()
            case "Anniversary":
                eventSelected = .anniversary
                imgEvent = UIImage(imageLiteralResourceName: "eventIcon")
                date = getNextDayEvent(date: event.dateEvent ?? Date())
            default:
                eventSelected = .birthday
                imgEvent = UIImage(imageLiteralResourceName: "birthIcon")
            }
        }
        
    }
    
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        //formatter.timeStyle = .medium
        return formatter
    }()
}

struct CellEventListView_Previews: PreviewProvider {
    static var previews: some View {
        CellEventListView(event: Event())
    }
}
