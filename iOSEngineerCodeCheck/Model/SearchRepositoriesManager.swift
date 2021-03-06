//
//  GithubSearchManager.swift
//  iOSEngineerCodeCheck
//
//  Created by Tatsuya Amida on 2020/08/18.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import Foundation
import Alamofire

protocol SearchRepositoriesManagerDelegate: class {
    func didUpdateRepositories(repositoriesDetail: [RepositoryDetailModel])
    func didFailWithError(error: Error)
}

protocol ParseJSONProtocol {
    func parseJSON(_ repositoryData: Data) -> [RepositoryDetailModel]?
}

class DefaultParseJSON: ParseJSONProtocol {

    func parseJSON(_ repositoryData: Data) -> [RepositoryDetailModel]? {
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(RepositoryData.self, from: repositoryData)

            var repositoryDetailArray: [RepositoryDetailModel] = []
            let repositoryCount = decodeData.items.count

            for num in 0..<repositoryCount {
                let title = decodeData.items[num].full_name ?? ""
                let language = decodeData.items[num].language ?? "Unknown"
                let starsCount = decodeData.items[num].stargazers_count ?? 0
                let watchersCount = decodeData.items[num].watchers_count ?? 0
                let forksCount = decodeData.items[num].forks_count ?? 0
                let openIssuesCount = decodeData.items[num].open_issues ?? 0
                let avatarImageURL = decodeData.items[num].owner?.avatar_url ?? ""

                let repositoryDetail = RepositoryDetailModel(title: title, language: language, starsCount: starsCount, watchersCount: watchersCount, forksCount: forksCount, openIssuesCount: openIssuesCount, avatarImageURL: avatarImageURL)

                repositoryDetailArray.append(repositoryDetail)
            }

            return repositoryDetailArray

        } catch {
            print(error)
            return nil
        }

    }

}

class SearchRepositoriesManager {

    private let searchURL = "https://api.github.com/search/repositories?"

    weak var delegate: SearchRepositoriesManagerDelegate?
    let parseJSONProtocol: ParseJSONProtocol

    init(parseJSONProtocol: ParseJSONProtocol = DefaultParseJSON()) {
        self.parseJSONProtocol = parseJSONProtocol
    }

    func fetchRepositories(repoName: String) {
        let urlString = "\(searchURL)q=\(repoName)"

        performRequest(with: urlString)
    }

    private func performRequest(with urlString: String) {
        AF.request(urlString, method: .get).responseJSON { (response) in
            switch response.result {
            case .success:
                guard let safeData = response.data else { return }

                if let repositoriesDetail = self.parseJSONProtocol.parseJSON(safeData) {
                    self.delegate?.didUpdateRepositories(repositoriesDetail: repositoriesDetail)
                }
            case .failure(let error):
                self.delegate?.didFailWithError(error: error)
            }
        }
    }

}
