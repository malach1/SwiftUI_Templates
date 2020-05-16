//
//  MapSearchView.swift
//  SwiftUI_Templates
//
//  Created by Hui, Malachi | DCMS on 2020/05/16.
//  Copyright © 2020 Hui, Malachi | DCMS. All rights reserved.
//

import SwiftUI
import MapKit
import Combine

struct MapViewContainer: UIViewRepresentable {
    
    var annotations = [MKPointAnnotation]()
    let mapView = MKMapView()
    
    func makeUIView(context: UIViewRepresentableContext<MapViewContainer>) -> MKMapView {
        setupRegionForMap()
        return mapView
    }
    
    fileprivate func setupRegionForMap() {
        //San Francisco Location
        let centerCoordinate = CLLocationCoordinate2D(latitude: 37.7666, longitude: -122.427290)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapViewContainer>) {
        uiView.removeAnnotations(uiView.annotations)
        uiView.addAnnotations(annotations)
        uiView.showAnnotations(uiView.annotations, animated: false)
    }
    
    typealias UIViewType = MKMapView
}

// keep track of properties that your view needs to render
class MapSearchingViewModel: ObservableObject {
    
    @Published var annotations = [MKPointAnnotation]()
    @Published var isSearching = false
    @Published var searchQuery = ""
    
    var cancellable: AnyCancellable?
    
    init() {
        print("Initializing view model")
        // combine code
        cancellable = $searchQuery.debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] (searchTerm) in
                self?.performSearch(query: searchTerm)
        }
    }
    
    fileprivate func performSearch(query: String) {
        isSearching = true
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        
        let localSearch = MKLocalSearch(request: request)
        localSearch.start { (resp, err) in
            guard err == nil else { return }
            
            var airportAnnotations = [MKPointAnnotation]()
            
            resp?.mapItems.forEach({ (mapItem) in
                print(mapItem.name ?? "")
                let annotation = MKPointAnnotation()
                annotation.title = mapItem.name
                annotation.coordinate = mapItem.placemark.coordinate
                airportAnnotations.append(annotation)
            })
            
            self.isSearching = false
            self.annotations = airportAnnotations
        }
    }
}


struct MapSearchView: View {
    @ObservedObject var vm = MapSearchingViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
            
            MapViewContainer(annotations: vm.annotations)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 12) {
                HStack {
                    TextField("Search terms", text: $vm.searchQuery)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color.white)
                    
                    
                }.shadow(radius: 3)
                    .padding()
                
                if vm.isSearching {
                    Text("Searching...")
                }
                
            }
        }
        
    }
}

struct MapSearchView_Previews: PreviewProvider {
    static var previews: some View {
        MapSearchView()
    }
}
