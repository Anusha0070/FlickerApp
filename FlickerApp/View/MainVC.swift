//
//  MainVC.swift
//  FlickerApp
//
//  Created by Anusha Raju on 12/13/24.
//


import UIKit

class MainVC: UIViewController {
    
    var searchBar : UISearchBar = {
        var searchBar = UISearchBar()
        searchBar.placeholder = "Search..."
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

    var photoCollectionView : UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    var activityIndicator : UIActivityIndicatorView = {
        var activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .medium
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    var flickrVM = FlickrVM()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupCollectionView()
        layoutSubviews()
        setupConstraints()
        getData()
    }
    
    func setupSearchBar() {
        searchBar.delegate = self
    }

    func setupCollectionView() {
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
        photoCollectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCell")
    }
    
    func layoutSubviews() {
        view.addSubview(searchBar)
        view.addSubview(photoCollectionView)
        view.addSubview(activityIndicator)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            
            photoCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            photoCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            photoCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            photoCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    func getData() {
        flickrVM.onSearchStarted = { [weak self] in
            DispatchQueue.main.async {
                self?.photoCollectionView.isHidden = true
                self?.activityIndicator.startAnimating()
            }
        }
        flickrVM.onDataUpdated = { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.photoCollectionView.isHidden = false
            self?.photoCollectionView.reloadData()
        }
        flickrVM.getFlickrData(url: ServerConstants.baseURL)
    }

}

extension MainVC: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flickrVM.getDataCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCollectionViewCell else{
            return UICollectionViewCell()
        }
        
        let flickrData = flickrVM.getFlickrItem(index: indexPath.row)
        let imageURL = flickrData?.media?.m
        
        ImageDownloader.shared.getImage(url: imageURL) { image in
            DispatchQueue.main.async {
                cell.photoImg.image = image
            }
        }
        return cell
    }
    
}

extension MainVC: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 120) // Cell size is slightly larger than the image
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let newScreen = storyboard?.instantiateViewController(identifier: "PhotoDetailsVC") as? PhotoDetailsVC else {
            return
        }
        let imgDetails = flickrVM.cleanedImageDetails(index: indexPath.row)
        newScreen.details = imgDetails
        navigationController?.pushViewController(newScreen, animated: true)
    }
    
}

extension MainVC: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        flickrVM.getFilteredImages(searchText: searchText)
    }
}

