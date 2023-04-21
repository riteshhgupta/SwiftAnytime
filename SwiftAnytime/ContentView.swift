//
//  ContentView.swift
//  SwiftAnytime
//
//  Created by Ritesh Gupta on 21/04/23.
//

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
	let viewState = ViewState<String>.init(currentState: .initial, error: AppError(), data: "nil")
    
	var body: some View {
		ZStack {
			switch viewState.currentState {
			case .initial: Text("Initial")
			case .loading: Text("Loading...")
			case .error: Text(viewState.error?.localizedDescription ?? "")
			case .data: Text(viewState.data ?? "")
			}
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
