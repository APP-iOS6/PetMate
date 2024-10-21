//
//  RegisterPetView.swift
//  PetMate
//
//  Created by 김동경 on 10/20/24.
//

import SwiftUI
import PhotosUI

struct RegisterPetView: View {
    
    @Environment(\.dismiss) private var dismiss
    private var viewModel: RegisterPetViewModel = RegisterPetViewModel()
    let register: Bool
    let action: () -> Void
    
    init(
        register: Bool = false,
        action: @escaping () -> Void
    ) {
        self.register = register
        self.action = action
    }
    
    var body: some View {
        @Bindable var vm = viewModel
        ScrollView {
            VStack {
                //헤더 섹션
                headerSection()
                    .padding(.bottom, .screenHeight * 0.05)
                
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
                .padding(.bottom, .screenHeight * 0.02)
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
                    if !viewModel.selectedPhotos.isEmpty {
                        TabView {
                            ForEach(viewModel.images, id: \.self) { image in
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(1, contentMode: .fill)
                                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                            }
                        }
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .tabViewStyle(PageTabViewStyle())
                    } else {
                        Image(.sysmbol)
                            .resizable()
                            .aspectRatio(1, contentMode: .fill)
                            .frame(width: 100, height: 100)
                    }
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 250)
                .onChange(of: viewModel.selectedPhotos) { oldValue, newValue in
                    //뷰모델의 selectedPhotos값이 바뀔 때마다 convertDataToImage함수 호출
                    viewModel.convertPickerItemToImage()
                }
                
                if viewModel.selectedPhotos.isEmpty {
                    Text("나의 반려동물 이미지를 추가해 보세요.")
                        .foregroundStyle(.secondary)
                        .padding(.vertical)
                        .animation(.smooth, value: viewModel.selectedPhotos)
                }
                
                Divider()
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                
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
        .padding()
    }
    
    private func headerSection() -> some View {
        HStack {
            Text("나의 펫 등록하기")
                .bold()
                .font(.title2)
        }
        .frame(maxWidth: .infinity)
        .overlay(alignment: .leading) {
            if !register {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .bold()
                }
            }
        }
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
                .frame(width: 24, height: 24)
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
        
        VStack(alignment: .leading) {
            Text("나의 반려 동물 이름")
                .bold()
                .padding(.bottom, 2)
            TextField("예) 가디", text: $vm.myPet.name)
                .underline()
                .focused($focusedField, equals: .name)
                .padding(.bottom)
                .onSubmit {
                    focusedField = .age
                }
            
            Text("나이")
                .bold()
                .padding(.bottom, 2)
            TextField("예) 5살", text: $ageString)
                .underline()
                .keyboardType(.numberPad)
                .focused($focusedField, equals: .age)
                .onChange(of: ageString) { oldValue, newValue in
                    viewModel.myPet.age = Int(newValue) ?? 0
                }
                .padding(.bottom)
                .onSubmit {
                    focusedField = .breed
                }
            
            Text("품종")
                .bold()
                .padding(.bottom, 2)
            TextField("예) 포메라니안", text: $vm.myPet.breed)
                .underline()
                .focused($focusedField, equals: .breed)
                .padding(.bottom)
                .onSubmit {
                    focusedField = .description
                }
            
            HStack {
                Text("나의 반려 동물을 소개해 주세요.")
                    .bold()
                Spacer()
                Text("\(viewModel.myPet.description.count)/300")
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }
            TextEditor(text: $vm.myPet.description)
                .frame(height: 130)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .focused($focusedField, equals: .description)
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(uiColor: .systemGray4), lineWidth: 1)
                }
                .onChange(of: viewModel.myPet.description) { oldValue, newValue in
                    if newValue.count > 300 {
                        viewModel.myPet.description = String(newValue.prefix(300))
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
                            .font(.caption)
                            .offset(x: 5, y: 12)
                    }
                }
                .padding(.bottom)
            
            Text("태그 선택하기")
                .bold()
                .padding(.bottom, 3)
            
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
