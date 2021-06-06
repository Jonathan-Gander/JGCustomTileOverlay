//
//  ViewController.swift
//  CustomTileOverlay
//
//  Created by Jonathan Gander on 05.06.21.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // *** UI
        self.title = "Custom tile overlay example"
        
        let button = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(optionsButtonTapped(sender:)))
        navigationItem.rightBarButtonItem = button
                
        // *** Map settings
        let customOverlay = JGCustomTileOverlay(urlTemplate: "https://a.tile.openstreetmap.org/{z}/{x}/{y}.png")
        customOverlay.saveInCache = true
        customOverlay.canReplaceMapContent = true
        
        mapView.delegate = self
        mapView.mapType = .satellite
        mapView.addOverlay(customOverlay, level: .aboveLabels)
    }
    
    // MARK: MKMapViewDelegate methods
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        return MKTileOverlayRenderer(tileOverlay: overlay as! MKTileOverlay)
    }
    
    // MARK: Options
    @objc func optionsButtonTapped(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
        
        // *** Action : Clear cache
        var text = "Clear cache"
        if let size = CacheDirectoryManager.shared.getCacheSize() {
            text += " (\(size))"
        }
        alert.addAction(UIAlertAction(title: text, style: .default, handler: { (UIAlertAction) in
            CacheDirectoryManager.shared.clearCacheDirectory()
        }))
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

