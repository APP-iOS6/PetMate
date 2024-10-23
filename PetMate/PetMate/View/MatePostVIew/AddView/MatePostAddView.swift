//
//  MatePostAddView.swift
//  PetMate
//
//  Created by 권희철 on 10/16/24.
//

import SwiftUI

struct MatePostAddView: View {
    @Environment(MatePostStore.self) var postStore: MatePostStore
    
    @Environment(\.dismiss) var dismiss
    @State private var progress: Double = 0.5
    
    var body: some View {
        @Bindable var postStore = postStore
        NavigationStack{
            VStack{
                ProgressView(value: progress)
                    .animation(.easeIn, value: progress)
                switch progress{
                case 0.5:
                    MatePostAddFirstView()
                        .transition(.move(edge: .leading))
                        .toolbar {
                            ToolbarItem(placement: .confirmationAction) {
                                Button{
                                    progress = 1.0
                                }label: {
                                    Text("다음")
                                }.disabled(postStore.location.isEmpty ||
                                           postStore.startDate > postStore.endDate ||
                                           postStore.cost.isEmpty
                                )
                            }
                            ToolbarItem(placement: .cancellationAction) {
                                Button{
                                    dismiss()
                                }label:{
                                    Image(systemName: "xmark")
                                }
                            }
                        }
                case 1.0:
                    MatePostAddSecondView()
                        .transition(.move(edge: .trailing))
                        .animation(.easeIn, value: progress)
                        .toolbar {
                            ToolbarItem(placement: .confirmationAction) {
                                Button{
                                    postStore.postMatePost()
                                    dismiss()
                                }label:{
                                    Text("완료")
                                }.disabled(postStore.selectedPets.isEmpty ||
                                           postStore.title.isEmpty ||
                                           postStore.content.isEmpty
                                )
                            }
                            ToolbarItem(placement: .cancellationAction) {
                                Button{
                                    progress = 0.5
                                }label:{
                                    Image(systemName: "chevron.left")
                                }
                            }
                        }
                    
                default:
                    Text("글작성 페이지에 문제가 있습니다.")
                    Button("나가기"){
                        dismiss()
                    }
                }
            }
            .animation(.easeIn, value: progress)
            .onAppear{
                postStore.addPostReset()
            }
        }
    }
}


#Preview {
    
    MatePostAddView()
        .environment(MatePostStore())
    
}
