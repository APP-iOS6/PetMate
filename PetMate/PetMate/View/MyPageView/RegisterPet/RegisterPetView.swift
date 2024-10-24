//
//  RegisterPetView.swift
//  PetMate
//
//  Created by 김동경 on 10/20/24.
//

import SwiftUI
import PhotosUI

// 펫 추가 View
struct RegisterPetView: View {
    
    @Environment(\.dismiss) private var dismiss
    private var viewModel: RegisterPetViewModel = RegisterPetViewModel()
    let register: Bool
    var pet: Pet? = nil
    let action: () -> Void
    
    init(
        register: Bool = false,
        pet: Pet?,
        action: @escaping () -> Void
    ) {
        self.register = register
        self.pet = pet
        self.action = action
    }
    init(
        register: Bool = false,
        action: @escaping () -> Void
    ) {
        self.register = register
        self.pet = nil
        self.action = action
    }
    
    var body: some View {
        @Bindable var vm = viewModel
        ScrollView {
            VStack {
                //헤더 섹션
                headerSection()
                
                //펫 타입 선택 섹션
                HStack {
                    Spacer()
                    ForEach(PetType.allCases, id: \.self) { category in
                        PetTypeButton(type: category, selected: viewModel.myPet.category1 == category.rawValue) {
                            viewModel.myPet.category1 = category.rawValue
                        }
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity)
                
                //카테고리2 섹션
                HStack {
                    ForEach(SizeType.allCases, id: \.self) { size in
                        let selected = viewModel.myPet.category2 == size.rawValue
                        Button {
                            viewModel.myPet.category2 = size.rawValue
                        } label: {
                            Text(size.sizeString)
                                .font(.callout)
                                .foregroundStyle(selected ? .white : Color.accentColor)
                                .padding(.horizontal)
                                .padding(.vertical, 12)
                                .background(selected ? Color.accentColor : Color(uiColor: .systemGray6))
                                .clipShape(RoundedRectangle(cornerRadius: 30))
                        }
                    }
                    
                }
                .padding(.bottom, .screenHeight * 0.02)
                .frame(maxWidth: .infinity)
                
                //포토피커 자신의 애완견 사진 정하는 섹션
                PhotosPicker(
                    selection: $vm.selectedPhotos,
                    maxSelectionCount: 3,
                    selectionBehavior: .ordered,
                    matching: .images
                ) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 18) // 이미지가 보여질 곳에 동일한 RoundedRectangle 추가
                            .stroke(Color(.systemGray2), lineWidth: 1)
                            .frame(maxWidth: .infinity)
                            .frame(height: 200)
                        
                        if !viewModel.selectedPhotos.isEmpty ||
                            !viewModel.myPet.images.isEmpty{
                            TabView {
                                ForEach(viewModel.images, id: \.self) { image in
                                    ZStack(alignment: .topTrailing){
                                        Image(uiImage: image)
                                            .resizable()
                                            .aspectRatio(1, contentMode: .fill)
                                            .frame(height: 200)
                                            .clipShape(RoundedRectangle(cornerRadius: 18))
                                        
                                        
                                        Image(systemName: "xmark.circle.fill")
                                            .onTapGesture{
                                                viewModel.removeImageInArray(image:image)
                                            }
                                            .font(.title)
                                            .padding(5)
                                        
                                    }
                                }
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .tabViewStyle(PageTabViewStyle())
                        } else {
                            VStack {
                                Image(systemName: "photo.badge.plus.fill")
                                    .resizable()
                                    .aspectRatio(1, contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                
                                Text("이미지 추가")
                                    .foregroundStyle(.secondary)
                                //                                    .padding(.top, 10)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding([.leading, .trailing], 16)
                }
                .frame(maxWidth: .infinity, maxHeight: 250)
                .onChange(of: viewModel.selectedPhotos) { oldValue, newValue in
                    //뷰모델의 selectedPhotos값이 바뀔 때마다 convertDataToImage함수 호출
                    viewModel.convertPickerItemToImage()
                }
                .contentShape(Circle())
                PetInfoSection(viewModel: viewModel)
                
                if register {
                    Button {
                        action()
                    } label: {
                        Text("다음에 입력할래요!")
                            .foregroundStyle(Color(uiColor: .systemGray3))
                            .underline()
                    }
                }
            }
        }
        .navigationTitle("나의 펫 등록하기")
        .overlay {
            if viewModel.loadState == .loading {
                ProgressView()
                    .scaleEffect(1.5)
            }
        }
        .onChange(of: viewModel.loadState, { _, newValue in
            if newValue == .complete {
                action()
            }
        })
        .task{
            if let pet{
                await viewModel.getUpdatePet(pet: pet)
                print(viewModel.myPet)
            }
        }
        .padding()
        
    }
    
    private func headerSection() -> some View {
        HStack {
            if !register {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .bold()
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct PetTypeButton: View {
    
    let type: PetType
    let selected: Bool
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(type.petType)
                .font(.headline)
                .bold()
                .foregroundStyle(selected ? .white : Color.accentColor)
            Image(type.rawValue)
                .resizable()
                .aspectRatio(1, contentMode: .fill)
                .frame(width: 24, height: 18)
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(selected ? Color.accentColor : Color(uiColor: .systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 30))
    }
}

struct PetInfoSection: View {
    
    private var viewModel: RegisterPetViewModel
    @State private var ageString: String = ""
    @FocusState private var focusedField: Field?
    
    init(viewModel: RegisterPetViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        @Bindable var vm = viewModel
        
        VStack(alignment: .leading, spacing: 25) {
            
            VStack(alignment: .leading, spacing: 5) {
                Text("나의 펫 이름")
                    .bold()
                    .padding(.bottom, 2)
                TextField("이름을 입력해주세요.", text: $vm.myPet.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($focusedField, equals: .name)
                    .onSubmit {
                        focusedField = .age
                    }
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("나이")
                    .bold()
                    .padding(.bottom, 2)
                TextField("나이를 입력해주세요.(년)", text: $ageString)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .age)
                    .onChange(of: ageString) { oldValue, newValue in
                        viewModel.myPet.age = Int(newValue) ?? 0
                    }
                    .padding(.bottom)
                    .onSubmit {
                        focusedField = .breed
                    }
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("품종")
                    .bold()
                    .padding(.bottom, 2)
                TextField("예) 포메라니안", text: $vm.myPet.breed)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($focusedField, equals: .breed)
                    .padding(.bottom)
                    .onSubmit {
                        focusedField = .description
                    }
            }
            
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text("나의 펫을 소개해 주세요.")
                        .bold()
                    Spacer()
                    Text("\(viewModel.myPet.description.count)/300")
                        .foregroundStyle(.secondary)
                        .font(.caption)
                }
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color(uiColor: .systemGray4), lineWidth: 1)
                        .background(Color(uiColor: .systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    
                    TextEditor(text: $vm.myPet.description)
                        .focused($focusedField, equals: .description)
                        .padding(8)
                        .frame(height: 180)
                        .onChange(of: viewModel.myPet.description) { oldValue, newValue in
                            if newValue.count > 300 {
                                viewModel.myPet.description = String(newValue.prefix(300))
                            }
                        }
                }
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("완료") {
                            focusedField = nil
                        }
                    }
                }
                .overlay(alignment: .topLeading) {
                    if viewModel.myPet.description.isEmpty {
                        Text("300자 이내로 나의 반려동물을 소개해 보세요.")
                            .foregroundStyle(.secondary)
                            .font(.system(size: 16))
                            .foregroundStyle(Color(.systemGray2))
                            .offset(x: 9, y: 12)
                    }
                }
                .padding(.bottom)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("태그 선택하기")
                    .bold()
                    .padding(.bottom, 6)
                
                FlowLayout {
                    ForEach(petTags, id: \.self) { tag in
                        let selected = viewModel.myPet.tag.contains(where: { $0 == tag })
                        Button {
                            viewModel.tagTapped(tag)
                        } label: {
                            Text(tag)
                                .modifier(TagModifier(selected: selected))
                        }
                    }
                }
                .padding(.bottom, .screenHeight * 0.08)
            }
            
            Button {
                Task {
                    await viewModel.uploadMyPet()
                }
            } label: {
                Text("저장하기")
                    .modifier(ButtonModifier())
            }
            .disabled(viewModel.myPet.tag.isEmpty || viewModel.myPet.name.isEmpty || viewModel.myPet.breed.isEmpty || viewModel.images.isEmpty || viewModel.myPet.description.isEmpty)
            
        }
        .padding()
        .onChange(of: vm.myPet) { oldValue, newValue in
            ageString = String(newValue.age)
        }
    }
}

enum Field: Hashable {
    case name
    case age
    case breed
    case description
}


#Preview {
    RegisterPetView(register: true) {}
}
