//
//  SchoolView.swift
//  LionSchool
//
//  Created by Jongwook Park on 6/18/24.
//

import SwiftUI

struct SchoolView: View {
    var body: some View {
        // 학교의 학년들을 목록으로 보여주기
        List {
            Section("표어") {
                Text("\(mySchool.campaign)")
            }
            
            Section("학년") {
                ForEach(mySchool.levels) { level in
                    
                    // 화면을 이동할 때는 button 대신
                    // NavigationLink를 써봅시다
                    NavigationLink("\(level.name)") {
                        // NavigationLink를 누르면 나올
                        // SwiftUI 화면(View) 코드
                        SchoolClassView(level: level)
                    }
                }
            }
        }
        .navigationTitle("\(mySchool.name)")
        // .listStyle(.plain)
        
    }
}

#Preview {
    // 화면넘김 등이 있는 View를 프리뷰로 동작까지 확인하려면
    // 프리뷰에서 NavigationStack을 만들어줄 필요가 있다
    NavigationStack {
        SchoolView()
    }
}
