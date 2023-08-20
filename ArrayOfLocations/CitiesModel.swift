//
//  CitiesModel.swift
//  OptimizedArray
//
//  Created by Илья on 17.08.2023.
//

import Foundation

struct CitiesModel: Codable {
    var cities: [PointModel]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        cities = try container.decode([PointModel].self, forKey: .cities)
    }
}
