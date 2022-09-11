//
//  SideMenuBar.swift
//  SwiftUI_Templates
//
//  Created by Malachi Hul on 2022/09/11.
//  Copyright © 2022 Hui, Malachi | DCMS. All rights reserved.
//

import SwiftUI

struct SideMenuBar: View {
    @State var currentTab: String = "Home"
    @State var showSideBar: Bool = false
    @Namespace var animation
    
    var body: some View {
        HStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    HStack {
                        Spacer()
                        ActivateButton()
                        Spacer()
                    }
                }
                .padding(15)
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .leading)
        .background {
            Color.black
                .opacity(0.04)
                .ignoresSafeArea()
        }
        .overlay(alignment: .leading) {
            ViewThatFits {
                SideBar()
                ScrollView(.vertical, showsIndicators: false) {
                    SideBar()
                }
                .background(Color.white.ignoresSafeArea())
            }
            .offset(x: showSideBar ? 0 : -100)
            .frame(maxWidth: .infinity,alignment: .leading)
            .background {
                Color.black
                    .opacity(showSideBar ? 0.25 : 0)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut){showSideBar.toggle()}
                    }
            }
        }
    }
    
    @ViewBuilder
    func ActivateButton()->some View {
        Button {
            withAnimation(.easeInOut){
                showSideBar.toggle()
            }
        } label: {
            Text("Activate")
        }
    }
    
    // MARK: Side Bar
    @ViewBuilder
    func SideBar()->some View {
        // MARK: Tabs
        let tabs: [String] = [ "Home","Table","Menu","Order","History","Report","Alert","Settings"]
        VStack(spacing: 10){
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 55, height: 55)
                .padding(.bottom,20)
            
            ForEach(tabs,id: \.self){tab in
                VStack(spacing: 8){
                    Image(tab)
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22, height: 22)
                    
                    Text(tab)
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                .foregroundColor(currentTab == tab ? .orange : .gray)
                .padding(.vertical,13)
                .frame(width: 65)
                .background {
                    if currentTab == tab{
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .fill(.orange.opacity(0.1))
                            .matchedGeometryEffect(id: "TAB", in: animation)
                    }
                }
                .onTapGesture {
                    withAnimation(.easeInOut){currentTab = tab}
                }
            }
            
            Button {
                
            } label: {
                VStack{
                    Image("Pic")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 45, height: 45)
                        .clipShape(Circle())
                    
                    Text("Profile")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                }
            }
            .padding(.top,20)
        }
        .padding(.vertical)
        .frame(maxHeight: .infinity,alignment: .top)
        .frame(width: 100)
        .background {
            Color.white
                .ignoresSafeArea()
        }
    }
}

struct SideBar_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuBar()
    }
}
