//
//  extension_View.swift
//  CodingChallengeWeather
//
//  Created by Alex on 8/24/24.
//

import SwiftUI
extension View {
    
    var loadingView: some View {
        VStack {
            Text("Loading...")
                .font(.headline)
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .padding()
        }
    }
    
    // show error
    func errorAlert(error: Binding<Error?>, buttonTitle: String = "OK") -> some View {
        let localizedAlertError = LocalizedAlertError(error: error.wrappedValue)
        return alert(isPresented: .constant(localizedAlertError != nil), error: localizedAlertError) { _ in
            Button(buttonTitle) {
                error.wrappedValue = nil
            }
        } message: { error in
            Text(error.recoverySuggestion ?? "")
        }
    }
    
}

struct LocalizedAlertError: LocalizedError {
    let underlyingError: LocalizedError
    var errorDescription: String? {
        underlyingError.errorDescription
    }
    var recoverySuggestion: String? {
        underlyingError.recoverySuggestion
    }
    
    init?(error: Error?) {
        guard let localizedError = error as? LocalizedError else { return nil }
        underlyingError = localizedError
    }
}
