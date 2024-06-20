//
//  SchoolClassView.swift
//  LionSchool
//
//  Created by Jongwook Park on 6/18/24.
//

import SwiftUI

struct SchoolClassView: View {
    // level 정보를 밖에서 정해주면
    // 적절하게 View를 그리는데 사용할 수 있다!
    let level: Level // = mySchool.levels.last!
    
    var body: some View {
        List(level.schoolClasses) { schoolClass in
            Section {
                VStack(alignment: .leading) {
                    Text("\(schoolClass.name)")
                        .font(.title)
                    Text("\(schoolClass.campaign)")
                }
                
                ForEach(schoolClass.students) { student in
                    Text("\(student.name)")
                }
            }
        }
        .navigationTitle("\(level.name)")
    }
}

#Preview {
    // 참고 키워드 : 의존성주입!
    NavigationStack {
        SchoolClassView(level: mySchool.levels.first!)
    }
}
