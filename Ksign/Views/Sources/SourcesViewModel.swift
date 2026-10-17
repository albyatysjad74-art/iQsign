//
//  SourcesViewModel.swift
//  iQsign
//
//  Created by samara on 30.04.2025.
//  Modified by idk
//

import Foundation
import AltSourceKit
import SwiftUI
import CoreData
import NimbleJSON

// MARK: - Class
final class SourcesViewModel: ObservableObject {
	static let shared = SourcesViewModel()
	
	typealias RepositoryDataHandler = Result<ASRepository, Error>
	
	private let _dataService = NBFetchService()
	
	var isFinished = true
	@Published var sources: [AltSource: ASRepository] = [:]
	
	// رابط سورس المتجر الافتراضي
	private let defaultRepoURLString = "https://raw.githubusercontent.com/ikiraplus/ipastore/main/jom.json"
	
	init() {
		checkAndAddDefaultSource()
	}
	
	/// التحقق من وجود السورس الافتراضي وإضافته تلقائياً عند التشغيل الأول
	func checkAndAddDefaultSource() {
		guard let defaultURL = URL(string: defaultRepoURLString) else { return }
		
		let context = Storage.shared.context
		let request: NSFetchRequest<AltSource> = AltSource.fetchRequest()
		request.predicate = NSPredicate(format: "sourceURL == %@", defaultURL as CVarArg)
		
		do {
			let count = try context.count(for: request)
			if count == 0 {
				let newSource = AltSource(context: context)
				newSource.sourceURL = defaultURL
				newSource.name = "iQsign Store"
				newSource.identifier = "com.iqsign.store"
				newSource.dateAdded = Date()
				
				try context.save()
			}
		} catch {
			print("Error inserting default source: \(error)")
		}
	}
	
	func fetchSources(_ sources: FetchedResults<AltSource>, refresh: Bool = false, batchSize: Int = 4) async {
		guard isFinished else { return }
		
		if !refresh, sources.allSatisfy({ self.sources[$0] != nil }) { return }
		
		isFinished = false
		defer { isFinished = true }
		
		await MainActor.run {
			self.sources = [:]
		}
		
		let sourcesArray = Array(sources)
		
		for startIndex in stride(from: 0, to: sourcesArray.count, by: batchSize) {
			let endIndex = min(startIndex + batchSize, sourcesArray.count)
			let batch = sourcesArray[startIndex..<endIndex]
			
			let batchResults = await withTaskGroup(of: (AltSource, ASRepository?).self, returning: [AltSource: ASRepository].self) { group in
				for source in batch {
					group.addTask {
						guard let url = source.sourceURL else {
							return (source, nil)
						}
						
						return await withCheckedContinuation { continuation in
							self._dataService.fetch(from: url) { (result: RepositoryDataHandler) in
								switch result {
								case .success(let repo):
									continuation.resume(returning: (source, repo))
								case .failure(_):
									continuation.resume(returning: (source, nil))
								}
							}
						}
					}
				}
				
				var results = [AltSource: ASRepository]()
				for await (source, repo) in group {
					if let repo {
						results[source] = repo
					}
				}
				return results
			}
			
			await MainActor.run {
				for (source, repo) in batchResults {
					self.sources[source] = repo
				}
			}
		}
	}
}
