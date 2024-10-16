//
//  PetDetailView.swift
//  PetMate
//
//  Created by Mac on 10/15/24.
//

import SwiftUI
import FirebaseFirestore

// PetDetailView: 특정 펫의 상세 정보를 보여주는 뷰
struct MatePostDetailView: View {
    
    @Binding var postStore: MatePostStore
    @State private var showChatView = false  // 채팅 뷰 표시 여부
    
    var body: some View {
        VStack(alignment: .leading) {
            if postStore.writer != nil{
                ScrollView {
                    VStack(alignment: .leading) {
                        // 펫 이미지 섹션
                        petImageSection
                        // 펫 정보 섹션
                        petInfoSection
                        
                        // 게시글 내용 및 날짜, 비용 섹션
                        postContentSection
                        
                        // 유저 정보 및 게시글 정보 섹션
                        userInfoSection

                    }
                }
                Spacer()
                
                // 채팅하기 버튼
                chatButton
            }
        }
        .task{
            if let post = postStore.selectedPost {
                postStore.writer = await postStore.getUser(post.writeUser)
                postStore.pet = post.firstPet
            }
        }
        .navigationTitle(postStore.selectedPost?.title ?? "산책 해줘") // 네비게이션 타이틀 설정
    }
    
    // 펫 이미지 섹션
    private var petImageSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(postStore.selectedPost?.firstPet.images ?? [], id: \.self) { imageUrl in
                    AsyncImage(url: URL(string: imageUrl)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 400, height: 400) // 이미지 크기 설정
                            .clipShape(.rect(cornerSize: CGSize(width: 12, height: 12)))
                    } placeholder: {
                        ProgressView() // 로딩 중 표시
                    }
                }
            }
            .padding()
        }
    }
    
    // 유저 정보 및 게시글 정보 섹션
    private var userInfoSection: some View {
        HStack(alignment: .top) {
            AsyncImage(url: URL(string: postStore.writer!.image)) { image in
                image
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle()) // 원형 이미지
            } placeholder: {
                Circle()
                    .fill(Color.gray)
                    .frame(width: 100, height: 100) // 로딩 중 회색 원
            }
            Spacer()
            VStack(alignment: .leading){
                HStack{
                    Text(postStore.writer!.name)
                        .font(.title)
                    Text("위치: \(postStore.writer!.location)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.leading, 10)
                Text("메이트 횟수: \(postStore.writer!.matchCount)번")
                Text("소개를 기다리고 있어요")
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(lineWidth: 1)
        }
        
        .padding(.horizontal)
        .padding(.bottom, 10)
    }
    
    // 게시글 내용 및 날짜, 비용 섹션
    private var postContentSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(postStore.selectedPost!.title)
                .font(.title2)
                .padding(.horizontal)
                
            Text(postStore.selectedPost!.content)
                .padding(.horizontal)
            
            Text("기간 \(postStore.selectedPost!.startDate, formatter: dateFormatter) ~ \(postStore.selectedPost!.endDate, formatter: dateFormatter)")
                .font(.title3)
                .padding(.horizontal)
                .padding(.top, 5)
            
            Text("메이트 비용 \(postStore.selectedPost!.cost)원")
                .font(.title3)
                .padding(.horizontal)
                .padding(.top, 5)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(lineWidth: 1)
        }
        .padding(.horizontal)
    }
    
    // 펫 정보 섹션
    private var petInfoSection: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading){
                HStack{
                    Text(postStore.pet!.name)
                        .font(.title)
                        .fontWeight(.bold)
                    Text("\(postStore.pet!.age)살")
                        .font(.caption)
                    Spacer()
                }
                
                Text(postStore.pet!.breed)
                    .font(.caption)
                FlowLayout {
                    ForEach(postStore.pet?.tag ?? [], id: \.self) { tag in
                        TagToggle(tag: tag, isSelected: true){}
                    }
                }
            }
            .padding()
            ZStack{
                Circle()
                    .frame(width: 100, height: 100)
                    .foregroundStyle(.gray)
                Text("산책")
            }
        }
        .background(.gray, in: .rect(cornerSize: CGSize(width: 12, height: 12)))
        .padding(.horizontal)
    }
    
    // 채팅하기 버튼
    private var chatButton: some View {
        Button(action: {
            showChatView.toggle() // 채팅 뷰 표시 여부 토글
        }) {
            Text("채팅하기")
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.brown)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        .padding()
        .sheet(isPresented: $showChatView) {
            EmptyView() // 채팅 뷰 추가
        }
    }
    
    // 상대 시간 계산 함수
    func relativeTime(from date: Date) -> String {
        let interval = Date().timeIntervalSince(date)
        let minutes = Int(interval / 60)
        return minutes > 1 ? "\(minutes)분 전" : "방금 전"
    }
}

// 날짜 포맷터
let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()
