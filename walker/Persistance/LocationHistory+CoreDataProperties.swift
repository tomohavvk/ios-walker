//
//  LocationHistory.swift
//  walker
//
//  Created by IZ on 02.02.2024.
//

import CoreData
import CoreLocation
import Foundation
import SwiftUI

@objc
public class LocationHistory: NSManagedObject {}

extension LocationHistory {
  @NSManaged public var latitude: NSNumber
  @NSManaged public var longitude: NSNumber
  @NSManaged public var accuracy: NSNumber
  @NSManaged public var speed: NSNumber
  @NSManaged public var time: NSNumber
}

public final class LocationHistoryDataManager {
  private init() {}

  public static let shared = LocationHistoryDataManager()

  private let (container, context) = {

    let c = NSPersistentContainer(name: "WalkerCoreData")
    let context = c.newBackgroundContext()
    c.loadPersistentStores { storeDescription, error in
      if let error {
        print("loadPersistentStores \(error.localizedDescription)")
      } else {
        print("DB URL:", storeDescription.url!)
      }
    }

    context.automaticallyMergesChangesFromParent = true
    context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    return (c, context)
  }()

  func saveLocationHistory(_ location: LocationDTO) {
    guard
      let description = NSEntityDescription.entity(
        forEntityName: "LocationHistory", in: self.context)
    else {
      return
    }

    let history = LocationHistory(entity: description, insertInto: self.context)

    history.latitude = NSNumber(value: location.latitude)
    history.longitude = NSNumber(value: location.longitude)
    history.accuracy = NSNumber(value: location.accuracy)
    history.speed = NSNumber(value: location.speed)
    history.time = NSNumber(value: location.time)

    saveContext()
  }

  func fetchLocationHistory() -> [LocationDTO] {
    let fetchRequest = NSFetchRequest<LocationHistory>(entityName: "LocationHistory")
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "time", ascending: true)]

    do {
      let locations = try (self.context.fetch(fetchRequest) as NSArray).map { element in
        let managedObject = element as! NSManagedObject
        let lat = managedObject.value(forKey: "latitude")! as! Double
        let lng = managedObject.value(forKey: "longitude")! as! Double
        let accuracy = managedObject.value(forKey: "accuracy")! as! Double
        let speed = managedObject.value(forKey: "speed")! as! Double
        let time = managedObject.value(forKey: "time")! as! Int64

        return LocationDTO(
          latitude: lat, longitude: lng, accuracy: accuracy, speed: speed, time: time)
      }

      return locations as [LocationDTO]
    } catch {
      print(error)
    }

    return []
  }

  private func saveContext() {
    if self.context.hasChanges {
      do {
        try self.context.save()
      } catch {
        fatalError(error.localizedDescription)
      }
    }
  }

}
