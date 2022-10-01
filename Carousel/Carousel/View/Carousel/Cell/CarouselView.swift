//
//  CarouselView.swift
//  Carousel
//
//  Created by Agam Mishra on 01/10/22.
//

import UIKit

protocol CarouselViewProtocol: AnyObject {
    func carouselChanged(index: Int)
}

class CarouselView: UIView {

    var delegate: CarouselViewProtocol?
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.showsHorizontalScrollIndicator = false
                collectionView.isPagingEnabled = true
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.backgroundColor = .clear
            collectionView.register(UINib(nibName: "CarouselCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        }
    }
    @IBOutlet weak var pageControl: UIPageControl! {
        didSet {
            pageControl.pageIndicatorTintColor = .gray
            pageControl.currentPageIndicatorTintColor = .white
        }
    }
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            if let delegate = delegate {
                delegate.carouselChanged(index: currentPage)
            }
        }
    }
    var carouselData = [CarouselData]()
    override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            commonInit()
        }

        private func commonInit() {
            let bundle = Bundle(for: type(of: self))
            bundle.loadNibNamed("CarouselView", owner: self, options: nil)
            addSubview(contentView)
            contentView.frame = bounds
            contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            contentView.backgroundColor = .black
        }
    func configureView(with data: [CarouselData]) {
        let cellPadding:CGFloat = 0//(frame.width - 300) / 2
            let carouselLayout = UICollectionViewFlowLayout()
            carouselLayout.scrollDirection = .horizontal
            carouselLayout.itemSize = .init(width: frame.width, height: 300)
            carouselLayout.sectionInset = .init(top: 0, left: cellPadding, bottom: 0, right: cellPadding)
            carouselLayout.minimumLineSpacing = 0//frame.width - 300
            collectionView.collectionViewLayout = carouselLayout

            carouselData = data
            collectionView.reloadData()
        }
    func getCurrentPage() -> Int {

            let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            if let visibleIndexPath = collectionView.indexPathForItem(at: visiblePoint) {
                return visibleIndexPath.row
            }

            return currentPage
        }
}

extension CarouselView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
          return 1
       }

       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return carouselData.count
       }

       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CarouselCell else { return UICollectionViewCell() }

          let image = carouselData[indexPath.item].mainImage
           if let url = URL(string: image ?? "") {
               DispatchQueue.main.async {
                   cell.imgView.loadImageWithUrl(url)
               }
           }

          return cell
       }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            currentPage = getCurrentPage()
        }

        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            currentPage = getCurrentPage()
        }

        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            currentPage = getCurrentPage()
        }
}
