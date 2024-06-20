//
//  ContentView.swift
//  LionSchool
//
//  Created by 최승호 on 6/17/24.
//
// 학교(학교캠페인, 학년리스트(학년캠페인, 학급리스트(학급 캠페인, 학생리스트)))
import SwiftUI

struct ContentView: View {
    var body: some View {
        // 화면이 전환되는 컨테이너 만들기
        NavigationStack {
            // 학교의 학년들을 목록으로 보여주기
            List {
                Section {
                    Text("\(mySchool.campaign)")
                }
                Section {
                    
                    ForEach(mySchool.levels) { level in
                        VStack(alignment: .leading){
                            NavigationLink("\(level.name)") {
                                List {
                                    Section{
                                        Text("\(level.campaign)")
                                    }
                                    Section{
                                        ForEach(level.schoolClasses) { schoolClass in  // << forEach
                                            VStack(alignment: .leading) {
                                                NavigationLink("\(schoolClass.name)"){
                                                    List{
                                                        Section {
                                                            Text("\(schoolClass.campaign)")

                                                        }
                                                        Section {
                                                            ForEach(schoolClass.students) { student in
                                                                VStack(alignment: .leading) {
                                                                    Text("\(student.name)").font(.title)
                                                                    Text("\(student.gender)")
                                                                    Text("\(student.height)")
                                                                    Text("\(student.weight)")
                                                                }
                                                            }
                                                        }
                                                    } .navigationTitle("\(schoolClass.name)")
                                                }
                                                .font(.title)
                                                Text("\(schoolClass.campaign)")
                                            }
                                        }
                                    }
                                }
                                
                                .navigationTitle("\(level.name)")
                            }
                            Text("\(level.campaign)")
                        }
                        
                    }
                }
            }
            .navigationTitle("\(mySchool.name)")
            // .listStyle(.plain)
        }
    }
}
#Preview {
    ContentView()
}
