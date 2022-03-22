//
//  Error+Result.swift
//  Superheroes
//
//  Created by Kacper Trębacz on 22/03/2022.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}

enum ErrorType: Error {
    case errorFetchingData
    case errorSavingData
    case errorDownloadingData

    var returnMessage: String {
        switch self {
        case .errorFetchingData:
            return "Error fetching data"
        case .errorSavingData:
            return "Error saving data"
        case .errorDownloadingData:
            return "Error while downloading data"
        }
    }
}
