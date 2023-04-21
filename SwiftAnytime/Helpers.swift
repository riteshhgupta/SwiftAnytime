//
//  Helpers.swift
//  SwiftAnytime
//
//  Created by Ritesh Gupta on 21/04/23.
//

import Combine
import Foundation
import SwiftUI

extension Publisher where Output == Failure {
	func assign<Root>(to keyPath: ReferenceWritableKeyPath<Root, Self.Output>, on object: Root) -> AnyCancellable {
		self
			.catch { Just($0) }
			.assign(to: keyPath, on: object)
	}
}

func successApi<T>(_ value: T) -> AnyPublisher<T, Error> {
	Deferred {
		Just(value)
			.delay(for: 2, scheduler: DispatchQueue.main)
			.setFailureType(to: Error.self)
	}
	.eraseToAnyPublisher()
}

func failureApi<T>(_ value: Error) -> AnyPublisher<T, Error> {
	Deferred {
		Fail(outputType: T.self, failure: value)
			.delay(for: 2, scheduler: DispatchQueue.main)
	}
	.eraseToAnyPublisher()
}

struct EmptyStateView: View {
	var body: some View {
		ZStack {}
	}
}
