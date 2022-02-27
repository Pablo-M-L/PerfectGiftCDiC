//
//  ViewModel.swift
//  PerfectGiftCDiC
//
//  Created by Pablo Millan on 4/8/21.
//

import Foundation


class ViewModel: ObservableObject{
    
    @Published var profileList: [profileListItem] = []
    @Published var currentProfile: Profile = Profile()
    @Published var currentEvent: Event = Event()
    @Published var currentIdea: Ideas = Ideas()
    @Published var backToHome: Bool = false
   
}
