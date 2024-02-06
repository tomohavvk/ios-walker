//
//  GPXFilesService.swift
//  walker
//
//  Created by IZ on 05.02.2024.
//

import Foundation
import SwiftUI

class GPXFilesService  {
    @ObservedObject var gpxFilesModel: GPXFilesModel
    
    init(gpxFilesModel: GPXFilesModel) {
        self.gpxFilesModel = gpxFilesModel
    }
    
    static func createGPXFile(locations: [LocationDTO]) {
        let dateFormatter = ISO8601DateFormatter()
        let timestamp = dateFormatter.string(from: Date())
        
        var gpxString = """
            <?xml version="1.0" encoding="UTF-8" ?>
            <gpx version="1.1" creator="YourApp" xmlns="http://www.topografix.com/GPX/1/1">
            """
        
        for location in locations {
            let timeString = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(location.time)))
            
            gpxString += """
                <wpt lat="\(location.latitude)" lon="\(location.longitude)">
                    <ele>\(location.altitude ?? 0.0)</ele>
                    <time>\(timeString)</time>
                </wpt>
                """
        }
        
        gpxString += """
            </gpx>
            """
        
        do {
            let fileURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("yourApp_\(timestamp).gpx")
            
            try gpxString.write(to: fileURL, atomically: true, encoding: .utf8)
            
            // File successfully created at fileURL
            print("GPX file created at: \(fileURL.absoluteString)")
        } catch {
            // Handle error
            print("Error creating GPX file: \(error.localizedDescription)")
        }
    }
    
    static func deleteGPXFile(fileName: String) {
        do {
            let fileURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent(fileName)
            
            try FileManager.default.removeItem(at: fileURL)
            
            // File successfully deleted
            print("GPX file deleted successfully.")
        } catch {
            // Handle error
            print("Error deleting GPX file: \(error.localizedDescription)")
        }
    }
    
    static func readGPXFile(fileName: String) {
        do {
            let fileURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent(fileName)
            
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            _ = try decoder.decode([LocationDTO].self, from: data)
            
            // Use decodedLocations as needed
            print("GPX file read successfully.")
        } catch {
            // Handle error
            print("Error reading GPX file: \(error.localizedDescription)")
        }
    }
    
    func readAllGPXFiles() {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let gpxFiles = try FileManager.default.contentsOfDirectory(atPath: documentDirectory.path)
                .filter { $0.hasSuffix(".gpx") }

            self.gpxFilesModel.gpxFileNameList = gpxFiles
            print("List of GPX files: \(gpxFiles)")
        } catch {
            // Handle error
            print("Error reading list of GPX files: \(error.localizedDescription)")
        }
    }
}
