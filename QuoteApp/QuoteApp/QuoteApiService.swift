import Foundation

enum ApiError: Error, LocalizedError {
    case badURL
    case invalidResponse
    case decodingError
    case unknownError

    var errorDescription: String? {
        switch self {
        case .badURL:
            return "The URL provided was invalid."
        case .invalidResponse:
            return "The server responded with an error."
        case .decodingError:
            return "Failed to decode the data from the server."
        case .unknownError:
            return "An unknown error occurred."
        }
    }
}

class ApiService {
    static let shared = ApiService()
    
     func fetchPosts(completion: @escaping (Result<[Post], ApiError>) -> Void) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            completion(.failure(.badURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(.unknownError))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }

            guard let data = data else {
                completion(.failure(.unknownError))
                return
            }

            do {
                let posts = try JSONDecoder().decode([Post].self, from: data)
                completion(.success(posts))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}

