//
//  CellEventUpcomingList.swift
//  PerfectGiftCDiC
//
//  Created by pablo millan lopez on 14/8/21.
//

import SwiftUI

struct CellEventUpcomingList: View {
    
    var event: Event
    @State private var title = ""
    @State private var date = Date()
    @State private var nameProfile = ""
    @State private var imgEvent = UIImage(imageLiteralResourceName: "logoPerfectgift")
    @State private var imgProfile = UIImage(imageLiteralResourceName: "logoPerfectgift")
    @State private var eventSelected: EventeSelected = EventeSelected.birthday
    
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    VStack{
                        Image(uiImage: imgProfile)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:60, height: 60)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(.white, lineWidth: 3))
                            .shadow(color: .gray, radius: 2, x: 1, y: 2)
                       // Text("\(nameProfile)")
                       //     .font(.custom("marker Felt", size: 14))
                    }.padding(.vertical, 10)

                    
                    Spacer()
                    
                    VStack{

                        Text("\(title)")
                            .foregroundColor(.purple)
                            .font(.custom("marker Felt", size: 22))
                            .lineLimit(1)
                            .minimumScaleFactor(0.3)
                        Text("\(date, formatter: itemFormatter)")
                            .foregroundColor(.purple)
                            .font(.custom("marker Felt", size: 18))
                            .lineLimit(1)
                            .minimumScaleFactor(0.3)
                    }
                    .font(.custom("marker Felt", size: 18))
                    .lineLimit(1)
                    .minimumScaleFactor(0.3)
                    .padding(2)
                    
                    Spacer()
                    
                    ZStack{
                        VStack{
                            Image(uiImage: imgEvent)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width:60, height: 60)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(.white, lineWidth: 3))
                                .shadow(color: .gray, radius: 2, x: 1, y: 2)
                        }
                        
                        if eventSelected == .birthday || eventSelected == .anniversary{
                            VStack{
                                Text(String(calcularAnyosCumplidos(dateEvent: event.dateEvent ?? Date())) + "\(eventSelected == .anniversary ? "º" : "")")
                                    .font(.custom("marker Felt", size: 26))
                                    .bold()
                                    .foregroundColor(eventSelected == .birthday ? .orange : .orange)
                                    .shadow(color: .black, radius: 2, x: 1, y: 2)
                                
                              //  Text(" \(eventSelected.rawValue)")
                                //    .font(.custom("marker Felt", size: 9))
                            }
                            .padding(5)
                            .lineLimit(1)
                            .minimumScaleFactor(0.3)
                            .background(Color("background2").opacity(0))
                            .cornerRadius(8)
                        }
                    }
                    

                }
            }.padding(.horizontal, 10)
        }.frame(height: 100)
        .onAppear{
            title = event.titleEvent ?? "No event title"
            date = getNextDayEvent(date: event.dateEvent ?? Date())
            nameProfile = event.profileEventRelation?.nameProfile ?? "no name"
            
            if event.profileEventRelation?.imageProfile == nil{
                imgProfile = UIImage(imageLiteralResourceName: "logoPerfectgift")
            }
            else{
                let imgData = event.profileEventRelation?.imageProfile
                let data = try! JSONDecoder().decode(Data.self, from: imgData!)
                imgProfile = UIImage(data: data)!
            }
            
            switch event.typeEvent{
            case "BirthDay":
                eventSelected = .birthday
                imgEvent = UIImage(imageLiteralResourceName: "birthIcon")
            case "Special Day":
                eventSelected = .specialDay
                imgEvent = UIImage(imageLiteralResourceName: "specialIcon")
            case "Anniversary":
                eventSelected = .anniversary
                imgEvent = UIImage(imageLiteralResourceName: "eventIcon")
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

struct CellEventUpcomingList_Previews: PreviewProvider {
    static var previews: some View {
        CellEventUpcomingList(event: Event())
    }
}
