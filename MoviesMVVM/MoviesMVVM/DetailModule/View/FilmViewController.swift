// FilmViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Экран "информация о фильме"
final class FilmViewController: UIViewController {
    // MARK: - Private Enum

    private enum Constants {
        static let starImageName = "star"
        static let rateLabelFont = "Helvetica"
        static let taglineLabelFont = "Avenir-Oblique"
        static let descriptionTitleText = "Обзор"
        static let descriptionTitleFont = "Avenir-Medium"
        static let rightImageName = "right"
        static let trailerLabelText = "Посмотреть трейлер"
        static let trailerLabelFont = "Avenir-Medium"
        static let dotChar = " \u{2022} "
        static let imdbFullRateString = "/10 IMDb"
        static let hoursString = "ч"
        static let minutesString = "мин"
        static let errorString = "Error"
    }

    // MARK: - Private Visual Components

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let filmImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .top
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.clipsToBounds = true
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()

    private let boxView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Constants.starImageName)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .black

        label.contentCompressionResistancePriority(for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let genresLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let rightImageView: UIImageView = {
        let image = UIImageView(image: UIImage(named: Constants.rightImageName))
        image.image?.withTintColor(.black, renderingMode: .alwaysTemplate)
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private let rateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont(name: Constants.rateLabelFont, size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let taglineLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.textAlignment = .natural
        label.font = UIFont(name: Constants.taglineLabelFont, size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.descriptionTitleText
        label.textColor = .black
        label.font = UIFont(name: Constants.descriptionTitleFont, size: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var trailerLabel: UIButton = {
        let label = UIButton(type: .custom)
        label.setTitle(Constants.trailerLabelText, for: .normal)
        label.titleLabel?.font = UIFont(name: Constants.trailerLabelFont, size: 22)
        label.titleLabel?.textColor = .white
        label.addTarget(self, action: #selector(goWebViewAction), for: .touchUpInside)
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var webViewButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(goWebViewAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Public property

    weak var coordinator: MainCoordinator?
    var filmIndex: Int?

    // MARK: - Private property

    private var filmViewModel: FilmViewModelProtocol?

    // MARK: - Initializer

    init(filmViewModel: FilmViewModelProtocol) {
        self.filmViewModel = filmViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        filmViewModel?.loadFilmData()
        updateTableView()
        alertView()
        makeImageView()
    }

    // MARK: - Private methods

    private func updateTableView() {
        filmViewModel?.updateViewData = {
            guard let film = self.filmViewModel?.filmInfo else { return }
            DispatchQueue.main.async {
                self.setupData(data: film)
            }
        }
    }

    private func alertView() {
        filmViewModel?.alertData = { alert in
            DispatchQueue.main.async {
                self.showErrorAlert(title: Constants.errorString, message: alert)
            }
        }
    }

    private func makeImageView() {
        filmViewModel?.imageData = { imageData in
            DispatchQueue.main.async {
                self.filmImageView.image = UIImage(data: imageData)
            }
        }
    }

    private func setupUI() {
        view.backgroundColor = .systemGray5
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(bottomView)
        view.addSubview(filmImageView)
        view.addSubview(scrollView)
        filmImageView.addSubview(webViewButton)
        filmImageView.addSubview(trailerLabel)
        webViewButton.addSubview(rightImageView)
        scrollView.addSubview(boxView)
        boxView.addSubview(titleLabel)
        boxView.addSubview(starImageView)
        boxView.addSubview(rateLabel)
        boxView.addSubview(taglineLabel)
        boxView.addSubview(descriptionTitleLabel)
        boxView.addSubview(descriptionLabel)
        boxView.addSubview(genresLabel)
        createConstraint()
    }

    private func createConstraint() {
        NSLayoutConstraint.activate([
            filmImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 90),
            filmImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            filmImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            filmImageView.heightAnchor.constraint(equalToConstant: 450),

            scrollView.topAnchor.constraint(equalTo: filmImageView.bottomAnchor, constant: -150),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            boxView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            boxView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            boxView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            boxView.bottomAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            boxView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),

            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            bottomView.heightAnchor.constraint(equalToConstant: 400),

            titleLabel.topAnchor.constraint(equalTo: boxView.topAnchor, constant: 25),
            titleLabel.leadingAnchor.constraint(equalTo: boxView.leadingAnchor, constant: 20),
            titleLabel.widthAnchor.constraint(equalToConstant: view.bounds.width - 80),

            genresLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            genresLabel.leadingAnchor.constraint(equalTo: boxView.leadingAnchor, constant: 20),
            genresLabel.trailingAnchor.constraint(equalTo: boxView.trailingAnchor, constant: -20),

            starImageView.topAnchor.constraint(equalTo: genresLabel.bottomAnchor, constant: 15),
            starImageView.leadingAnchor.constraint(equalTo: boxView.leadingAnchor, constant: 20),
            starImageView.widthAnchor.constraint(equalToConstant: 20),
            starImageView.heightAnchor.constraint(equalToConstant: 20),

            rateLabel.bottomAnchor.constraint(equalTo: starImageView.bottomAnchor, constant: 2),
            rateLabel.leadingAnchor.constraint(equalTo: starImageView.trailingAnchor, constant: 10),

            taglineLabel.topAnchor.constraint(equalTo: starImageView.bottomAnchor, constant: 15),
            taglineLabel.leadingAnchor.constraint(equalTo: boxView.leadingAnchor, constant: 20),
            taglineLabel.widthAnchor.constraint(equalTo: boxView.widthAnchor, constant: -40),

            descriptionTitleLabel.topAnchor.constraint(equalTo: taglineLabel.bottomAnchor, constant: 8),
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: boxView.leadingAnchor, constant: 20),

            descriptionLabel.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: boxView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: boxView.trailingAnchor, constant: -20),
            descriptionLabel.bottomAnchor.constraint(equalTo: boxView.bottomAnchor, constant: 20),

            webViewButton.leadingAnchor.constraint(equalTo: filmImageView.leadingAnchor, constant: 10),
            webViewButton.topAnchor.constraint(equalTo: filmImageView.topAnchor, constant: 250),
            webViewButton.heightAnchor.constraint(equalToConstant: 40),
            webViewButton.widthAnchor.constraint(equalToConstant: 40),

            rightImageView.heightAnchor.constraint(equalToConstant: 20),
            rightImageView.widthAnchor.constraint(equalToConstant: 20),
            rightImageView.topAnchor.constraint(equalTo: webViewButton.topAnchor, constant: 10),
            rightImageView.leadingAnchor.constraint(equalTo: webViewButton.leadingAnchor, constant: 12),

            trailerLabel.leadingAnchor.constraint(equalTo: webViewButton.trailingAnchor, constant: 10),
            trailerLabel.bottomAnchor.constraint(equalTo: webViewButton.bottomAnchor, constant: 2)

        ])
    }

    private func setupData(data: Film) {
        navigationItem.title = data.title
        filmViewModel?.loadImage()
        titleLabel.attributedText = NSMutableAttributedString().normal("\(data.title) ")
            .normalGray("(\(data.release.prefix(4)))")
        rateLabel.text = "\(data.rate)" + Constants.imdbFullRateString
        taglineLabel.text = "\(data.tagline)"
        descriptionLabel.text = data.overview
        genresLabel.text =
            "\(data.genres.map(\.name).joined(separator: ", ")) \(Constants.dotChar) \((data.runtime) / 60)" +
            " \(Constants.hoursString) \((data.runtime) % 60) \(Constants.minutesString)"
    }

    @objc private func goWebViewAction() {
        let fvc = WebViewController()
        fvc.filmIndex = filmIndex
        present(fvc, animated: true)
    }
}
