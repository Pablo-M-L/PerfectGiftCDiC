//
//  DetailGiftDoitView.swift
//  PerfectGiftCDiC
//
//  Created by pablo millan lopez on 6/2/22.
//

import SwiftUI
import Combine

struct DetailGiftDoitView: View {
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
    var idea: Ideas?
    var profile: Profile?
    var isNewIdea: Bool
    
   // var eventParent: Event
    @State private var giftDate = Date()
    @State private var imageDone = false
    @State private var imgServicio = UIImage(imageLiteralResourceName: "logoPerfectgift")
    @State private var imgIdea1 = UIImage(imageLiteralResourceName: "logoPerfectgift")
    @State private var imgIdea2 = UIImage(imageLiteralResourceName: "logoPerfectgift")
    @State private var imgIdea3 = UIImage(imageLiteralResourceName: "logoPerfectgift")
    @State private var titleIdea = ""
    @State private var descriptionIdea = ""
    @State private var regalado = false
    @State private var showAlertDelete = false
    @State private var borrarIdea = false
    @State private var reasonGift = ""
    @State private var showDatePicker = false
    @State private var showAlertSaveAsGift = false
    
    var body: some View {
        ZStack{
            
            Color("background")
                .edgesIgnoringSafeArea(.all)
            
            ScrollView{
                VStack{
                        VStack{
                            VStack{
                                
                                if isNewIdea{
                                HStack{
                                    Spacer()
                                    
                                    Button(action:{
                                        showAlertSaveAsGift = true
                                    },label:{
                                        Text("save")
                                    })
                                    Spacer()
                                }
                                }
                                HStack{
                                Text("Gift")
                                    .foregroundColor(.purple)
                                    .font(.custom("marker Felt", size: 18))
                                    Spacer()
                                }
                                
                                ZStack{
                                TextField("Enter Gift", text: $titleIdea)
                                    .padding(5)
                                    .background(Color.white)
                                    .font(.custom("Arial", size: 24))
                                    .cornerRadius(10)
                                    
                                    .onReceive(Just(titleIdea)){ value in
                                        if value != "" && value != idea?.ideaTitle{
                                            updateIdea()
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
                                
                                
                                HStack{
                                Text("Reason for the Gift")
                                    .foregroundColor(.purple)
                                    .font(.custom("marker Felt", size: 18))
                                    Spacer()
                                }
                                
                                ZStack{
                                TextField("Reason for the Gift", text: $reasonGift)
                                    .padding(5)
                                    .background(Color.white)
                                    .font(.custom("Arial", size: 24))
                                    .cornerRadius(10)
                                    
                                    .onReceive(Just(reasonGift)){ value in
                                        if value != "" && value != idea?.eventTitleIdea{
                                            updateIdea()
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
                                        Text("Gift Date:")
                                            .foregroundColor(.purple)
                                            .font(.custom("marker Felt", size: 18))
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
                                            Text("Gift Date")
                                                .font(.custom("marker Felt", size: 18))
                                                .foregroundColor(.purple)
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.3)
                                        }
                                        .accentColor(Color("backgroundButton"))
                                        .datePickerStyle(GraphicalDatePickerStyle())
                                    }
                                }
                                
                                
                                
                                VStack{
                                    HStack{
                                        Text("Description")
                                            .font(.custom("Arial", size: 18))
                                            .foregroundColor(.purple)
                                        Spacer()
                                        
                                    }
                                    
                                    ZStack{
                                        
                                        TextEditor(text: $descriptionIdea)
                                            .frame(height: UIScreen.main.bounds.height / 5.5)
                                            .font(.custom("Arial", size: 18))
                                            .cornerRadius(25)
                                            .onReceive(Just(descriptionIdea)){ value in
                                                if value != "" && value != idea?.descriptionIdea{
                                                    updateIdea()
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

                                }
                            }.onTapGesture {
                                //para ocultar el teclado
                                    UIApplication.shared.endEditing()
                                }
                            

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
                            .onDisappear{
                                if imageChange{
                                    updateIdea()
                                }
                            }
                            
                        }
                    
                    Text("Links")
                        .foregroundColor(.purple)
                        .font(.custom("marker Felt", size: 18))

                    ZStack{
                        
                        VStack{
                            if let idea1 = idea{
                                if recargarLista{
                                    UrlsListView(idea: idea1)
                                        .cornerRadius(15)
                                }
                                else{
                                    UrlsListView(idea: idea1)
                                        .cornerRadius(15)
                                }
                                
                            }

                        }
                        
                        //boton de guardar url segun si se está creando una idea o editandola.
                        VStack{
                            HStack{
                                Spacer()

                                NavigationLink(destination: AddUrlView(idea: idea, newUrl: true), label: {
                                    ZStack{
                                        Circle()
                                            .foregroundColor(Color("backgroundButton"))
                                        Image(systemName: "plus.circle")
                                            .resizable()
                                            .foregroundColor(.white)
                                            .aspectRatio(contentMode: .fit)
                                            .padding(8)
                                        
                                        
                                    }
                                    .frame(width: 40, height: 40)
                                    .padding(.trailing, 5)
                                    .padding(.top,5)
                                })
                            }
                            
                            Spacer()
                        }.frame(height: UIScreen.main.bounds.height / 3)
                    }
                    
                        
                    
 


                }
                .onDisappear{
                    if borrarIdea{
                        deleteIdea(idea: idea!)
                    }
                }
                .padding()
                 .font(.custom("Marker Felt", size: 18))
            }
            


        }.navigationBarTitle("Gift for \(nameProfile)")
         .navigationBarItems(trailing:
                                HStack{
                                    Spacer()
                                    Image(uiImage: imgServicio)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width:  35, height: 35)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(.white, lineWidth: 3))
             
                                     Button(action: {
                                         print("borrar idea")
                                         showAlertDelete = true
                                     },label:{
                                         Image(systemName: "trash")
                                             .resizable()
                                             .aspectRatio(contentMode: .fit)
                                             .frame(width: 35, height: 35)
                                             .foregroundColor(.purple)
                                     })
                                }
            ).alert(isPresented: $showAlertDelete, content: {
             Alert(
                 title: Text("Do you want to delete this Gift?"),
                 primaryButton: .default(Text("Delete"), action: {
                     print("borrar idea")
                     borrarIdea = true
                     presentationMode.wrappedValue.dismiss()
                 }),
                 secondaryButton: .cancel(Text("Cancel")))
         })
            .alert(isPresented: $showAlertSaveAsGift, content: {
             Alert(
                 title: Text("Do you want to save this ideas as Gift?"),
                 primaryButton: .default(Text("Save"), action: {
                     print("borrar idea")
                     updateIdea()
                     presentationMode.wrappedValue.dismiss()
                 }),
                 secondaryButton: .cancel(Text("Cancel")))
         })
            .onAppear{
                recargarLista.toggle()
//                eventTitle = eventParent.titleEvent ?? "title event Empty"
//                nameProfile = eventParent.profileEventRelation?.nameProfile ?? "name profile empty"
//                eventTitle = viewModel.currentEvent.titleEvent ?? "title event Empty"

                
                titleIdea = idea?.ideaTitle ?? ""
                descriptionIdea = idea?.descriptionIdea ?? ""
                reasonGift = idea?.eventTitleIdea ?? ""
                giftDate = idea?.fechaQueRegalo ?? Date()
                
                eventTitle = ""
                nameProfile = viewModel.currentProfile.nameProfile ?? ""
                
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
    
    private func deleteIdea(idea: Ideas){
        presentationMode.wrappedValue.dismiss()
        @FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \Ideas.ideaTitle, ascending: true)],
            animation: .default)
        
        var profiles: FetchedResults<Ideas>
        
        viewContext.delete(idea)
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        
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
        }
       // presentationMode.wrappedValue.dismiss()
        
    }
}

//struct DetailGiftDoitView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailGiftDoitView()
//    }
//}
