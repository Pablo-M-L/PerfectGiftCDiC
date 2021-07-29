//
//  DetailEventView.swift
//  PerfectGiftCDiC
//
//  Created by pablo on 8/7/21.
//

import SwiftUI
import Combine

struct DetailEventView: View {
    
    var event: Event
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
        
    @State private var birthDate = Date()
    @State private var titleEvent = "vacio"
    @State private var dateEvent = ""
    @State private var observationsEvent = "vacio"
    @State private var yearsAgoEvent = "1"
    @State private var eventSelected: EventeSelected = EventeSelected.birthday
    
    var body: some View {
        ZStack{
            Color("background")
                .edgesIgnoringSafeArea(.all)
                VStack{
                    TextFieldProfile(hint: "title", dataString: $titleEvent)
                        .onReceive(Just(titleEvent)){ value in
                            if value != "vacio" && value != event.titleEvent{
                                saveChanges()
                            }
                        }
                    //datepicker
                    HStack{
                        DatePicker(selection: $birthDate, displayedComponents: .date) {
                            Text("Date: ")
                        }.padding(.trailing, 20)
                        
                        if eventSelected == .birthday || eventSelected == .anniversary{
                            HStack{
                                Text(yearsAgoEvent + "º" + " \(eventSelected.rawValue)" )
                            }
                            .padding(10)
                            .padding(.leading, 20)
                            .font(.custom("marker Felt", size: 18))
                            .background(Color("background2"))
                            .cornerRadius(8)
                        }
                    }
                    
                    HStack{
                        Text("Observations")
                            .padding(1)
                        Spacer()
                        
                    }
                    
                    TextEditor(text: $observationsEvent)
                        .frame(height: UIScreen.main.bounds.height / 7)
                        .padding(1)
                        .cornerRadius(25)
                        .onReceive(Just(observationsEvent)){ value in
                            if value != "vacio" && value != event.observations{
                                saveChanges()
                            }
                        }
                    
                    IdeasListView(filterProfile: event.profileEventRelation!.idProfile!.uuidString, filterEvent: event.idEvent!.uuidString, event: event)
            }
            
            VStack{
                
                Spacer()
                //boton añadir evento
                HStack{
                    
                    Spacer()
                    
                    NavigationLink(destination: AddIdeaView(newIdea: true, eventParent: event), label: {
                        ZStack{
                            Circle()
                                .foregroundColor(.blue)
                            Image(systemName: "calendar.badge.plus")
                                .resizable()
                                .foregroundColor(.white)
                                .aspectRatio(contentMode: .fit)
                                .padding(8)
                            
                            
                        }
                        .frame(width: 50, height: 50)
                        .padding()
                    })
                }
            }
        }
        .onAppear{
            titleEvent = event.titleEvent ?? "no title event"
            observationsEvent = event.observations ?? "no observations"
            
            switch event.titleEvent{
                case "BirthDay":
                    eventSelected = .birthday
                case "Special Day":
                    eventSelected = .specialDay
                case "Anniversary":
                    eventSelected = .anniversary
                default:
                    eventSelected = .birthday
            }
        }
        .navigationTitle(titleEvent)
    }
    
    private func saveChanges(){
       withAnimation {
        event.titleEvent = titleEvent
        event.observations = observationsEvent
        event.dateEvent = birthDate
        do {
            try viewContext.save()
            print("evento actualizado")
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
       }
    }
}

struct RowDataEventDetail: View{
    var textString: String
    @Binding var dataString: String
    
    var body: some View{
        HStack{
            Text(textString + ":")
            TextFieldModifyEvent(hint: textString, dataString: $dataString)
        }
        
    }
}

struct TextFieldModifyEvent: View{
    var hint: String
    @Binding var dataString: String
    
    var body: some View{
        TextField(hint, text: $dataString)
            .padding([.vertical, .leading],10)
            .lineLimit(1)
            .background(Color(.white))
            .font(.custom("marker Felt", size: 12))
            .cornerRadius(8)
    }
}

//struct DetailEventView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailEventView(event: Event())
//    }
//}
