//
//  AddProfileView.swift
//  PerfectGiftCDiC
//
//  Created by pablo on 5/7/21.
//

import SwiftUI
import CloudKit
import CoreData

struct AddProfileView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode

    @State private var nameProfile = ""
    @State private var annotationsProfile = ""
    @State private var mostrarImagePicker = false
    @State private var imageDone = false
    @State private var imgServicio = UIImage(imageLiteralResourceName: "logoPerfectgift")
    
    var body: some View {
        ZStack{
            
            Color("background")
                .edgesIgnoringSafeArea(.all)
            
 //           ScrollView(.vertical){
                
                VStack{
                        
                    //boton cambiar imagen y toggle
                    HStack{
                        Spacer()
                        
                        Button(action:{
                            self.mostrarImagePicker.toggle()
                        },label:{
                            VStack{
                                if let uiImage = imgServicio{
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100, height: 100)
                                        .padding(.bottom, 3)
                                }
                                else{
                                    Image(systemName: "person")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100, height: 100)
                                        .padding(.bottom, 3)
                                }
                                HStack(alignment: .center){
                                    Text("Change Image")
                                }
                        }
                        })
                        .sheet(isPresented: $mostrarImagePicker){
                            ImagePicker(selectedImage: self.$imgServicio, selectedImageDone: $imageDone)
                        }
                        
                        Spacer()
                        
                    }.padding(.trailing, 7)
                    
                    HStack{
                        Text("NAME: ")
                        TextField("Name Profile", text: $nameProfile)
                            .padding(.vertical, 10)
                            .background(Color(.white))
                            .lineLimit(1)
                            .cornerRadius(8)
                            
                        
                    }.font(.custom("Marker Felt", size: 18))
                    .padding()
                    
                    VStack{
                        Text("ANNOTATION: ")
                        TextField("Info", text: $annotationsProfile)
                            //.multilineTextAlignment(.leading)
                            .padding(.vertical,10)
                            .lineLimit(1)
                            .cornerRadius(8)
                            .background(Color(.white))
                            .padding(.horizontal, 10)
                        
                            
                    }.font(.custom("marker Felt", size: 18))
                    
                    Spacer()
                    
                    Button(action:{
                        addProfile()
                        presentationMode.wrappedValue.dismiss()
                    },label:{
                            ZStack{
                                Text("ADD PROFILE")
                                    .frame(width: UIScreen.main.bounds.width / 1.2, height: 50)
                                    .background(Color.orange)
                                    .foregroundColor(.white)
                                    .font(.custom("Marker Felt", size: 20))
                                    .cornerRadius(25)
                                    .padding()
                            }
                    }).padding()
                    
                }
                .navigationTitle("Add Profile")
        }
        //}
    }
    
    
        private func addProfile() {
            withAnimation {
                let newProfile = Profile(context: viewContext)
                newProfile.idProfile = UUID()
                newProfile.annotationsProfile = annotationsProfile
                newProfile.nameProfile = nameProfile
                let imagenUIRedimensionada = resizeImage(image: imgServicio)
                let imageData =  imagenUIRedimensionada.jpegData(compressionQuality: 0.5)
                let data = try! JSONEncoder().encode(imageData)
                newProfile.imageProfile = data
    
                do {
                    try viewContext.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }
        }
}

struct AddProfileView_Previews: PreviewProvider {
    static var previews: some View {
        AddProfileView()
    }
}
