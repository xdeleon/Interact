//
//  ResizableOverlayModel.swift
//  
//
//  Created by Kieran Brown on 11/17/19.
//

import Foundation
import SwiftUI

/// Data Model that provides all needed components for a resizable overlay
/// Uses a generic type `Handle` to create the views in each of the four corners of the overlay.
@available(iOS 13.0, macOS 10.15, watchOS 6.0 , tvOS 13.0, *)
public class ResizableOverlayModel<Handle: View>: ObservableObject {
    
    
    // MARK: State
    
    @Published var topLeadState: CGSize = .zero
    @Published var bottomLeadState: CGSize = .zero
    @Published var topTrailState: CGSize = .zero
    @Published var bottomTrailState: CGSize = .zero
    @Binding var offset: CGSize
    @Binding var size: CGSize
    @Binding var isSelected: Bool
    @Binding var angle: CGFloat
    @Binding var magnification: CGFloat
    
    

    // MARK: Overlay
    
    var handle: (Bool, Bool) -> Handle
    
    
    var topLead: some View {
        
        
        let pX = topLeadState.width + bottomLeadState.width
        let pY = topLeadState.height + topTrailState.height
        
        let oX = -size.width*(magnification-1)/2
        let oY = -size.height*(magnification-1)/2
        
        let dragGesture = DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged({ (value) in
                self.topLeadState = value.translation
            })
            .onEnded { (value) in
                let x = cos(self.angle)*value.translation.width - sin(self.angle)*value.translation.height
                let y = cos(self.angle)*value.translation.height + sin(self.angle)*value.translation.width
                
                self.offset.width += x/2
                self.offset.height += y/2
                
                self.size.width -= value.translation.width
                self.size.height -= value.translation.height
                
                self.topLeadState = .zero
        }
        
        return ZStack {
            handle(isSelected, topLeadState != .zero)
        }
        .position(x: pX, y: pY)
        .gesture(dragGesture)
        .offset(x: oX, y: oY)
    }
    
    var bottomLead: some View {
        
        
        let pX = topLeadState.width + bottomLeadState.width
        let pY = size.height + bottomTrailState.height + bottomLeadState.height
        
        let oX = -size.width*(magnification-1)/2
        let oY = size.height*(magnification-1)/2
        
        
        let dragGesture = DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged({ (value) in
                self.bottomLeadState = value.translation
            })
            .onEnded { (value) in
                let x = cos(self.angle)*value.translation.width - sin(self.angle)*value.translation.height
                let y = cos(self.angle)*value.translation.height + sin(self.angle)*value.translation.width
                
                self.offset.width += x/2
                self.offset.height += y/2
                
                self.size.width -= value.translation.width
                self.size.height += value.translation.height
                
                self.bottomLeadState = .zero
        }
        
        return ZStack {
            handle(isSelected, bottomLeadState != .zero)
        }
        .position(x: pX, y: pY)
        .gesture(dragGesture)
        .offset(x: oX, y: oY)
    }
    
    var topTrail: some View {
        
        
        let pX = size.width + bottomTrailState.width + topTrailState.width
        let pY = topLeadState.height + topTrailState.height
        
        let oX = size.width*(magnification-1)/2
        let oY = -size.height*(magnification-1)/2
        
        let dragGesture = DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged({ (value) in
                self.topTrailState = value.translation
            })
            .onEnded { (value) in
                let x = cos(self.angle)*value.translation.width - sin(self.angle)*value.translation.height
                let y = cos(self.angle)*value.translation.height + sin(self.angle)*value.translation.width
                
                self.offset.width += x/2
                self.offset.height += y/2
                
                self.size.width += value.translation.width
                self.size.height -= value.translation.height
                
                self.topTrailState = .zero
        }
        
        return ZStack {
            handle(isSelected, topTrailState != .zero )
        }
        .position(x: pX, y: pY)
        .gesture(dragGesture)
        .offset(x: oX, y: oY)
    }
    
    var bottomTrail: some View {
        
        let pX = size.width + topTrailState.width + bottomTrailState.width
        let pY = size.height + bottomLeadState.height + bottomTrailState.height
        
        let oX = size.width*(magnification-1)/2
        let oY = size.height*(magnification-1)/2
        
        let dragGesture = DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged({ (value) in
                self.bottomTrailState = value.translation
            })
            .onEnded { (value) in
                let x = cos(self.angle)*value.translation.width - sin(self.angle)*value.translation.height
                let y = cos(self.angle)*value.translation.height + sin(self.angle)*value.translation.width
                
                self.offset.width += x/2
                self.offset.height += y/2
                self.size.width += value.translation.width
                self.size.height += value.translation.height
                
                self.bottomTrailState = .zero
        }
        
        return ZStack {
            handle(isSelected, bottomTrailState != .zero)
        }
        .position(x: pX, y: pY)
        .gesture(dragGesture)
        .offset(x: oX, y: oY)
        
    }
    
    public var overlay: some View {
        ZStack {
            topLead
            topTrail
            bottomLead 
            bottomTrail
        }
    }
    
    
    
    // MARK: Init
    
    public init(initialSize: CGSize = CGSize(width: 100, height: 200), offset: Binding<CGSize>, size: Binding<CGSize>, magnification: Binding<CGFloat>, angle: Binding<CGFloat>, isSelected: Binding<Bool>, handle: @escaping (_ isSelected: Bool, _ isActive: Bool) -> Handle) {
        self._size = size
        self._offset = offset
        self._magnification = magnification
        self._angle = angle 
        self._isSelected = isSelected
        
        self.handle = handle
    }
    
    
}

