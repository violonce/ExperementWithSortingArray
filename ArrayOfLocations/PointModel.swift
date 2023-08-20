//
//  PointModel.swift
//  OptimizedArray
//
//  Created by Илья on 17.08.2023.
//

import Foundation
import KDTree

struct PointModel: Codable {
    let _id: String
    let name: String
    let latitude: Double
    let longitude: Double
}

extension PointModel: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(_id)
    }
    
    static func == (lhs: PointModel, rhs: PointModel) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

extension PointModel: KDTreePoint {
    static var dimensions: Int {
        return 2
    }
    
    func kdDimension(_ dimension: Int) -> Double {
        return dimension == 0 ? self.latitude : self.longitude
    }
    
    func squaredDistance(to otherPoint: PointModel) -> Double {
        let x = self.latitude - otherPoint.latitude
        let y = self.longitude - otherPoint.longitude
        return sqrt(Double(x*x + y*y))
    }
}
