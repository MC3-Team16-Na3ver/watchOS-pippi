//
//  SendButtonView.swift
//  luv-dub Watch App
//
//  Created by 김예림 on 2023/07/25.
//

import SwiftUI

struct SendButtonView: View {
    @EnvironmentObject private var viewModel: ButtonViewModel
    
    var body: some View {
        ZStack {
            if viewModel.longPressDetected {
                ProgressBar()
            }
            if viewModel.isProgressComplete {
                StatusView()
                    .onAppear {
                        viewModel.sendPeerToNotification()
                    }
            } else {
                Button(action: { }) {
                    Text("SEND")
                        .modifier(ButtonTextStyle())
                }
                .buttonStyle(SendButtonStyle(isPossibleToSend: viewModel.remainingHearts > 0))
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0.0)
                        .onChanged{ _ in
                            viewModel.startProgressAnimation()
                        }
                        .onEnded{ _ in
                            viewModel.longPressDetected = false
                        }
                )
                .disabled(viewModel.remainingHearts == 0)

            }
        }
    }
}



// Button Style
fileprivate struct SendButtonStyle: ButtonStyle {
    let isPossibleToSend: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? .white.opacity(0.7) : .white)
            .background(
                ZStack {
                    Circle()
                        .fill(
                            isPossibleToSend ? LinearGradient(stops: [
                                Gradient.Stop(color: Color(red: 1, green: 0.3, blue: 0.48), location: 0.00),
                                Gradient.Stop(color: Color(red: 0.98, green: 0.07, blue: 0.31), location: 1.00),
                            ], startPoint: UnitPoint(x: 0.92, y: 0.1), endPoint: UnitPoint(x: 0.15, y: 0.87))
                            : LinearGradient(stops: [
                                Gradient.Stop(color: Color(red: 0.5, green: 0.5, blue: 0.5), location: 0.00),
                                Gradient.Stop(color: Color(red: 0.5, green: 0.5, blue: 0.5), location: 1.00),
                            ], startPoint: UnitPoint(x: 0.92, y: 0.1), endPoint: UnitPoint(x: 0.15, y: 0.87))
                        )
                        .frame(width: 116, height: 116)
                        .shadow(color: .black.opacity(configuration.isPressed ? 0.6 : 0.8), radius: 2, x: 0, y: 0)
                        .mask(Circle())
                    if configuration.isPressed {
                        Circle().fill(
                            Color.black.opacity(0.3)
                        )
                    }
                }
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

// Button Text Style
fileprivate struct ButtonTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(
                Font.custom("Apple SD Gothic Neo", size: 14)
                    .weight(.bold)
            )
            .kerning(0.1)
            .multilineTextAlignment(.center)
        
    }
}




struct SendButtonView_Previews: PreviewProvider {
    static var previews: some View {
        SendButtonView()
            .environmentObject(ButtonViewModel())
    }
}
