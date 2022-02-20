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
    @State private var titleEvent = ""
    @State private var titleDate = "Date of Birth"
    @State private var dateEvent = ""
    @State private var observationsEvent = ""
    @State private var yearsAgoEvent = "1"
    @State private var eventSelected: EventeSelected = EventeSelected.birthday
    @State private var showAlert = false
    @State private var borrarEvento = false
    @State private var anyosCumplidos = 0
    @State private var showSheetMode = false
    @State private var showDatePicker = false
    var body: some View {
        ZStack{
            Color("background")
                .edgesIgnoringSafeArea(.all)
            
            
            VStack{
                
                //titulo del evento
                VStack{
                    //titulo fecha de nacimiento.......
                    HStack{
                        Text("Event Title")
                            .font(.custom("marker Felt", size: 18))
                            .foregroundColor(.purple)
                        Spacer()
                    }
                    
                    
                    ZStack{
                    TextFieldProfile(hint: "title", dataString: $titleEvent)
                        .onReceive(Just(titleEvent)){ value in
                            if value != "" && value != event.titleEvent{
                                saveChanges()
                            }
                        }
                    
                        HStack{
                            Spacer()
                            Image(systemName: "pencil.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                                .foregroundColor(Color.gray)
                                .padding(.trailing, 20)
                        }
                    }
                    

                    
                    //añadir fecha
                        HStack{
                            //titulo fecha de nacimiento.......
                            Text(eventSelected == .birthday ? "Date of Birth" : "Date to Commemorate")
                                .font(.custom("marker Felt", size: 18))
                                .foregroundColor(.purple)
                                .padding(.top, 10)
                            
                            Spacer()
                            
                            Text(getStringFromDate(date:birthDate))
                                .foregroundColor(Color("colorTextoTitulo"))
                                .font(.custom("marker Felt", size: 18))
                                .padding(1)
                            
                            Button(action:{
                                showDatePicker.toggle()
                            }, label: {
                                ZStack{
                                Image(systemName: "calendar")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30, height: 30)
                                    
                                    if showDatePicker {
                                        
                                        Image(systemName: "xmark")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 30, height: 30)
                                    }
                                }
                            }).padding(.horizontal,10)
                            
                        }.padding(.top,10)
                    
                    //datepicker
                    
                    if showDatePicker{
                        HStack{
                    
                            //si no es un special day, solo se puede seleccionar fechas anteriores a la actual ya que los cumpleaños y aniversiarios la fecha siempre será anterior.
                            if eventSelected != .specialDay{
                                DatePicker(selection: $birthDate, in: ...Date(), displayedComponents: .date) {
                                   EmptyView()
                                }
                                .datePickerStyle(WheelDatePickerStyle())
                               // .frame(width: 20, alignment: .leading)
                                    .onReceive(Just(birthDate)) { date in
                                        if birthDate != Date(timeIntervalSince1970: 100){
                                            anyosCumplidos = calcularAnyosCumplidos(dateEvent: birthDate)
                                            saveChanges()
                                        }
                                    }
                            }
                            else{
                                DatePicker(selection: $birthDate,in: Date()... ,  displayedComponents: .date) {
                                    EmptyView()
                                }
                                .frame(width: 20, alignment: .leading)
                                    .onReceive(Just(birthDate)) { date in
                                        if birthDate != Date(timeIntervalSince1970: 100){
                                            anyosCumplidos = calcularAnyosCumplidos(dateEvent: birthDate)
                                            saveChanges()
                                        }
                                    }
                            }
                            
                        }
                    }
                    
                    //muestra los años cumplidos o ha conmemorar
                    if eventSelected == .birthday || eventSelected == .anniversary{
                        HStack{
                            Text(String(anyosCumplidos) + "º")
                                .font(.custom("marker Felt", size: 20))
                            Text(" \(eventSelected.rawValue)")
                                .font(.custom("marker Felt", size: 9))
                        }
                        .padding(5)
                        .padding(.leading, 20)
                        .padding(.trailing, 10)
                        .font(.custom("marker Felt", size: 18))
                        .background(Color("background2"))
                        .cornerRadius(8)
                    }
                    
                    
                    HStack{
                        Text("Observations")
                            .font(.custom("marker Felt", size: 18))
                            .foregroundColor(.purple)
                            .padding(1)
                        Spacer()
                    }.padding(.top, 10)
                    
                    ZStack{
                    
                    TextEditor(text: $observationsEvent)
                        .cornerRadius(15)
                        .onReceive(Just(observationsEvent)){ value in
                            if value != "" && value != event.observationsEvent{
                                saveChanges()
                            }
                        }
                        VStack{
                            HStack{
                                Spacer()
                                ZStack{
                                    Image(systemName: "keyboard")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 25, height: 25)
                                        .foregroundColor(.purple)
                                        .padding()
                                    Image(systemName: "xmark")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 25, height: 25)
                                        .foregroundColor(.purple)
                                        .padding()
                                }
                            }
                           Spacer()
                        }

                    }.frame(height: UIScreen.main.bounds.height / 4)
                }.onTapGesture {
                    UIApplication.shared.endEditing()
                }
                
                
                
                //IdeasListView(filterProfile: event.profileEventRelation!.idProfile!.uuidString)
                
                Spacer()
                
            }        .padding(.horizontal,5)
                .padding(.top,10)
            
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
        //.navigationTitle(titleEvent)
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
                title: Text("¿Do you want to delete this event from \(event.profileEventRelation?.nameProfile ?? "profile")?"),
                primaryButton: .default(Text("Delete"), action: {
                    print("borrar evento")
                    borrarEvento = true
                    presentationMode.wrappedValue.dismiss()
                }),
                secondaryButton: .cancel(Text("Cancel")))
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
