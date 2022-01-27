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
    
    @EnvironmentObject var viewModel: ViewModel
        
    @State private var imgServicio = UIImage(imageLiteralResourceName: "logoPerfectgift")
    @State private var birthDate: Date = Date(timeIntervalSince1970: 100)
    @State private var titleEvent = "vacio"
    @State private var dateEvent = ""
    @State private var observationsEvent = "vacio"
    @State private var yearsAgoEvent = "1"
    @State private var eventSelected: EventeSelected = EventeSelected.birthday
    @State private var showAlert = false
    @State private var borrarEvento = false
    @State private var anyosCumplidos = 0
    
    var body: some View {
        ZStack{
            Color("background")
                .edgesIgnoringSafeArea(.all)
                VStack{
                    VStack{
                    TextFieldProfile(hint: "title", dataString: $titleEvent)
                        .onReceive(Just(titleEvent)){ value in
                            if value != "vacio" && value != event.titleEvent{
                                saveChanges()
                            }
                        }
                    //datepicker
                    HStack{
                        Spacer()
                        
                        //si no es un special day, solo se puede seleccionar fechas anteriores a la actual ya que los cumpleaños y aniversiarios la fecha siempre será anterior.
                        if eventSelected != .specialDay{
                            DatePicker(selection: $birthDate, in: ...Date(), displayedComponents: .date) {
                                Text( eventSelected == .birthday ? "Fecha de nacimiento" : "Fecha a conmemorar")
                                    .font(.custom("marker Felt", size: 12))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.3)
                            }.padding(.trailing, 20)
                            .onReceive(Just(birthDate)) { date in
                                if birthDate != Date(timeIntervalSince1970: 100){
                                    anyosCumplidos = calcularAnyosCumplidos(dateEvent: birthDate)
                                    saveChanges()
                                }
                            }
                        }
                        else{
                            DatePicker(selection: $birthDate,in: Date()... ,  displayedComponents: .date) {
                                Text("Fecha del evento")
                                    .font(.custom("marker Felt", size: 12))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.3)
                            }.padding(.trailing, 20)
                            .onReceive(Just(birthDate)) { date in
                                if birthDate != Date(timeIntervalSince1970: 100){
                                    anyosCumplidos = calcularAnyosCumplidos(dateEvent: birthDate)
                                    saveChanges()
                                }
                            }
                        }
                        
                        if eventSelected == .birthday || eventSelected == .anniversary{
                            HStack{
                                Text(String(anyosCumplidos) + "º")
                                    .font(.custom("marker Felt", size: 20))
                                Text(" \(eventSelected.rawValue)")
                                    .font(.custom("marker Felt", size: 9))
                            }
                            .padding(10)
                            .padding(.leading, 20)
                            .font(.custom("marker Felt", size: 18))
                            .background(Color("background2"))
                            .cornerRadius(8)
                        }
                        
                        Spacer()
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
                                if value != "vacio" && value != event.observationsEvent{
                                    saveChanges()
                                }
                            }
                    }.onTapGesture {
                        UIApplication.shared.endEditing()
                    }
                    

                    
                    IdeasListView(filterProfile: event.profileEventRelation!.idProfile!.uuidString, filterEvent: event.idEvent!.uuidString, event: event)
                    
                    Spacer()
                    
            }
            
            VStack{
                
                Spacer()
                //boton añadir evento
                HStack{
                    Spacer()
                    
                    NavigationLink(destination: AddIdeaView(newIdea: true), label: {
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
        .onDisappear{
            if borrarEvento{
                deleteEvent()
            }
        }
        .onAppear{
            viewModel.currentProfile = event.profileEventRelation!
            viewModel.currentEvent = event
            
            titleEvent = event.titleEvent ?? "no title event"
            observationsEvent = event.observationsEvent ?? "no observations"
            birthDate = event.dateEvent ?? Date()
            anyosCumplidos = calcularAnyosCumplidos(dateEvent: event.dateEvent ?? Date())
            
            if event.profileEventRelation!.imageProfile == nil{
                imgServicio = UIImage(imageLiteralResourceName: "logoPerfectgift")
            }
            else{
                let imgData = event.profileEventRelation!.imageProfile
                let data = try! JSONDecoder().decode(Data.self, from: imgData!)
                imgServicio = UIImage(data: data)!
            }
            switch event.typeEvent{
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
        .navigationBarItems(trailing:
                                HStack{
                                    Image(uiImage: imgServicio)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(Circle())
                                    .frame(width: 35, height: 35)
                                    
                                    Button(action:{
                                        showAlert = true
                                        },
                                    label:{
                                        Image(systemName: "trash")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .accentColor(Color("backgroundButton"))
                                            .frame(width: 35, height: 35)
                                    })
                                }

        ).alert(isPresented: $showAlert, content: {
            Alert(
                title: Text("¿Quieres borrar este evento de \(event.profileEventRelation?.nameProfile ?? "perfil")?"),
                  primaryButton: .default(Text("Borrar"), action: {
                    print("borrar evento")
                    borrarEvento = true
                    presentationMode.wrappedValue.dismiss()
                  }),
                secondaryButton: .cancel(Text("Cancelar")))
        })
    }
    
    private func deleteEvent(){
        withAnimation {
            viewContext.delete(event)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
        
        //presentationMode.wrappedValue.dismiss()
    }
    
    private func saveChanges(){
        print("guardar")
       withAnimation {
        event.titleEvent = titleEvent
        event.observationsEvent = observationsEvent
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
