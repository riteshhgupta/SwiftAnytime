//
//  ContentView.swift
//  SwiftAnytime
//
//  Created by Ritesh Gupta on 21/04/23.
//

import Combine
import SwiftUI

struct AppError {}
extension AppError: LocalizedError {
	var errorDescription: String? { "No internet!" }
}

struct ViewState<T> {
	let currentState: State
	let error: Error?
	let data: T?
	
	enum State {
		case initial
		case loading
		case error
		case data
	}
}

struct ContentView: View {
	
	var body: some View {
		Text("Content")
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		ContentView()
    }
}
