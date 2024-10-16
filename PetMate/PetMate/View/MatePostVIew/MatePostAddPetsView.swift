//
//  MatePostAddPetsView.swift
//  PetMate
//
//  Created by 권희철 on 10/16/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct MatePostAddPetsView: View {
    @State var pets: [Pet] = []
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack{
                ForEach(pets) { pet in
                    Text(pet.name)
                }
            }
        }.task {
            pets = await getMyPets()
            print(pets)
        }
    }
    func getMyPets() async -> [Pet] {
        //let currentUser: String = Auth.auth().currentUser?.uid ?? ""
        let currentUser: String = "POzraPP1j3OXqveglMc51GrIN332"
        let db = Firestore.firestore()
        var pets: [Pet] = []
        let snapshots = try? await db.collection("Pet").whereField("ownerUid", isEqualTo: currentUser).getDocuments()
        snapshots?.documents.forEach{ snapshot in
            if let pet = try? snapshot.data(as: Pet.self){
                pets.append(pet)
            }
        }
        
        return pets
    }
}

#Preview {
    MatePostAddPetsView()
}
