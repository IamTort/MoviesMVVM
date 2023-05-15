// FilmViewModelTests.swift
// Copyright © PozolotinaAA. All rights reserved.

@testable import MoviesMVVM
import XCTest

/// Тестирование вью-модели экрана с фильмом
final class FilmViewModelTests: XCTestCase {
    // MARK: - Private property

    private var imageServiceMock = ImageServiceMock()
    private var networkServiceMock = NetworkServiceMock()
    private var coreDataServiceMock = CoreDataServiceMock()
    private var filmViewModel: FilmViewModelProtocol?
    private var mockFilmIndex = 5

    // MARK: - Public methods

    override func setUp() {
        super.setUp()
        filmViewModel = FilmViewModel(
            imageService: imageServiceMock,
            networkService: networkServiceMock,
            coreDataService: coreDataServiceMock,
            filmIndex: mockFilmIndex
        )
    }

    override func tearDown() {
        super.tearDown()
        filmViewModel = nil
    }

    func testGetCoreDataMovie() {
        filmViewModel?.loadFilmData()
        XCTAssertEqual(filmViewModel?.filmInfo?.id, mockFilmIndex)
    }

    func testGetNetworkMovie() {
        filmViewModel?.loadFilmData()
        XCTAssertEqual(filmViewModel?.filmInfo?.id, 5)
    }
}
