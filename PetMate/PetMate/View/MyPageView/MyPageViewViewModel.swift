//
//  PetProfileViewModel.swift
//  PetMate
//
//  Created by 이다영 on 10/20/24.
//

import Foundation
import FirebaseAuth
import Observation
import FirebaseFirestore

@Observable
class MyPageViewViewModel {
    private var db = Firestore.firestore()
    var myInfo: MateUser?
    var phase: Phase = .loading
    var nearPets: [Pet] = []
    var petInfo: Pet?
    
    init() {
        Task {
            await getMyInfodata()
        }
    }
    
    func getMyInfodata() async {
            guard let myUid = Auth.auth().currentUser?.uid else {
                print("로그인 상태가 아님")
                return
            }
            DispatchQueue.main.async {
                self.phase = .loading
            }
            do {
                let myuser = try await db.collection("User").document(myUid).getDocument(as: MateUser.self)
                DispatchQueue.main.async {
                    self.myInfo = myuser
                    self.phase = .success
                }
                await getNearPets(myuser.location)
            } catch {
                DispatchQueue.main.async {
                    self.phase = .failure
                }
                print("유저 정보 불러오다가 오류남")
                print(error.localizedDescription)
            }
        }
    
    // 화면에 보이는 데이터를 업데이트에 직접적인 관여이기 때문에
    // 많이 쓰면 버벅거림 심해짐
    // @MainActor
    func getNearPets(_ location: String) async {
        print(location)
        
        do {
            let documents = try await self.db.collection("Pet").whereField("location", isEqualTo: location).getDocuments().documents
            // 조건에 부합한 것들을 다 가져온다는 것
            // map : 배열 다 돌면서 어떤 작업을 할지
            // compactMap : 이상한거 들어오면 앱이 죽, map은 실패하면 nil값 집어넣음 compactMap은 nil을 자동으로 제외하고 처리해줌
            let petData = try documents.compactMap {
                try $0.data(as: Pet.self) // 배열의 한 요소를 Pet형태로 바꿔줘
            }
            DispatchQueue.main.async {
                self.nearPets = petData
                // async는 main에서 나와서 따로 진행
                // DispatchQueue 이거 쓰면 main에서 해줌
            }
        } catch {
            print("내주댕찾 실패함")
            print(error.localizedDescription)
        }
    }
    
    
}
