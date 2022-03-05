//
//  AddGiftDoitView.swift
//  PerfectGiftCDiC
//
//  Created by pablo millan lopez on 6/2/22.
//

import SwiftUI
import Combine
import AVFoundation

struct AddGiftDoitView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var viewModel: ViewModel
        
    
    @State private var nameProfile = ""
    @State private var eventTitle = ""
    @State private var mostrarImagePicker = false
    @State private var mostrarImagePicker2 = false
    @State private var mostrarImagePicker3 = false
    @State private var imageChange = false
    @State private var recargarLista = false
    @State private var ideaYaGuardada = false //si se abre la vista de añadir url y se guarda la idea, hay que actualizar no guardar
    @State private var showAlertUrl = false
    @State private var reasonGift = ""
    @State private var giftDate = Date()

    var maxUrl = 3
    @State var idea: Ideas? //solo se crea si se añpaden urls
    var profile: Profile
    @State var showUrl = false
    @Environment(\.presentationMode) private var presentationMode
    
   // var eventParent: Event
    
    @State private var imageDone = false
    @State private var imgServicio = UIImage(imageLiteralResourceName: "logoPerfectgift")
    @State private var imgIdea1 = UIImage(imageLiteralResourceName: "logoPerfectgift")
    @State private var imgIdea2 = UIImage(imageLiteralResourceName: "logoPerfectgift")
    @State private var imgIdea3 = UIImage(imageLiteralResourceName: "logoPerfectgift")
    @State private var titleIdea = ""
    @State private var descriptionIdea = ""
    @State private var closeWithUpdate = false
    @State private var showDatePicker = false
    
    var body: some View {
        ZStack{
            
            Color("background")
                .edgesIgnoringSafeArea(.all)
            ScrollView{
                VStack{
                        VStack{
                            VStack{
                                
                                //cabecero
                                HStack{
                                    Spacer()
                                    
                                    Text("New Gift")
                                        .foregroundColor(Color("colorTextoTitulo"))
                                        .font(.custom("marker Felt", size: 36))
                                    Spacer()
                                }
                                .padding(.horizontal, 25)
                                
                                HStack{
                                Text("Gift Title:")
                                        .foregroundColor(.purple)
                                        .font(.custom("marker Felt", size: 22))
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.3)
                                    Spacer()
                                }
                                //introducir titulo
                                TextField("Enter Gift", text: $titleIdea)
                                    .padding(5)
                                    .background(Color.white)
                                    .font(.custom("Arial", size: 24))
                                    .cornerRadius(10)
                                    .onReceive(Just(titleIdea)){ value in
                                        if value != "" && value != idea?.ideaTitle{
                                            if ideaYaGuardada{
                                                updateIdea()
                                            }
                                        }
                                        
                                    }
                                
                                
                                HStack{
                                Text("Reason for the Gift")
                                        .foregroundColor(.purple)
                                        .font(.custom("marker Felt", size: 22))
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.3)
                                    Spacer()
                                }
                                TextField("Enter Reason for the Gift", text: $reasonGift)
                                    .padding(5)
                                    .background(Color.white)
                                    .font(.custom("Arial", size: 24))
                                    .cornerRadius(10)
                                    
                                    .onReceive(Just(reasonGift)){ value in
                                        if value != "" && value != idea?.eventTitleIdea{
                                            updateIdea()
                                        }
                                        
                                    }
                                
                                //añadir fecha
                                    HStack{
                                        Text("Gift Date:")
                                            .foregroundColor(.purple)
                                            .font(.custom("marker Felt", size: 22))
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.3)
                                            .padding(1)
                                        
                                        Spacer()
                                        
                                        Text(getStringFromDate(date:giftDate))
                                            .foregroundColor(Color("colorTextoTitulo"))
                                            .font(.custom("marker Felt", size: 18))
                                            .minimumScaleFactor(0.3)
                                            .padding(1)
                                            .padding(.trailing, 10)
                                        
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
                                
                                if showDatePicker{
                                    HStack{
                                        
                                        
                                        DatePicker(selection: $giftDate, in: ...Date(), displayedComponents: .date) {
                                            EmptyView()}
                                        .accentColor(Color("backgroundButton"))
                                        .datePickerStyle(WheelDatePickerStyle())
                                        .onChange(of: giftDate) { newValue in
                                                updateIdea()
                                        }
                                    }
                                }
                                
                                
                                  
                                //description
                                VStack{
                                    HStack{
                                        Text("Description")
                                            .foregroundColor(.purple)
                                            .font(.custom("marker Felt", size: 22))
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.3)
                                        Spacer()
                                        
                                    }
                                    
                                    
                                    ZStack{
                                        TextEditor(text: $descriptionIdea)
                                            .frame(height: UIScreen.main.bounds.height / 5.5)
                                            .font(.custom("Arial", size: 18))
                                            .cornerRadius(25)
                                            .onReceive(Just(descriptionIdea)){ value in
                                                if value != "" && value != idea?.descriptionIdea{
                                                    if ideaYaGuardada{
                                                        updateIdea()
                                                    }
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
                                    }

                                        
                                }.padding(.vertical,15)
                                
                            }.onTapGesture {
                                //para ocultar el teclado
                                    UIApplication.shared.endEditing()
                                }
                            

                            //imagenes
                            HStack{
                                Image(uiImage: imgIdea1)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 70, height: 70)
                                    .cornerRadius(20)
                                    .onTapGesture {
                                        mostrarImagePicker = true
                                        imageChange = true
                                    }
                                    .sheet(isPresented: $mostrarImagePicker) {
                                        FullScreenImage(image: $imgIdea1)
                                    }
                                
                                Spacer()
                                
                                Image(uiImage: imgIdea2)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 70, height: 70)
                                    .cornerRadius(20)
                                    .onTapGesture {
                                        mostrarImagePicker2 = true
                                        imageChange = true
                                    }
                                    .sheet(isPresented: $mostrarImagePicker2) {
                                        FullScreenImage(image: $imgIdea2)
                                    }
                                
                                Spacer()
                                
                                Image(uiImage: imgIdea3)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:  70, height: 70)
                                    .cornerRadius(20)
                                    .onTapGesture {
                                        mostrarImagePicker3 = true
                                        imageChange = true
                                    }
                                    .sheet(isPresented: $mostrarImagePicker3) {
                                        FullScreenImage(image: $imgIdea3)
                                    }
                                
                            }.padding(.horizontal,20)
                                .padding(.vertical, 10)
                            .shadow(color: .gray, radius: 3, x: 3, y: 3)

                            
                        }
                    
                    Text("Links")
                        .foregroundColor(.purple)
                        .font(.custom("marker Felt", size: 18))
                    
                    ZStack{
                        
                        if recargarLista{
                            if let idea1 = idea{
                                UrlsListView(idea: idea1)
                                    //.colorMultiply(Color("background"))
                                    .cornerRadius(15)
                            }
                        }else{
                            if let idea1 = idea{
                                UrlsListView(idea: idea1)
                                    //.colorMultiply(Color("background"))
                                    .cornerRadius(15)
                            }
                            
                        }
                        

                        
                        //boton de guardar url segun si se está creando una idea o editandola.
                        VStack{
                            HStack{
                                Spacer()
                                    NavigationLink(destination: AddUrlView(idea: idea, newUrl: true), isActive: $showUrl){
                                        EmptyView()
                                    }
                                
                                Button(action:{
                                    //antes de abrir la vista para crear una entrada de Url, hay que guardar la idea abierta.
                                    //sin no hay una idea creada no se puede crear la url ya que necesita estar vinculada con una idea.
                                    if ideaYaGuardada{
                                        showUrl = true
                                    }else{
                                        showAlertUrl = true
                                    }
                                    
                                }, label:{
                                    ZStack{
                                        Circle()
                                            .foregroundColor(Color("backgroundButton"))
                                        Image(systemName: idea == nil ? "safari" : "plus.circle")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .foregroundColor(.white)
                                            .padding(8)
                                            
                                        
                                    }
                                    .frame(width: 50, height: 50)
                                    .padding()
                                })
                                    .alert(isPresented: $showAlertUrl, content: {
                                        Alert(title: Text("Save Idea"),
                                              message: Text("To be able to add Links you have to save the Idea first."),
                                              primaryButton: Alert.Button.default(Text("Accept"),
                                                                                  action: {
                                                                                        addIdeaBeforeUrl()
                                                                                    }),
                                              secondaryButton: Alert.Button.destructive(Text("Cancel")))
                                    })

                            }
                            
                            Spacer()
                        }
                    }.frame(height: 500)
                    
                    


                }.padding()
                 .font(.custom("Marker Felt", size: 12))
            }
            
            VStack{
                Spacer()
            HStack{
                Spacer()
                Button(action: {
                    if ideaYaGuardada{
                        closeWithUpdate = true
                        updateIdea()
                    }
                    else{
                        addIdea()
                    }
                    
                }, label: {
                    
                    Text(ideaYaGuardada ? "Update Gift" : "Save Gift")
                        .font(.custom("Marker Felt", size: 18))
                        .foregroundColor(.blue)
                        .padding(20)
                        .background(Color.orange)
                        .cornerRadius(25)
                        .shadow(color: .gray, radius: 2, x: 2, y: 2)
                })
            }.padding()
            
            }
            //boton añadir url segun si se está creando una idea o editandola.
            //boton guardar


        }
            .onAppear{
                recargarLista.toggle()
//                eventTitle = eventParent.titleEvent ?? "title event Empty"
//                nameProfile = eventParent.profileEventRelation?.nameProfile ?? "name profile empty"
//                eventTitle = viewModel.currentEvent.titleEvent ?? "title event Empty"

                
                viewModel.currentProfile = profile
                //titleIdea =  "title"
                
                eventTitle = "title event Empty"
                nameProfile = viewModel.currentProfile.nameProfile ?? "name profile empty"
                
//                if eventParent.profileEventRelation?.imageProfile == nil{
//                    imgServicio = UIImage(imageLiteralResourceName: "logoPerfectgift")
//                }
                if viewModel.currentProfile.imageProfile == nil{
                    imgServicio = UIImage(imageLiteralResourceName: "logoPerfectgift")
                }
                else{
                    //let imgData = eventParent.profileEventRelation?.imageProfile
                    let imgData = viewModel.currentProfile.imageProfile
                    let data = try! JSONDecoder().decode(Data.self, from: imgData!)
                    imgServicio = UIImage(data: data)!
                }
                
                
                if idea?.image1Idea == nil{
                    imgIdea1 = UIImage(imageLiteralResourceName: "logoPerfectgift")
                }
                else{
                    let imgData = idea?.image1Idea
                    let data = try! JSONDecoder().decode(Data.self, from: imgData!)
                    imgIdea1 = UIImage(data: data)!
                }
                
                if idea?.image2Idea == nil{
                    imgIdea2 = UIImage(imageLiteralResourceName: "logoPerfectgift")
                }
                else{
                    let imgData = idea?.image2Idea
                    let data = try! JSONDecoder().decode(Data.self, from: imgData!)
                    imgIdea2 = UIImage(data: data)!
                }
                
                if idea?.image3Idea == nil{
                    imgIdea3 = UIImage(imageLiteralResourceName: "logoPerfectgift")
                }
                else{
                    let imgData = idea?.image3Idea
                    let data = try! JSONDecoder().decode(Data.self, from: imgData!)
                    imgIdea3 = UIImage(data: data)!
                }
            }
            .navigationBarItems(trailing:
                                    Image(uiImage: imgServicio)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(Circle())
                                    .frame(width: 35, height: 35)
                                    .overlay(Circle().stroke(.white, lineWidth: 3))
            )

    }
    
    private func updateIdea(){
        withAnimation {
            idea?.ideaTitle = titleIdea
            idea?.descriptionIdea = descriptionIdea
            idea?.regalado = true
            idea?.eventTitleIdea = reasonGift
            idea?.fechaQueRegalo = giftDate
            
            //imagen 1
            let imagenUIRedimensionada = resizeImage(image: imgIdea1)
            let imageData =  imagenUIRedimensionada.jpegData(compressionQuality: 0.5)
            let data = try! JSONEncoder().encode(imageData)
            idea?.image1Idea = data
            
            //imagen 2
            let imagenUIRedimensionada2 = resizeImage(image: imgIdea2)
            let imageData2 =  imagenUIRedimensionada2.jpegData(compressionQuality: 0.5)
            let data2 = try! JSONEncoder().encode(imageData2)
            idea?.image2Idea = data2
            
            // imagen 3
            let imagenUIRedimensionada3 = resizeImage(image: imgIdea3)
            let imageData3 =  imagenUIRedimensionada3.jpegData(compressionQuality: 0.5)
            let data3 = try! JSONEncoder().encode(imageData3)
            idea?.image3Idea = data3
            
            do {
                try viewContext.save()
                print("idea actualizada")
                
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            
            if closeWithUpdate{
                presentationMode.wrappedValue.dismiss()
            }
        }
        
        
    }
    
    private func addIdea(){
        withAnimation {
            let newIdea = Ideas(context: viewContext)
            newIdea.ideaTitle = titleIdea
            newIdea.profileIdeasRelation = profile
            newIdea.regalado = true
            newIdea.eventTitleIdea = reasonGift
            newIdea.fechaQueRegalo = giftDate
           // newIdea.eventTitleIdea = eventTitle
          //  newIdea.profileIdea = nameProfile
            newIdea.descriptionIdea = descriptionIdea
            newIdea.idIdeas = UUID()
            newIdea.idProfileIdea =  profile.idProfile?.uuidString //eventParent.profileEventRelation?.idProfile?.uuidString
            //newIdea.idEventIdea = eventParent.idEvent?.uuidString
            //newIdea.idEventIdea = viewModel.currentEvent.idEvent?.uuidString
            
            //imagen 1
            let imagenUIRedimensionada = resizeImage(image: imgIdea1)
            let imageData =  imagenUIRedimensionada.jpegData(compressionQuality: 0.5)
            let data = try! JSONEncoder().encode(imageData)
            newIdea.image1Idea = data
            
            //imagen 2
            let imagenUIRedimensionada2 = resizeImage(image: imgIdea2)
            let imageData2 =  imagenUIRedimensionada2.jpegData(compressionQuality: 0.5)
            let data2 = try! JSONEncoder().encode(imageData2)
            newIdea.image2Idea = data2
            
            // imagen 3
            let imagenUIRedimensionada3 = resizeImage(image: imgIdea3)
            let imageData3 =  imagenUIRedimensionada3.jpegData(compressionQuality: 0.5)
            let data3 = try! JSONEncoder().encode(imageData3)
            newIdea.image3Idea = data3

            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    private func addIdeaBeforeUrl(){
        withAnimation {
            let newIdea = Ideas(context: viewContext)
            newIdea.ideaTitle = titleIdea
            newIdea.regalado = true
            newIdea.eventTitleIdea = reasonGift
            newIdea.fechaQueRegalo = giftDate
            
           // newIdea.eventTitleIdea = eventTitle
          //  newIdea.profileIdea = nameProfile
            newIdea.descriptionIdea = descriptionIdea
            newIdea.idIdeas = UUID()
            newIdea.idProfileIdea =  profile.idProfile?.uuidString //eventParent.profileEventRelation?.idProfile?.uuidString
            //newIdea.idEventIdea = eventParent.idEvent?.uuidString
            //newIdea.idEventIdea = viewModel.currentEvent.idEvent?.uuidString
            
            //imagen 1
            let imagenUIRedimensionada = resizeImage(image: imgIdea1)
            let imageData =  imagenUIRedimensionada.jpegData(compressionQuality: 0.5)
            let data = try! JSONEncoder().encode(imageData)
            newIdea.image1Idea = data
            
            //imagen 2
            let imagenUIRedimensionada2 = resizeImage(image: imgIdea2)
            let imageData2 =  imagenUIRedimensionada2.jpegData(compressionQuality: 0.5)
            let data2 = try! JSONEncoder().encode(imageData2)
            newIdea.image2Idea = data2
            
            // imagen 3
            let imagenUIRedimensionada3 = resizeImage(image: imgIdea3)
            let imageData3 =  imagenUIRedimensionada3.jpegData(compressionQuality: 0.5)
            let data3 = try! JSONEncoder().encode(imageData3)
            newIdea.image3Idea = data3

            
            do {
                try viewContext.save()
                idea = newIdea
                ideaYaGuardada = true
                print("idea guardada")
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            showUrl = true
        }
    }
}

//struct AddGiftDoitView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddGiftDoitView()
//    }
//}
