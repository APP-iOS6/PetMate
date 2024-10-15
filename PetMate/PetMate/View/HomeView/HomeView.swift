//
//  HomeView.swift
//  PetMate
//
//  Created by 권희철 on 10/15/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        GeometryReader{ proxy in
            VStack(alignment: .leading){
                HStack{
                    Image(systemName: "mappin")
                    Text("영동구 매탄동")
                }
                VStack{
                    AsyncImage(url: URL(string:"https://www.dutch.com/cdn/shop/articles/shutterstock_1898629669.jpg?v=1697090094")){ image in
                        image.image?.resizable()
                            .scaledToFill()
                    }
                }
                .frame(maxWidth: .infinity)
                
                HStack{
                    Button{}label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 12)
                            .frame(width: proxy.size.width * 0.45, height: proxy.size.width * 0.35)
                            Text("돌봐주세요!")
                                .foregroundStyle(.white)
                        }
                    }
                    Spacer()
                    Button{}label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 12)
                            .frame(width: proxy.size.width * 0.45, height: proxy.size.width * 0.35)
                            Text("산책해주세요!")
                                .foregroundStyle(.white)
                        }
                    }
                }
                //.padding(.leading, 20)
                Text("후기")
                ScrollView(.horizontal) {
                    LazyHStack{
                        ForEach(1...10, id: \.self){ _ in
                            VStack{
                                Text("애옹")
                            }
                            .frame(width: 300, height: 150)
                            .border(.black, width: 1)
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .frame(minHeight: 150)
                
                Text("주댕찾")
                ScrollView(.horizontal) {
                    LazyHStack{
                        ForEach(1...10, id: \.self){ _ in
                            VStack{
                                Text("애옹")
                            }
                            .frame(width: 140, height: 80)
                            .border(.black, width: 1)
                        }
                    }
                }
            }.padding()
        }
    }
}
#Preview {
    HomeView()
}
