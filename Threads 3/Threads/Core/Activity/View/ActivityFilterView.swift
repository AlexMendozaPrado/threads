//
//  ActivityFilterView.swift
//  Threads
//
//  Created by Stephan Dowless on 7/13/23.
//

import SwiftUI

struct ActivityFilterView: View {
    @Binding var selectedFilter: ActivityFilterViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(ActivityFilterViewModel.allCases) { filter in
                    Text(filter.title)
                        .foregroundColor(filter == selectedFilter ? Color.theme.primaryBackground : Color.theme.primaryText)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(width: 130, height: 42)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        }
                        .background(filter == selectedFilter ? Color.theme.primaryText : .clear)
                        .cornerRadius(10)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                selectedFilter = filter
                            }
                        }
                }
            }
            .padding(.horizontal)

        }
    }
}

struct ActivityFilterView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityFilterView(selectedFilter: .constant(.all))
    }
}
