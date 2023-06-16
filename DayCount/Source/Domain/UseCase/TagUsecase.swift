//
//  TagUsecase.swift
//  DayCount
//
//  Created by ChangMin on 2023/06/08.
//

import Foundation

protocol TagUsecaseProtocol {
    func addTag(tag: Tag)
    func fetchTagList() -> TagList?
}

final class TagUsecase: TagUsecaseProtocol {
    private let tagRepository: TagRepositoryProtocol
    
    // MARK: Initializer
    init(repository: TagRepositoryProtocol) {
        tagRepository = repository
    }
    
    // MARK: Methods
    func addTag(tag: Tag) {
        if let tagList = tagRepository.fetchTag() {
            if tagList.contains(where: { $0.title == tag.title }) == false {
                tagRepository.saveTag(tag: tag)
            }
        }
    }
    
    func fetchTagList() -> TagList? {
        return tagRepository.fetchTag()
    }
}
