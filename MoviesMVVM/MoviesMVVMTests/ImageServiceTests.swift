// ImageServiceTests.swift
// Copyright © PozolotinaAA. All rights reserved.

@testable import MoviesMVVM
import XCTest

/// Тестирование сервиса по загрузке картинок
final class ImageServiceTests: XCTestCase {
    // MARK: - Public property

    var imageService: ImageService?
    var mockProxy: MockProxy?

    // MARK: - Private property

    private let mockUrl = "url"

    // MARK: - Public methods

    override func setUp() {
        super.setUp()
        mockProxy = MockProxy()
        guard let mockProxy = mockProxy else {
            return
        }
        imageService = ImageService(proxy: mockProxy)
    }

    override func tearDown() {
        super.tearDown()
        imageService = nil
        mockProxy = nil
    }

    func testLoadImage() {
        imageService?.proxy.loadImage(by: mockUrl) { result in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, Data(count: 10))
            case let .failure(error):
                XCTAssertNotNil(error)
            }
        }
    }
}
