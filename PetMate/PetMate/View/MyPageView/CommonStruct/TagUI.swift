//
//  TagView.swift
//  PetMate
//
//  Created by 이다영 on 10/15/24.
//

import SwiftUI

// 기본태그뷰
struct TagView: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.system(size: 12))
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color("petTag_Color"))
            .foregroundStyle(Color.white)
            .cornerRadius(12)
    }
}
// 태그 선택
struct TagToggle: View {
    let tag: String
    var isSelected: Bool
    var toggleAction: () -> Void
    
    var body: some View {
        Text(tag)
            .font(.system(size: 15))
            .padding(.horizontal, 15)
            .padding(.vertical, 5)
            .background(isSelected ? Color("petTag_Color") : Color(.systemGray6))
            .foregroundStyle(isSelected ? .white : Color(.darkGray))
            .cornerRadius(15)
            .onTapGesture {
                toggleAction()
            }
    }
}

// 태그 나열 레이아웃
struct FlowLayout: Layout {
    var spacing: CGFloat
    
    init(spacing: CGFloat = 8) {
        self.spacing = spacing
    }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        
        var totalHeight: CGFloat = 0
        var totalWidth: CGFloat = 0
        
        var lineHeight: CGFloat = 0
        var lineWidth: CGFloat = 0
        
        for size in sizes {
            if lineWidth + size.width + spacing > proposal.width ?? 0 {
                totalHeight += lineHeight + spacing
                totalWidth = max(totalWidth, lineWidth)
                lineWidth = size.width
                lineHeight = size.height
            } else {
                lineWidth += size.width + spacing
                lineHeight = max(lineHeight, size.height)
            }
        }
        totalHeight += lineHeight
        totalWidth = max(totalWidth, lineWidth)
        
        return CGSize(width: totalWidth, height: totalHeight)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        
        var lineX = bounds.minX
        var lineY = bounds.minY
        var lineHeight: CGFloat = 0
        
        for index in subviews.indices {
            if lineX + sizes[index].width + spacing > bounds.maxX {
                lineY += lineHeight + spacing
                lineHeight = 0
                lineX = bounds.minX
            }
            
            let position = CGPoint(
                x: lineX + sizes[index].width / 2,
                y: lineY + sizes[index].height / 2
            )
            
            subviews[index].place(
                at: position,
                anchor: .center,
                proposal: ProposedViewSize(sizes[index])
            )
            
            lineHeight = max(lineHeight, sizes[index].height)
            lineX += sizes[index].width + spacing
        }
    }
}

