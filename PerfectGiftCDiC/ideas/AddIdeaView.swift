//
//  AddIdeaView.swift
//  PerfectGiftCDiC
//
//  Created by Pablo Millan on 26/7/21.
//

import SwiftUI
import Combine


/** vista para añadir o editar una idea*/
struct AddIdeaView: View {
    
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
    
    
    var maxUrl = 3
    @State var idea: Ideas? //solo se crea si se añaden urls
    var profile: Profile
    @State var showUrl = false
    @State var showWebContainer = false
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
                                
                                Text(NSLocalizedString("newIdea", comment: ""))
                                    .foregroundColor(Color("colorTextoTitulo"))
                                    .font(.custom("marker Felt", size: 36))
                                
                                Spacer()
                            }
                            .padding(.horizontal, 25)
                            
                            
                            VStack{
                                HStack{
                                    Text(NSLocalizedString("ideaTit", comment: ""))
                                        .font(.custom("marker Felt", size: 24))
                                        .foregroundColor(.purple)
                                    Spacer()
                                    
                                }
                                
                                //introducir titulo
                                TextField(NSLocalizedString("enterIdeaTit", comment: ""), text: $titleIdea)
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
                            }
                            
                            
                            //description
                            VStack{
                                HStack{
                                    Text(NSLocalizedString("description", comment: ""))
                                        .font(.custom("marker Felt", size: 24))
                                        .foregroundColor(.purple)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.3)
                                    Spacer()
                                    
                                }
                                
                                ZStack{
                                    
                                    TextEditor(text: $descriptionIdea)
                                        .frame(height: UIScreen.main.bounds.height / 5.5)
                                        .font(.custom("Arial", size: 18))
                                        .cornerRadius(20)
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
                                
                                
                            }.padding(.vertical, 15)
                            
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
                                }.sheet(isPresented: $mostrarImagePicker2) {
                                    FullScreenImage(image: $imgIdea2)
                                }
                            //                                    .sheet(isPresented: $mostrarImagePicker2){
                            //                                        ImagePicker(selectedImage: self.$imgIdea2, selectedImageDone: $imageDone)
                            //                                    }
                            
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
                        
                        HStack(alignment: .center){
                            
                            Spacer()
                            
                            ZStack{
                                
                                //antes de abrir la vista para crear una entrada de Url, hay que guardar la idea abierta.
                                //sin no hay una idea creada no se puede crear la url ya que necesita estar vinculada con una idea.
                                if ideaYaGuardada{
                                    NavigationLink(destination: WebContainer(idea: idea!, urlRecived: UserDefaults.standard.value(forKey: key.homeWebAddres.rawValue) as? String ?? "https://google.com"), isActive: $showWebContainer){
                                        EmptyView()
                                    }
                                }
                                
                                Button(action: {
                                    if !ideaYaGuardada{
                                        showAlertUrl = true
                                    }else{
                                        showWebContainer = true
                                    }
                                }, label: {
                                    Text(NSLocalizedString("openBrowser", comment: ""))
                                        .font(.custom("Marker Felt", size: 24))
                                        .foregroundColor(.white)
                                        .padding(.vertical,20)
                                        .padding(.horizontal, 50)
                                        .background(Color("backgroundButton"))
                                        .cornerRadius(25)
                                        .shadow(color: .gray, radius: 2, x: 2, y: 2)
                                })

                            }
                            
                            Spacer()
                            
                            
                            
                            
                        }.padding(30)
                            .alert(isPresented: $showAlertUrl, content: {
                                Alert(title: Text(NSLocalizedString("saveIdea", comment: "")),
                                      message: Text(NSLocalizedString("alertUrlMess", comment: "")),
                                      primaryButton: Alert.Button.default(Text(NSLocalizedString("accept", comment: "")),
                                                                          action: {
                                    addIdeaBeforeUrl()
                                }),
                                      secondaryButton: Alert.Button.destructive(Text(NSLocalizedString("cancel", comment: ""))))
                            })
                    }
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
                        
                        Text(ideaYaGuardada ? NSLocalizedString("updateIdea", comment: "") : NSLocalizedString("saveIdea", comment: ""))
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
        )
        
    }
    
    private func updateIdea(){
        withAnimation {
            idea?.ideaTitle = titleIdea
            idea?.descriptionIdea = descriptionIdea
            
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
            newIdea.regalado = false
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
            newIdea.regalado = false
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
                viewModel.currentIdea = newIdea
                ideaYaGuardada = true
                showWebContainer = true
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            
        }
    }
    
}

//struct AddIdeaView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddIdeaView(nameProfile: "pablo", eventTitle: "cumple",newIdea: true)
//    }
//}
