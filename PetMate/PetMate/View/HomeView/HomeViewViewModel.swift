//
//  HomeViewViewModel.swift
//  PetMate
//
//  Created by Hyeonjeong Sim on 10/21/24.
//

import Foundation
import FirebaseAuth
import Observation
import FirebaseFirestore

@Observable
class HomeViewViewModel {
    
    private let db = Firestore.firestore()
    var myInfo: MateUser?
    var phase: Phase = .loading
    
    // 유저 정보를 땡겨와야 함 내 UID 정보
    
    init() { // 맨 처음으로 불리는 코드
        Task {
            await getMyInfodata()
        }
    }
    
    @MainActor
    func getMyInfodata() async {
        // 자동으로 값이 저장 이 값이 없으면 로그인 상태가 아니라는 거임 nil 로그인도 안 했는데 어케들어옴? 쫓아내야함 step1
        guard let myUid = Auth.auth().currentUser?.uid else {
            print("로그인 상태가 아님") // 1번
            return
        }
        phase = .loading // 서버랑 통신할게 > 로딩
        do { // decoder가 사기임
            myInfo = try await db.collection("User").document(myUid).getDocument(as: MateUser.self)
            phase = .success
            //            print("마이인포 잘 받아옴 \(String(describing: myInfo))") // 2번 await 쓰는 게 코드 가독성에 좋다
        } catch {
            phase = .failure
            print("유저 정보 불러오다가 오류남")
            print(error.localizedDescription)
        }
    }
}

enum Phase {
    case loading
    case success
    case failure
}

// 프리뷰확인용
extension HomeViewViewModel {
    convenience init(initialPhase: Phase = .success) {
        self.init()
        self.phase = initialPhase
        self.myInfo = MateUser(
            id: "preview",
            name: "프리뷰 사용자",
            image: "default_image_url",
            matchCount: 0,
            location: "강남구 개포1동",
            createdAt: Date()
        )
    }
}
