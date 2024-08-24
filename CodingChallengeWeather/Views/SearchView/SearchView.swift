//
//  SearchView.swift
//  CodingChallengeWeather
//
//  Created by Alex on 8/24/24.
//

import SwiftUI
import MapKit

struct SearchView: View {
    @StateObject var viewModel: SearchViewViewModel

    @State private var searchText: String = ""
    @State private var isNavigationActive: Bool = false
    @State private var previousCity: String? = nil

    @ObservedObject private var completerDelegate = SearchCompleterDelegate()

    var body: some View {
        NavigationView {
            VStack {
                Text("Search")
                    .font(.title)
                
                searchBar
                    .padding(.bottom, 12)
                
                // only show the button if they've already searched for a city
                if let city = viewModel.getPreviousCity() {
                    // Use a separate method or property to avoid direct state modification in the body
                    usePreviousCityButton(city: city)
                        .padding(.bottom, 12)
                }

                useMyLocationButton()
                    .padding(.bottom, 12)

                List {
                    ForEach(viewModel.getCityList(results: completerDelegate.searchResults)) { location in
                        Button(action: {
                            // Saving location for future use
                            UserDefaults.standard.set(location.locationText(), forKey: "PreviousCity")
                            isNavigationActive = true
                        }) {
                            Text(location.locationText())
                        }
                        .background(
                            NavigationLink(
                                destination: DetailView(viewModel: DetailViewViewModel(location: location)),
                                isActive: $isNavigationActive
                            ) {
                                EmptyView()
                            }
                        )
                    }
                }
            }
            .onAppear {
                viewModel.completer.delegate = completerDelegate
            }
        }
    }
    
    var searchBar: some View {
        HStack {
            TextField("Enter City Here...", text: $searchText)
                .padding(.leading, 12)
                .padding(.vertical, 12)
            
            Button(action: {
                searchText = ""
            }, label: {
                Image(systemName: "xmark.circle.fill")
                    .padding(.trailing, 12)
                    .opacity(searchText == "" ? 0 : 1)
            })
        }
        .padding(.horizontal)
        .background(Color(.systemGray5))
        .cornerRadius(10)
        .padding(.horizontal)
        .onChange(of: searchText, { _, newValue in
            viewModel.performSearch(query: newValue)
        })
    }
    
    // if there's a previous city, this button appears and will populate the search text when selected
    func usePreviousCityButton(city: String) -> some View {
        Button(action: {
            self.previousCity = city
            self.searchText = city
        }) {
            Text("Use Previous City")
        }
    }
    
    func useMyLocationButton() -> some View {
        Button(action: {
            viewModel.fetchLocation()
            self.searchText = viewModel.locationDescription ?? ""
        }) {
            Text("Use My Location")
        }
    }
    
}
