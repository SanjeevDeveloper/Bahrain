/**
 This class contains the end points of all the urls.
 */

import Foundation

class ApiEndPoints: NSObject {
    
    struct Onboarding {
        static let signIn = "auth/signin"
        static let verifyNumber = "auth/verifyNumber"
        static let signup = "auth/signup"
        static let resetPassword = "resetPassword"
    }
    
    struct userModule {
        static let splashData = "getAllsplashdata"
        static let categories = "getAllCategories"
        static let listBusinessByCategoryId = "listBusinessByCategoryId"
        static let ListBusinessByServiceName = "ListBusinessByServiceName"
        static let countUnreadNotification = "countUnreadNotification"
        static let listFavorite = "listFavorite"
        static let listAllOffers = "listAllOffers"
        static let listAllOffersFilter = "listAllOffersFilter"
        static let listBusiness = "listBusiness"
        static let listAllNotification = "listAllNotification"
        static let readNotifications = "readNotifications"
        static let clearNotifications = "clearNotifications"
        static let searchSalonFilter = "searchSalonFilter"
        static let sendFeedback = "sendFeedback"
        static let privacyPolicy = "getPrivacyPolicy"
        static let addRemoveFavorite = "addRemoveFavorite"
        static let getAreasList = "getAreasList"
        static let getBlocks = "listBlocks"
        static let listBusinessWorkingHours = "listBusinessWorkingHours"
        static let updateProfileImage = "updateProfileImage"
        static let editUserProfile = "editUserProfile"
        static let changepassword = "change_password"
        static let addReview = "addReview"
        static let userListAllReviews = "userListAllReviews"
        static let getBusinessById = "getBusinessById"
        static let listTherapistByBusinessId = "listTherapistByBusinessId"
        static let advanceFilterBusiness = "advanceFilterBusiness"
        static let filterFavoriteBusiness = "filterFavoriteBusiness"
        static let businessByCategoryIdFilter = "businessByCategoryIdFilter"
        static let listTherapistTimeSlots = "listTherapistTimeSlots"
        static let listUserAppointments = "listUserAppointments"
        static let cancelAppoinment = "cancelAppoinment"
        static let bookingService  = "bookingService"
        static let reconnectExistingBusiness = "auth/reconnectExistingBusiness"
        static let logout = "auth/logout"
        static let sendOtp = "sendOtp"
        static let userBookingPayment = "userBookingPayment"
        static let checkBusinessPaymentType = "checkBusinessPaymentType"
        static let deleteBooking = "deleteBooking"
        static let getBookingCancelReasons = "getBookingCancelReasons"
        static let getUserWallet = "getUserWallet"
        static let orderDetail = "orderDetail"
        static let cashoutConfirmationByUser = "cashoutConfirmationByUser"
        static let updateArrivalStatus = "updateArrivalStatus"
        static let openGatewayUrl = "openGatewayUrl"
        static let getPromoCodeInfo = "getPromoCodeInfo"
        static let addressList = "listAddress"
        static let address = "shippingAddress"
        static let defaultAddress = "defaultAddress"
        static let getAdvanceBookingDays = "getFutureBookingDays"
        static let getSalonsWithSpecialOffers = "listUserOffers"
        static let getSpecialOfferOfBusiness = "getBusinessOffers"
        static let getBenefitPayDetail = "getPaymentMethodByTypeBenefit/BenefitPay"
        static let gatewayCallbackBenefitPay = "gatewayCallbackBenefitPay"
    }
    
    struct Business {
        static let addBusinessClient = "addBusinessClient"
        static let getServicesList = "getServicesList"
        static let getBusinessSelectedServices = "getBusinessSelectedServices"
        static let registerBusiness = "registerBusiness"
        static let updateBusiness = "updateBusiness"
        static let updateBusinessProfileImage = "updateBusinessProfileImage"
        static let listBusinessAppointments = "listBusinessAppointments"
        static let getBusinessGallery = "getBusinessGallery"
        static let uploadBusinessGallery = "uploadBusinessGallery"
        static let addBusinessService = "addBusinessService"
        static let listServicesByBusinessId = "listServicesByBusinessId"
        static let deleteBusinessService = "deleteBusinessService"
        static let editBusinessService = "editBusinessService"
        static let getBusinessById = "getBusinessById"
        static let listTherapistByBusinessId = "listTherapistByBusinessId"
        static let addBusinessTherapist = "addBusinessTherapist"
        static let editTherapistInfo = "editTherapistInfo"
        static let deleteBusinessAccount = "deleteBusinessAccount"
        static let listReviewsByBusinessId = "listReviewsByBusinessId"
        static let listBusinessOffers = "listBusinessOffers"
        static let deleteOffer = "deleteOffer"
        static let listBusinessClient = "listBusinessClient"
        static let editBusinessClientInfo = "editBusinessClientInfo"
        static let deleteBusinessClient = "deleteBusinessClient"
        static let createOffer = "createOffer"
        static let deleteAppointment = "deleteAppointment"
        static let addToSpam = "addToSpam"
        static let listScheduleBreaks = "listScheduleBreaks"
        static let editOfferDetail = "editOfferDetail"
        static let checkTherapistAssigned = "checkTherapistAssigned"

    }
   
    
    struct message {
         static let getAllChats = "getAllChats"
    }
    
}
