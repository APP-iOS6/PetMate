//
//  SearchAddressModal.swift
//  PetMate
//
//  Created by 김동경 on 10/19/24.
//

import SwiftUI
import Observation

struct SearchAddressModal: View {
    
    @Environment(\.dismiss) private var dismiss
    private var viewModel: SearchAddressViewModel = SearchAddressViewModel()
    
    let action: (String) -> Void
    
    init(action: @escaping (String) -> Void) {
        self.action = action
    }
    
    var body: some View {
        List {
            ForEach(viewModel.address, id:\.id) { district in
                DisclosureGroup(district.gu) {
                    ForEach(district.dong, id: \.self) { dong in
                        Button {
                            action("\(district.gu) \(dong)")
                            dismiss()
                        } label: {
                            Text(dong)
                                .foregroundStyle(.primary)
                        }
                    }
                }
            }
        }
    }
}


@Observable
class SearchAddressViewModel {
    var address: [Districts] = []
    
    
    init() {
        address = loadDistricts(from: "districts")
    }
    
    func loadDistricts(from fileName: String) -> [Districts] {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            fatalError("\(fileName).json 파일을 찾을 수 없습니다.")
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let districts = try decoder.decode([Districts].self, from: data)
            return districts
        } catch {
            print("데이터 로딩 오류: \(error)")
            return []
        }
    }
}


#Preview {
    SearchAddressModal() {_ in }
}
