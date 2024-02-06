//
//  GPXFilesModel.swift
//  walker
//
//  Created by IZ on 05.02.2024.
//

import Foundation

class GPXFilesModel: ObservableObject {
    @Published var gpxFileNameList: [String]
    
    init(gpxFileNameList: [String]) {
        self.gpxFileNameList = gpxFileNameList
    }
}
