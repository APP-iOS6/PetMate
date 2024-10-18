//
//  SignUpViewModel.swift
//  PetMate
//
//  Created by 김동경 on 10/18/24.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import Observation

@Observable
class SignUpViewModel {
    
    enum Progress: Double {
        case address = 0.5
        case profile = 1.0
    }
    
    var progress: Progress = .address
    var mateUser: MateUser = MateUser(id: nil, name: "", image: "", matchCount: 0, location: "", createdAt: Date())
}
