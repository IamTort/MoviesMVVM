// MoviesViewModelTests.swift
// Copyright © PozolotinaAA. All rights reserved.

@testable import MoviesMVVM
import XCTest

/// Тестирование вью-модели экрана с фильмами
final class MoviesViewModelTests: XCTestCase {
    // MARK: - Private Enum

    private enum Constants {
        static let key = "apiKey"
    }

    // MARK: - Private property

    private let apiKeyValue = "testKey"
    private var moviesViewModel: MoviesViewModel?
    private var imageServiceMock = ImageServiceMock()
    private var networkServiceMock = NetworkServiceMock()
    private var coreDataServiceMock = CoreDataServiceMock()
    private var keychainServiceMock = KeychainServiceMock()

    // MARK: - Public methods

    override func setUp() {
        super.setUp()
        moviesViewModel = MoviesViewModel(
            imageService: imageServiceMock,
            networkService: networkServiceMock,
            coreDataService: coreDataServiceMock,
            keychainService: keychainServiceMock
        )
    }

    override func tearDown() {
        super.tearDown()
        moviesViewModel = nil
    }

    func testFetchNewCategory() throws {
        moviesViewModel?.fetchMoviesNewCategory(api: .topRated)
        XCTAssertTrue(moviesViewModel?.films.count != 0)
        moviesViewModel?.fetchMoviesNewCategory(api: .popular)
        XCTAssertTrue(moviesViewModel?.films.count != 0)
    }

    func testStartApp() {
        moviesViewModel?.fetchFilmsData()
        XCTAssertTrue(moviesViewModel?.films.count != 0)
    }

    func testCheckApiKey() {
        moviesViewModel?.setApiKey(apiKeyValue)
        let key = keychainServiceMock.getAPIKey(Constants.key)
        XCTAssertEqual(apiKeyValue, key)
    }

    func testCategory() {
        moviesViewModel?.updateMoviesCategory(sender: 0)
        XCTAssertEqual(moviesViewModel?.category, .popular)
        moviesViewModel?.updateMoviesCategory(sender: 1)
        XCTAssertEqual(moviesViewModel?.category, .topRated)
        moviesViewModel?.updateMoviesCategory(sender: 2)
        XCTAssertEqual(moviesViewModel?.category, .upcoming)
    }

    func testInfinityScroll() {
        moviesViewModel?.fetchFilmsData()
        moviesViewModel?.loadMore()
        guard let moviesCount = moviesViewModel?.films.count else { return }
        XCTAssertTrue(moviesCount > 1)
    }
}
