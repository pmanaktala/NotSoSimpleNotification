//
//  MessageView.swift
//  NotSoSimpleNotification
//
//  Created by Parth Manaktala on 8/22/24.
//


import SwiftUI

struct MessageView: View {
    @Binding var userInput: String

    var body: some View {
        VStack {
            TextField("Enter your message", text: $userInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
        }
    }
}