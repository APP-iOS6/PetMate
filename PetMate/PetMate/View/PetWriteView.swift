//
//  PetWriteView.swift
//  PetMate
//
//  Created by Mac on 10/15/24.
//

import SwiftUI
import FirebaseFirestore

// DistrictViewModel: 구 데이터를 불러오고 필터링하는 뷰 모델
class DistrictViewModel: ObservableObject {
    @Published var districts: [District] = []
    @Published var filteredDistricts: [District] = []

    init() {
        loadDistricts()
    }

    // JSON 파일에서 구 데이터를 로드
    func loadDistricts() {
        guard let url = Bundle.main.url(forResource: "districts", withExtension: "json") else {
            print("Failed to find districts.json")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode(DistrictsResponse.self, from: data)
            self.districts = jsonData.districts
            self.filteredDistricts = self.districts
            print("Loaded \(self.districts.count) districts")
        } catch {
            print("Error loading districts: \(error)")
        }
    }

    // 구 검색을 위한 필터링 기능
    func filterDistricts(with query: String) {
        if query.isEmpty {
            filteredDistricts = districts
        } else {
            filteredDistricts = districts.filter { $0.district.contains(query) }
        }
        print("Filtered districts: \(filteredDistricts.count)")
    }
}

// DistrictsResponse: JSON 응답 구조체
struct DistrictsResponse: Codable {
    let districts: [District]
}

// District: 구 모델 구조체
struct District: Codable, Identifiable {
    let district: String
    var id: String { district }
}

// PetWriteView: 메인 뷰, 사용자가 펫 관련 게시글을 작성하는 UI
struct PetWriteView: View {
    @StateObject private var districtViewModel = DistrictViewModel()
    @State private var location: String = ""
    @State private var showLocationSheet: Bool = false
    @State private var searchQuery: String = ""

    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    
    @State private var cost: Int = 0
    @State private var content: String = ""
    
    @State private var selectedPet: String? = nil
    @State private var pets: [Pet] = dummyPets
    
    @State private var currentPage: Int = 1
    @State private var progress: Double = 0.0
    
    var body: some View {
        NavigationStack {
            VStack {
                ProgressView(value: progress, total: 1.0)
                    .padding(.horizontal)
                    .offset(y: -40)
                
                // 첫 번째 페이지와 두 번째 페이지 분기
                if currentPage == 1 {
                    formPage1
                } else {
                    formPage2
                }
                
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if currentPage == 2 {
                        Button(action: {
                            currentPage = 1
                            progress = 0.0
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.blue)
                        }
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("산책시켜주세요!")
                        .font(.headline)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        if currentPage == 1 {
                            progress = 0.5
                            currentPage = 2
                        } else {
                            progress = 1.0
                            submitPost()
                        }
                    }) {
                        Text(currentPage == 1 ? "다음" : "올리기")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
    }
    
    // 첫 번째 입력 폼: 위치, 날짜, 가격
    var formPage1: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 구 검색
            Text("동 검색")
                .font(.headline)
                .padding(.horizontal)
            
            Button(action: { showLocationSheet.toggle() }) {
                HStack {
                    Text(location.isEmpty ? "사시는 구를 검색해주세요." : location)
                        .foregroundColor(location.isEmpty ? .gray : .black)
                    Spacer()
                    Image(systemName: "magnifyingglass")
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }
            .sheet(isPresented: $showLocationSheet) {
                // 위치 검색 모달
                VStack {
                    TextField("사시는 구를 입력해주세요.", text: $searchQuery)
                        .padding()
                        .onChange(of: searchQuery) { newValue in
                            districtViewModel.filterDistricts(with: newValue)
                        }
                    
                    List(districtViewModel.filteredDistricts) { district in
                        Button(action: {
                            location = district.district
                            showLocationSheet = false
                        }) {
                            Text(district.district)
                        }
                    }
                    .overlay(
                        Group {
                            if districtViewModel.filteredDistricts.isEmpty {
                                Text("No results found")
                            }
                        }
                    )
                }
                .padding()
            }
            .padding()
            
            // 날짜 설정
            Text("날짜 설정")
                .font(.headline)
                .padding(.horizontal)
            
            DatePicker("시작 날짜", selection: $startDate, displayedComponents: [.date, .hourAndMinute])
                .padding(.horizontal)
            
            DatePicker("종료 날짜", selection: $endDate, displayedComponents: [.date, .hourAndMinute])
                .padding(.horizontal)
            
            // 가격 입력
            Text("가격")
                .font(.headline)
                .padding()
                .padding(.bottom, -20)
            
            TextField("가격을 입력해주세요", value: $cost, formatter: NumberFormatter())
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
        }
    }
    
    // 두 번째 입력 폼: 펫 선택, 내용 입력
    var formPage2: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 펫 선택
            Text("Select a Pet")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(pets, id: \.id) { pet in
                        VStack {
                            ForEach(pet.images, id: \.self) { imageUrl in
                                AsyncImage(url: URL(string: imageUrl)) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 150, height: 150)
                                } placeholder: {
                                    ProgressView()
                                }
                                .onTapGesture {
                                    selectedPet = pet.id
                                }
                                .overlay(
                                    selectedPet == pet.id ?
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.blue)
                                        .offset(x: 40, y: -40)
                                    : nil
                                )
                            }
                            
                            Text(pet.name)
                                .font(.caption)
                                .padding(.top, 4)
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .frame(height: 150)
            
            // 내용 입력
            Text("내용")
                .font(.headline)
                .padding(.horizontal)
            TextEditor(text: $content)
                .frame(height: 100)
                .border(Color.gray, width: 1)
                .padding()
        }
    }
    
    // 게시글 제출 함수
    func submitPost() {
        let db = Firestore.firestore()
        guard let selectedPetId = selectedPet else {
            print("No pet selected")
            return
        }
        
        let matePost = MatePost(
            writeUser: db.collection("users").document("userId"),
            pet: db.collection("pets").document(selectedPetId),
            startDate: startDate,
            endDate: endDate,
            cost: cost,
            content: content,
            location: location,
            reservationUser: nil,
            postState: "Available",
            createdAt: Date(),
            updatedAt: Date()
        )
        
        do {
            let _ = try db.collection("matePosts").addDocument(from: matePost)
            print("Post submitted successfully")
        } catch {
            print("Error submitting post: \(error)")
        }
    }
}

// 더미 데이터: 펫 리스트
let dummyPets: [Pet] = [
    Pet(id: "1", name: "아지", description: "활발한 성격", age: 3, tag: ["산책 좋아함"], breed: "모르겠음", images: [ "https://i.pinimg.com/236x/f8/e9/b5/f8e9b56372c19576ff1936f91973d088.jpg"], createdAt: Date(), updatedAt: Date()),
    Pet(id: "2", name: "양이", description: "착함", age: 2, tag: ["조용함"], breed: "모르겠음", images: ["https://mblogthumb-phinf.pstatic.net/MjAyMTAyMDRfNjIg/MDAxNjEyNDA4OTk5NDQ4.6UGs399-0EXjIUwwWsYg7o66lDb-MPOVQ-zNDy1Wnnkg.m-WZz0IKKnc5OO2mjY5dOD-0VsfpXg7WVGgds6fKwnIg.JPEG.sunny_side_up12/1612312679152－2.jpg?type=w800"], createdAt: Date(), updatedAt: Date())
]

#Preview {
    PetWriteView()
}
