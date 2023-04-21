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

extension ViewState: Error {}

protocol ViewStateProvider: ObservableObject {
	associatedtype T
	
	var viewState: ViewState<T> { get set }
	
	var cancellables: [AnyCancellable] { get set }
	
	func action() -> AnyPublisher<T, Error>
}

extension ViewStateProvider {
	func performAction() {
		action()
			.map { (data: T) in ViewState<T>.init(currentState: .data, error: nil, data: data) }
			.mapError { (error: Error) in ViewState<T>.init(currentState: .error, error: error, data: nil) }
			.assign(to: \.viewState, on: self)
			.store(in: &cancellables)
	}
}

protocol StatefulView: View {
	associatedtype VM: ViewStateProvider
	var viewModel: VM { get set }
}

extension StatefulView {
	@ViewBuilder
	func statefulViewBuilder<T>(
		viewBuilder:(T) -> some View,
		loadingViewBuilder:(() -> some View) = { Text("loading...") },
		errorViewBuilder:((Error) -> some View) = { Text($0.localizedDescription) }
	) -> some View where VM.T == T {
		let state = viewModel.viewState
		switch state.currentState {
		case .loading: loadingViewBuilder()
		case .error: errorViewBuilder(state.error!)
		case .data: viewBuilder(state.data!)
		case .initial: EmptyStateView()
		}
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
