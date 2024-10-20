//
//  RegisterPetViewModel.swift
//  PetMate
//
//  Created by 김동경 on 10/20/24.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import Observation

@Observable
class RegisterPetViewModel {
    
    var myPet: Pet = Pet(name: "", description: "", age: 0, type: "강아지", tag: [], breed: "", images: [], ownerUid: "", createdAt: Date(), updatedAt: Date())
    
    
}
