import Foundation

struct Post: Identifiable, Codable {
    let id: Int
    let title: String
    let body: String
}

