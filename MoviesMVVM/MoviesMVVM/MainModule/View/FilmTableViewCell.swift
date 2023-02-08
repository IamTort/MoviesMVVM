// FilmTableViewCell.swift
// Copyright © PozolotinaAA. All rights reserved.

import UIKit

/// Ячейка фильма экрана первого
final class FilmTableViewCell: UITableViewCell {
    // MARK: - Private Enum

    private enum Constants {
        static let nameFont = "Helvetica-Bold"
        static let errorMessage = "init(coder:) has not been implemented"
        static let green = "green"
    }

    // MARK: - Private Visual Components

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont(name: Constants.nameFont, size: 17)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.black
        label.textAlignment = .natural
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let filmImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let rateView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = UIColor(named: Constants.green)
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let rateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.nameFont, size: 14)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let boxView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.gray.cgColor
        return view
    }()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = UITableViewCell.SelectionStyle.none
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Constants.errorMessage)
    }

    // MARK: - Private methods

    private func setupUI() {
        contentView.backgroundColor = .clear
        contentView.addSubview(boxView)
        boxView.addSubview(nameLabel)
        boxView.addSubview(descriptionLabel)
        boxView.addSubview(filmImageView)
        filmImageView.addSubview(rateView)
        rateView.addSubview(rateLabel)
        createConstraints()
    }

    private func createConstraints() {
        NSLayoutConstraint.activate([
            boxView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            boxView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            boxView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            boxView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            boxView.heightAnchor.constraint(equalToConstant: filmImageView.bounds.height + 20),

            filmImageView.topAnchor.constraint(equalTo: boxView.topAnchor, constant: 20),
            filmImageView.leadingAnchor.constraint(equalTo: boxView.leadingAnchor, constant: 20),
            filmImageView.bottomAnchor.constraint(equalTo: boxView.bottomAnchor, constant: -20),
            filmImageView.widthAnchor.constraint(equalTo: filmImageView.heightAnchor, multiplier: 0.7),

            nameLabel.topAnchor.constraint(equalTo: boxView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: filmImageView.trailingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: boxView.trailingAnchor, constant: -20),

            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0),
            descriptionLabel.leadingAnchor.constraint(equalTo: filmImageView.trailingAnchor, constant: 20),
            descriptionLabel.bottomAnchor.constraint(equalTo: boxView.bottomAnchor, constant: -15),
            descriptionLabel.trailingAnchor.constraint(equalTo: boxView.trailingAnchor, constant: -10),

            rateView.leadingAnchor.constraint(equalTo: filmImageView.leadingAnchor, constant: -10),
            rateView.topAnchor.constraint(equalTo: filmImageView.topAnchor, constant: 12),
            rateView.widthAnchor.constraint(equalToConstant: 35),
            rateView.heightAnchor.constraint(equalTo: rateView.widthAnchor, multiplier: 0.6),

            rateLabel.centerYAnchor.constraint(equalTo: rateView.centerYAnchor, constant: 0),
            rateLabel.centerXAnchor.constraint(equalTo: rateView.centerXAnchor, constant: 0),
            rateLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func colorRateView(data: Movie) {
        if data.rate >= 7 {
            rateView.backgroundColor = UIColor(named: Constants.green)
        } else {
            rateView.backgroundColor = .gray
        }
    }

    // MARK: - Public methods

    func setupData(data: Movie) {
        nameLabel.text = data.title
        descriptionLabel.text = data.overview
        rateLabel.text = "\(data.rate)"
        filmImageView.loadImage(with: data.poster)
        colorRateView(data: data)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        filmImageView.image = nil
    }
}
