/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit

class PancakeHouseTableViewCell: UITableViewCell {

  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var pancakeImage : UIImageView!
  @IBOutlet weak var ratingImage: UIImageView!
  @IBOutlet weak var cityLabel: UILabel!
  @IBOutlet weak var priceGuideLabel: UILabel!
  @IBOutlet weak var extraDetailStackView: UIStackView!
  
  var pancakeHouse : PancakeHouse? {
    didSet {
      if let pancakeHouse = pancakeHouse {
        nameLabel?.text = pancakeHouse.name
        pancakeImage?.image = pancakeHouse.thumbnail ?? UIImage(named: "placeholder_thumb")
        ratingImage?.image = pancakeHouse.rating.smallRatingImage
        cityLabel?.text = pancakeHouse.city
        priceGuideLabel?.text = "\(pancakeHouse.priceGuide)"
      }
    }
  }
  
  var showExtraDetails : Bool = false {
    didSet {
      extraDetailStackView.hidden = !showExtraDetails
    }
  }
  
  func animateShowExtraDetails(show: Bool) {
    UIView.animateWithDuration(1.0) {
      self.showExtraDetails = show
    }
  }
}
