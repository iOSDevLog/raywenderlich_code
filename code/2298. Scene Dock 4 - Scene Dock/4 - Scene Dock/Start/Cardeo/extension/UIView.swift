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

extension UIView {
  func addSubview(
    _ subview: UIView,
    constrainedTo anchorsView: UIView
  ) {
    addSubview(subview)
    subview.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      subview.centerXAnchor.constraint(equalTo: anchorsView.centerXAnchor),
      subview.centerYAnchor.constraint(equalTo: anchorsView.centerYAnchor),
      subview.widthAnchor.constraint(equalTo: anchorsView.widthAnchor),
      subview.heightAnchor.constraint(equalTo: anchorsView.heightAnchor)
    ])
  }

  func animateIn(handleCompletion: ( () -> Void )? = nil) {
    transform = CGAffineTransform.identity.scaledBy(x: 0.5, y: 0.5)
    alpha = 0
    isHidden = false

    UIView.animate(
      withDuration: 0.5,
      delay: 0,
      usingSpringWithDamping: 0.4,
      initialSpringVelocity: 0.5,
      animations: {
        self.alpha = 1
        self.transform = .identity
      },
      completion: handleCompletion.map { handleCompletion in
        { _ in handleCompletion() }
      }
    )
  }

  func roundCorners() {
    let cardRadius = bounds.maxX / 6
    layer.cornerRadius = cardRadius
  }
}
