//
//  AppError.swift
//  RecipeApp
//
//  Created by Ryan Smetana on 2/16/25.
//

import Foundation

enum AppError: Error {    
    case invalidImageData
    case invalidImage
    case invalidUrlString
    case fetchRecipeError(Error)
    case malformedResponse
        
    var localizedDescription: String {
        switch self {
        case .invalidImageData: "Data can not be converted to a UIImage"
        case .invalidImage: "Invalid image"
        case .invalidUrlString: "Invalid URL String"
        case .fetchRecipeError(let err): "A non coding key error was thrown while fetching recipes: \(err)"
        case .malformedResponse: "Malformed response data"
        }
    }
}

