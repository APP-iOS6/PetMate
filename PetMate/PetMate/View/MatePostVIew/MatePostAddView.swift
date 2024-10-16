//
//  MatePostAddView.swift
//  PetMate
//
//  Created by 권희철 on 10/16/24.
//

import SwiftUI

struct MatePostAddView: View {
    @State var postStore = MatePostStore()
    
    @Environment(\.dismiss) var dismiss
    @State private var currentPage: Int = 1
    @State private var progress: Double = 0.0
    
    
    var body: some View {
        @Bindable var postStore = postStore
        
        NavigationStack{
            MatePostAddFirstView(
                location: $postStore.location,
                startDate: $postStore.startDate,
                endDate: $postStore.endDate,
                cost: $postStore.cost)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    NavigationLink {
                        MatePostAddSecondView(postStore: self.$postStore)
                            .toolbar {
                                ToolbarItem(placement: .confirmationAction) {
                                    Button("저장"){
                                        postStore.postMatePost()
                                        dismiss()
                                    }
                                    .disabled(postStore.selectedPets.isEmpty ||
                                             postStore.title.isEmpty ||
                                             postStore.content.isEmpty)
                                }
                            }
                    } label: {
                        Text("다음")
                    }.disabled(
                        postStore.location.isEmpty || postStore.cost.isEmpty
                    )
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button{
                        dismiss()
                    }label: {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
    }
}


#Preview {
    MatePostAddView()
}
