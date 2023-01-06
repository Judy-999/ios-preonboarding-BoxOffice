//
//  MovieDetailViewController.swift
//  BoxOffice
//
//  Created by Judy on 2023/01/04.
//

import UIKit

class MovieDetailViewController: UIViewController {
    private let entireStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let reviewTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ReviewTableViewCell.self,
                           forCellReuseIdentifier: "ReviewTableViewCell")
        return tableView
    }()

    private lazy var movieReviewView = MovieReviewView(tableView: reviewTableView)
    private let movieMainInfoView = MovieMainInfoView()
    private let movieSubInfoView = MovieSubInfoView()
    private let reviewViewModel = MovieReviewViewModel()
    private let movieDetail: MovieData
    
    init(movieDetail: MovieData) {
        self.movieDetail = movieDetail
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadReview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationItem()
        bind()
    }
    
    private func loadReview() {
        reviewViewModel.fetch()
    }
    
    private func bind() {
        reviewViewModel.reviews.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.reviewTableView.reloadData()
            }
        }
    }
}

//MARK: Review TableView
extension MovieDetailViewController: UITableViewDataSource {
    private func setupTableView() {
        reviewTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let reviewCount = reviewViewModel.reviews.value.count
        
        return reviewCount > 3 ? 3 : reviewCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReviewTableViewCell.identifier,
                                                       for: indexPath) as? ReviewTableViewCell else { return UITableViewCell() }
        let review = reviewViewModel.reviews.value[indexPath.row]
        cell.configure(with: review)
        
        return cell
    }
}

//MARK: Setup View
extension MovieDetailViewController {
    private func setupView() {
        movieMainInfoView.configure(with: movieDetail)
        movieSubInfoView.configure(with: movieDetail)

        addSubView()
        setupConstraint()
        setupTableView()
        addTagetButton()
        view.backgroundColor = .systemBackground
    }
    
    private func addSubView() {
        entireStackView.addArrangedSubview(movieMainInfoView)
        entireStackView.addArrangedSubview(movieSubInfoView)
        entireStackView.addArrangedSubview(movieReviewView)
        
        view.addSubview(entireStackView)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            entireStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            entireStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            entireStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            entireStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            movieMainInfoView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor,
                                                      multiplier: 1/3),
            movieReviewView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor,
                                                    multiplier: 5/10)
        ])
    }
}

//MARK: Button Action
extension MovieDetailViewController {
    private func addTagetButton() {
        movieSubInfoView.addTargetMoreButton(with: self,
                                             selector: #selector(moreActorButtonTapped))
        movieReviewView.addTargetWriteButton(with: self,
                                             selector: #selector(writeReviewButtonTapped))
        movieReviewView.addTargetMoreButton(with: self,
                                            selector: #selector(moreReviewButtonTapped))
    }
    
    @objc private func moreActorButtonTapped() {
        //TODO: 배우 더보기 modal
    }
    
    @objc private func writeReviewButtonTapped() {
        //TODO: 리뷰 쓰기 화면 이동
    }
    
    @objc private func moreReviewButtonTapped() {
        //TODO: 리뷰 테이블 페이지 이동
    }
}

//MARK: Setup NavigationItem
extension MovieDetailViewController {
    private func setupNavigationItem() {
        let shareBarButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(shareButtonTapped))
        
        navigationItem.rightBarButtonItem = shareBarButton
        navigationItem.title = movieDetail.title
    }
    
    @objc private func shareButtonTapped() {
        //TODO: 영화정보 공유하기
    }
}