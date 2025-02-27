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

import Vapor
import Leaf

struct WebsiteController: RouteCollection {
  func boot(router: Router) throws {
    router.get(use: indexHandler)
    router.get("acronyms", Acronym.parameter, use: acronymHandler)
    router.get("users", User.parameter, use: userHandler)
    router.get("users", use: allUsersHandler)
    router.get("categories", Category.parameter, use: categoryHandler)
    router.get("categories", use: allCategoriesHandler)
    router.get("create-acronym", use: createAcronymHandler)
    router.post("create-acronym", use: createAcronymPostHandler)
    router.get("acronyms", Acronym.parameter, "edit", use: editAcronymHandler)
    router.post("acronyms", Acronym.parameter, "edit", use: editAcronymPostHandler)
    router.post("acronyms", Acronym.parameter, "delete", use: deleteAcronymHandler)
  }

  func indexHandler(_ req: Request) throws -> Future<View> {
    return Acronym.query(on: req).all().flatMap(to: View.self) { acronyms in
      let context = IndexContent(title: "Homepage", acronyms: acronyms.isEmpty ? nil : acronyms)
      return try req.leaf().render("index", context)
    }
  }

  func acronymHandler(_ req: Request) throws -> Future<View> {
    return try req.parameter(Acronym.self).flatMap(to: View.self) { acronym in
      return try flatMap(to: View.self, acronym.creator.get(on: req), acronym.categories.query(on: req).all()) { creator, categories in
        let context = AcronymContext(title: acronym.long, acronym: acronym, creator: creator, categories: categories.isEmpty ? nil : categories)
        return try req.leaf().render("acronym", context)
      }
    }
  }

  func userHandler(_ req: Request) throws -> Future<View> {
    return try req.parameter(User.self).flatMap(to: View.self) { user in
      return try user.acronyms.query(on: req).all().flatMap(to: View.self) { acronyms in
        let context = UserContext(title: user.name, user: user, acronyms: acronyms.isEmpty ? nil : acronyms)
        return try req.leaf().render("user", context)
      }
    }
  }

  func allUsersHandler(_ req: Request) throws -> Future<View> {
    return User.query(on: req).all().flatMap(to: View.self) { users in
      let context = AllUsersContext(title: "All Users", users: users)
      return try req.leaf().render("allUsers", context)
    }
  }

  func categoryHandler(_ req: Request) throws -> Future<View> {
    return try req.parameter(Category.self).flatMap(to: View.self) { category in
      return try category.acronyms.query(on: req).all().flatMap(to: View.self) { acronyms in
        let context = CategoryContext(title: category.name, category: category, acronyms: acronyms)
        return try req.leaf().render("category", context)
      }
    }
  }

  func allCategoriesHandler(_ req: Request) throws -> Future<View> {
    return Category.query(on: req).all().flatMap(to: View.self) { categories in
      let context = AllCategoriesContext(title: "All Categories", categories: categories)
      return try req.leaf().render("allCategories", context)
    }
  }

  func createAcronymHandler(_ req: Request) throws -> Future<View> {
    return User.query(on: req).all().flatMap(to: View.self) { users in
      let context = CreateAcronymContext(title: "Create An Acronym", users: users)
      return try req.leaf().render("createAcronym", context)
    }
  }

  func createAcronymPostHandler(_ req: Request) throws -> Future<Response> {
    return try req.content.decode(AcronymPostData.self).flatMap(to: Response.self) { data in
      let acronym = Acronym(short: data.acronymShort, long: data.acronymLong, creatorID: data.creator)
      return acronym.save(on: req).map(to: Response.self) { acronym in
        guard let id = acronym.id else {
          return req.redirect(to: "/")
        }
        return req.redirect(to: "/acronyms/\(id)")
      }
    }
  }

  func editAcronymHandler(_ req: Request) throws -> Future<View> {
    return try flatMap(to: View.self, req.parameter(Acronym.self), User.query(on: req).all()) { acronym, users in
      let context = EditAcronymContext(title: "Edit Acronym", acronym: acronym, users: users)
      return try req.leaf().render("createAcronym", context)
    }
  }

  func editAcronymPostHandler(_ req: Request) throws -> Future<Response> {
    return try flatMap(to: Response.self, req.parameter(Acronym.self), req.content.decode(AcronymPostData.self)) { acronym, data in
      acronym.short = data.acronymShort
      acronym.long = data.acronymLong
      acronym.creatorID = data.creator

      return acronym.save(on: req).map(to: Response.self) { acronym in
        guard let id = acronym.id else {
          return req.redirect(to: "/")
        }
        return req.redirect(to: "/acronyms/\(id)")
      }
    }
  }

  func deleteAcronymHandler(_ req: Request) throws -> Future<Response> {
    return try req.parameter(Acronym.self).flatMap(to: Response.self) { acronym in
      return acronym.delete(on: req).transform(to: req.redirect(to: "/"))
    }
  }
}

extension Request {
  func leaf() throws -> LeafRenderer {
    return try self.make(LeafRenderer.self)
  }
}

struct IndexContent: Encodable {
  let title: String
  let acronyms: [Acronym]?
}

struct AcronymContext: Encodable {
  let title: String
  let acronym: Acronym
  let creator: User
  let categories: [Category]?
}

struct UserContext: Encodable {
  let title: String
  let user: User
  let acronyms: [Acronym]?
}

struct AllUsersContext: Encodable {
  let title: String
  let users: [User]
}

struct CategoryContext: Encodable {
  let title: String
  let category: Category
  let acronyms: [Acronym]
}

struct AllCategoriesContext: Encodable {
  let title: String
  let categories: [Category]
}

struct CreateAcronymContext: Encodable {
  let title: String
  let users: [User]
}

import Foundation

struct AcronymPostData: Content {
  static var defaultMediaType = MediaType.urlEncodedForm
  let acronymLong: String
  let acronymShort: String
  let creator: UUID
}

struct EditAcronymContext: Encodable {
  let title: String
  let acronym: Acronym
  let users: [User]
  let editing = true
}
