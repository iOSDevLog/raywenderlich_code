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

class CardStackLayout: UICollectionViewLayout {
  
  private var panGestureRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer()
  
  override func prepare() {
    super.prepare()
    
    panGestureRecognizer.addTarget(self, action: #selector(handlePan(gestureRecognizer:)))
    collectionView?.addGestureRecognizer(panGestureRecognizer)
  }
  
  fileprivate func indexPathsForElementsInRect(_ rect: CGRect) -> [IndexPath] {
    var indexPaths: [IndexPath] = []
    
    if let numItems = collectionView?.numberOfItems(inSection: 0), numItems > 0 {
      for i in 0...numItems-1 {
        indexPaths.append(IndexPath(item: i, section: 0))
      }
    }
    
    return indexPaths
  }
  
  @objc func handlePan(gestureRecognizer: UIPanGestureRecognizer) {
    print("panning")
  }
  
  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    
    // Here we can just target the top two items on the stack
    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
    
    attributes.frame = collectionView?.bounds ?? .zero
    
    var isNotTop = false
    if let numItems = collectionView?.numberOfItems(inSection: 0), numItems > 0 {
      isNotTop = indexPath.row != numItems - 1
    }
    
    attributes.alpha = isNotTop ? 0 : 1
    
    return attributes
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    let indexPaths = indexPathsForElementsInRect(rect)
    let layoutAttributes = indexPaths.map { layoutAttributesForItem(at: $0) }
      .filter { $0 != nil }.map { $0! }
    
    return layoutAttributes
    
  }
}

