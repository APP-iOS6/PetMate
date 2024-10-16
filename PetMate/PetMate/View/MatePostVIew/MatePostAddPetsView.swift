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
    @Environment(\.dismiss) var dismiss
    @State var pets: [Pet] = []
    @Binding var selectedPets: Set<Pet>
    var body: some View {
        GeometryReader{ proxy in
            VStack{
                HStack{
                    Spacer()
                    Button{
                        dismiss()
                    }label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.largeTitle)
                    }
                }
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 20){
                        ForEach(pets) { pet in
                            MatePostAddPetCardView(pet: pet, proxy: proxy, selectedPets: $selectedPets)
                                
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
        }
        .task {
            pets = await getMyPets()
            print(pets)
        }
        .padding()
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
    @Previewable @State var selectedPets: Set<Pet> = []
    MatePostAddPetsView(selectedPets: $selectedPets)
}
