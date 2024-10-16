//
//  KakaoAPIClient.swift
//  PetMate
//
//  Created by 김정원 on 10/16/24.
//

import Foundation
import Combine

final class KakaoAPIClient {
    private let baseURL = "https://dapi.kakao.com/v2/local/search/keyword.json"
    private let apiKey = Bundle.main.kakaoAppKey
    
    func searchPlaces(query: String, x: String? = nil, y: String? = nil, radius: Int? = nil, page: Int = 1, size: Int = 15, sort: String? = "accuracy") -> AnyPublisher<KakaoAPIResponse, Error> {
        // URL 컴포넌트 구성
        var components = URLComponents(string: baseURL)!
        var queryItems = [URLQueryItem(name: "query", value: query),
                          URLQueryItem(name: "page", value: "\(page)"),
                          URLQueryItem(name: "size", value: "\(size)")]
        
        if let x = x, let y = y, let radius = radius {
            queryItems.append(URLQueryItem(name: "x", value: x))
            queryItems.append(URLQueryItem(name: "y", value: y))
            queryItems.append(URLQueryItem(name: "radius", value: "\(radius)"))
        }
        
        if let sort = sort {
            queryItems.append(URLQueryItem(name: "sort", value: sort))
        }
        
        components.queryItems = queryItems
        
        guard let url = components.url else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        // 요청 생성
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("KakaoAK \(apiKey)", forHTTPHeaderField: "Authorization")
        
        // 데이터 태스크 퍼블리셔 생성
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { result -> Data in
                guard let httpResponse = result.response as? HTTPURLResponse,
                      200..<300 ~= httpResponse.statusCode else {
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .decode(type: KakaoAPIResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
