
import UIKit

enum SpecialSalonList
{
  // MARK: Use cases
    
    struct ViewModel: Codable {
        var listBusiness: [SalonObject]
    }
    
    struct SalonObject: Codable {
        var businessId: String?
        var businessName: String?
        var coverPhoto: String?
        var homePackages: Int?
        var homeServices: Int?
        var percentageOff: Int?
        var profileImage: String?
        var salonPackages: Int?
        var salonServices: Int?
    }
}
