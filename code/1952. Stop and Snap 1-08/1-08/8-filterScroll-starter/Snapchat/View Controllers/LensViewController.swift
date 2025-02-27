/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class LensViewController: UIViewController {
  @IBOutlet weak var faceImage: UIImageView!
  @IBOutlet weak var lensCollectionView: UICollectionView!
  
  private lazy var lensFiltersImages: [UIImage] = {
    var images: [UIImage] = []
    for i in 0...19 {
      guard let image = UIImage(named: "face\(i)") else { break }
      images.append(image)
    }
    return images
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    lensCollectionView.delegate = self
    lensCollectionView.dataSource = self
    lensCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
    lensCollectionView.register(LensCircleCell.self, forCellWithReuseIdentifier: LensCircleCell.identifier)
  }
}

// MARK: UICollectionViewDelegate
extension LensViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return lensFiltersImages.count
  }
}

// MARK: UICollectionViewDataSource
extension LensViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LensCircleCell.identifier, for: indexPath) as? LensCircleCell else { fatalError() }
    
    cell.image = lensFiltersImages[indexPath.row]
    return cell
  }
}

// MARK: UICollectionViewDelegateFlowLayout
extension LensViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let side = lensCollectionView.frame.height * 0.9
    return CGSize(width: side, height: side)
  }
}
