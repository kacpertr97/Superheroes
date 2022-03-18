//
//  Webservices.swift
//  Superheroes
//
//  Created by Kacper Trębacz on 18/03/2022.
//

import Foundation
import RxSwift

struct Resource<T> {
    let url: URL
}

enum Webservices {
    static func fetchData<T: Codable>(resource: Resource<T>) -> Observable<T> {
        let request = URLRequest(url: resource.url)
        return URLSession.shared.rx.data(request: request)
            .map { data in
                try JSONDecoder().decode(T.self, from: data)
            }.observe(on: MainScheduler.asyncInstance)
    }

    static func fetchImg(url: String) -> Observable<Data>? {
        guard let url = URL(string: url) else { return nil }
        let request = URLRequest(url: url)
        return URLSession.shared.rx.data(request: request)
    }
}
