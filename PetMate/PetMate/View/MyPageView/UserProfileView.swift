//
//  MyProfileView.swift
//  PetMate
//
//  Created by 이다영 on 10/14/24.
//

import SwiftUI
import FirebaseFirestore

struct ProfileView: View {
    @State private var profileImage: Image?
    @State private var isImagePickerPresented = false // 이미지 선택기
    @State private var introduction = "소개를 기다리고 있어요"
    @State private var isEditingIntroduction = false // 편집모드인지 여부
    
    @State private var user: MateUser = MateUser(name: "김정원", image: "", matchCount: 5, location: "구월3동", createdAt: Date())
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .center, spacing: 16) {
                ZStack(alignment: .bottom) {
                    (profileImage ?? Image("placeholder"))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .onTapGesture {
                            isImagePickerPresented = true
                        } // 이미지 탭하면 편집기능 true
                    
                    Text("편집")
                        .font(.caption)
                        .padding(4)
                        .background(Color.black.opacity(0.7))
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        .padding(.bottom, 4)
                }
                .sheet(isPresented: $isImagePickerPresented) {
                    ImagePicker(image: $profileImage)
                }
                
                // 이름, 지역, 매칭 횟수, 소개글
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(user.name)
                            .font(.system(size: 24))
                            .fontWeight(.bold)
                        Text("📍\(user.location)")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    Text("메이트 횟수: \(user.matchCount)번")
                        .font(.subheadline)
                        .foregroundColor(.black)
                    
                    // 소개글 편집
                    if isEditingIntroduction {
                        TextField("소개", text: $introduction, onCommit: {
                            isEditingIntroduction = false
                        })
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    } else {
                        Text(introduction)
                            .foregroundColor(.gray)
                            .onTapGesture {
                                isEditingIntroduction = true
                            }
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// 이미지 선택기
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: Image?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = Image(uiImage: uiImage)
            }
            picker.dismiss(animated: true)
        }
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
