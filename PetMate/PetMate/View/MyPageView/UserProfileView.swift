import SwiftUI
import FirebaseFirestore

struct UserProfileView: View {
    @State private var profileImage: Image?
    @State private var isImagePickerPresented = false // 이미지 선택기
    @State private var isEditingIntroduction = false // 편집모드인지 여부
    @State private var introduction = "소개를 기다리고 있어요"
    
    private var viewModel: MyPageViewViewModel
    
    init(viewModel: MyPageViewViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .center, spacing: 16) {
                    ZStack(alignment: .bottom) {
                        // 유저 프로필 이미지
                        AsyncImage(url: URL(string: viewModel.myInfo?.image ?? "")) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color(.systemGray2), lineWidth: 1)
                                )
                        } placeholder: {
                            Image("")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                        }
                        
                        // 유저 프로필 편집 버튼
                        Button(action: {
                            isEditingIntroduction = true
                        }) {
                            Image(systemName: "gearshape")
                                .foregroundColor(.white)
                                .padding(3)
                                .background(Color(.systemGray2))
                                .clipShape(Circle())
                        }
                        .offset(x: 30, y: 0)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(viewModel.myInfo?.name ?? "사용자 이름")
                                .font(.system(size: 24))
                                .fontWeight(.bold)
                            Text("📍\(viewModel.myInfo?.location ?? "위치 정보 없음")")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        Text("메이트 횟수: \(viewModel.myInfo?.matchCount ?? 0) 번")
                            .font(.subheadline)
                            .foregroundColor(.black)
                    }
                }
                
                HStack {
                    Text("쩰리 점수 ")
                        .font(.system(size: 14))
                        .foregroundStyle(.gray)
                    Text("")
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .onAppear {
            Task {
                await viewModel.getMyInfodata()
            }
        }
//        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    UserProfileView(viewModel: MyPageViewViewModel())
}
