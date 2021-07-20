//
//  DetailEventView.swift
//  PerfectGiftCDiC
//
//  Created by pablo on 8/7/21.
//

import SwiftUI

struct DetailEventView: View {
    
    var event: Event
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
        
    @State private var birthDate = Date()
    @State private var titleEvent = ""
    @State private var nameProfile = ""
    @State private var dateEvent = ""
    @State private var observationsEvent = ""
    @State private var yearsAgoEvent = "1"
    @State private var eventSelected: EventeSelected = EventeSelected.birthday
    
    var body: some View {
        ZStack{
            Color("background")
                .edgesIgnoringSafeArea(.all)
            ScrollView{
                VStack{
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
                        .frame(height: UIScreen.main.bounds.height / 4)
                        .padding()
                        .cornerRadius(25)
                    
                    Spacer()
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
        .onDisappear{
            event.observations = observationsEvent
            event.dateEvent = birthDate            
            do {
                try viewContext.save()
                print("evento guardado")
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
        .navigationTitle(titleEvent)
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

struct DetailEventView_Previews: PreviewProvider {
    static var previews: some View {
        DetailEventView(event: Event())
    }
}
