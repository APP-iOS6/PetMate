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
    var nearPets: [Pet] = []
    var isChatRoomExists = false
    var petOwner: MateUser? = nil
    var selectedChatUser: MateUser? = nil
    var shouldNavigateToChat = false
    
    
    // 유저 정보를 땡겨와야 함 내 UID 정보
    
    init() { // 맨 처음으로 불리는 코드
        Task {
            await getMyInfodata()
        }
    }
    
    func getMyInfodata() async {
        // 자동으로 값이 저장 이 값이 없으면 로그인 상태가 아니라는 거임 nil 로그인도 안 했는데 어케들어옴? 쫓아내야함 step1
        guard let myUid = Auth.auth().currentUser?.uid else {
            print("로그인 상태가 아님") // 1번
            return
        }
        DispatchQueue.main.async {
            self.phase = .loading // 서버랑 통신할게 > 로딩
        }
        do { // decoder가 사기임
            
            let myuser = try await db.collection("User").document(myUid).getDocument(as: MateUser.self)
            DispatchQueue.main.async {
                self.myInfo = myuser
                self.phase = .success
            }
            await getNearPets(myuser.location)
            //            print("마이인포 잘 받아옴 (String(describing: myInfo))") // 2번 await 쓰는 게 코드 가독성에 좋다
        } catch {
            DispatchQueue.main.async {
                self.phase = .failure
            }
            print("유저 정보 불러오다가 오류남")
            print(error.localizedDescription)
        }
    }
    
    func updateLocationData(location: String) async{
        guard let currentUser = Auth.auth().currentUser?.uid else{
            print("로그인 상태가 아님")
            return
        }
        do{
            try await db.collection("User").document(currentUser).setData([
                "location": location
            ])
            myInfo?.location = location
            await getNearPets(location)
        }catch{
            print("레퍼런스 오류: \(error)")
        }
    }
    
    // @MainActor 화면에 보이는 데이터를 직접적으로 간섭 안정적으로 운영하는 데 있어선 괜찮은데 화면이 버벅거림에 원인이 될 수 있음
    // > 정석은 디스패치큐??
    
    func getNearPets(_ location: String) async { // async 메인에서 집나온친구 메인이 혼자하면 버거우니
        guard let userUid = Auth.auth().currentUser?.uid else {
            print("getNearPets오류: 로그인 상태 아님")
            return
        }
        print(location)
        do { // 이 배열도 우리가 아는 형태로 바꿔줘야 함
            let documents = try await self.db.collection("Pet").whereField("location", isEqualTo: location).getDocuments().documents
            let petData = try documents.compactMap { // map = 배열을 한 바퀴 싹 돌면서 어떤 작업 해줄까?
                try $0.data(as: Pet.self) // map은 변환 하다가 오류가 생겼네? 그럼 nil을 집어넣음. // compactmap은 nil을 다 뺌!
            }
            DispatchQueue.main.async { // 이걸 쓰는 이유는 난 메인이 아니기 때문에 얘한테 시킴
                self.nearPets = petData.filter { $0.ownerUid != userUid }
            }
        } catch {
            print("내주댕찾 찾는거 실패함")
            print(error.localizedDescription)
        }
    }
    
    // 펫 주인 정보
    func fetchPetOwner(_ ownerUid: String) async {
        do {
            let document = try await db.collection("User").document(ownerUid).getDocument()
            if let owner = try? document.data(as: MateUser.self) {
                DispatchQueue.main.async {
                    self.petOwner = owner
                }
            }
        } catch {
            print("펫 주인 정보를 가져오는데 실패했습니다: \(error.localizedDescription)")
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
