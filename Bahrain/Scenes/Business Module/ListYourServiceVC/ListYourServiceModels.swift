
import UIKit

enum ListYourService
{
    struct Request
    {
    }
    struct Response
    {
        var servicesArray:NSArray
    }
    struct ViewModel
    {
        struct service {
            var keyName:String
            var name:String
            var imageName:String
            var id:String
            var bgImageName: String
            var isSelected: Bool
            
        }
        
        var servicesArray:[service]
    }
    
    struct selectedService
    {
        struct service {
            var keyName:String
            var name:String
            var id:String
        }
        
        var selectedServicesArray:[service]
        
    }
  
}
