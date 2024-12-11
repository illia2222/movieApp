//
//  DataPersistanceManager.swift
//  MovieApp
//
//  Created by User on 24.08.2024.
//

import Foundation
import UIKit
import CoreData

class DataPersistanceManager {
    
    enum DatabaseError: Error {
        case failedToSaveData
        case failedToFetchData
        case failedToDeleteData
    }
    
    static let shared = DataPersistanceManager()
    
    func downloadTitleWith(with model: Title, completion: @escaping(Result<Void, Error>) -> Void ) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let item = TitleItemDownload(context: context)
        
        item.original_title = model.original_title
        item.id = Int64(model.id)
        item.media_type = model.media_type
        item.original_language = model.original_language
        item.original_name = model.original_name
        item.overview = model.overview
        item.poster_path = model.poster_path
        item.release_date = model.release_date
        item.vote_average = model.vote_average
        item.vote_count = Int64(model.vote_count)
        
        do {
            try context.save()
            completion(.success(()))
        }
        catch {
            completion(.failure(DatabaseError.failedToSaveData))
        }
        
    }
    
    func favouriteTitleWith(with model: Title, completion: @escaping(Result<Void, Error>) -> Void ) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let item = TitleItemFavourite(context: context)
        
        item.original_title = model.original_title
        item.id = Int64(model.id)
        item.media_type = model.media_type
        item.original_language = model.original_language
        item.original_name = model.original_name
        item.overview = model.overview
        item.poster_path = model.poster_path
        item.release_date = model.release_date
        item.vote_average = model.vote_average
        item.vote_count = Int64(model.vote_count)
        
        do {
            try context.save()
            completion(.success(()))
        }
        catch {
            completion(.failure(DatabaseError.failedToSaveData))
        }
        
    }
    
    func fetchingDownloadTitleFromDatabase(completion: @escaping (Result<[TitleItemDownload], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<TitleItemDownload>
        
        request = TitleItemDownload.fetchRequest()
        
        do {
            let titles = try context.fetch(request)
            completion(.success(titles))
            
        } catch {
            completion(.failure(DatabaseError.failedToFetchData))
        }
    }
    
    func fetchingFavouriteTitleFromDatabase(completion: @escaping (Result<[TitleItemFavourite], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<TitleItemFavourite>
        
        request = TitleItemFavourite.fetchRequest()
        
        do {
            let titles = try context.fetch(request)
            completion(.success(titles))
            
        } catch {
            completion(.failure(DatabaseError.failedToFetchData))
        }
    }
    
    func deleteDownloadTitleFromDatabaseWith(with model: TitleItemDownload,completion: @escaping(Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToDeleteData))
        }
    }
    
    func deleteFavouriteTitleFromDatabaseWith(with model: TitleItemFavourite,completion: @escaping(Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToDeleteData))
        }
    }
}
