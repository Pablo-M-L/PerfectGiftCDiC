//
//  DetailProfileView.swift
//  PerfectGiftCDiC
//
//  Created by pablo on 7/7/21.
//

import SwiftUI
import Combine

struct DetailProfileView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var helper: ViewModel
    
    var profile: Profile
    
    
    @State private var nameProfile = ""
    @State private var annotationsProfile = ""
    @State private var mostrarImagePicker = false
    @State private var imageDone = false
    @State private var imgServicio = UIImage(imageLiteralResourceName: "logoPerfectgift")
    @State private var vistaActiva: VistaActivaPerfil = .ideas
    @State private var showAlert = false
    @State private var borrarEvento = false
    @State private var titleList = "IDEAS"
    @State private var showAddEvent = false
    @State private var showAddIdea = false
    @State private var showAddGift = false
    @State private var imgAddButton = "addIdeaIcon"
    
    var body: some View {
        ZStack{
            
            Color("background")
                .edgesIgnoringSafeArea(.all)
            //bloque de datos del profile
            VStack{
                HStack{
                    //boton cambiar imagen y toggle
                    HStack{
                        Button(action:{
                            self.mostrarImagePicker.toggle()
                        },label:{
                            VStack{
                                if let uiImage = imgServicio{
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 80, height: 80)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(.white, lineWidth: 3))
                                        .padding(.bottom, 3)
                                        .onReceive(Just(imageDone)) { done in
                                            if done{
                                                saveChangesProfile()
                                            }
                                        }
                                }
                                else{
                                    Image(systemName: "person")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 80, height: 80)
                                        .clipShape(Circle())
                                        .padding(.bottom, 3)
                                }
                            }
                            .shadow(color: .gray, radius: 3, x: 2, y: 2)
                        })
                            .sheet(isPresented: $mostrarImagePicker){
                                ImagePicker(selectedImage: self.$imgServicio, selectedImageDone: $imageDone)
                            }
                    }
                    
                    //nombre y anotaciones
                    VStack(alignment: .leading){
                        
                        ZStack{
                            TextFieldProfile(hint: "Enter Person's Name", dataString: $nameProfile)
                            //onReceive detecta cambio en la variable nameProfile, si hay cambio llama a la funcion de guardar en BD.
                            //tambien se compara con el string "vacio" que es el valor inicial, porque detectaba el cambio en la variable
                            //al abrir la pantalla, y guardaba en la BD el valor "vacio", borrando el dato correcto.
                                .onReceive(Just(nameProfile)){ value in
                                    if value != "" && value != profile.nameProfile{
                                        saveChangesProfile()
                                    }
                                }
                            HStack{
                                Spacer()
                                Image(systemName: "pencil.circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(Color.gray)
                                    .padding(.trailing, 10)
                            }
                        }
                        
                        ZStack{
                            TextFieldProfile(hint: "Details", dataString: $annotationsProfile)
                                .onReceive(Just(nameProfile)){ value in
                                    if value != "" && value != profile.annotationsProfile{
                                        saveChangesProfile()
                                    }
                                }
                            
                            HStack{
                                Spacer()
                                Image(systemName: "pencil.circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(Color.gray)
                                    .padding(.trailing, 10)
                            }
                        }
                        
                        
                    }
                    
                    
                }.padding([.horizontal, .top], 10)
                
                VStack{
                    
                    HStack{
                        Spacer()
                        Text(titleList)
                            .foregroundColor(Color("colorTextoTitulo"))
                            .font(.custom("marker Felt", size: 18))
                        
                        Spacer()
                        
                        if vistaActiva == .ideas{
                            NavigationLink(destination: AddIdeaView(profile: profile), isActive: $showAddIdea){
                                EmptyView()
                            }
                        }
                        else if vistaActiva == .eventos{
                            NavigationLink(destination: AddEventView(profile: profile), isActive: $showAddEvent){
                                EmptyView()
                            }
                        }
                        else if vistaActiva == .regalados{
                            NavigationLink(destination: AddGiftDoitView(profile: profile), isActive: $showAddGift){
                                EmptyView()
                            }
                        }
                        
                        
                        Button(action:{
                            if vistaActiva == .ideas{
                                showAddIdea = true
                            }
                            else if vistaActiva == .eventos{
                                showAddEvent = true
                            }
                            else if vistaActiva == .regalados{
                                showAddGift = true                            }
                            
                            
                        }, label:{
                            ZStack{
                                Image(imgAddButton)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(Color("backgroundButton"))
                                    .offset(x: -15, y: 15)
                            }
                            .frame(width: 35, height: 35)
                            .shadow(color: .gray, radius: 2, x: 2, y: 2)
                            .padding(3)
                        })
                    }
                    
                    Rectangle()
                        .foregroundColor(.gray)
                        .opacity(0.3)
                        .frame(height: 5)
                }
                
                
                if vistaActiva == .ideas{
                    IdeasListView(profile: profile)
                        .colorMultiply(Color("background"))
                        .edgesIgnoringSafeArea(.all)
                }
                else if vistaActiva == .eventos{
                    EventsListView(filter: profile.nameProfile ?? "", profile: profile)
                        .colorMultiply(Color("background"))
                        .edgesIgnoringSafeArea(.all)
                }
                else if vistaActiva == .regalados{
                    ListGiftDoitView(profile: profile)
                        .colorMultiply(Color("background"))
                        .edgesIgnoringSafeArea(.all)
                }
                
                
                VStack{
                    HStack(alignment: .center, spacing: 50){
                        Button(action:{
                            withAnimation {
                                vistaActiva = .ideas
                                titleList = "IDEAS"
                                imgAddButton = "addIdeaIcon"
                            }
                            
                        },label:{
                            SelecctViewListButtonStyle(vistaActiva: $vistaActiva, listaAsociadaAlBoton: .ideas)
                        })
                        
                        Button(action:{
                            withAnimation {
                                vistaActiva = .eventos
                                titleList = "EVENTS"
                                imgAddButton = "addEventIcon"
                            }
                        },label:{
                            SelecctViewListButtonStyle(vistaActiva: $vistaActiva, listaAsociadaAlBoton: .eventos)
                        })
                        
                        Button(action:{
                            withAnimation {
                                vistaActiva = .regalados
                                titleList = "GIFTS"
                                imgAddButton = "addGiftDoitIcon"
                            }
                        },label:{
                            SelecctViewListButtonStyle(vistaActiva: $vistaActiva, listaAsociadaAlBoton: .regalados)
                        })
                        
                        
                    }.padding(.bottom,35)
                    
                }.frame( height: 25)
                
            }
            
        }
        .onDisappear{
            if borrarEvento{
                deleteEvent()
            }
        }
        .onAppear{
            setupAppearance()
            helper.currentProfile = profile
            nameProfile = profile.nameProfile ?? "sin nombre"
            annotationsProfile = profile.annotationsProfile ?? ""
            if profile.imageProfile == nil{
                imgServicio = UIImage(imageLiteralResourceName: "logoPerfectgift")
            }
            else{
                let imgData = profile.imageProfile
                let data = try! JSONDecoder().decode(Data.self, from: imgData!)
                imgServicio = UIImage(data: data)!
            }
            
        }
        .navigationTitle(nameProfile == "" ? "Name" : nameProfile )
        .navigationBarItems(trailing:
                                HStack{
            Spacer()
            //            Image(uiImage: imgServicio)
            //                .resizable()
            //                .aspectRatio(contentMode: .fit)
            //                .clipShape(Circle())
            //                .frame(width: 35, height: 35)
            
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
                title: Text("¿Do you want to delete this person from \(profile.nameProfile ?? "profile")?"),
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
            viewContext.delete(profile)
            
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
    
    func setupAppearance() {
        //setea los colores de los puntos y el fondo de los indicadores del tabview
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color("colorTextoTitulo"))
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
    }
    
    //funcion que guarda el nombre, anotaciones e imagen del perfil.
    func saveChangesProfile(){
        withAnimation{
            profile.nameProfile = nameProfile
            profile.annotationsProfile = annotationsProfile
            let imagenUIRedimensionada = resizeImage(image: imgServicio)
            let imageData =  imagenUIRedimensionada.jpegData(compressionQuality: 0.5)
            let data = try! JSONEncoder().encode(imageData)
            profile.imageProfile = data
            
            //comprueba si la persona esta en la lista de favoritos,y si es asi, actualiza los datos del listado en el usersdefault.
            if isFavoriteProfile(profile: profile) != 10{
                let sortNumber = isFavoriteProfile(profile: profile)
                changeFavoriteProfileData(sortNumber: sortNumber, profile: profile)
            }
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
        
        // presentationMode.wrappedValue.dismiss()
        
    }
    
    func isFavoriteProfile(profile: Profile)-> Int{
        var sortNumber = 10
        
        let arrayFavorite = HelperWidget.arrayFavoriteData
        
        for fav in arrayFavorite{
            if fav.idProfileFav == profile.idProfile?.uuidString{
                sortNumber = fav.sortNumber
            }
        }
        
        return sortNumber
    }
    
    func changeFavoriteProfileData(sortNumber: Int, profile: Profile){
        
        HelperWidget.arrayFavoriteData[sortNumber - 1].nameProfileFav = profile.nameProfile!
        HelperWidget.arrayFavoriteData[sortNumber - 1].imgProfileFav = profile.imageProfile!
        
        if let userDefaults = UserDefaults(suiteName: appGroupName) {
            userDefaults.setArray(HelperWidget.arrayFavoriteData, forKey: key.arrayFavoriteData.rawValue)
            userDefaults.synchronize()
        }
    }
}

enum VistaActivaPerfil{
    case ideas
    case eventos
    case regalados
}
struct TextFieldProfile: View{
    var hint: String
    @Binding var dataString: String
    
    var body: some View{
        TextField(hint, text: $dataString)
            .padding([.vertical, .leading],5)
            .lineLimit(1)
            .background(Color(.white))
            .font(.custom("marker Felt", size: 18))
            .cornerRadius(8)
    }
}

struct SelecctViewListButtonStyle:View{
    @Binding var vistaActiva: VistaActivaPerfil
    var listaAsociadaAlBoton: VistaActivaPerfil
    
    var body: some View{
        ZStack(alignment: .center){
            Spacer()
            
            switch listaAsociadaAlBoton {
            case .ideas:
                Image(vistaActiva == listaAsociadaAlBoton ? "addIdeaIcon" : "addIdeaIconLight")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(5)
                    .background(Color(vistaActiva == listaAsociadaAlBoton ? "backgroundButton" : "background3"))
                    .cornerRadius(20)
            case .eventos:
                Image(vistaActiva == listaAsociadaAlBoton ? "addEventIcon" : "addEventIconLight")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(5)
                    .background(Color(vistaActiva == listaAsociadaAlBoton ? "backgroundButton" : "background3"))
                    .cornerRadius(20)
            case .regalados:
                Image(vistaActiva == listaAsociadaAlBoton ? "addGiftDoitIcon" : "addGiftIconLight")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(5)
                    .background(Color(vistaActiva == listaAsociadaAlBoton ? "backgroundButton" : "background3"))
                    .cornerRadius(20)
            }
            
        }.frame(width: UIScreen.main.bounds.width / 4.5, height: 60)
            .shadow(color: .gray, radius: 2, x: 2, y: 2)
            .padding(.bottom, 15)
    }
    
}


//struct DetailProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailProfileView(profile: Profile())
//    }
//}
