
import UIKit

class BusinessPageViewController: UIPageViewController,movePageController {
    
    private var currentCount = 0
    private var currentIndex = 0
    private var lastPosition: CGFloat = 0
    var stepLabel: UILabel!
    var backBtn : UIBarButtonItem!
    
    
    private var scrollViewFixedHeight:CGFloat = 0.0
    private var pageControlY:CGFloat = 0.0
    
    var updatedControllers = [UIViewController]()
    
    lazy var controllers: [UIViewController] = {
        return [
            self.getViewController(withIdentifier: ViewControllersIds.BasicInformationViewControllerID),
            self.getViewController(withIdentifier: ViewControllersIds.LocationViewControllerID),
            self.getViewController(withIdentifier: ViewControllersIds.PinLocationViewControllerID),
            self.getViewController(withIdentifier: ViewControllersIds.AddPhotosViewControllerID),
            self.getViewController(withIdentifier: ViewControllersIds.WorkingHoursViewControllerID),
            self.getViewController(withIdentifier: ViewControllersIds.ListServiceViewControllerID),
            self.getViewController(withIdentifier: ViewControllersIds.TherapistListViewControllerID)
        ]
    }()
    
    func getViewController(withIdentifier identifier: String) -> UIViewController
    {
        return AppStoryboard.Business.instance.instantiateViewController(withIdentifier: identifier)
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.navigationItem.hidesBackButton = true
        self.view.backgroundColor = UIColor.white
        hideBackButtonTitle()
        addFirstController()
        updateScrollDelegation(true)
        self.dataSource = self
        self.delegate = self
        
        let xPosition = (self.view.bounds.size.width * 0.5) - 30.0
        stepLabel = UILabel(frame: CGRect(x: xPosition, y: 700, width: 60, height: 60))
        stepLabel.textColor = UIColor.lightGray
        stepLabel.font = UIFont.systemFont(ofSize: 15)
        stepLabel.text = localizedTextFor(key: BusinessPageViewControllerSceneText.businessPageViewControllerStepText.rawValue) + " " + (currentCount + 1).description
        self.view.addSubview(stepLabel)
        
        backBtn =  UIBarButtonItem(image: #imageLiteral(resourceName: "whiteBackIcon"), style: .plain, target: self, action: #selector(self.moveToPreviousPage))
        self.navigationItem.leftBarButtonItem = backBtn
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        
    }
    
    override func viewDidLayoutSubviews() {
        for subView in self.view.subviews {
            if let scrollView = subView as? UIScrollView {
                if currentCount == 0 {
                    scrollViewFixedHeight = self.view.bounds.size.height - 60
                }
                scrollView.frame.size.height = scrollViewFixedHeight
            }
            if let pageControl = subView as? UIPageControl {
                pageControl.currentPageIndicatorTintColor = appBarThemeColor
                pageControl.pageIndicatorTintColor =  appSignupBtnBackGroundColor
                pageControl.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                pageControl.isUserInteractionEnabled = false
                if currentCount == 0 {
                    pageControlY = pageControl.frame.origin.y - 15
                }
                pageControl.frame.origin.y = pageControlY
                ////////////////////////////////////////
                // provide 25 with respect to iphone sizes
                stepLabel.frame.origin.y = pageControl.frame.origin.y + 25
                ////////////////////////////////////////
                
            }
        }
        super.viewDidLayoutSubviews()
    }
    
    func updateScrollDelegation(_ bool:Bool) {
        for view in self.view.subviews {
            if let subView = view as? UIScrollView {
                if bool {
                    subView.delegate = self
                }
                else {
                    subView.delegate = nil
                }
            }
        }
    }
    
    
    func addFirstController() {
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:   localizedTextFor(key: BasicInformationSceneText.basicInformationSceneTitle.rawValue), onVC: self)
        updatedControllers.append(controllers.first!)
        (updatedControllers.first as! BasicInformationViewController).delegate = self
        setViewControllers(updatedControllers, direction: .forward, animated: true, completion: nil)
    }
    
    // MARK: MoveToNextPage
    
    func moveToNextPage() {
        updateScrollDelegation(false)
        currentCount += 1
        stepLabel.text = localizedTextFor(key: BusinessPageViewControllerSceneText.businessPageViewControllerStepText.rawValue) + " " + (currentCount + 1).description
        updatedControllers.append(controllers[currentCount])
        let nextVC = updatedControllers[1]
        
        switch currentCount {
        case 1:
            (nextVC as! LocationViewController).delegate = self
            CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:   localizedTextFor(key: LocationSceneText.locationSceneTitle.rawValue), onVC: self)
        case 2:
            (nextVC as! PinLocationViewController).delegate = self
            CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:   localizedTextFor(key: BusinessPinLocationSceneText.businessPinLocationSceneTitle.rawValue), onVC: self)
        case 3:
            (nextVC as! AddPhotosViewController).delegate = self
            CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:   localizedTextFor(key: PhotosSceneText.photosSceneTitle.rawValue), onVC: self)
        case 4:
            (nextVC as! WorkingHoursViewController).delegate = self
            CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:   localizedTextFor(key: WorkingHourSceneText.workingHourSceneTitle.rawValue), onVC: self)
        case 5:
            (nextVC as! ListServiceViewController).delegate = self
            CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:   localizedTextFor(key: ListServiceSceneText.listServiceSceneTitle.rawValue), onVC: self)
        case 6:
            (nextVC as! TherapistListViewController).delegate = self
            CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:   localizedTextFor(key: TherapistListSceneText.therapistListSceneTitle.rawValue), onVC: self)
            
        default:
            break
        }
        setViewControllers([nextVC], direction: .forward, animated: true) { (bool) in
            self.updateScrollDelegation(true)
        }
        updatedControllers.remove(at: 0)
    }
    
    @objc func moveToPreviousPage() {
        if currentCount == 0 {
            self.dismiss(animated: true, completion: nil)
            //            self.navigationController?.popViewController(animated: true)
        }
        else {
            
            updateScrollDelegation(false)
            currentCount -= 1
            stepLabel.text = localizedTextFor(key: BusinessPageViewControllerSceneText.businessPageViewControllerStepText.rawValue) + " " + (currentCount + 1).description
            updatedControllers.append(controllers[currentCount])
            let previousVC = updatedControllers[1]
            
            switch currentCount {
            case 0:
                (previousVC as! BasicInformationViewController).delegate = self
                CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:   localizedTextFor(key: BasicInformationSceneText.basicInformationSceneTitle.rawValue), onVC: self)
                
            case 1:
                (previousVC as! LocationViewController).delegate = self
                CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:   localizedTextFor(key: LocationSceneText.locationSceneTitle.rawValue), onVC: self)
                
            case 2:
                (previousVC as! PinLocationViewController).delegate = self
                CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:   localizedTextFor(key: BusinessPinLocationSceneText.businessPinLocationSceneTitle.rawValue), onVC: self)
                
            case 3:
                (previousVC as! AddPhotosViewController).delegate = self
                CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:   localizedTextFor(key: PhotosSceneText.photosSceneTitle.rawValue), onVC: self)
                
            case 4:
                (previousVC as! WorkingHoursViewController).delegate = self
                CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:   localizedTextFor(key: WorkingHourSceneText.workingHourSceneTitle.rawValue), onVC: self)
                
            case 5:
                (previousVC as! ListServiceViewController).delegate = self
                CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:   localizedTextFor(key: ListServiceSceneText.listServiceSceneTitle.rawValue), onVC: self)
                
            case 6:
                (previousVC as! TherapistListViewController).delegate = self
                CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:   localizedTextFor(key: TherapistListSceneText.therapistListSceneTitle.rawValue), onVC: self)
            default:
                break
            }
            setViewControllers([previousVC], direction: .reverse, animated: true) { (bool) in
                self.updateScrollDelegation(true)
            }
            updatedControllers.remove(at: 0)
        }
    }
}

// MARK: UIScrollViewDelegate
extension BusinessPageViewController:UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.lastPosition = scrollView.contentOffset.x
        
        if (currentIndex == updatedControllers.count - 1) && (lastPosition > scrollView.frame.width) {
            scrollView.contentOffset.x = scrollView.frame.width
            return
            
        } else if currentIndex == 0 && lastPosition < scrollView.frame.width {
            scrollView.contentOffset.x = scrollView.frame.width
            return
        }
    }
    
}

// MARK: UIPageViewControllerDataSource
extension BusinessPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = updatedControllers.index(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0          else { return updatedControllers.last }
        
        guard updatedControllers.count > previousIndex else { return nil        }
        
        return updatedControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        guard let viewControllerIndex = updatedControllers.index(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < updatedControllers.count else { return updatedControllers.first }
        
        guard updatedControllers.count > nextIndex else { return nil         }
        
        return updatedControllers[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 7
    }
    
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        //        if currentCount == 0 {
        //            self.navigationItem.leftBarButtonItem?.isEnabled = true
        //            self.navigationItem.leftBarButtonItem?.image = #imageLiteral(resourceName: "whiteRightArrow")
        //        }
        //        else if currentCount == 1 {
        //            self.navigationItem.leftBarButtonItem?.isEnabled = true
        //            self.navigationItem.leftBarButtonItem?.image = #imageLiteral(resourceName: "whiteRightArrow")
        //        }
        //        else {
        self.navigationItem.leftBarButtonItem?.isEnabled = true
        let languageIdentifier = UserDefaults.standard.value(forKey: userDefualtKeys.currentLanguage.rawValue) as! String
        if languageIdentifier == Languages.Arabic {
            self.navigationItem.leftBarButtonItem?.image = #imageLiteral(resourceName: "whiteRightArrow")
        }
        else {
            self.navigationItem.leftBarButtonItem?.image = #imageLiteral(resourceName: "whiteBackIcon")
        }
        //            self.navigationItem.leftBarButtonItem?.image = #imageLiteral(resourceName: "whiteBackIcon")
        //        }
        return currentCount
    }
}

