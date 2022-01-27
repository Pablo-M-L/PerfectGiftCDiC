//
//  Helper.swift
//  PerfectGiftCDiC
//
//  Created by Pablo Millan on 30/7/21.
//

import Foundation
import UIKit
import SwiftUI

//para ocultar teclado
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    //para cerrar al pulsar fuera del textview
    /*
     .onTapGesture {
         UIApplication.shared.endEditing()
     }
     */
}

struct backToHomeButton: View{
    
    var body: some View{
        ZStack{
            Circle()
                .foregroundColor(Color("backgroundButton"))
            Image(systemName: "home")
                .resizable()
                .foregroundColor(.white)
                .background(Color("backgroundButton"))
                .aspectRatio(contentMode: .fit)
                .padding(8)
            
            
        }
        .frame(width: 50, height: 50)
        .padding()
    }
}
