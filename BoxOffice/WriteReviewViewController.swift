//
//  WriteReviewViewController.swift
//  BoxOffice
//
//  Created by Judy on 2023/01/03.
//

import UIKit

class WriteReviewViewController: UIViewController {
    private let photoView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo.on.rectangle.angled")
        imageView.tintColor = .black
        imageView.backgroundColor = .systemGray6
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nickNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "닉네임을 입력해주세요."
        textField.borderStyle = .roundedRect
        textField.font = .preferredFont(forTextStyle: .title3)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "암호를 입력해주세요."
        textField.borderStyle = .roundedRect
        textField.font = .preferredFont(forTextStyle: .title3)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let contentTextView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        textView.layer.borderColor = UIColor.systemGray5.cgColor
        textView.layer.borderWidth = 2
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let textFieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let photoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let entireStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let ratingStarView = StarRatingView()
    private var password = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupDelegate()
    }
    
    private func setupView() {
        addSubView()
        setupConstraint()
        setupNavigationItem()
        view.backgroundColor = .systemBackground
    }
    
    private func addSubView() {
        textFieldStackView.addArrangedSubview(nickNameTextField)
        textFieldStackView.addArrangedSubview(passwordTextField)
        
        photoStackView.addArrangedSubview(photoView)
        photoStackView.addArrangedSubview(textFieldStackView)
        
        entireStackView.addArrangedSubview(ratingStarView)
        entireStackView.addArrangedSubview(photoStackView)
        entireStackView.addArrangedSubview(contentTextView)
        
        view.addSubview(entireStackView)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            entireStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                 constant: 8),
            entireStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                 constant: -8),
            entireStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                 constant: 16),
            entireStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                 constant: -16),
        
            photoView.widthAnchor.constraint(equalTo: photoView.heightAnchor)
        ])
    }
}

//MARK: NavigationItem Setting
extension WriteReviewViewController {
    private func setupNavigationItem() {
        let saveBarButton = UIBarButtonItem(title: "저장",
                                            style: .done,
                                            target: self,
                                            action: #selector(saveBarButtonTapped))
        
        navigationItem.rightBarButtonItem = saveBarButton
        //TODO: 영화 제목 넘겨받기
        navigationItem.title = "영화 제목"
    }
    
    @objc private func saveBarButtonTapped() {
        //TODO: 리뷰 저장하기
        
        navigationController?.popViewController(animated: true)
    }
}

//MARK: Password Process
extension WriteReviewViewController: UITextFieldDelegate {
    private func setupDelegate() {
        passwordTextField.delegate = self
    }
    
    private func validatePassword() -> Bool {
        let number = convert("0123456789")
        let specialCharacters = convert("!@#$")
        let alphabet = convert("abcdefghijklmnopqrstuvwxyz")
        let checkingPassword = convert(password)
        
        guard checkingPassword.intersection(number).isEmpty == false,
              checkingPassword.intersection(specialCharacters).isEmpty == false,
              checkingPassword.intersection(alphabet).isEmpty == false else {
            return false
        }
        
        return true
    }
    
    private func convert(_ text: String) -> Set<String> {
        var newSet: Set<String> = []
        
        text.forEach {
            newSet.update(with: String($0))
        }
        
        return newSet
    }
    
    //TODO: text를 지우는 경우 password에서 지워지지 않고 그대로 쌓임
    private func setupPassword(with textField: UITextField) {
        if let text = textField.text, let lastText = text.last {
            password += String(lastText)
            textField.text = String(repeating: "*", count: text.count)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        setupPassword(with: textField)
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        setupPassword(with: textField)
        
        return true
    }
}
