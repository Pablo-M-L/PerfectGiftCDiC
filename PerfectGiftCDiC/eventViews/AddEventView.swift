//
//  AddEventView.swift
//  PerfectGiftCDiC
//
//  Created by pablo on 8/7/21.
//

import SwiftUI

struct AddEventView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    
    var profile: Profile
    
    @State private var birthDate = Date()
    @State private var imgServicio = UIImage(imageLiteralResourceName: "logoPerfectgift")
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
            
            VStack{
                ScrollView(.vertical){
                    HStack{
                        
                        Text("Event For......")
                            .foregroundColor(Color("colorTextoTitulo"))
                            .font(.custom("marker Felt", size: 28))
                            .minimumScaleFactor(0.3)
                        
                        Spacer()

                        Image(uiImage: imgServicio)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:  70, height: 70)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(.white, lineWidth: 3))
                    }
                    .padding(.horizontal, 25)
                    .background(Color.blue.opacity(0.2))
                    HStack{
                        Spacer()
                        Text("Select Categoty")
                            .foregroundColor(Color("colorTextoTitulo"))
                            .font(.custom("marker Felt", size: 18))
                        Spacer()
                    }.padding(5)
                    
                    HStack{
                        VStack{
                        Image("birthIcon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: eventSelected == .birthday ? 80 : 50, height: eventSelected == .birthday ? 80 : 50)
                            .clipShape(Circle())
                            .padding(.bottom, 3)
                            .onTapGesture {
                                eventSelected = .birthday
                                titleEvent = "Birthday"
                            }
                            Text("Birthday")
                                .foregroundColor(Color("colorTextoTitulo"))
                                .font(.custom("marker Felt", size: 11))
                        }
                        Spacer()
                        
                        VStack{

                        Image("specialIcon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: eventSelected == .specialDay ? 80 : 50, height: eventSelected == .specialDay ? 80 : 50)
                            .clipShape(Circle())
                            .padding(.bottom, 3)
                            .onTapGesture {
                                eventSelected = .specialDay
                                titleEvent = "Special Day"
                            }
                                
                                Text("Special Day")
                                    .foregroundColor(Color("colorTextoTitulo"))
                                    .font(.custom("marker Felt", size: 11))
                            }
                        
                        Spacer()
                        
                        VStack{
                        Image("eventIcon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: eventSelected == .anniversary ? 80 : 50, height: eventSelected == .anniversary ? 80 : 50)
                            .clipShape(Circle())
                            .padding(.bottom, 3)
                            .onTapGesture {
                                eventSelected = .anniversary
                                titleEvent = "Anniversary"
                            }
                            Text("Event")
                                .foregroundColor(Color("colorTextoTitulo"))
                                .font(.custom("marker Felt", size: 11))
                        }
                        
                    }.padding(20)
                     .shadow(color: .gray, radius: 2, x: 2, y: 2)
                     .background(Color.blue.opacity(0.2))
                    
                    VStack{
                        RowDataEvent(textString: "Title", dataString: $titleEvent)
                            .font(.custom("marker Felt", size: 18))
                            .padding(1)
                        
                        
                        HStack{
                            
                            //si no es un special day, solo se puede seleccionar fechas anteriores a la actual ya que los cumpleaños y aniversiarios la fecha siempre será anterior.
                            if eventSelected != .specialDay{
                                DatePicker(selection: $birthDate, in: ...Date(), displayedComponents: .date) {
                                    Text(eventSelected == .birthday ? "Date of Birth" : "Date to Commemorate")
                                        .font(.custom("marker Felt", size: 18))
                                        .foregroundColor(.purple)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.3)
                                }
                                .padding(.trailing, 80)
                                .accentColor(Color("backgroundButton"))
                            }
                            else{
                                DatePicker(selection: $birthDate,in:  Date()... ,displayedComponents: .date) {
                                    Text("Event Date")
                                        .font(.custom("marker Felt", size: 18))
                                        .foregroundColor(.purple)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.3)
                                }.padding(.trailing, 80)
                                 .accentColor(Color("backgroundButton"))
                            }

                            
//                            DatePicker(selection: $birthDate, displayedComponents: .date) {
//                                Text("Date: ")
//                            }.padding(.trailing, 20)
                            
//                            DatePicker("", selection: $birthDate)
//                                .datePickerStyle(GraphicalDatePickerStyle())
//                                .frame(maxHeight: 400)
                            
//                            if eventSelected == .birthday || eventSelected == .anniversary{
//                                HStack{
//                                    Text(yearsAgoEvent + "º" + " \(eventSelected.rawValue)" )
//                                }
//                                .padding(10)
//                                .padding(.leading, 20)
//                                .font(.custom("marker Felt", size: 18))
//                                .background(Color("background2"))
//                                .cornerRadius(8)
//                            }
                        }
                        
                        //Text("Date is \(birthDate, formatter: dateFormatter)")
                        HStack{
                            Text("Observations")
                                .font(.custom("marker Felt", size: 18))
                                .foregroundColor(.purple)
                                .padding(1)
                            Spacer()
                            
                        }
                        
                        ZStack{
                            TextEditor(text: $observationsEvent)
                                .frame(height: UIScreen.main.bounds.height / 4)
                                .cornerRadius(25)
                            
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
                        }
                           
                        
                        Button(action: {
                            addEvent()
                        }, label: {
                            
                            Text("Save")
                                .font(.custom("Marker Felt", size: 18))
                                .foregroundColor(.blue)
                                .padding(20)
                                .background(Color.orange)
                                .cornerRadius(25)
                        }).shadow(color: .gray, radius: 2, x: 2, y: 2)
                    }.onTapGesture {
                        UIApplication.shared.endEditing()
                    }
                }
                
                Spacer()
            }.padding()
            .font(.custom("Marker Felt", size: 12))
            .onAppear{
                nameProfile = profile.nameProfile ?? "No Name"
                titleEvent = eventSelected.rawValue
                if profile.imageProfile == nil{
                    imgServicio = UIImage(imageLiteralResourceName: "logoPerfectgift")
                }
                else{
                    let imgData = profile.imageProfile
                    let data = try! JSONDecoder().decode(Data.self, from: imgData!)
                    imgServicio = UIImage(data: data)!
                }
            }
            .navigationTitle(nameProfile)
            .navigationBarItems(trailing:
                                    Image(uiImage: imgServicio)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(Circle())
                                    .frame(width: 35, height: 35)
            )
        }
    }
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    private func addEvent() {
        withAnimation {
            let newEvent = Event(context: viewContext)
            newEvent.idEvent = UUID()
            newEvent.titleEvent = titleEvent
            newEvent.observationsEvent = observationsEvent
            newEvent.dateEvent = birthDate
            newEvent.typeEvent = eventSelected.rawValue
            newEvent.profileEventRelation = profile
            
            
            if eventSelected == .anniversary || eventSelected == .birthday{
                newEvent.annualEvent = true
            }
            else{
                newEvent.annualEvent = false
            }
            
            
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
        presentationMode.wrappedValue.dismiss()
    }
}

enum EventeSelected: String{
    case birthday = "BirthDay"
    case anniversary = "Anniversary"
    case specialDay = "Special Day"
}

struct RowDataEvent: View{
    var textString: String
    @Binding var dataString: String
    
    var body: some View{
        HStack{
            Text(textString + ":")
                .foregroundColor(.purple)
            TextFieldAddEvent(hint: textString, dataString: $dataString)
        }
        
    }
}

struct TextFieldAddEvent: View{
    var hint: String
    @Binding var dataString: String
    
    var body: some View{
        ZStack{
        TextField(hint, text: $dataString)
            .padding([.vertical, .leading],10)
            .lineLimit(1)
            .background(Color(.white))
            .font(.custom("marker Felt", size: 12))
            .cornerRadius(8)
            
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
    }
}

struct AddEventView_Previews: PreviewProvider {
    static var previews: some View {
        AddEventView(profile: Profile())
    }
}
