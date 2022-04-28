/** This class contains keys to read the text from the localized string file
 */

import Foundation

enum LanguageSceneText:String {
    case languageSceneTitle = "languageSceneTitle"
    case languageSceneSubtitle = "languageSceneSubtitle"
    case languageSceneEnglishButton = "languageSceneEnglishButton"
    case languageSceneArabicButton = "languageSceneArabicButton"
}

enum LoginSceneText:String {
    case loginSceneTitle = "loginSceneTitle"
    case loginSceneMobileTextFieldPlaceholder = "loginSceneMobileTextFieldPlaceholder"
    case loginScenePasswordTextFieldPlaceholder = "loginScenePasswordTextFieldPlaceholder"
    case loginSceneSignInButton = "loginSceneSignInButton"
    case loginSceneForgotButton = "loginSceneForgotButton"
    case loginSceneSignupButton = "loginSceneSignupButton"
    case loginSceneSkipButton = "loginSceneSkipButton"
    case male
    case female
    case gender
    case selectGender
    case ladies
    case gents
}

enum RegisterNameSceneText:String {
    case registerNameSceneTitle = "registerNameSceneTitle"
    case registerNameSceneSubtitle = "registerNameSceneSubtitle"
    case registerNameSceneNameTextFieldPlaceholder = "registerNameSceneNameTextFieldPlaceholder"
    case registerNameSceneNextButton = "registerNameSceneNextButton"
}


enum RegisterMobileSceneText:String {
    case registerMobileSceneTitle = "registerMobileSceneTitle"
    case registerMobileSceneSubtitlePart1 = "registerMobileSceneSubtitlePart1"
    case registerMobileSceneSubtitlePart2 = "registerMobileSceneSubtitlePart2"
    case registerMobileSceneNumberTextFieldPlaceholder = "registerMobileSceneNumberTextFieldPlaceholder"
    case registerMobileSceneEmailTextFieldPlaceholder = "registerMobileSceneEmailTextFieldPlaceholder"
    case registerMobileSceneNameTextFieldPlaceholder = "registerMobileSceneNameTextFieldPlaceholder"
    case registerMobileScenePasswordTextFieldPlaceholder = "registerMobileScenePasswordTextFieldPlaceholder"
    
}

enum OTPVerifySceneText:String {
    case oTPVerifySceneTitle = "oTPVerifySceneTitle"
    case oTPVerifySceneSubtitle = "oTPVerifySceneSubtitle"
    case oTPVerifySceneResendButton = "oTPVerifySceneResendButton"
    case timerLabelPart1 = "timerLabelPart1"
    case timerLabelPart2 = "timerLabelPart2"
    case emptyOTP = "emptyOTP"
    case validOTP = "validOTP"
    case OTPNotSent = "OTPNotSent"
}

enum RegisterLocationSceneText:String {
    case registerLocationSceneTitle = "registerLocationSceneTitle"
    case registerLocationSceneSubtitle = "registerLocationSceneSubtitle"
    case registerLocationSceneAreaTextFieldPlaceholder = "registerLocationSceneAreaTextFieldPlaceholder"
    case registerLocationSceneAdressTextFieldPlaceholder = "registerLocationSceneAdressTextFieldPlaceholder"
    case registerLocationSceneFullAdressTextFieldPlaceholder = "registerLocationSceneFullAdressTextFieldPlaceholder"
    case registerLocationSceneBirthdayTextFieldPlaceholder = "registerLocationSceneBirthdayTextFieldPlaceholder"
    case registerLocationSceneRegisterButton = "registerLocationSceneRegisterButton"
    case registerLocationSceneAddress = "registerLocationSceneAddress"
    case registerBirthdayScene = "registerBirthdayScene"
    case registerEmailTextFieldPlaceholder = "registerEmailTextFieldPlaceholder"
    case selectArea
    case selectBlock
    case road
    case houseNo
    case flatNo
    case pinLocation
}


enum UserPinLocationSceneText:String {
    case UserPinLocationSceneTitle = "UserPinLocationSceneTitle"
}

enum ForgotPasswordSceneText:String {
    case forgotPasswordSceneTitle = "forgotPasswordSceneTitle"
    case forgotPasswordSceneSubtitle = "forgotPasswordSceneSubtitle"
    case forgotPasswordSceneSubtitleDescription = "forgotPasswordSceneSubtitleDescription"
    case forgotPasswordSceneNumberTextFieldPlaceholder = "forgotPasswordSceneNumberTextFieldPlaceholder"
}


enum ForgotPasswordOtpSceneText:String {
    case forgotPasswordOtpSceneTitle = "forgotPasswordOtpSceneTitle"
    case forgotPasswordOtpSceneSubtitle = "forgotPasswordOtpSceneSubtitle"
    case forgotPasswordOtpSceneResendButton = "forgotPasswordOtpSceneResendButton"
}



enum ForgotPasswordResetSceneText:String {
    case forgotPasswordResetSceneTitle = "forgotPasswordResetSceneTitle"
    case forgotPasswordResetSceneSubtitle = "forgotPasswordResetSceneSubtitle"
    case forgotPasswordResetScenePasswordTextFieldPlaceholder = "forgotPasswordResetScenePasswordTextFieldPlaceholder"
    case forgotPasswordResetSceneConfirmPasswordTextFieldPlaceholder = "forgotPasswordResetSceneConfirmPasswordTextFieldPlaceholder"
    case forgotPasswordResetSceneSubmitButton = "forgotPasswordResetSceneSubmitButton"
}

enum TabBarText:String {
    case homeTabTitle = "homeTabTitle"
    case appointmentTabTitle = "appointmentTabTitle"
    case messagesTabTitle = "messagesTabTitle"
    case profileTabTitle = "profileTabTitle"
}

enum UserSideMenuText:String {
    case homeMenuTitle = "homeMenuTitle"
    case searchMenuTitle = "searchMenuTitle"
    case appointmentsTitle = "appointmentsTitle"
    case WalletTitle = "WalletTitle"
    case favoritesMenuTitle = "favoritesMenuTitle"
    case messageTitle = "messageTitle"
    case notificationTitle = "notificationTitle"
    case sendFeedbackMenuTitle = "sendFeedbackMenuTitle"
    case privacyPolicy = "privacyPolicy"
    case settingTitile = "settingTitile"
    case logoutTitle = "logoutTitle"
    case switchBusiness = "switchBusiness"
    case logoutAlert = "logoutAlert"
    case loginTitle = "loginTitle"
    case logoutMessage = "Are you sure you want to sign out ?"
}

enum BusinessSideMenuText:String {
    case todayMenuTitle = "todayMenuTitle"
    case calendarMenuTitle = "calendarMenuTitle"
    case bookingMenuTitle = "bookingMenuTitle"
    case settingsMenuTitle = "settingsMenuTitle"
    case switchUser = "switchUser"
    case NotApproved = "NotApproved"
}


enum HomeSceneText:String {
    case homeSceneTitle = "homeSceneTitle"
    case homeSceneSpecialOffer = "homeSceneSpecialOffer"
    case homeSceneSalon = "homeSceneSalon"
    case homeSceneMakeupArtist = "homeSceneMakeupArtist"
    case homeSceneSpa = "homeSceneSpa"
    case homeSceneHomeServices = "homeSceneHomeServices"
    case homeSceneBrowseCategories = "homeSceneBrowseCategories"
}



enum FilterSceneText:String {
    case FilterSceneTitleLabel = "FilterSceneTitleLabel"
    case FilterScenePriceTitleLabel = "FilterScenePriceTitleLabel"
    case FilterSceneMinPriceLabel = "FilterSceneMinPriceLabel"
    case FilterSceneMaxPriceLabel = "FilterSceneMaxPriceLabel"
    case FilterSceneCategoriesTitleLabel = "FilterSceneCategoriesTitleLabel"
    case FilterSceneSelectAreaTitleLabel = "FilterSceneSelectAreaTitleLabel"
    case FilterScenePaymentMethodTitleLabel = "FilterScenePaymentMethodTitleLabel"
    case FilterSceneApplyButtonTitle = "FilterSceneApplyButtonTitle"
    case FilterSceneCurrencyTextLabel = "FilterSceneCurrencyTextLabel"
    case FilterSceneSelectedTextLabel = "FilterSceneSelectedTextLabel"
    case FilterSceneCategoryErrorMessage = "FilterSceneCategoryErrorMessage"
    case FilterSceneCashText = "FilterSceneCashText"
    case FilterSceneCardText = "FilterSceneCardText"
    case FilterSceneAtText = "FilterSceneAtText"
    case FilterSceneSmallatText = "FilterSceneSmallatText"
    case FilterSceneBookingConfirmed = "FilterSceneBookingConfirmed"
    case FilterSceneClearButtonText = "FilterSceneClearButtonText"
    case FilterScenefavourite = "FilterScenefavourite"
    
}

enum SearchSceneText:String {
    case SearchSceneTitle = "SearchSceneTitle"
    case SearchSceneSearchTextFiledPlaceholderText = "SearchSceneSearchTextFiledPlaceholderText"
}


enum MyAppointmentSceneText:String {
    case MyAppointmentSceneTitle = "MyAppointmentSceneTitle"
    case MyAppointmentSceneUpcomingButtonTitle = "MyAppointmentSceneUpcomingButtonTitle"
    case MyAppointmentScenePastAppointmentButtonTitle = "MyAppointmentScenePastAppointmentButtonTitle"
    case MyAppointmentSceneTotalAmountLabelTitle = "MyAppointmentSceneTotalAmountLabelTitle"
    case MyAppointmentSceneCancelledTitle = "MyAppointmentSceneCancelledTitle"
    case MyAppointmentSceneCancelAlertTitle = "MyAppointmentSceneCancelAlertTitle"
    case MyAppointmentScenefullPaid = "MyAppointmentScenefullPaid"
    case MyAppointmentSceneCash = "MyAppointmentSceneCash"
}




enum ProfileSettingSceneText:String {
    case ProfileSettingSceneTitle = "ProfileSettingSceneTitle"
    case ProfileSettingSceneNameLabel = "ProfileSettingSceneNameLabel"
    case ProfileSettingSceneNumberLabel = "ProfileSettingSceneNumberLabel"
    case ProfileSettingSceneSelectAreaLabel = "ProfileSettingSceneSelectAreaLabel"
    case ProfileSettingSceneAddressLabel = "ProfileSettingSceneAddressLabel"
    case ProfileSettingSceneFullAddressLabel = "ProfileSettingSceneFullAddressLabel"
    case ProfileSettingSceneEmailLabel = "ProfileSettingSceneEmailLabel"
    case ProfileSettingScenePasswordLabel = "ProfileSettingScenePasswordLabel"
    case ProfileSettingScenePasswordTextField = "ProfileSettingScenePasswordTextField"
    case ProfileSettingSceneBirthdayLabel = "ProfileSettingSceneBirthdayLabel"
    case ProfileSettingSceneSwitchLanguageLabel = "ProfileSettingSceneSwitchLanguageLabel"
    case ProfileSettingSceneNotificationLabel = "ProfileSettingSceneNotificationLabel"
    case ProfileSettingSceneEditButton = "ProfileSettingSceneEditButton"
    case ProfileSettingSceneSaveButton = "ProfileSettingSceneSaveButton"
    case blockLabel
    case roadLabel
    case houseLabel
    case flatLabel
    case pinLocationLabel
    case changeLocation
    case ProfileSettingSceneChangePasswordLabel = "ProfileSettingSceneChangePasswordLabel"
    case ProfileSettingSceneOldPasswordTextField = "ProfileSettingSceneOldPasswordTextField"
    case ProfileSettingSceneNewPasswordTextField = "ProfileSettingSceneNewPasswordTextField"
    case ProfileSettingSceneConfirmPasswordTextField = "ProfileSettingSceneConfirmPasswordTextField"
    case ProfileSettingSceneCancelButton = "ProfileSettingSceneCancelButton"
    case ProfileSettingSceneDoneButton = "ProfileSettingSceneDoneButton"
    case ProfileSettingSceneProfileUpdateSuccessMessage = "ProfileSettingSceneProfileUpdateSuccessMessage"
    case ProfileSettingSceneChangeLanguageAlertText = "ProfileSettingSceneChangeLanguageAlertText"
    case namePlaceholder
    case emailAddressPlaceholder
    case fullAddressPlaceholder
    case roadPlaceholder
    case housePlaceholder
    case flatplaceholder
    
}

enum FavoriteListSceneText:String {
    case FavoriteListSceneTitle = "FavoriteListSceneTitle"
    case FavoriteListSceneSearchTextField = "FavoriteListSceneSearchTextField"
    case FavoriteListScenePriceFromLabel = "FavoriteListScenePriceFromLabel"
    case FavoriteListSceneCardPaymentLabel = "FavoriteListSceneCardPaymentLabel"
    case FavoriteListSceneCashPaymentLabel = "FavoriteListSceneCashPaymentLabel"
    case FavoriteListSceneFiteredData = "FavoriteListSceneFiteredData"
    case FavoriteListScreneFilterScreen = "FavoriteListScreneFilterScreen"
    case FavoriteListSceneLocationTextFieldPlaceholder = "FavoriteListSceneLocationTextFieldPlaceholder"
}

enum SpecialOfferListUserSceneText:String {
    case specialOfferListUserSceneTitle = "specialOfferListUserSceneTitle"
    case specialOfferListUserSceneBookNow = "specialOfferListUserSceneBookNow"
    case specialOfferListUserSceneForAll = "specialOfferListUserSceneForAll"
    case specialOfferListUserSceneAddOfferLabel = "specialOfferListUserSceneAddOfferLabel"
    case specialOfferListUserSceneNoOfferAvailableLabel = "specialOfferListUserSceneNoOfferAvailableLabel"
    
}


enum OpeningHoursSceneText:String {
    case OpeningHoursSceneTitle = "OpeningHoursSceneTitle"
    case OpeningHoursSceneToText = "OpeningHoursSceneToText"
    
}

enum SendFeedBackSceneText:String {
    case SendFeedBackSceneTitle = "SendFeedBackSceneTitle"
    case SendFeedBackSceneFeedBackTextViewPlaceholder = "SendFeedBackSceneFeedBackTextViewPlaceholder"
    case SendFeedBackSceneSendButtonTitle = "SendFeedBackSceneSendButtonTitle"
    case SendFeedBackSceneEmptyTextMsg = "SendFeedBackSceneEmptyTextMsg"
    case sendfeedbackTextViewEmptyTextMsg = "sendfeedbackTextViewEmptyTextMsg"
    case sendfeedbackTextEmptyMsg = "sendfeedbackTextEmptyMsg"
}

enum SalonDetailSceneText:String {
    case SalonDetailSceneRateUsButton = "SalonDetailSceneRateUsButton"
    case SalonDetailSceneEnjoyLabel = "SalonDetailSceneEnjoyLabel"
    case SalonDetailSceneReviewTextViewPlaceholder = "SalonDetailSceneReviewTextViewPlaceholder"
    case SalonDetailSceneCancelButton = "SalonDetailSceneCancelButton"
    case SalonDetailSceneSubmitButton = "SalonDetailSceneSubmitButton"
    case SalonDetailSceneReviewStaticText = "SalonDetailSceneReviewStaticText"
    case SalonDetailSceneEmptyRatingText = "SalonDetailSceneEmptyRatingText"
    case SalonDetailSceneServiceBookedText = "SalonDetailSceneServiceBookedText"
    case SalonDetailSceneBookOrderText = "SalonDetailSceneBookOrderText"
    // Static collection view cell titles
    case SalonDetailSceneAbout = "SalonDetailSceneAbout"
    case SalonDetailSceneFavorites = "SalonDetailSceneFavorites"
    case SalonDetailSceneHours = "SalonDetailSceneHours"
    case SalonDetailSceneChat = "SalonDetailSceneChat"
    case SalonDetailSceneDirection = "SalonDetailSceneDirection"
    case SalonDetailSceneStaff = "SalonDetailSceneStaff"
    case SalonDetailSceneAddreviewSuccessResponse = "SalonDetailSceneAddreviewSuccessResponse"
    case SalonDetailSceneNoServiceLabelText = "SalonDetailSceneNoServiceLabelText"
    case SalonDetailSceneWhatsApp = "SalonDetailSceneWhatsApp"
    case SalonDetailSceneShare = "SalonDetailSceneShare"
}


enum UserListSceneText:String {
    case UserListSceneAddButton = "UserListSceneAddButton"
    case UserListSceneAddedButton = "UserListSceneAddedButton"
}

enum MapSceneText:String {
    case MapSceneTitle = "MapSceneTitle"
    
}

enum AddAddressSceneText: String {
    case addErrorMessage
    case addAddressSceneTile
    case googlePinButtonTitle
    case selectAddressTypePlaceholder
    case addressTextViewPlaceholder
    case errorPhoneMessage
    case errorAddAddressMessage
    case errorValidPhoneNumber
    case editAddressTitle
    case updateButtonTitle
    case addressUpdatedMessage
    case addressAddedMesage
    case saveButtonTitle
    case shareLocationTitle
    case errorAddressTitle
    case addressInfoTitle
    case addressOtherInfo
    case addressInfoSceneTitle
    case addressInfoNavigate
    case addressHouseNumber
    case addressFlatNumber
    case addressBlock
}

enum AddressListString: String {
    case addressListSceneText
    case addAddressTitle
    case deletedAddress
    case deleteAddress
    case deleteConfirmation
    case useThisAddress
}

enum BookingSummarySceneText:String {
    case bookingSummarySceneSceneTitle = "bookingSummarySceneSceneTitle"
    case bookingSummarySceneYourServiceText = "bookingSummarySceneYourServiceText"
    case bookingSummarySceneDateTitleText = "bookingSummarySceneDateTitleText"
    case bookingSummarySceneAtText = "bookingSummarySceneAtText"
    case bookingSummaryScenePaymentMethodText = "bookingSummaryScenePaymentMethodText"
    case bookingSummarySceneTotalPriceText = "bookingSummarySceneTotalPriceText"
    case bookingSummarySceneDiscountPriceText = "bookingSummarySceneDiscountPriceText"
    case bookingSummarySceneConfirmBookingText = "bookingSummarySceneConfirmBookingText"
    case bookingSummarySceneBookingDateCellLabel = "bookingSummarySceneBookingDateCellLabel"
    case bookingSummarySceneTherapistCellLabel = "bookingSummarySceneTherapistCellLabel"
    case bookingSummarySceneSalonNameCellLabel = "bookingSummarySceneSalonNameCellLabel"
    case bookingSummaryScenepriceCellLabel = "bookingSummaryScenepriceCellLabel"
    case selectHomeAddressMessage
    case selectAddress
    case summaryDiscountAmount
    case summaryPayableAmount
    case bookingSummaryScenePayablePriceText
    case enterPromoCode
    case apply
    case noPromoCode
    case promoCodeAppliedSuccessfully
    case maximumDiscount
    case limitHasExceed
    case bookingSummarySceneTotalAmountText
    case note
}

enum BookingSceneText:String {
    case BookingSceneTitle = "BookingSceneTitle"
    case BookingSceneServiceDetailLabelText = "BookingSceneServiceDetailLabelText"
    case BookingSceneInstructionTextViewText = "BookingSceneInstructionTextViewText"
    case BookingSceneProceedButtonTitle = "BookingSceneProceedButtonTitle"
    case BookingSceneMinLabelText = "BookingSceneMinLabelText"
    case BookingSceneTimeSelectionAlert = "BookingSceneTimeSelectionAlert"
    case BookingSceneAllServiceSelectionAlert = "BookingSceneAllServiceSelectionAlert"
    case BookingSceneServiceText = "BookingSceneServiceText"
    case BookingSceneNoSlotAvailableAlert = "BookingSceneNoSlotAvailableAlert"
    case BookingSceneNoSlot
}

enum MessageSceneText:String {
    case MessageSceneTitle = "MessageSceneTitle"
    case MessageSceneUpcomingButtonTitle = "MessageSceneUpcomingButtonTitle"
    case MessageScenePastAppointmentButtonTitle = "MessageScenePastAppointmentButtonTitle"
    case MessageSceneTotalAmountLabelTitle = "MessageSceneTotalAmountLabelTitle"
    case MessageSceneCancelledTitle = "MessageSceneCancelledTitle"
    case MessageSceneCancelAlertTitle = "MessageSceneCancelAlertTitle"
}

enum ChatSceneText:String {
    case ChatSceneTypingTextLabel = "ChatSceneTypingTextLabel"
    case ChatSceneOnlineTextLabel = "ChatSceneOnlineTextLabel"
    case ChatSceneOfflineTextLabel = "ChatSceneOfflineTextLabel"
    case ChatSceneTextViewText = "ChatSceneTextViewText"
}

enum ChatMessageSceneText:String {
    case ChatMessageSceneTitle = "ChatMessageSceneTitle"
    
}


enum rateReviewSceneText:String {
    case RateReviewSceneTitle
    case AvgRatingLabel
    case Quality
    case Money
    case Services
    case Timing
    case ReviewBtn
    case therapistRating
}

enum RateServicesSceneText:String {
    case RateServicesSceneTitle
    case ReviewTextView
    case SubmitBtn
}


enum NotifySceneText:String {
    case NotifySceneTitle = "NotifySceneTitle"
    case NotifySceneClearButtonText = "NotifySceneClearButtonText"
    case NotifySceneNoDataLabel = "NotifySceneNoDataLabel"
    case NotifySceneClearAllAlert = "NotifySceneClearAllAlert"
    case NotifySceneClearAllSuccessMessage = "NotifySceneClearAllSuccessMessage"
}


enum PaymentMethodSceneText:String {
    case PaymentMethodSceneTitle
    case PaymentMethodTypeLabelTitle
    case PaymentPartialPayLabelTitle
    case PaymentFullPayLabelTitle
    case PaymentWalletBtnTitle
    case PaymentMethodTotalAmtLabelTitle
    case PaymentMethodAdvanceAmtTitle
    case PaymentMethodSalonAmtTitle
    case PaymentMethodBenefitTitle
    case PaymentMethodCreditTitle 
    case PaymentMethodLabelTitle
    case PaymentMethodBenefitBtnTitle
    case PaymentMethodMpgsBtnTitle
    case PaymentMethodContinueBtnTitle
    case PaymentMethodContinueBtnPayTitle
    case PaymentMethodSelectPaymenttypeErrorMsg
    case PaymentMethodSelectPaymentMethodErrorMsg
    case PaymentMethodWalletAmtLblTitle
    case PaymentMethodDeductedLblTitle
    case PaymentMethodRemainingBalanceLblTitle
    case PaymentMethodRemainPayableTitleLbl
}

enum CardDetailSceneText:String {
    case CardDetailSceneTitle
    case CardDetailMethodNameLbl
    case CardDetailEnterDetailLbl
    case CardDetailExpiryLbl
    case CardDetailCardNumberTxtFldPlaceholder
    case CardDetailMonthTxtFldPlaceholder
    case CardDetailYearTxtFldPlaceholder
    case CardDetailCvvTxtFldPlaceholder
    case CardDetailPaymentBtnTitle
    case CardDetailInfoLbl
    case CardDetailMoreInfoText
    case CardDetailLessInfoText
    case CardDetailFirstInfoText
    case CardDetailSecondInfoText
    case CardDetailThirdInfoText
    case CardDetailNumberValidationText
    case CardDetailMonthValidationText
    case CardDetailYearValidationText
    case CardDetailCvvValidationText
}


enum CancelAppointmentSceneText:String {
    case CancelAppointmentSceneTitle
    case CancelAppointmentSceneTextFieldPlaceholder
    case CancelAppointmentSceneSubmitBtnTitle
    case CancelAppointmentSceneSelectReasonAlert
    case CancelAppointmentScenePopupAlertTitle
    case CancelAppointmentScenePopupCancelBtnTitle
    case CancelAppointmentScenePopupConfirmBtnTitle
}

enum WalletSceneText:String {
    case WalletSceneTitle
    case WalletSceneCurrentBalanceLblTitle
    case WalletSceneBottomInfoLabelTitle
    case WalletSceneNoDataLblTitle
    
}





///////////////////// Business module //////////////////

enum TodaySceneText:String {
    case todaySceneTitle = "todaySceneTitle"
}


enum SettingsSceneText:String {
    case settingSceneTitle = "settingSceneTitle"
    
    // headers keys
    case headerClients = "headerClients"
    case headerProfile = "headerProfile"
    case headerOffers = "headerOffers"
    case headerSchedule = "headerSchedule"
    case headerAccount = "headerAccount"
    
    // rows keys
    case rowClientReviews = "rowClientReviews"
    case rowClients = "rowClients"
    case rowAppointments
    case rowViewProfile = "rowViewProfile"
    case rowPhotos = "rowPhotos"
    case rowSpecialOffer = "rowSpecialOffer"
    case rowServices = "rowServices"
    case rowCategories = "rowCategories"
    case rowScheduleBreaks = "rowScheduleBreaks"
    case rowWorkingHours = "rowWorkingHours"
    case rowBookingSetting = "rowBookingSetting"
    case rowTherapist = "rowTherapist"
    case rowBasicInfo = "rowBasicInfo"
    case rowLocations = "rowLocations"
    case rowAccountVisibility = "rowAccountVisibility"
    
}


enum ClientReviewsSceneText:String {
    case ClientReviewsSceneTitle = "ClientReviewsSceneTitle"
    case ClientReviewsSceneShowHideLabelText = "ClientReviewsSceneShowHideLabelText"
    
}


enum ClientListSceneText:String {
    case clientListSceneTitle = "clientListSceneTitle"
    case clientListSceneAddLabel = "clientListSceneAddLabel"
    case clientListSceneSearchTextFieldPlaceholder = "clientListSceneSearchTextFieldPlaceholder"
}

enum AddClientSceneText:String {
    case addClientSceneTitle = "addClientSceneTitle"
    case editClientSceneTitle = "editClientSceneTitle"
    case addClientSceneNameFieldPlaceholder = "addClientSceneNameFieldPlaceholder"
    case addClientSceneLastNameFieldPlaceholder = "addClientSceneLastNameFieldPlaceholder"
    case addClientSceneNumberFieldPlaceholder = "addClientSceneNumberFieldPlaceholder"
    case addClientSceneContinueButton = "addClientSceneContinueButton"
    case addClientSceneEmptyNameValidation = "addClientSceneEmptyNameValidation"
    case addClientSceneEmptyCountryCodeValidation = "addClientSceneEmptyCountryCodeValidation"
    case addClientSceneEmptyPhoneNumberValidation = "addClientSceneEmptyPhoneNumberValidation"
    case addClientSceneContinueSaveChangesButton = "addClientSceneContinueSaveChangesButton"
    case addClientSceneDeleteAccountButton = "addClientSceneDeleteAccountButton"
    case addClientSceneDeleteAccountText = "addClientSceneDeleteAccountText"
    case addClientSceneClientUpdatedSuccessFullyText = "addClientSceneClientUpdatedSuccessFullyText"
    case addClientSceneClientAddedSuccessFullyText = "addClientSceneClientAddedSuccessFullyText"
    
}

enum WorkingHourSceneText:String {
    case workingHourSceneTitle = "workingHourSceneTitle"
    case workingHourFromLabel = "workingHourFromLabel"
    case workingHourTillLabel = "workingHourTillLabel"
    case workingHourSuccessMessage = "workingHourSuccessMessage"
    case workingHoursError = "workingHoursError"
    case workingHourApplyText = "workingHourApplyText"
    case workingHourAmText = "workingHourAmText"
    case workingHoursPmText = "workingHoursPmText"
    case workingOpeningHoursWrongSelecttime = "workingOpeningHoursWrongSelecttime"
    case workingCloseHoursWrongSelecttime = "workingCloseHoursWrongSelecttime"
}


enum LocationSceneText:String {
    case locationSceneTitle = "locationSceneTitle"
    case capital
    case locationSceneAreaTextFieldPlaceholder = "locationSceneAreaTextFieldPlaceholder"
    case locationSceneAddress1TextFieldPlaceholder = "locationSceneAddress1TextFieldPlaceholder"
    case locationSceneAddress2TextFieldPlaceholder = "locationSceneAddress2TextFieldPlaceholder"
    case locationSceneAvenueTextFieldPlaceholder = "locationSceneAvenueTextFieldPlaceholder"
    case locationSceneBuildingTextFieldPlaceholder = "locationSceneBuildingTextFieldPlaceholder"
    case locationSceneSpecialTextFieldPlaceholder = "locationSceneSpecialTextFieldPlaceholder"
    case locationSceneContinueButton = "locationSceneContinueButton"
    case locationSceneEmptyArea = "locationSceneEmptyArea"
    case locationSceneEmptyBlockAddress = "locationSceneEmptyBlockAddress"
    case locationSceneEmptyStreetAddress = "locationSceneEmptyStreetAddress"
    case selectBlock
    case crNumberEmptyError
    case uploadCrError
    case crNumber
    case uploadCr
    case pleaseSelect
    
}



enum PhotosSceneText:String {
    case photosSceneTitle = "photosSceneTitle"
    case photosSceneDoneButton = "DONE"
    case photosSceneAddPhotoLabel = "Add Photo"
    case emptyImagesArray = "emptyImagesArray"
    case PhotosSceneImageUploadedSuccessfully = "PhotosSceneImageUploadedSuccessfully"
}


enum AccountVisibilitySceneText:String {
    case accountVisibilitySceneTitle = "accountVisibilitySceneTitle"
    case accountVisibilitySceneSwitchButtonTitle = "accountVisibilitySceneSwitchButtonTitle"
    case accountVisibilitySceneDeleteButtonTitle = "accountVisibilitySceneDeleteButtonTitle"
    case accountVisibilityScenePopupTitle = "accountVisibilityScenePopupTitle"
    case accountVisibilityScenePopupSubTitle = "accountVisibilityScenePopupSubTitle"
    case accountVisibilitySceneTurnedOnMessage = "accountVisibilitySceneTurnedOnMessage"
    case accountVisibilitySceneTurnedOffMessage = "accountVisibilitySceneTurnedOffMessage"
}




enum BasicInformationSceneText: String {
    case basicInformationSceneTitle = "basicInformationSceneTitle"
    case basicInformationAddProfileImgLblTitle = "basicInformationAddProfileImgLblTitle"
    case basicInformationAddCoverImgLblTitle = "basicInformationAddCoverImgLblTitle"
    case basicInformationSceneSalonNameTextFieldPlaceholder = "basicInformationSceneSalonNameTextFieldPlaceholder"
    case basicInformationSceneSalonArabicNameTextFieldPlaceholder = "basicInformationSceneSalonArabicNameTextFieldPlaceholder"
    case basicInformationSceneWebsiteTextFieldPlaceholder = "basicInformationSceneWebsiteTextFieldPlaceholder"
    case basicInformationSceneInstagramTextFieldPlaceholder = "basicInformationSceneInstagramTextFieldPlaceholder"
    case basicInformationScenePhoneTextFieldPlaceholder = "basicInformationScenePhoneTextFieldPlaceholder"
    case basicInformationSceneAboutTextViewPlaceholder = "basicInformationSceneAboutTextViewPlaceholder"
    case basicInformationSceneArabicAboutTextViewPlaceholder
    case basicInformationSceneDoneButton = "basicInformationSceneDoneButton"
    case basicInformationSceneEmptySaloonName = "basicInformationSceneEmptySaloonName"
    case basicInformationSceneEmptySaloonImage = "basicInformationSceneEmptySaloonImage"
    case basicInformationSceneEmptyCoverSaloonImage = "basicInformationSceneEmptyCoverSaloonImage"
    case basicInformationSceneInfoUpdatedSuccessMessage = "basicInformationSceneInfoUpdatedSuccessMessage"
    case basicInformationSceneEmptySaloonCoverImage = "basicInformationSceneEmptySaloonCoverImage"
    
}




enum BookingSettingsSceneText:String {
    case bookingSettingsSceneTitle = "bookingSettingsSceneTitle"
    case bookingSettingsSceneDoneButton = "bookingSettingsSceneDoneButton"
    case bookingSettingsSceneTimeTitleLabel = "bookingSettingsSceneTimeTitleLabel"
    case bookingSettingsSceneTimeDescriptionLabel = "bookingSettingsSceneTimeDescriptionLabel"
    case bookingSettingsSceneMinuteLabel = "bookingSettingsSceneMinuteLabel"
    case bookingSettingsSceneNoteTitleLabel = "bookingSettingsSceneNoteTitleLabel"
    case bookingSettingsSceneNoteDescriptionLabel = "bookingSettingsSceneNoteDescriptionLabel"
    case bookingSettingsSceneNoteTextView = "bookingSettingsSceneNoteTextView"
    case bookingSettingsSceneSuccessMessage = "bookingSettingsSceneSuccessMessage"
    case bookingSettingsSceneLeadTimeTextView = "bookingSettingsSceneLeadTimeTextView"
    
}



enum AddSalonServiceSceneText:String {
    case addSalonServiceSceneTitle = "addSalonServiceSceneTitle"
    case addSalonServiceSceneHomeLabel = "addSalonServiceSceneHomeLabel"
    case addSalonServiceSceneSalonLabel = "addSalonServiceSceneSalonLabel"
    case addSalonServiceSceneMainCategoryTextFieldPlaceholder = "addSalonServiceSceneMainCategoryTextFieldPlaceholder"
    case addSalonServiceSceneSelectServiceCategoryTextFieldPlaceholder = "addSalonServiceSceneSelectServiceCategoryTextFieldPlaceholder"
    case addSalonServiceSceneServiceNameTextFieldPlaceholder = "addSalonServiceSceneServiceNameTextFieldPlaceholder"
    case addSalonServiceSceneArabicNameTextFieldPlaceholder = "addSalonServiceSceneArabicNameTextFieldPlaceholder"
    case addSalonServiceSceneHomePriceTextFieldPlaceholder = "addSalonServiceSceneHomePriceTextFieldPlaceholder"
    case addSalonServiceSceneHomePriceLabel = "addSalonServiceSceneHomePriceLabel"
    case addSalonServiceSceneSalonPriceTextFieldPlaceholder = "addSalonServiceSceneSalonPriceTextFieldPlaceholder"
    case addSalonServiceSceneSalonPriceLabel = "addSalonServiceSceneSalonPriceLabel"
    case addSalonSceneDurationTextFieldPlaceholder = "addSalonSceneDurationTextFieldPlaceholder"
    case addSalonServiceSceneDurationLabel = "addSalonServiceSceneDurationLabel"
    case addSalonServiceSceneAboutServiceTextView = "addSalonServiceSceneAboutServiceTextView"
    case addSalonServiceSceneArabicAboutTextView = "addSalonServiceSceneArabicAboutTextView"
    
    case addSalonServiceSceneMoreAddOnLabel = "addSalonServiceSceneMoreAddOnLabel"
    case addSalonServiceSceneAddOnHomeLabel = "addSalonServiceSceneAddOnHomeLabel"
    case addSalonServiceSceneAddOnSalonLabel = "addSalonServiceSceneAddOnSalonLabel"
    case addSalonServiceSceneAddOnNameTextFieldPlaceholder = "addSalonServiceSceneAddOnNameTextFieldPlaceholder"
    case addSalonServiceSceneAddOnHomePriceTextFieldPlaceholder = "addSalonServiceSceneAddOnHomePriceTextFieldPlaceholder"
    case addSalonServiceSceneAddOnHomePriceLabel = "addSalonServiceSceneAddOnHomePriceLabel"
    case addSalonServiceSceneAddOnSalonPriceTextFieldPlaceholder = "addSalonServiceSceneAddOnSalonPriceTextFieldPlaceholder"
    case addSalonServiceSceneAddOnSalonPriceLabel = "addSalonServiceSceneAddOnSalonPriceLabel"
    case addSalonServiceSceneAddOnDurationTextFieldPlaceholder = "addSalonServiceSceneAddOnDurationTextFieldPlaceholder"
    case addSalonServiceSceneSaveButton = "addSalonServiceSceneSaveButton"
    case addSalonServiceSceneCancelButton = "addSalonServiceSceneCancelButton"
    case addSalonServiceSceneContinueButton = "addSalonServiceSceneContinueButton"
    case addSalonServiceSceneMoreAddOnColonLabel = "addSalonServiceSceneMoreAddOnColonLabel"
    
    case addSalonServiceSceneMainCategoryValidation = "addSalonServiceSceneMainCategoryValidation"
    case addSalonServiceSceneCategoryValidation = "addSalonServiceSceneCategoryValidation"
    case addSalonServiceSceneServiceNameValidation = "addSalonServiceSceneServiceNameValidation"
    case addSalonServiceSceneSalonPriceValidation = "addSalonServiceSceneSalonPriceValidation"
    case addSalonServiceSceneHomePriceValidation = "addSalonServiceSceneHomePriceValidation"
    case addSalonServiceSceneDurationValidation = "addSalonServiceSceneDurationValidation"
    
    case addSalonServiceSceneAddOnNameValidation = "addSalonServiceSceneAddOnNameValidation"
    case addSalonServiceSceneAddOnSalonPriceValidation = "addSalonServiceSceneAddOnSalonPriceValidation"
    case addSalonServiceSceneAddOnHomePriceValidation = "addSalonServiceSceneAddOnHomePriceValidation"
    case addSalonServiceSceneContinueSaveChangesButton = "addSalonServiceSceneContinueSaveChangesButton"
    case addSalonServiceScenemins = "addSalonServiceScenemins"
    
}



enum ListServiceSceneText:String {
    case listServiceSceneTitle = "listServiceSceneTitle"
    case listServiceSceneAddServiceLabel = "listServiceSceneAddServiceLabel"
    case listServiceSceneContinueButton = "listServiceSceneContinueButton"
    case listServiceSceneDeleteServiceLabel = "listServiceSceneDeleteServiceLabel"
    case listServiceSceneAddLabel = "listServiceSceneAddLabel"
}


enum TherapistListSceneText:String {
    case therapistListSceneTitle = "therapistListSceneTitle"
    case therapistListSceneAddLabel = "therapistListSceneAddLabel"
    case therapistListSceneListBusinessButtonTitle = "therapistListSceneListBusinessButtonTitle"
    case therapistListSceneThanksAlertTitle = "therapistListSceneThanksAlertTitle"
    case therapistListSceneThanksAlertSubtitle = "therapistListSceneThanksAlertSubtitle"
    case therapistListSceneThanksAlertSecondSubtitle = "therapistListSceneThanksAlertSecondSubtitle"
}

enum AddTherapistSceneText:String {
    case addTherapistSceneTitle = "addTherapistSceneTitle"
    case addTherapistSceneNameFieldPlaceholder = "addTherapistSceneNameFieldPlaceholder"
    case addTherapistSceneArabicNameFieldPlaceholder = "addTherapistSceneArabicNameFieldPlaceholder"
    case addTherapistSceneJobTitleFieldPlaceholder = "addTherapistSceneJobTitleFieldPlaceholder"
    case addTherapistSceneJobTitleArabicFieldPlaceholder = "addTherapistSceneJobTitleArabicFieldPlaceholder"
    case addTherapistSceneServicesFieldPlaceholder = "addTherapistSceneServicesFieldPlaceholder"
    case addTherapistSceneWorkingHourFieldPlaceholder = "addTherapistSceneWorkingHourFieldPlaceholder"
    case addTherapistSceneContinueButton = "addTherapistSceneContinueButton"
    case addTherapistSceneSelectNameError = "addTherapistSceneSelectNameError"
    case addTherapistSceneSelectJobTitleError = "addTherapistSceneSelectJobTitleError"
    case addTherapistSceneSelectServiceError = "addTherapistSceneSelectServiceError"
    case addTherapistSceneSelectHoursError = "addTherapistSceneSelectHoursError"
    case addTherapistSceneHoursSelectedText = "addTherapistSceneHoursSelectedText"
    case addTherapistSceneServiceSelectedText = "addTherapistSceneServiceSelectedText"
    case addTherapistSceneDisableButton = "addTherapistSceneDisableButton"
    case addTherapistSceneEnableButton = "addTherapistSceneEnableButton"
    case addTherapistSceneSaveChangesButton = "addTherapistSceneSaveChangesButton"
    case addTherapistSceneDisableTherapistText = "addTherapistSceneDisableTherapistText"
    case addTherapistSceneEnableTherapistText = "addTherapistSceneEnableTherapistText"
    case addTherapistSceneAddTherapistSuccessMessage = "addTherapistSceneAddTherapistSuccessMessage"
    case addTherapistSceneUpdateTherapistSuccessMessage = "addTherapistSceneUpdateTherapistSuccessMessage"
    case addTherapistSceneBreakSelectedText = "addTherapistSceneBreakSelectedText"
    case addTherapistOpeningworkingHoursWrongText = "addTherapistOpeningworkingHoursWrongText"
    case addTherapistCloseworkingHoursWrongText = "addTherapistCloseworkingHoursWrongText"
    case businessworkingHoursWrongText = "businessworkingHoursWrongText"
    case therapistOpeningHourText = "therapistOpeningHourText"
    case therapistCloseHourText = "therapistCloseHourText"
    
}

enum SpecialNewOffersSceneText:String {
    case SpecialNewOffersSceneTitle = "listServiceSceneTitle"
    case SpecialNewOffersSceneDeleteCellButton = "SpecialNewOffersSceneDeleteCellButton"
    case SpecialNewOffersSceneSetPriceLabel = "SpecialNewOffersSceneSetPriceLabel"
    case SpecialNewOffersSceneSetPriceTextFieldPlaceholder = "SpecialNewOffersSceneSetPriceTextFieldPlaceholder"
    case SpecialNewOffersSceneTotalPriceLabel = "SpecialNewOffersSceneTotalPriceLabel"
    case SpecialNewOffersSceneExpirationDateLabel = "SpecialNewOffersSceneExpirationDateLabel"
    case SpecialNewOffersScenePreviewOfferButton = "SpecialNewOffersScenePreviewOfferButton"
    case SpecialNewOffersSceneDoneButton = "SpecialNewOffersSceneDoneButton"
    case SpecialNewOffersSceneSetPriceValidationText = "SpecialNewOffersSceneSetPriceValidationText"
    case SpecialNewOffersSceneExpiryDateValidationText = "SpecialNewOffersSceneExpiryDateValidationText"
    case SpecialNewOffersSceneOfferCreatedText = "SpecialNewOffersSceneOfferCreatedText"
    case SpecialNewOffersSceneOfferArrayValidationText = "SpecialNewOffersSceneOfferArrayValidationText"
    case SpecialNewOffersSceneOfferPriceValidationText = "SpecialNewOffersSceneOfferPriceValidationText"
}


enum SpecialOffersListSceneText:String {
    case SpecialOffersListSceneTitle = "SpecialOffersListSceneTitle"
    case SpecialOffersListSceneDeleteCellButton = "SpecialOffersListSceneDeleteCellButton"
    case SpecialOffersListSceneAddOfferLabel = "SpecialOffersListSceneAddOfferLabel"
    case SpecialOffersListSceneExpiryDateText = "SpecialOffersListSceneExpiryDateText"
    case SpecialOffersListSceneDeleteOfferText = "SpecialOffersListSceneDeleteOfferText"
}



enum AboutSalonSceneText:String {
    case AboutSalonSceneTitle = "AboutSalonSceneTitle"
    case AboutSalonSceneAvailabilityTitleLabel = "AboutSalonSceneAvailabilityTitleLabel"
    case AboutSalonSceneHomeLabel = "AboutSalonSceneHomeLabel"
    case AboutSalonSceneSalonLabel = "AboutSalonSceneSalonLabel"
    case AboutSalonSceneAvailableLabel = "AboutSalonSceneAvailableLabel"
    case AboutSalonSceneNonAvailableLabel = "AboutSalonSceneNonAvailableLabel"
    case AboutSalonSceneInstaTitleLabel = "AboutSalonSceneInstaTitleLabel"
    case AboutSalonSceneDiscriptionTitleLabel = "AboutSalonSceneDiscriptionTitleLabel"
}

enum SelectAreaSceneText:String {
    case SelectAreaSceneTitle = "SelectAreaSceneTitle"
    case SelectAreaSceneSelectAreaTextField = "SelectAreaSceneSelectAreaTextField"
    case SelectAreaSceneFilter = "SelectAreaSceneFilter"
    case SelectAreaSceneprofileSetting = "SelectAreaSceneprofileSetting"
    case SelectAreaSceneRegisterLocation = "SelectAreaSceneRegisterLocation"
    case SelectAreaSceneBusinessLocation = "SelectAreaSceneBusinessLocation"
    case SelectAreaSceneSelectBlockTitle = "SelectAreaSceneSelectBlockTitle"
}


enum OrderDetailSceneText:String {
    case OrderDetailSceneTitle = "OrderDetailSceneTitle"
    case OrderDetailSceneTotalPriceLabel = "OrderDetailSceneTotalPriceLabel"
    case OrderDetailSceneTimeLabel = "OrderDetailSceneTimeLabel"
    case OrderDetailSceneTherapistLabel = "OrderDetailSceneTherapistLabel"
    case OrderDetailScenePaymentHeaderLabel = "OrderDetailScenePaymentHeaderLabel"
    case OrderDetailScenePaymentTypeLabel = "OrderDetailScenePaymentTypeLabel"
    case OrderDetailScenePaymentStatusLabel = "OrderDetailScenePaymentStatusLabel"
    case OrderDetailSceneSpecialInstructionLabel = "OrderDetailSceneSpecialInstructionLabel"
    case OrderDetailSceneReportButtonTitle = "OrderDetailSceneReportButtonTitle"
    case OrderDetailSceneBottomCancelButtonTitle = "OrderDetailSceneBottomCancelButtonTitle"
    case OrderDetailSceneBottomBookingButtonTitle = "OrderDetailSceneBottomBookingButtonTitle"
    case OrderDetailSceneBookingCancelledButtonTitle = "OrderDetailSceneBookingCancelledButtonTitle"
    case OrderDetailSpecialTypeScene = "OrderDetailSpecialTypeScene"
    case OrderDetailSpecialCancelScene = "OrderDetailSpecialCancelScene"
    case OrderDetailBookingTableCell = "OrderDetailBookingTableCell"
    case OrderDetailPaidAmountLabelText = "OrderDetailPaidAmountLabelText"
    case OrderDetailRemainingAmountLabelText = "OrderDetailRemainingAmountLabelText"
    case OrderDetailBookingStatusTitleLabelText = "OrderDetailBookingStatusTitleLabelText"
    case OrderDetailPaymentDetailtLabelText = "OrderDetailPaymentDetailtLabelText"
    case OrderDetailCloseButtonTitle = "OrderDetailCloseButtonTitle"
    case OrderDetailArrivalStatusLabelText = "OrderDetailArrivalStatusLabelText"
    case OrderDetailTypeTitleLabelText = "OrderDetailTypeTitleLabelText"
    case OrderDetailAmountTitleLabelText = "OrderDetailAmountTitleLabelText"
    case OrderDetailTransactionTitleLabelText = "OrderDetailTransactionTitleLabelText"
    case OrderDetailTotalAmountText = "OrderDetailTotalAmountText"
    case OrderDetailPromoCodeText = "OrderDetailPromoCodeText"
    case OrderDetailDiscountAvailText = "OrderDetailDiscountAvailText"
    case OrderDateText
    case OrderDetailViewAdressText
    case OrderDetailDiscountAmountText
    case OrderDetailPayableAmountText
    case OrderDetailTotalAmmountText
    case totalAfterDiscountTitle
    case maxDiscountLimitExceedTitle
    case maxDiscountLimitExceedValue
    case isSpecialOfferTitle
    case isSpecialOfferValue
    
}


enum AddScheduledBreakSceneText:String {
    case AddScheduledBreakSceneTitle = "AddScheduledBreakSceneTitle"
    case AddScheduledBreakSceneCustomLabelTitle = "AddScheduledBreakSceneCustomLabelTitle"
    case AddScheduledBreakSceneBreakTypeTitle = "AddScheduledBreakSceneBreakTypeTitle"
    case AddScheduledBreakSceneFullDayLabel = "AddScheduledBreakSceneFullDayLabel"
    case AddScheduledBreakSceneTitleLabel = "AddScheduledBreakSceneTitleLabel"
    case AddScheduledBreakSceneStartDateAndTimeTextField = "AddScheduledBreakSceneStartDateAndTimeTextField"
    case AddScheduledBreakSceneEndDateAndTimeTextField = "AddScheduledBreakSceneEndDateAndTimeTextField"
    case AddScheduledBreakSceneRepeatTextField = "AddScheduledBreakSceneRepeatTextField"
    case AddScheduledBreakSceneDoneButton = "AddScheduledBreakSceneDoneButton"
    case AddScheduledBreakSceneSelectTitleAlert = "AddScheduledBreakSceneSelectTitleAlert"
    case AddScheduledBreakSceneSelectStartTimeAlert = "AddScheduledBreakSceneSelectStartTimeAlert"
    case AddScheduledBreakSceneSelectEndTimeAlert = "AddScheduledBreakSceneSelectEndTimeAlert"
    case AddScheduledBreakSceneEveryDayLabel = "AddScheduledBreakSceneEveryDayLabel"
    case AddScheduledBreakSceneEndDateGreaterAlert = "AddScheduledBreakSceneEndDateGreaterAlert"
    case AddScheduledBreakSceneEndTimeGreaterAlert = "AddScheduledBreakSceneEndTimeGreaterAlert"
    case AddScheduledBreakSceneSelectDateAlert = "AddScheduledBreakSceneSelectDateAlert"
    case AddScheduledBreakSceneSelectBreakTypeAlert = "AddScheduledBreakSceneSelectBreakTypeAlert"
    
}


enum AddSpecialOfferSceneText:String {
    case AddSpecialOfferSceneTitle = "AddSpecialOfferSceneTitle"
    case AddSpecialOfferSceneOfferNameTextField = "AddSpecialOfferSceneOfferNameTextField"
    case AddSpecialOfferSceneContinueButton = "AddSpecialOfferSceneContinueButton"
    case AddSpecialOfferSceneOfferNameValidationText = "AddSpecialOfferSceneOfferNameValidationText"
    case AddSpecialOfferSceneOfferServiceValidationText = "AddSpecialOfferSceneOfferServiceValidationText"
    case AddSpecialOfferSceneAddOfferTitle = "AddSpecialOfferSceneAddOfferTitle"
    case AddSpecialOfferSceneEditOfferTitle = "AddSpecialOfferSceneEditOfferTitle"
    case AddOfferEmptyImage = "AddOfferEmptyImage"
}



enum StaffSceneText:String {
    case StaffSceneTitle = "StaffSceneTitle"
    case StaffSceneNoStaffLabel = "StaffSceneNoStaffLabel"
    
}

enum ListYourServiceSceneText:String {
    case ListYourServiceSceneTitle = "ListYourServiceSceneTitle"
    case ListYourServiceSceneSubTitle = "ListYourServiceSceneSubTitle"
    case ListYourServiceSceneSelectedServiceText = "ListYourServiceSceneSelectedServiceText"
    case ListYourServiceSceneContinueButton = "ListYourServiceSceneContinueButton"
    case ListYourServiceSceneSaveChangesButton = "ListYourServiceSceneSaveChangesButton"
    case ListYourServiceSceneCategoriesUpdated = "ListYourServiceSceneCategoriesUpdated"
}


enum BusinessTodaySceneText:String {
    case BusinessTodayTherapistText = "BusinessTodayTherapistText"
    case BusinessTodayClientNameText = "BusinessTodayClientNameText"
    case BusinessTodayTimeText = "BusinessTodayTimeText"
    case BusinessTodayCancelText = "BusinessTodayCancelText"
    case upcoming
    case pastAppointments
}

enum BusinessPageViewControllerSceneText:String {
    case businessPageViewControllerStepText = "businessPageViewControllerStepText"
}


enum BusinessPinLocationSceneText:String {
    case businessPinLocationSceneTitle = "businessPinLocationSceneTitle"
}


enum BusinessBookingSceneText:String {
    case BusinessBookingSceneTitle = "BusinessBookingSceneTitle"
    case BusinessBookingSceneSelectServiceLocationLabel = "BusinessBookingSceneSelectServiceLocationLabel"
    case BusinessBookingSceneSelectServiceLabel = "BusinessBookingSceneSelectServiceLabel"
    case BusinessBookingSceneServiceDetailLabel = "BusinessBookingSceneServiceDetailLabel"
    case BusinessBookingSceneClientLabel = "BusinessBookingSceneClientLabel"
    case BusinessBookingSceneBookServiceButton = "BusinessBookingSceneBookServiceButton"
    case BusinessBookingScenePickYourServiceLabel = "BusinessBookingScenePickYourServiceLabel"
    case BusinessBookingSceneAtSalonButton = "BusinessBookingSceneAtSalonButton"
    case BusinessBookingSceneAtHomeButton = "BusinessBookingSceneAtHomeButton"
    case BusinessBookingScenePickDoneButton = "BusinessBookingScenePickDoneButton"
    case BusinessBookingScenePickCancelButton = "BusinessBookingScenePickCancelButton"
    case BusinessBookingSceneHomeSelectedText = "BusinessBookingSceneHomeSelectedText"
    case BusinessBookingSceneSalonSelectedText = "BusinessBookingSceneSalonSelectedText"
    case BusinessBookingSceneServiceSelectedText = "BusinessBookingSceneServiceSelectedText"
    case BusinessBookingSceneServiceTypeLabelText = "BusinessBookingSceneServiceTypeLabelText"
    case BusinessBookingSceneSelectServiceErrorAlert = "BusinessBookingSceneSelectServiceErrorAlert"
    case BusinessBookingSceneTimingSlotErrorAlert = "BusinessBookingSceneTimingSlotErrorAlert"
    case BusinessBookingSceneSelectServiceFirstAlert = "BusinessBookingSceneSelectServiceFirstAlert"
    case BusinessBookingSceneSelectClientErrorAlert = "BusinessBookingSceneSelectClientErrorAlert"
    case BusinessBookingSceneBookingConfirmedMessage = "BusinessBookingSceneBookingConfirmedMessage"
    case BusinessBookingConfirmAlertMessage = "BusinessBookingConfirmAlertMessage"
}


enum BusinessCalenderSceneText:String {
    case BusinessCalenderSceneTitle = "BusinessCalenderSceneTitle"
    case BusinessCalenderSceneServiceNameLabel = "BusinessCalenderSceneServiceNameLabel"
    case BusinessCalenderSceneServiceDurationLabel = "BusinessCalenderSceneServiceDurationLabel"
    case BusinessCalenderSceneServiceDurationMinuteText = "BusinessCalenderSceneServiceDurationMinuteText"
    case BusinessCalenderSceneTotalPriceLabel = "BusinessCalenderSceneTotalPriceLabel"
    case BusinessCalenderSceneTimeLabel = "BusinessCalenderSceneTimeLabel"
    case BusinessCalenderSceneHairCutLabel = "BusinessCalenderSceneHairCutLabel"
    case BusinessCalenderDeleteAlert = "BusinessCalenderDeleteAlert"
    case BusinessCalenderConfirmPopupTitle = "BusinessCalenderConfirmPopupTitle"
}

enum BusinessChatSceneText:String {
    case BusinessChatSceneTypingTextLabel = "BusinessChatSceneTypingTextLabel"
    case BusinessChatSceneOnlineTextLabel = "BusinessChatSceneOnlineTextLabel"
    case BusinessChatSceneOfflineTextLabel = "BusinessChatSceneOfflineTextLabel"
    case BusinessChatSceneTextViewText = "BusinessChatSceneTextViewText"
}

enum BusinessChatMessageSceneText:String {
    case BusinessChatMessageSceneTitle = "BusinessChatMessageSceneTitle"
}


enum BusinessAppointmentDetailSceneText:String {
    case BusinessAppointmentDetailSceneTitle = "BusinessAppointmentDetailSceneTitle"
    case BusinessAppointmentDetailSceneReportButtonTitle = "BusinessAppointmentDetailSceneReportButtonTitle"
    case BusinessAppointmentDetailSceneReportAlertText = "BusinessAppointmentDetailSceneReportAlertText"
    case BusinessAppointmentDetailSceneReportApiSuccessText = "BusinessAppointmentDetailSceneReportApiSuccessText"
    case BusinessAppointmentPriceLabelText = "BusinessAppointmentPriceLabelText"
    
}

enum ListScheduledBreakSceneText:String {
    case ListScheduledBreakSceneTitle = "ListScheduledBreakSceneTitle"
    case ListScheduledBreakSceneDoneButton = "ListScheduledBreakSceneDoneButton"
    case ListScheduledBreakSceneDeleteButton = "ListScheduledBreakSceneDeleteButton"
    case ListScheduledBreakSceneAddScheduledLabel = "ListScheduledBreakSceneAddScheduledLabel"
    case ListScheduledBreakSceneAddScheduledBreakLabel = "ListScheduledBreakSceneAddScheduledBreakLabel"
    case ListScheduledBreakSceneFullDay = "ListScheduledBreakSceneFullDay"
}







// Validations

enum ValidationsText:String {
    case emptyName = "emptyName"
    case emptyPhoneNumber = "emptyPhoneNumber"
    case phoneNumberMinLength = "phoneNumberMinLength"
    case invalidPhoneNumber = "invalidPhoneNumber"
    case emptyPassword = "emptyPassword"
    case emptyNewPassword = "emptyNewPassword"
    case emptyConfirmPassword = "emptyConfirmPassword"
    case confirmPasswordMatch = "confirmPasswordMatch"
    case passwordLength = "passwordLength"
    case emptyEmail = "emptyEmail"
    case invalidEmail = "invalidEmail"
    case emptyArea = "emptyArea"
    case emptyBirthdate = "emptyBirthdate"
    case emptyCountryCode = "emptyCountryCode"
    case emptyImage = "emptyImage"
    case enterArea
    case enterBlock
}

// General

enum GeneralText: String {
    case bookingConfirmedSuccessfully
    case imageUploadedSuccess = "imageUploadedSuccess"
    case keyboardDoneButton = "keyboardDoneButton"
    case appName = "Bahrain Salons"
    case no = "no"
    case yes = "yes"
    case cancel = "cancel"
    case editRow = "Edit"
    case deleteRow = "Delete"
    case pleaseLogin = "pleaseLogin"
    case gpsPermission = "gpsPermission"
    case cameraPermission = "cameraPermission"
    case image
    case document
    case noSalonAvailableMessage = "noSalonAvailableMessage"
    case noAppointmentsAvailableMessage = "noAppointmentsAvailableMessage"
    case permissionHeading = "permissionHeading"
    case nextButton = "nextButton"
    case bhd = "bhd"
    case ok = "ok"
    case doneButton = "doneButton"
    case cancelButton = "cancelButton"
    case comingSoon = "comingSoon"
    case Continue = "Continue"
    case ConfirmBooking = "ConfirmBooking"
    case sessionexpired = "sessionexpired"
    case from
    case to
    case accept
    case reject
    case bookingId
    case paymentSsnTimedOut
    case validTill
    case amount
    case expiaryMonth
    case expiaryYear
    case cashOutWarning
    case salonAvailService
    case availService
    case cancelled
    case confirm
    case confirmed
    case selectAnotherSlot
    case useMyCurrentLocation
    case by
    case serviceCompleted
    case basicInfoAdded
    case locationFetched
    case businessPinned
    case servicesAdded
    case serviceUpdated
    case serviceAdded
    case englishDigitsError
    case mon
    case tue
    case wed
    case thu
    case fri
    case sat
    case sun
    case armon
    case artue
    case arwed
    case arthu
    case arfri
    case arsat
    case arsun
    case monthView
    case weekView
    case paymentMsg
    case businessAlreadyExist
    case businessAlreadyApproved
    case registeredOn
    case generalTextNoInternetError
    case tooManyGooglePlacesRequests
    case googleServerError
    case searchPlace
    case reminderNotification0
    case reminderNotification1
    case reminderNotification2
    case reminderNotification3
    case reminderNotification4
    case reminderHeader
}

enum SpecialOffersText:String {
    case specialOffers
    case homeServices
    case homePackages
    case salonServices
    case salonPackages
    case off
    case addItem
    case outOf
    case checkout
    case maxSelection
    case specialInstructions
}

// Twilio Wrapper

enum TwilioWrapperText:String {
    case userMessage = "userMessage"
}

