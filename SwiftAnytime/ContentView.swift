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

final class ContentViewInnerModel: ObservableObject {
	@Published var viewState = ViewState<String>.init(currentState: .initial, error: nil, data: nil) {
		didSet {
			print(viewState)
		}
	}
	
	func updateState() {
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
	}
}

final class ContentViewModel: ObservableObject {
	@Published var innerModel:ContentViewInnerModel = .init()

	func updateState() {
		innerModel.updateState()
	}
}

struct ContentView: View {
	@ObservedObject var viewModel: ContentViewModel
	
	var body: some View {
		ZStack {
			Button(action: {
				self.viewModel.updateState()
			}) {
				switch viewModel.innerModel.viewState.currentState {
				case .initial: Text("Initial")
				case .loading: Text("Loading...")
				case .error: Text(viewModel.innerModel.viewState.error?.localizedDescription ?? "")
				case .data: Text(viewModel.innerModel.viewState.data ?? "")
				}
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		ContentView(viewModel: .init())
    }
}
