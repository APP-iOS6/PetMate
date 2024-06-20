//
//  Data.swift
//  LionSchool
//
//  Created by Jongwook Park on 6/17/24.
//

import Foundation

// 학교 > 학년(~3) > 학급(~8) > 학생(~35)
// School > Level > Class > Student

// 애니메이션 반 만들기


// 학교를 만듭시다

let mySchool: School = School(name: "멋쟁이고등학교", campaign: "멋쟁이가 됩시다!", levels: [
    Level(name: "1학년", schoolClasses: [
        SchoolClass(name: "래퍼반", campaign: "내용 입력(래퍼)", students: [
            Student(name: "비와이"),
            Student(name: "씨잼"),
            Student(name: "타이거JK"),
            Student(name: "이영지"),
            Student(name: "키드밀리"),
            Student(name: "재키와이"),
        ]),
        SchoolClass(name: "스포츠반", campaign: "올림픽 금메달을 향하여!", students: [
            Student(name: "박태환"),
            Student(name: "이상혁"),
            Student(name: "손흥민"),
            Student(name: "김연아"),
            Student(name: "김연경"),
            Student(name: "강호동"),
            Student(name: "장미란"),
            Student(name: "메시"),
            Student(name: "음바페"),
            Student(name: "호날두"),
        ]),
        SchoolClass(name: "배우반", campaign: "오스카 상을 받자!", students: [
            Student(name: "변우석"),
            Student(name: "손석구"),
            Student(name: "이채민"),
            Student(name: "김지원"),
            Student(name: "공효진"),
            Student(name: "김지미"),
        ]),
    ]),
    Level(name: "2학년", schoolClasses: [
        SchoolClass(name: "육식동물반", campaign: "고기 최고!!", students: [
            Student(name: "치타"),
            Student(name: "호랑이"),
            Student(name: "사자"),
            Student(name: "곰"),
            Student(name: "하이에나"),
            Student(name: "늑대"),
            Student(name: "표범"),
            Student(name: "재규어"),
            Student(name: "여우"),
        ]),
        SchoolClass(name: "애니메이션반", campaign: "애니메이션 최고!!", students: [
            Student(name: "짱구"),
            Student(name: "도라에몽"),
            Student(name: "흰둥이"),
            Student(name: "큐티니"),
            Student(name: "하니"),
            Student(name: "하츄핑"),
        ]),
        SchoolClass(name: "다국적반", campaign: "내용 입력(다국적)", students: [
            Student(name: "탕웨이"),
            Student(name: "아이묭"),
            Student(name: "박보검"),
            Student(name: "톰크루즈"),
            Student(name: "엠마왓슨"),
        ]),
    ]),
    Level(name: "3학년", schoolClasses: [
        SchoolClass(name: "과학반", campaign: "그래도 지구는 돈다!", students: [
            Student(name: "아리스토텔레스"),
            Student(name: "에디슨"),
            Student(name: "갈릴레오갈릴레이"),
            Student(name: "마리퀴리"),
            Student(name: "찰스다윈"),
        ]),
        SchoolClass(name: "미술반", campaign: "가자 소더비로!", students: [
            Student(name: "반고흐"),
            Student(name: "다빈치"),
            Student(name: "뭉크"),
            Student(name: "피카소"),
            Student(name: "미켈란젤로"),
        ])
    ]),
])









