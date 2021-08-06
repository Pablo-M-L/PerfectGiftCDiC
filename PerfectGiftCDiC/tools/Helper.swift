//
//  Helper.swift
//  PerfectGiftCDiC
//
//  Created by Pablo Millan on 30/7/21.
//

import Foundation
import UIKit

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
