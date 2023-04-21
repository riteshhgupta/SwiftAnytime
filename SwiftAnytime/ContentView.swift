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
	@State var viewState = ViewState<String>.init(currentState: .initial, error: AppError(), data: "nil")
    
	var body: some View {
		ZStack {
			Button(action: {
				switch self.viewState.currentState {
				case .initial:
					self.viewState = .init(currentState: .loading, error: nil, data: nil)
				case .loading:
					self.viewState = .init(currentState: .data, error: nil, data: "swift anytime!")
				case .data:
					self.viewState = .init(currentState: .error, error: AppError(), data: nil)
				case .error:
					self.viewState = .init(currentState: .initial, error: nil, data: nil)
				}
			}) {
				switch viewState.currentState {
				case .initial: Text("Initial")
				case .loading: Text("Loading...")
				case .error: Text(viewState.error?.localizedDescription ?? "")
				case .data: Text(viewState.data ?? "")
				}
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
