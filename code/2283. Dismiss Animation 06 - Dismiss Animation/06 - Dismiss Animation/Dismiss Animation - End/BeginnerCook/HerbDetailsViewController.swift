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

class HerbDetailsViewController: UIViewController, UIViewControllerTransitioningDelegate {
  
  @IBOutlet var containerView: UIView!
  
  @IBOutlet var bgImage: UIImageView!
  @IBOutlet var titleView: UILabel!
  @IBOutlet var descriptionView: UITextView!
  @IBOutlet var licenseButton: UIButton!
  @IBOutlet var authorButton: UIButton!
  
  var herb: HerbModel!
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    bgImage.image = UIImage(named: herb.image)
    titleView.text = herb.name
    descriptionView.text = herb.description
    
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionClose(_:))))
  }
  
  @objc func actionClose(_ tap: UITapGestureRecognizer) {
    presentingViewController?.dismiss(animated: true, completion: nil)
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  //MARK: button actions
  
  @IBAction func actionLicense(_ sender: AnyObject) {
    UIApplication.shared.open(URL(string: herb!.license)!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
  }
  
  @IBAction func actionAuthor(_ sender: AnyObject) {
    UIApplication.shared.open(URL(string: herb!.credit)!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
  }
  
  
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
