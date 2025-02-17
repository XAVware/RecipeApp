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
    
    var localizedDescription: String {
        switch self {
        case .invalidImageData: "Data can not be converted to a UIImage"
        case .invalidImage: "Invalid image"
        case .invalidUrlString: "Invalid URL String"
        case .fetchRecipeError(let err): "Error while fetching recipes: \(err)"
        }
    }
}

