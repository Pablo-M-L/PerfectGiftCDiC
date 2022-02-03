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
    
    var body: some View {
        ZStack{
            
            Color("background")
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                    VStack{
                        VStack{
                            
                            //cabecero
                            HStack{
                                
                                Text("Idea For......")
                                    .foregroundColor(Color("colorTextoTitulo"))
                                    .font(.custom("marker Felt", size: 36))
                                Spacer()

                                Image(uiImage: imgServicio)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:  70, height: 70)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(.white, lineWidth: 3))
                            }
                            .padding(.horizontal, 25)
                            
                            //introducir titulo
                            TextField("Enter Title", text: $titleIdea)
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
                              
                            //description
                            VStack{
                                HStack{
                                    Text("Description")
                                        .font(.custom("marker Felt", size: 24))
                                        .foregroundColor(.purple)
                                    Spacer()
                                    
                                }
                                
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
                                    
                            }
                            
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
                                .onTapGesture {
                                    mostrarImagePicker = true
                                    imageChange = true
                                }
                                .sheet(isPresented: $mostrarImagePicker){
                                    ImagePicker(selectedImage: self.$imgIdea1, selectedImageDone: $imageDone)
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
                                .sheet(isPresented: $mostrarImagePicker2){
                                    ImagePicker(selectedImage: self.$imgIdea2, selectedImageDone: $imageDone)
                                }
                            
                            Spacer()
                            
                            Image(uiImage: imgIdea3)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width:  70, height: 70)
                                .onTapGesture {
                                    mostrarImagePicker3 = true
                                    imageChange = true
                                }
                                .sheet(isPresented: $mostrarImagePicker3){
                                    ImagePicker(selectedImage: self.$imgIdea3, selectedImageDone: $imageDone)
                                }
                            
                        }.padding(.horizontal,20)
                        .shadow(color: .gray, radius: 3, x: 3, y: 3)

                        
                    }
                
                ZStack{
                    
                    if recargarLista{
                        if let idea1 = idea{
                            UrlsListView(idea: idea1)
                                .cornerRadius(15)
                        }
                        
                    }else{
                        if let idea1 = idea{
                            UrlsListView(idea: idea1)
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
                                print("safari")
                                if ideaYaGuardada{
                                    showUrl = true
                                }else{
                                    showAlertUrl = true
                                }
                                
                            }, label:{
                                ZStack{
                                    Circle()
                                        .foregroundColor(.blue)
                                    Image(systemName: "safari")
                                        .resizable()
                                        .foregroundColor(.white)
                                        .aspectRatio(contentMode: .fit)
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
                }
                
                HStack{
                    Spacer()
                    Button(action: {
                        print("guardar idea")
                        if ideaYaGuardada{
                            updateIdea()
                        }
                        else{
                            addIdea()
                        }
                        
                    }, label: {
                        
                        Text(ideaYaGuardada ? "Update Idea" : "Save Idea")
                            .font(.custom("Marker Felt", size: 18))
                            .foregroundColor(.blue)
                            .padding(20)
                            .background(Color.orange)
                            .cornerRadius(25)
                    })
                }.padding()
                Spacer()

            }.padding()
             .font(.custom("Marker Felt", size: 12))
            
            
            //boton añadir url segun si se está creando una idea o editandola.
            //boton guardar


        }
            .onAppear{
                print("appear addidea")
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
                print("idea actualizada")
                
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            presentationMode.wrappedValue.dismiss()
        }
        
        
    }
    
    private func addIdea(){
        print("añadiendo idea")
        
        withAnimation {
            let newIdea = Ideas(context: viewContext)
            newIdea.ideaTitle = titleIdea
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
                print("idea guardada")
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
        print("añadiendo idea antes de url")
        
        withAnimation {
            let newIdea = Ideas(context: viewContext)
            newIdea.ideaTitle = titleIdea
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

//struct AddIdeaView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddIdeaView(nameProfile: "pablo", eventTitle: "cumple",newIdea: true)
//    }
//}
