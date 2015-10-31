//
//  Location.swift
//  LocationPicker
//
//  Created by Almas Sapargali on 7/29/15.
//  Copyright (c) 2015 almassapargali. All rights reserved.
//

import Foundation

import CoreLocation
import AddressBookUI

// class because protocol
public class Location: NSObject, NSCoding {
	public let name: String?
	
	// difference from placemark location is that if location was reverse geocoded,
	// then location point to user selected location
	public let location: CLLocation
	public let placemark: CLPlacemark
	
	public var address: String {
		// try to build full address first
		if let addressDic = placemark.addressDictionary {
			if let lines = addressDic["FormattedAddressLines"] as? [String] {
				return lines.joinWithSeparator(", ")
			} else {
				// fallback
				return ABCreateStringWithAddressDictionary(addressDic, true)
			}
		} else {
			return "\(coordinate.latitude), \(coordinate.longitude)"
		}
	}
	
	public init(name: String?, location: CLLocation? = nil, placemark: CLPlacemark) {
		self.name = name
		self.location = location ?? placemark.location!
		self.placemark = placemark
	}
  
  public func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(self.name, forKey: "name")
    aCoder.encodeObject(self.location, forKey: "location")
    aCoder.encodeObject(self.placemark, forKey: "placemark")
  }
  
  required public init(coder aDecoder: NSCoder) {
    self.name = aDecoder.decodeObjectForKey("name") as! String
    self.location = aDecoder.decodeObjectForKey("location") as! CLLocation
    self.placemark = aDecoder.decodeObjectForKey("placemark") as! CLPlacemark
  }
}

import MapKit

extension Location: MKAnnotation {
    @objc public var coordinate: CLLocationCoordinate2D {
		return location.coordinate
	}
	
    public var title: String? {
		return name ?? address
	}
}