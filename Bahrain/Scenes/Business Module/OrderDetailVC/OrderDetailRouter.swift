
import UIKit

protocol OrderDetailRoutingLogic
{
    func routeToBooking(bookingArray: [SalonDetail.ViewModel.service], salonName: String, businessID: String)
    func routeToCancelAppointment(appoinmentId:String)
    func routeToSaloonDetail(businessId:String)
    func routeToHome()
    func routeToAddressInfoVc(editObj: AddressList.ViewModel)
}

protocol OrderDetailDataPassing
{
    var dataStore: OrderDetailDataStore? { get }
}

class OrderDetailRouter: NSObject, OrderDetailRoutingLogic, OrderDetailDataPassing
{
    weak var viewController: OrderDetailViewController?
    var dataStore: OrderDetailDataStore?
    
    // MARK: Routing
    
    func routeToBooking(bookingArray: [SalonDetail.ViewModel.service], salonName: String, businessID: String)
    {
        
        let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: ViewControllersIds.BookingViewControllerID) as! BookingViewController
        var ds = destinationVC.router?.dataStore
        passDataToSomewhere(source: dataStore!, destination: &ds!, bookingArray: bookingArray, salonName: salonName, businessID: businessID)
        navigateToSomewhere(source: viewController!, destination: destinationVC)
    }
    
    func routeToSaloonDetail(businessId:String) {
        let storyboard = AppStoryboard.Main.instance
        let destinationVC = storyboard.instantiateViewController(withIdentifier: ViewControllersIds.SalonDetailViewControllerID) as! SalonDetailViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataToSalonDetail(businessId: businessId, destination: &destinationDS)
        navigateToSalonDetail(source: viewController!, destination: destinationVC)
    }
    
    func routeToCancelAppointment(appoinmentId:String) {
        let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: ViewControllersIds.CancelAppointmentViewControllerID) as! CancelAppointmentViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataToCancelAppointment(source: dataStore!, destination: &destinationDS, id: appoinmentId)
        navigateToCancelAppointment(source: viewController!, destination: destinationVC)
    }
    
    func routeToAddressInfoVc(editObj: AddressList.ViewModel) {
        let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: ViewControllersIds.addressInfoViewControllerId) as! AddressInfoViewController
        destinationVC.editObj = editObj
        viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    // MARK: Navigation
    
    func navigateToSomewhere(source: OrderDetailViewController, destination: BookingViewController)
    {
        viewController?.navigationController?.pushViewController(destination, animated: true)
    }
    
    func navigateToCancelAppointment(source: OrderDetailViewController, destination: CancelAppointmentViewController)
    {
        viewController?.navigationController?.pushViewController(destination, animated: true)
    }
    
    // MARK: Passing data
    
    func passDataToSomewhere(source: OrderDetailDataStore, destination: inout BookingDataStore, bookingArray: [SalonDetail.ViewModel.service], salonName: String, businessID: String)
    {
        destination.selectedServicesArray = bookingArray
        destination.businessId = businessID
        destination.saloonName = salonName
    }
    
    func passDataToCancelAppointment(source: OrderDetailDataStore, destination: inout CancelAppointmentDataStore, id:String)
    {
        destination.appoinmentId = id
    }
    
    
    func navigateToSalonDetail(source: OrderDetailViewController, destination: SalonDetailViewController)
    {
        viewController?.navigationController?.pushViewController(destination, animated: true)
    }
    
    // MARK: Passing data
    
    func passDataToSalonDetail(businessId: String, destination: inout SalonDetailDataStore)
    {
        destination.saloonId = businessId
    }
    
    func passDataTofilter(source: FavoriteListDataStore, destination: inout FilterDataStore,minimumValue: NSNumber,MaximumValue:NSNumber,isFavorite:String)
    {
        destination.filterDict = source.filterDict
        destination.filterCategoryArr = source.filterCategoryArr
        printToConsole(item: source.filterDict)
        destination.paymentArr = source.paymentArr
        destination.fromFav = isFavorite
        destination.minimumValue = minimumValue
        destination.maximumValue = MaximumValue
        destination.isFavorite = isFavorite // not used
        destination.serviceName = source.name
    }
    
    func routeToHome() {
        let vcArray = (viewController?.navigationController?.viewControllers)!
        for vc in vcArray {
            if vc.isKind(of: HomeViewController.self) {
                viewController?.navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
}
