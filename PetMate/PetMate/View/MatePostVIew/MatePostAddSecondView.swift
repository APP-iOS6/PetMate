//
//  MatePostAddSecondView.swift
//  PetMate
//
//  Created by 권희철 on 10/16/24.
//

import SwiftUI

struct MatePostAddSecondView: View {
    @Binding var content: String
    
    let contentFieldText =
        """
        게시글 내용을 작성해주세요
        내 아이의 행복한 시간을 위해서 메이트에게 전당하고 싶은 여러 사항들을 자세하게 적어주세요
        """
    var body: some View {
        VStack(spacing: 50){
            ZStack{
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(.gray)
                    .frame(width: 300, height: 150)
                    .opacity(0.3)
                HStack{
                    Text("내 펫 불러오기")
                    Image(systemName: "plus.circle")
                }.font(.largeTitle)
            }
            VStack(alignment: .leading){
                Text("내용")
                    .font(.title2)
                ScrollView(.vertical) {
                    TextField(contentFieldText, text: $content)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }.border(.black)
            }
            Spacer()
        }.padding()
    }
}

//#Preview {
//    MatePostAddSecondView()
//}
