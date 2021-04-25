//
//  Container.swift
//  Cargo ship tracking app
//
//  Created by Rachit Prajapati on 25/04/21.
//

import Foundation

// MARK: - Container

struct Container: Codable {
    let route: Route
}

// MARK: - Route

struct Route: Codable {
    let details: [Detail]
}

// MARK: - Detail

struct Detail: Codable {
    let shipType: String
    let shipName: String
    let portNameFrom, portCountryFrom, portNameTo, portCountryTo: String

    enum CodingKeys: String, CodingKey {
        case shipType, shipName
        case portNameFrom = "port_name_from"
        case portCountryFrom = "port_country_from"
        case portNameTo = "port_name_to"
        case portCountryTo = "port_country_to"
    }
    
    
    init(from decoder: Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        self.shipType = try value.decode(String.self, forKey: CodingKeys.shipType)
        self.shipName = try value.decode(String.self, forKey: CodingKeys.shipName)
        self.portNameFrom = try value.decode(String.self, forKey: CodingKeys.portNameFrom)
        self.portCountryFrom = try value.decode(String.self, forKey: CodingKeys.portCountryFrom)
        self.portNameTo = try value.decode(String.self, forKey: CodingKeys.portNameTo)
        self.portCountryTo = try value.decode(String.self, forKey: CodingKeys.portCountryTo)
    }
}
