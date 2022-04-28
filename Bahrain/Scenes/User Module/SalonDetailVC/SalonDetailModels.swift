
import UIKit

enum SalonDetail
{
    // MARK: Use cases
    
    struct Request
    {
        var rating: String
        var reviewText: String
    }
    struct Response
    {
    }
    struct ViewModel
    {
        var galleryImages:[String]
        var avgRating:Double
        var review:Int?
        var isFavorite:Int
        var salonName:String
        var profileImage:String
        var serviceType:String
        var latitude:Double
        var longitude:Double
        var categoriesArray:[String]
        var servicesArray:[[service]]
        
        
        struct service {
            var name:String
            var duration:String
            var salonPrice:String
            var homePrice:String
            var type:String
            var id:String
            var isSelected:Bool
            var about: String
            var salonOfferPrice:String
            var homeOfferPrice:String
            var isOfferAvailable: Bool
            var isSOfferAvailable: Bool
        }
    }
    
    struct StaticCollectionViewModel
    {
        var title:String
        var image:UIImage
    }
    
    struct SpecialOfferDetail: Codable {
        var _id: String?
        var offerName: String?
        var offerNameArabic: String?
        var offerSalonPrice: Double?
        var offerHomePrice: Double?
        var totalHomePrice: Double?
        var totalSalonPrice: Double?
        var offerImage: String?
        var serviceType: String?
        var offerType: String?
        var canBookServices: Int?
        var businessId: BusinessObject?
        var heading: String?
        var businessServicesId: [SpecialOfferService]?
    }
    
    struct BusinessObject: Codable {
        var _id: String?
        var coverPhoto: String?
    }
    
    struct SpecialOfferService: Codable {
        var offerId: String?
        var _id: String?
        var serviceType: String?
        var offerType: String?
        var serviceDuration: String?
        var salonPrice: Double?
        var homePrice: Double?
        var serviceNameArabic: String?
        var serviceName: String?
        var serviceDescription: String?
        var serviceDescriptionArabic: String?
        var servicePrice: Double?
        var isServiceAdded: Bool
        var offerSalonPrice: Double?
        var offerHomePrice: Double?
        var totalHomePrice: Double?
        var totalSalonPrice: Double?
    }
}
