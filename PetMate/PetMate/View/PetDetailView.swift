//
//  PetDetailView.swift
//  PetMate
//
//  Created by Mac on 10/15/24.
//

//
//  PetDetailView.swift
//  PetMate
//
//  Created by Mac on 10/15/24.
//
import SwiftUI
import FirebaseFirestore

struct PetDetailView: View {
    var pet: Pet
    var post: MatePost
    var writeUser: MateUser
    @State private var reviews: [Review] = dummyReviews
    @State private var newReviewContent: String = ""
    @State private var showChatView = false

    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                VStack(alignment: .leading) {
                    // Pet Images
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(pet.images, id: \.self) { imageUrl in
                                AsyncImage(url: URL(string: imageUrl)) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 400, height: 400)
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                        }
                        .padding()
                    }

                    // User Details and Post Info
                    HStack(alignment: .top) {
                        AsyncImage(url: URL(string: writeUser.image)) { image in
                            image
                                .resizable()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                        } placeholder: {
                            Circle()
                                .fill(Color.gray)
                                .frame(width: 50, height: 50)
                        }

                        VStack(alignment: .leading) {
                            Text(writeUser.name)
                                .font(.headline)
                            Text("위치: \(writeUser.location)")
                                .font(.subheadline)
                                .foregroundColor(.gray)

                            // Post created time and relative time
                            Text("작성일: \(post.createdAt, formatter: dateFormatter) (\(relativeTime(from: post.createdAt)))")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                        .padding(.leading, 10)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)

                    Divider()

                    // Post Content with Start/End Date and Cost
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
                    Divider()

                    // Pet Details
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

                    Divider()

                    // Reviews Section

                    ForEach(reviews, id: \.id) { review in
                        VStack(alignment: .leading) {
                            Text("뼈점: \(String(repeating: "🦴", count: review.bome))")
                            Text(review.content)
                                .padding(.vertical, 5)
                                .padding(.horizontal)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                    }

                    // Add New Review
                    VStack(alignment: .leading) {
                        Text("댓글 남기기")
                            .font(.headline)
                            .padding(.bottom, 5)
                        TextEditor(text: $newReviewContent)
                            .frame(height: 100)
                            .border(Color.brown, width: 1)
                            .padding(.bottom, 10)
                        Button(action: {
                            addReview()
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
            }

            Spacer()

            // Start Chat Button
            Button(action: {
                showChatView.toggle()
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
                EmptyView() // Add chat view here
            }
        }
        .navigationTitle("Pet Details")
    }

    // Function to add a review (dummy)
    func addReview() {
        let newReview = Review(id: UUID().uuidString, post: Firestore.firestore().document("matePosts/\(post.id!)"), bome: 5, content: newReviewContent, createdAt: Date())
        reviews.append(newReview)
        newReviewContent = ""
    }

    // Helper to format relative time
    func relativeTime(from date: Date) -> String {
        let interval = Date().timeIntervalSince(date)
        let minutes = Int(interval / 60)
        return minutes > 1 ? "\(minutes)분 전" : "방금 전"
    }
}

// Dummy Reviews
let dummyReviews: [Review] = [
    Review(id: "김둘", post: Firestore.firestore().document("matePosts/post1"), bome: 4, content: "저희 개랑 친구하고 싶네요!", createdAt: Date()),
    Review(id: "김셋", post: Firestore.firestore().document("matePosts/post1"), bome: 5, content: "너무 귀엽네요", createdAt: Date())
]

// Dummy Date Formatter
let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

// Preview
struct PetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PetDetailView(
            pet: dummyPets[0],
            post: MatePost(
                writeUser: Firestore.firestore().document("users/user1"),
                pet: Firestore.firestore().document("pets/1"),
                startDate:Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 16, hour: 10, minute: 0))!,
                endDate: Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 16, hour: 22, minute: 0))!, // End date
                cost: 1000,  // Cost of 10,000 원
                content: "1시간 산책 같이 하실분.",
                location: "강남구",
                reservationUser: nil,
                postState: "Available",
                createdAt: Date().addingTimeInterval(-3600), // 1 hour ago
                updatedAt: Date()
            ),
            writeUser: MateUser(id: "1", name: "김하나", image: "https://mblogthumb-phinf.pstatic.net/MjAyMzA3MTlfMzIg/MDAxNjg5NzcyMTQ0MzM0.m6BURqGnMKNRiuPNwuhYBqeg-9tLItHl81OVWUdmx5og.gFqEhucCUhnbdHANuZ-4W11Hl4-GM1_LtdSN7RhtQBUg.JPEG.ssw9014/KakaoTalk_20230703_062302394_01.jpg?type=w800", matchCount: 10, location: "강남구", createdAt: Date())
        )
    }
}
