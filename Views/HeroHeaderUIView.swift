//
//  HeroHeaderUIView.swift
//  MovieApp
//
//  Created by User on 16.08.2024.
//

import UIKit
import SDWebImage
import WebKit

class HeroHeaderUIView: UIView {

    private lazy var heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "moviePoster")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(didTapPlayButton), for: .touchUpInside)
        return button
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 0.9
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 5
        
        let blurEffect = UIBlurEffect(style: .dark) // Выберите стиль .light, .dark, .extraLight и т.д.
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = button.bounds
        blurEffectView.isUserInteractionEnabled = false // Отключаем взаимодействие, чтобы кнопка работала
        blurEffectView.layer.cornerRadius = 5
        blurEffectView.clipsToBounds = true
        
        blurEffectView.alpha = 0.5

            // Добавление эффекта размытия в кнопку
        button.insertSubview(blurEffectView, at: 0)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(heroImageView)
        addGradient()
        addSubview(playButton)
        addSubview(downloadButton)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        heroImageView.frame = bounds
        
        if let blurEffectView = downloadButton.subviews.first(where: { $0 is UIVisualEffectView }) {
            blurEffectView.frame = downloadButton.bounds
        }
    }
    
    @objc func didTapPlayButton() {
        print("Play movie")
//        configure(with:TitlePreviewViewModel(youtubeVideo: <#T##VideoElement#>, title: <#T##String#>, overview: <#T##String#>, rate: <#T##Double#>))
    }
//    
//    func configure(with model: TitlePreviewViewModel) {
//        
//        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeVideo.id.videoId)") else { return }
//        webView.load(URLRequest(url: url))
//    }
    
    
    public func configure(with model: TitleViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else { return }
        heroImageView.sd_setImage(with: url, completed: nil)
    }
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor, UIColor.black.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    private func addConstraints() {
        let playButtonConstraints = [
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 60),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            playButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        
        let downloadButtonConstraints = [
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            downloadButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
}
