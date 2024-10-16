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
    var pet: Pet
    var post: MatePost
    var writeUser: MateUser
    @State private var reviews: [Review] = dummyReviews  // 리뷰 목록
    @State private var newReviewContent: String = ""  // 새로운 리뷰 내용
    @State private var showChatView = false  // 채팅 뷰 표시 여부

    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                VStack(alignment: .leading) {
                    // 펫 이미지 섹션
                    petImageSection
                    
                    // 유저 정보 및 게시글 정보 섹션
                    userInfoSection
                    
                    Divider() // 구분선
                    
                    // 게시글 내용 및 날짜, 비용 섹션
                    postContentSection
                    
                    Divider() // 구분선
                    
                    // 펫 정보 섹션
                    petInfoSection
                    
                    Divider() // 구분선
                    
                    // 리뷰 목록 섹션
                    reviewsSection
                    
                    // 새로운 리뷰 작성 섹션
                    newReviewSection
                }
            }

            Spacer()

            // 채팅하기 버튼
            chatButton
        }
        .navigationTitle("Pet Details") // 네비게이션 타이틀 설정
    }

    // 펫 이미지 섹션
    private var petImageSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(pet.images, id: \.self) { imageUrl in
                    AsyncImage(url: URL(string: imageUrl)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 400, height: 400) // 이미지 크기 설정
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
            AsyncImage(url: URL(string: writeUser.image)) { image in
                image
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle()) // 원형 이미지
            } placeholder: {
                Circle()
                    .fill(Color.gray)
                    .frame(width: 50, height: 50) // 로딩 중 회색 원
            }

            VStack(alignment: .leading) {
                Text(writeUser.name)
                    .font(.headline)
                Text("위치: \(writeUser.location)")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                // 게시글 작성일 및 상대 시간
                Text("작성일: \(post.createdAt, formatter: dateFormatter) (\(relativeTime(from: post.createdAt)))")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            .padding(.leading, 10)
        }
        .padding(.horizontal)
        .padding(.bottom, 20)
    }

    // 게시글 내용 및 날짜, 비용 섹션
    private var postContentSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(post.content)
                .font(.body)
                .padding(.horizontal)
                .padding(.top, 10)
            
            Text("시작 날짜: \(post.startDate, formatter: dateFormatter)")
                .font(.body)
                .padding(.horizontal)
                .padding(.top, 5)
            
            Text("종료 날짜: \(post.endDate, formatter: dateFormatter)")
                .font(.body)
                .padding(.horizontal)
                .padding(.top, 5)
            
            Text("비용: \(post.cost)원")
                .font(.body)
                .padding(.horizontal)
                .padding(.top, 5)
        }
    }

    // 펫 정보 섹션
    private var petInfoSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("이름: \(pet.name)")
                .font(.title)
                .fontWeight(.bold)

            Text("품종: \(pet.breed)")
                .font(.subheadline)
                .foregroundColor(.gray)

            Text("나이: \(pet.age)살")
                .font(.subheadline)
                .foregroundColor(.gray)

            Text("특징: \(pet.tag.joined(separator: ", "))")
                .font(.subheadline)
                .foregroundColor(.blue)

            Text("성격: \(pet.description)")
                .padding(.vertical)
        }
        .padding(.horizontal)
    }

    // 리뷰 목록 섹션
    private var reviewsSection: some View {
        ForEach(reviews, id: \.id) { review in
            VStack(alignment: .leading) {
                Text("뼈점: \(String(repeating: "🦴", count: review.bome))") // 뼈점 표시
                Text(review.content)
                    .padding(.vertical, 5)
                    .padding(.horizontal)
                    .background(Color.gray.opacity(0.1)) // 배경색
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
        }
    }

    // 새로운 리뷰 작성 섹션
    private var newReviewSection: some View {
        VStack(alignment: .leading) {
            Text("댓글 남기기")
                .font(.headline)
                .padding(.bottom, 5)
            TextEditor(text: $newReviewContent)
                .frame(height: 100)
                .border(Color.brown, width: 1)
                .padding(.bottom, 10)
            Button(action: {
                addReview() // 리뷰 추가 버튼 클릭 시
            })  {
                Text("댓글 등록")
                    .frame(width: 100, height: 50)
                    .background(Color.brown)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
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

    // 리뷰 추가 함수
    func addReview() {
        let newReview = Review(
            id: UUID().uuidString,
            post: Firestore.firestore().document("matePosts/\(post.id!)"),
            bome: 5,
            content: newReviewContent,
            createdAt: Date()
        )
        reviews.append(newReview) // 리뷰 목록에 추가
        newReviewContent = "" // 입력 필드 초기화
    }

    // 상대 시간 계산 함수
    func relativeTime(from date: Date) -> String {
        let interval = Date().timeIntervalSince(date)
        let minutes = Int(interval / 60)
        return minutes > 1 ? "\(minutes)분 전" : "방금 전"
    }
}

// 더미 데이터: 리뷰 목록
let dummyReviews: [Review] = [
    Review(id: "김둘", post: Firestore.firestore().document("matePosts/post1"), bome: 4, content: "저희 개랑 친구하고 싶네요!", createdAt: Date()),
    Review(id: "김셋", post: Firestore.firestore().document("matePosts/post1"), bome: 5, content: "너무 귀엽네요", createdAt: Date())
]

// 날짜 포맷터
let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

// 프리뷰
struct PetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MatePostDetailView(
            pet: dummyPets[0],
            post: MatePost(
                writeUser: Firestore.firestore().document("users/user1"),
                pet: Firestore.firestore().document("pets/1"),
                startDate: Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 16, hour: 10, minute: 0))!,
                endDate: Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 16, hour: 22, minute: 0))!,
                cost: 1000,  // 비용
                content: "1시간 산책 같이 하실분.",
                location: "강남구",
                reservationUser: nil,
                postState: "Available",
                createdAt: Date().addingTimeInterval(-3600), // 1시간 전
                updatedAt: Date()
            ),
            writeUser: MateUser(
                id: "1",
                name: "김하나",
                image: "https://mblogthumb-phinf.pstatic.net/MjAyMzA3MTlfMzIg/MDAxNjg5NzcyMTQ0MzM0.m6BURqGnMKNRiuPNwuhYBqeg-9tLItHl81OVWUdmx5og.gFqEhucCUhnbdHANuZ-4W11Hl4-GM1_LtdSN7RhtQBUg.JPEG.ssw9014/KakaoTalk_20230703_062302394_01.jpg?type=w800",
                matchCount: 10,
                location: "강남구",
                createdAt: Date()
            )
        )
    }
}
