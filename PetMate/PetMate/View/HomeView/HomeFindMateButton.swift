//
//  HomeFindButton.swift
//  PetMate
//
//  Created by 권희철 on 10/15/24.
//

import SwiftUI

struct HomeFindMateButton: View {
    var text: String = "ButtonText"
    var image: ImageResource? = nil
    var color: Color? = .primary
    var proxy: GeometryProxy
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 12)
                .frame(width: proxy.size.width * 0.45, height: proxy.size.width * 0.35)
                .foregroundStyle(color ?? .primary)
            if let image{
                Image(image)
                    .frame(width: proxy.size.width * 0.2, height: proxy.size.width * 0.2)
            }
            Text(text)
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    GeometryReader { proxy in
        HomeFindMateButton(proxy: proxy)
    }
}
