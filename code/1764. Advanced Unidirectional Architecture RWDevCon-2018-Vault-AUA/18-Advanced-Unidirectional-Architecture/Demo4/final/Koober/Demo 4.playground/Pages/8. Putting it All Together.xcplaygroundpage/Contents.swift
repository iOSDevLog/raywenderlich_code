/*:
 [Table of Contents](Table%20of%20Contents) | [Previous](@previous) | [Next](@next)
 ****
 # Putting it All Together

 Now that you've explored the tutorial's scenario, it's time to build out the settings view controller.
 */
import PlaygroundSupport

import UIKit
import ReSwift
import RxSwift

//: First, implement the settings view controller by including a new designated initializer with an observable parameter. Use the provided observable to render the screen:
class SettingsViewController: NiblessViewController {
  let stateObservable: Observable<SettingsViewState>
  let disposeBag = DisposeBag()
  let loadUserProfileUseCaseFactory: LoadUserProfileUseCaseFactory
  let updateClawedUseCaseFactory: UpdateClawedUseCaseFactory

  init(stateObservable: Observable<SettingsViewState>,
       loadUserProfileUseCaseFactory: LoadUserProfileUseCaseFactory,
       updateClawedUseCaseFactory: UpdateClawedUseCaseFactory) {
    self.stateObservable = stateObservable
    self.loadUserProfileUseCaseFactory = loadUserProfileUseCaseFactory
    self.updateClawedUseCaseFactory = updateClawedUseCaseFactory
    super.init()
  }

  var rootView: SettingsRootView {
    return view as! SettingsRootView
  }

  override func loadView() {
    view = SettingsRootView(ixResponder: self)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    subscribe(to: stateObservable)
  }

  func updateView(with viewState: SettingsViewState) {
    rootView.update(with: viewState)
  }

  func subscribe(to observable: Observable<SettingsViewState>) {
    observable.subscribe(
      onNext: { [weak self] viewState in
        self?.updateView(with: viewState)
    }).disposed(by: disposeBag)
  }
}

extension SettingsViewController: SettingsIXResponder {
  func loadUserProfile() {
    let useCase =
      loadUserProfileUseCaseFactory
        .makeLoadUserProfileUseCase()
    useCase.start()
  }

  public func update(clawed: Bool) {
    let useCase =
      updateClawedUseCaseFactory
        .makeUpdateClawedUseCase(clawed: clawed)
    useCase.start()
  }
}
//: Next, the settings view controller needs to be presented. To do that build a home view controller:
class HomeViewController: NiblessViewController {
  let settingsViewControllerFactory: SettingsViewControllerFactory
  let loadPersistedStateUseCaseFactory: LoadPersistedStateUseCaseFactory

  init(settingsViewControllerFactory: SettingsViewControllerFactory,
       loadPersistedStateUseCaseFactory: LoadPersistedStateUseCaseFactory) {
    self.settingsViewControllerFactory = settingsViewControllerFactory
    self.loadPersistedStateUseCaseFactory = loadPersistedStateUseCaseFactory
    super.init()
  }

  override func loadView() {
    self.view = HomeRootView(ixResponder: self)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    restorePersistedState()
  }

  func restorePersistedState() {
    let useCase =
      loadPersistedStateUseCaseFactory
        .makeLoadPersistedStateUseCase()
    useCase.start()
  }
}

extension HomeViewController: HomeIXResponder {
  public func goToSettings() {
    let settingsViewController =
      settingsViewControllerFactory.makeSettingsViewController()
    present(settingsViewController, animated: true)
  }
}

//: Finally, implement the dependency provider protocol:
class DependencyContainer: DependencyProvider {
  let reduxStore = Store<AppState>(reducer: reduce,
                                   state: nil)
  let userStore: PersistentUserStore = FakePersistentUserStore()
  let statePersister: StatePersister

  func makeSettingsViewStateObservable() -> Observable<SettingsViewState> {
    let observable =
      reduxStore
        .makeObservable { appState in
          return appState.settingsViewState
        }.distinctUntilChanged()
    return observable
  }

  init() {
    statePersister = ReduxStatePersister(reduxStore: reduxStore)
  }

  func makeSettingsViewController() -> UIViewController {
    let observable = makeSettingsViewStateObservable()
    return SettingsViewController(stateObservable: observable,
                                  loadUserProfileUseCaseFactory: self,
                                  updateClawedUseCaseFactory: self)
  }

  func makeLoadPersistedStateUseCase() -> UseCase {
    return LoadPersistedStateUseCase(userStore: userStore,
                                     reduxStore: reduxStore,
                                     statePersister: statePersister)
  }

  func makeUserRemoteAPI() -> UserRemoteAPI {
    return KooberUserRemoteAPI()
  }

  func makeLoadUserProfileUseCase() -> UseCase {
    let remoteAPI = makeUserRemoteAPI()
    return LoadUserProfileUseCase(remoteAPI: remoteAPI,
                                  reduxStore: reduxStore)
  }

  func makeUpdateClawedUseCase(clawed: Bool) -> UseCase {
    let userRemoteAPI = makeUserRemoteAPI()
    return UpdateClawedUseCase(clawed: clawed,
                               remoteAPI: userRemoteAPI,
                               reduxStore: reduxStore)
  }
}

//: Present the view controller in the live view window:
let dependencyContainer: DependencyProvider = DependencyContainer()
let homeViewController = HomeViewController(settingsViewControllerFactory: dependencyContainer,
                                            loadPersistedStateUseCaseFactory: dependencyContainer)
PlaygroundPage.current.liveView = homeViewController

/*:
 ****
 [Table of Contents](Table%20of%20Contents) | [Previous](@previous) | [Next](@next)
 */
