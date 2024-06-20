
import Foundation

// 학교 > 학년(~3) > 학급(~8) > 학생(~35)
// School > Level > Class > Student

// 이 프로토콜을 따르는 타입들은 이름 항목이 꼭 있어야 한다.
protocol NameExist {
    var name: String { get set }
}

protocol CampaignExist {
    var campaign: String { get set }
}

protocol Gender {
    var gender: String { get set }
}

protocol Height {
    var height: String { get set }
}

protocol Weight {
    var weight: String { get set }
}

struct School: NameExist, CampaignExist {
    var campaign: String
    var name: String
    var levels: [Level]
}

// 클래스는 메모리 처리를 이해하면 상수로 선언해도 된다
// let mySchool: School = School(name: "USC")

struct Level : Identifiable, CampaignExist {
    var campaign: String
    
    var id : UUID = UUID()
    var name: String
    var schoolClasses: [SchoolClass]
}

struct SchoolClass: Identifiable, CampaignExist {
    var campaign: String
    
    var id : UUID = UUID()
    var name: String
    var students: [Student]
}

struct Student : Identifiable, Gender, Height, Weight {
    var gender: String
    var height: String
    var weight: String
    
    var id : UUID = UUID()
    var name: String
}

// 1학년 반
let animationStudents: [Student] = [
    Student(gender: "남", height: "136cm", weight: "30kg", name: "짱구"),
    Student(gender: "남", height: "134cm", weight: "55kg",name: "도라에몽"),
    Student(gender: "남", height: "30cm", weight: "8kg",name: "흰둥이"),
    Student(gender: "여", height: "156cm", weight: "46kg",name: "큐티니"),
    Student(gender: "여", height: "165cm", weight: "55kg",name: "하니"),
    Student(gender: "여", height: "20cm", weight: "4kg",name: "하츄핑")
]

let animationClass: SchoolClass = SchoolClass(campaign: "애니메이션 최고!!", name: "애니메이션반", students: animationStudents)
// 스포츠 반 만들기
let sportClass: SchoolClass = SchoolClass(campaign: "우리가 스포츠 왕!!", name: "스포스반", students: [
    Student(gender: "남", height: "188cm", weight: "67kg",name: "박태환"),
    Student(gender: "남", height: "175cm", weight: "30kg",name: "이상혁"),
    Student(gender: "남", height: "187cm", weight: "75kg",name: "손흥민"),
    Student(gender: "여", height: "165cm", weight: "45kg",name: "김연아"),
    Student(gender: "여", height: "190cm", weight: "56kg",name: "김연경"),
    Student(gender: "남", height: "200cm", weight: "100kg",name: "강호동"),
    Student(gender: "여", height: "167cm", weight: "60kg",name: "장미란"),
])

let actClass: SchoolClass = SchoolClass(campaign: "탑클래스 배우!!", name: "배우반", students: [
    Student(gender: "남", height: "180cm", weight: "88kg",name: "송강호"),
    Student(gender: "남", height: "188cm", weight: "70kg",name: "김우빈"),
    Student(gender: "여", height: "166cm", weight: "55kg",name: "이영애"),
    Student(gender: "여", height: "170cm", weight: "45kg",name: "배수지"),
    Student(gender: "남", height: "160cm", weight: "30kg",name: "이경영"),
    Student(gender: "여", height: "166cm", weight: "6kg",name: "장나라"),
    Student(gender: "남", height: "177cm", weight: "77kg",name: "강하늘"),
])

// 2학년 반
let animal1: SchoolClass = SchoolClass(campaign: "풀만 먹고 살지요!!", name: "초식동물반", students: [
    Student(gender: "여", height: "300cm", weight: "800kg", name: "기린"),
    Student(gender: "남", height: "100cm", weight: "2kg", name: "토끼"),
    Student(gender: "남", height: "120cm", weight: "25kg", name: "염소"),
    Student(gender: "여", height: "200cm", weight: "500kg", name: "말"),
    Student(gender: "남", height: "210cm", weight: "700kg", name: "소"),
    Student(gender: "남", height: "150cm", weight: "1500kg", name: "하마"),
    Student(gender: "여", height: "110cm", weight: "45kg", name: "양")
])

let animal2: SchoolClass = SchoolClass(campaign: "고기 최고!!", name: "육식동물반", students: [
    Student(gender: "여", height: "90cm", weight: "50kg", name: "치타"),
    Student(gender: "남", height: "110cm", weight: "220kg", name: "호랑이"),
    Student(gender: "남", height: "120cm", weight: "190kg", name: "사자"),
    Student(gender: "남", height: "160cm", weight: "270kg", name: "곰"),
    Student(gender: "여", height: "95cm", weight: "60kg", name: "하이에나"),
    Student(gender: "남", height: "85cm", weight: "45kg", name: "늑대"),
    Student(gender: "여", height: "95cm", weight: "55kg", name: "표범"),
    Student(gender: "남", height: "110cm", weight: "100kg", name: "재규어"),
    Student(gender: "여", height: "40cm", weight: "6kg", name: "여우")
])

let animal3: SchoolClass = SchoolClass(campaign: "뻐끔... 뻐끔..", name: "생선반", students: [
    Student(gender: "남", height: "30cm", weight: "300g", name: "굴비"),
    Student(gender: "여", height: "25cm", weight: "250g", name: "조기"),
    Student(gender: "남", height: "35cm", weight: "400g", name: "고등어"),
    Student(gender: "여", height: "50cm", weight: "500g", name: "갈치"),
    Student(gender: "남", height: "20cm", weight: "200g", name: "전어"),
    Student(gender: "여", height: "40cm", weight: "450g", name: "우럭"),
    Student(gender: "남", height: "55cm", weight: "600g", name: "붕장어")
])

// 3학년 반
let numClass: SchoolClass = SchoolClass(campaign: "1234567", name: "숫자반", students: [
    Student(gender: "여", height: "178", weight: "14", name: "111"),
    Student(gender: "여", height: "178", weight: "14", name: "222"),
    Student(gender: "여", height: "178", weight: "14", name: "333"),
    Student(gender: "여", height: "178", weight: "14", name: "444"),
    Student(gender: "여", height: "178", weight: "14", name: "555"),
    Student(gender: "여", height: "178", weight: "14", name: "666"),
    Student(gender: "여", height: "178", weight: "14", name: "777"),
])

let korClass: SchoolClass = SchoolClass(campaign: "세종대왕님 가라사대..", name: "한글반", students: [
    Student(gender: "남", height: "14cm", weight: "1kg", name: "가나"),
    Student(gender: "여", height: "16cm", weight: "1.5kg", name: "다라"),
    Student(gender: "여", height: "12cm", weight: "0.8kg", name: "마바"),
    Student(gender: "남", height: "18cm", weight: "2kg", name: "사아"),
    Student(gender: "남", height: "19cm", weight: "2.1kg", name: "자카"),
    Student(gender: "여", height: "15cm", weight: "2.5kg", name: "타파"),
    Student(gender: "여", height: "13cm", weight: "1.3kg", name: "하!"),
])

let engClass: SchoolClass = SchoolClass(campaign: "can u speak eng?", name: "알파벳반", students: [
    Student(gender: "남", height: "13cm", weight: "1.2kg", name: "A"),
    Student(gender: "남", height: "14cm", weight: "1.3kg", name: "B"),
    Student(gender: "여", height: "11cm", weight: "0.9kg", name: "C"),
    Student(gender: "여", height: "9cm", weight: "0.6kg", name: "D"),
    Student(gender: "남", height: "10cm", weight: "1.0kg", name: "E"),
    Student(gender: "남", height: "11cm", weight: "1.1kg", name: "F"),
    Student(gender: "여", height: "18cm", weight: "1.9kg", name: "G"),
])

// 각 학년을 만듭시다
let levelOne: Level = Level(campaign: "1학년은 새내기에용", name: "1학년", schoolClasses: [animationClass, sportClass, actClass])

let levelTwo: Level = Level(campaign: "2학년 무시하지마세용", name: "2학년", schoolClasses: [animal1, animal2, animal3])

let levelThree: Level = Level(campaign: "우리 곧 수능본다;", name: "3학년", schoolClasses: [numClass, korClass, engClass])


// 학교를 만듭시다
let mySchool: School = School(campaign: "멋쟁이가 되어봐요!", name: "멋쟁이고등학교", levels: [levelOne, levelTwo, levelThree])
