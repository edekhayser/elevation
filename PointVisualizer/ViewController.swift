//
//  ViewController.swift
//  PointVisualizer
//
//  Created by Evan Dekhayser on 10/11/18.
//  Copyright © 2018 Xappox, LLC. All rights reserved.
//

import UIKit
import Mapbox

struct GeoPoint {
    let lat: Double
    let long: Double
    let elev: Double
}

class ViewController: UIViewController, MGLMapViewDelegate {

    var mapView: MGLMapView!
    
    var points: [GeoPoint] = []
    
    func loadData() {
        let text = try! String(contentsOfFile: Bundle.main.path(forResource: "time_step_3", ofType: "csv")!)
        points = []
        let rows = text.components(separatedBy: "\n")
        for row in rows {
            let columns = row.components(separatedBy: ",").map { $0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) }.compactMap(Double.init)
            if columns.count == 3 {
                points.append(GeoPoint(lat: columns[0], long: columns[1], elev: columns[2]))
            }
        }
    }
    
    func boundingRect() -> MGLCoordinateQuad {
        let minLong = points.min { (a, b) -> Bool in
            a.long < b.long
        }!.long
        let maxLong = points.max { (a, b) -> Bool in
            a.long < b.long
        }!.long
        let minLat = points.min { (a, b) -> Bool in
            a.lat < b.lat
        }!.lat
        let maxLat = points.max { (a, b) -> Bool in
            a.lat < b.lat
        }!.lat
        
        return MGLCoordinateQuad(topLeft: CLLocationCoordinate2D(latitude: maxLat, longitude: maxLong),
                                 bottomLeft: CLLocationCoordinate2D(latitude: minLat, longitude: minLong),
                                 bottomRight: CLLocationCoordinate2D(latitude: minLat, longitude: maxLong),
                                 topRight: CLLocationCoordinate2D(latitude: maxLat, longitude: minLong))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
        // Create a new map view using the Mapbox Light style.
        mapView = MGLMapView(frame: view.bounds)
        mapView.styleURL = MGLStyle.lightStyleURL
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.tintColor = .darkGray
        
        // Set the map’s center coordinate and zoom level.
//        mapView.setCenter(CLLocationCoordinate2D(latitude: 38.897, longitude: -77.039), animated: false)
//        mapView.zoomLevel = 10.5
        
        let quad = boundingRect()
        mapView.setVisibleCoordinateBounds(MGLCoordinateBounds(sw: quad.bottomLeft, ne: quad.topRight), animated: false)
//        mapView.zoomLevel = 1
        
        mapView.delegate = self
        view.addSubview(mapView)
    }
    
    // Wait until the style is loaded before modifying the map style.
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        
        // "mapbox://examples.2uf7qges" is a map ID referencing a tileset. For more
        // more information, see mapbox.com/help/define-map-id/
//        let source = MGLVectorTileSource(identifier: "trees", configurationURL: URL(string: "mapbox://edekhayser.c15afe6g")!)
//        let source = MGLVectorTileSource(identifier: "trees", configurationURL: URL(string: "mapbox://examples.2uf7qges")!)

//        style.addSource(source)
//
//        let layer = MGLCircleStyleLayer(identifier: "tree-style", source: source)
//
//        // The source name from the source's TileJSON metadata: mapbox.com/api-documentation/#retrieve-tilejson-metadata
//        layer.sourceLayerIdentifier = "yoshino-trees-a0puw5"
//
////        // Stops based on age of tree in years.
////        let stops = [
////            0: UIColor(red: 1.00, green: 0.72, blue: 0.85, alpha: 1.0),
////            2: UIColor(red: 0.69, green: 0.48, blue: 0.73, alpha: 1.0),
////            4: UIColor(red: 0.61, green: 0.31, blue: 0.47, alpha: 1.0),
////            7: UIColor(red: 0.43, green: 0.20, blue: 0.38, alpha: 1.0),
////            16: UIColor(red: 0.33, green: 0.17, blue: 0.25, alpha: 1.0)
////        ]
//
//        // Style the circle layer color based on the above stops dictionary.
////        layer.circleColor = NSExpression(format: "mgl_step:from:stops:(AGE, %@, %@)", UIColor(red: 1.0, green: 0.72, blue: 0.85, alpha: 1.0), stops)
//        layer.circleColor = NSExpression(forConstantValue: UIColor.blue)
//
//        layer.circleRadius = NSExpression(forConstantValue: 3)
//
//        style.addLayer(layer)
        
        
//        for point in points {
//
//        }
//        let source = MGLVectorTileSource(identifier: "elevs", configurationURL: URL(string: Bundle.main.path(forResource: "convertcsv", ofType: "geojson")!)!)
//        let layer = MGLCircleStyleLayer(identifier: "elevs", source: source)
//        layer.circleColor = NSExpression(forConstantValue: UIColor.green)
//        layer.circleOpacity = NSExpression(forConstantValue: 0.7)
//        mapView.style?.addLayer(layer)
        
        
        for point in points {
            let annotation = MyCustomPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: point.lat, longitude: point.long)
            mapView.addAnnotation(annotation)
        }
    }
    
    class MyCustomPointAnnotation: MGLPointAnnotation {}
    
//    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
//        if let _ = annotation as? MyCustomPointAnnotation {
//            let v = MGLAnnotationView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
////            v.
//            v.backgroundColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.5)
//            return v
//        }
//        return nil
//    }
}

