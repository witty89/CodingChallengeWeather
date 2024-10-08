//
//  DetailView.swift
//  CodingChallengeWeather
//
//  Created by Alex on 8/24/24.
//

import SwiftUI

struct DetailView: View {
    @StateObject var viewModel: DetailViewViewModel
    
    // needed to dismiss detailView and return to homescreen on error
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                loadingView
            } else {
                contentView
            }
        }
        .padding()
        
        // show error
        .alert(isPresented: $viewModel.isShowingError) {
            Alert(title: Text("Error"), message: Text(viewModel.error ?? "Unknown error"), dismissButton: .default(Text("OK")) {
                viewModel.isShowingError = false
                
                // dismiss detail view and return to search view
                self.presentationMode.wrappedValue.dismiss()
            })
        }
        .onReceive(viewModel.$error) { error in
            // Show the alert when the error occurs
            if let _ = error {
                viewModel.isShowingError = true
            }
        }
        // accessing the toolbar to add the refresh button
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.getData()
                }) {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
    }
    
    var contentView: some View {
        VStack {
            if let current = viewModel.weatherData?.current {
                // city name as title
                Text(viewModel.location.city)
                    .font(.title)
                
                // show the icon, if we have one
                if let icon = current.weather.first?.icon {
                    iconImage
                }
                
                // show relevant properties: description, summary, and the attribute list
                if let description = current.weather.first?.description {
                    Text(description)
                        .textCase(.uppercase)
                }
                
                Text(viewModel.weatherData?.daily?.first?.summary ?? "No Description Available")
                    .padding(.horizontal, 24)
                    .padding(.bottom, 16)
                
                weatherAttributeList(current: current)
                temperatureUnitSwitch
            }
        }
    }
    
    // get the image, show placeholder image until icon returns to avoid awkard resizing
    @ViewBuilder
    var iconImage: some View {
        AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(viewModel.weatherData?.current.weather.first?.icon ?? "")@4x.png")) { phase in
            switch phase {
            case .empty:
                // Placeholder image
                Image(systemName: "sun.dust.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200)
                    .clipped()
            case .success(let image):
                // The loaded image
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200)
                    .clipped()
            case .failure:
                // Placeholder image
                Image(systemName: "sun.dust.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200)
                    .clipped()
            @unknown default:
                // Placeholder image
                Image(systemName: "sun.dust.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200)
                    .clipped()
            }
        }
    }
    
    // allow user to switch between Celcius and Fahrenheit
    var temperatureUnitSwitch: some View {
        HStack {
            Text("°C")
            Toggle("Temperature Unit", isOn: $viewModel.isFahrenheit)
                .labelsHidden()
                .padding()
            Text("°F")
        }
    }
    
    // shows the title and value pairs for each attribute
    func attributeView(title: String, value: String, showDivider: Bool = true) -> some View {
        VStack {
            HStack {
                Text(title)
                Spacer()
                Text(value)
            }
            .padding(.horizontal, 24)
            
            if showDivider {
                Divider()
            }
        }
    }
    
    func weatherAttributeList(current: Current) -> some View {
        // scrollview, just in case user has a small device, or to allow future additions to the attributes
        ScrollView {
            ForEach(viewModel.weatherAttributes) {
                attributeView(title: $0.title, value: $0.value)
            }
        }
    }
}
