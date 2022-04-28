
import UIKit

enum ForgotPasswordReset
{
  // MARK: Use cases
  
  
    struct Request
    {
        var newPassword:String
        var confirmPassword:String
    }
    struct Response
    {
        
    }
    struct ViewModel
    {
        var error:String?
    }
  
}
