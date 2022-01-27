//
//  AddIdeaView.swift
//  PerfectGiftCDiC
//
//  Created by Pablo Millan on 26/7/21.
//

import SwiftUI
import Combine

struct AddIdeaView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    
    @EnvironmentObject var viewModel: ViewModel
        
    
    @State private var nameProfile = ""
    @State private var eventTitle = ""
    @State private var mostrarImagePicker = false
    @State private var mostrarImagePicker2 = false
    @State private var mostrarImagePicker3 = false
    @State private var imageChange = false
    @State private var recargarLista = false

    var maxUrl = 3
    var newIdea: Bool
    var idea: Ideas?
   // var eventParent: Event
    
    @State private var imageDone = false
    @State private var imgServicio = UIImage(imageLiteralResourceName: "logoPerfectgift")
    @State private var imgIdea1 = UIImage(imageLiteralResourceName: "logoPerfectgift")
    @State private var imgIdea2 = UIImage(imageLiteralResourceName: "logoPerfectgift")
    @State private var imgIdea3 = UIImage(imageLiteralResourceName: "logoPerfectgift")
    @State private var titleIdea = "vacio"
    @State private var descriptionIdea = "vacio"
    
    var body: some View {
        ZStack{
            
            Color("background")
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                    VStack{
                        VStack{
                            Text("\(nameProfile)")
                            Text("reason: \(eventTitle)")
                            TextField("title", text: $titleIdea)
                                .onReceive(Just(titleIdea)){ value in
                                    if value != "vacio" && value != idea?.ideaTitle{
                                        updateIdea()
                                    }
                                    
                                }
                            VStack{
                                HStack{
                                    Text("Description")
                                        .padding(1)
                                    Spacer()
                                    
                                }
                                
                                TextEditor(text: $descriptionIdea)
                                    .frame(height: UIScreen.main.bounds.height / 5.5)
                                    .padding()
                                    .cornerRadius(25)
                                    .onReceive(Just(descriptionIdea)){ value in
                                        if value != "vacio" && value != idea?.descriptionIdea{
                                            updateIdea()
                                        }
                                        
                                    }
                            }
                        }.onTapGesture {
                                UIApplication.shared.endEditing()
                            }
                        

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
                        .onDisappear{
                            if !newIdea && imageChange{
                                updateIdea()
                            }
                        }
                        
                    }
                
                
                if !newIdea{
                    if recargarLista{
                        UrlsListView(filterUrl: (idea?.idIdeas!.uuidString)!, idea: idea!)
                    }else{
                        UrlsListView(filterUrl: (idea?.idIdeas!.uuidString)!, idea: idea!)
                    }
                }


            }.padding()
             .font(.custom("Marker Felt", size: 12))
            
            
            //boton de guardar o añadir url segun si se está creando una idea o editandola.
            if newIdea{
                //boton guardar
                VStack{
                    Spacer()
                    
                    HStack{
                        Spacer()
                        Button(action: {
                            if newIdea{
                                addIdea()
                            }else{
                                updateIdea()
                            }
                        }, label: {
                            
                            Text("Save")
                                .font(.custom("Marker Felt", size: 18))
                                .foregroundColor(.blue)
                                .padding(20)
                                .background(Color.orange)
                                .cornerRadius(25)
                        })
                    }
                }
            }
            else{
                VStack{
                    Spacer()
                    
                    HStack{
                        Spacer()

                        NavigationLink(destination: AddUrlView(idea: idea, newUrl: true), label: {
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
                    }
                }
            }

        }
            .onAppear{
                recargarLista.toggle()
//                eventTitle = eventParent.titleEvent ?? "title event Empty"
//                nameProfile = eventParent.profileEventRelation?.nameProfile ?? "name profile empty"
                
                eventTitle = viewModel.currentEvent.titleEvent ?? "title event Empty"
                nameProfile = viewModel.currentProfile.nameProfile ?? "name profile empty"
                
                if newIdea{
                    titleIdea =  "title"
                }else{
                    titleIdea = idea?.ideaTitle ?? "empty"
                    descriptionIdea = idea?.descriptionIdea ?? "description"
                    
                }
                
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
            .navigationTitle("Idea for....")
            .navigationBarItems(trailing:
                                    Image(uiImage: imgServicio)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(Circle())
                                    .frame(width: 20, height: 20)
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
                print("idea actualizada")
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
       // presentationMode.wrappedValue.dismiss()
        
    }
    
    private func addIdea() {
        withAnimation {
            let newIdea = Ideas(context: viewContext)
            newIdea.ideaTitle = titleIdea
           // newIdea.eventTitleIdea = eventTitle
          //  newIdea.profileIdea = nameProfile
            newIdea.descriptionIdea = descriptionIdea
            newIdea.idIdeas = UUID()
            newIdea.idProfileIdea =  viewModel.currentProfile.idProfile?.uuidString //eventParent.profileEventRelation?.idProfile?.uuidString 
            //newIdea.idEventIdea = eventParent.idEvent?.uuidString
            newIdea.idEventIdea = viewModel.currentEvent.idEvent?.uuidString
            
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
        }
        presentationMode.wrappedValue.dismiss()
    }

}

//struct AddIdeaView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddIdeaView(nameProfile: "pablo", eventTitle: "cumple",newIdea: true)
//    }
//}
