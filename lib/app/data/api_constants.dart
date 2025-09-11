class ApiConstants{
/// google maps

  static String googleBaseUrl="https://maps.googleapis.com/maps/api/place/autocomplete/json";
  static String estimatedTimeUrl="https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&";
   /// App Url
    static String baseUrl="https://radwan5000.sobhoy.com";
    static String  imageBaseUrl="http://10.0.80.205:9090";
    static String socketUrl="http://radwan5000.sobhoy.com";


///>>>>>>>>>>>>>>>>>>>>>>>>>>> Api End point >>>>>>>>>>>>>>>>>>>

static String registerUrl= '/api/v1/user/register';
static String verifyOtpUrl= '/api/v1/user/verify-otp';
static String verifyForgotOtpUrl(String userMail) =>  '/api/v1/user/verify-forget-otp?email=$userMail';
static String searchMechanicUrl(String service) =>  '/api/v1/mechanic/all?serviceName=$service';
static String mechanicDetailsUrl(String mechanicId) =>  '/api/v1/mechanic/$mechanicId';
static String mechanicAcceptOrderUrl(String orderId) =>  '/api/v1/order/accept/$orderId';
static String mechanicCancelOrderUrl(String orderId) =>  '/api/v1/order/cancel/$orderId';
static String mechanicMarkAsCompleteUrl(String orderId) =>  '/api/v1/order/markComplete/$orderId';
static String mechanicServiceWithPriceUrl(String mechanicId) =>  '/api/v1/mechanic/services/$mechanicId';
static String favouriteUrl(String mechanicId) =>  '/api/v1/favourite/toggle/$mechanicId';
static String orderStatusUrl(String status) =>  '/api/v1/order/status/$status';
static String orderDetailsUrl(String orderId) =>  '/api/v1/order/$orderId';
static String deleteServiceUrl(String serviceId) => '/api/v1/service/mechanic/$serviceId';
static String toggleAvailabilityUrl(String mechanicId) =>  '/api/v1/mechanic/toggle-availability/$mechanicId';
static String paymentMethodDeleteUrl(String methodId) =>  '/api/v1/payment-method/$methodId';
static String vehicleDeleteUrl(String vehicleId) =>  '/api/v1/vehicle/$vehicleId';
static String chatHistoryUrl(String receiverId) =>  '/api/v1/chat/$receiverId';
static String orderTrackingInitializeUrl(String mechanicId) =>  '/api/v1/locationTracking/initialize/$mechanicId';
static String myLocationUrl(String myId) =>  '/api/v1/user/location/$myId';
static String makePaymentUrl(String orderId) =>  '/api/v1/order/makePayment/$orderId';
static String reviewUrl(String mechanicId) =>  '/api/v1/review/$mechanicId';
static String allMechanicUrl({int? currentPage, int? limit}) =>  '/api/v1/mechanic/all?currentPage=$currentPage&limit=$limit';

static String emailSendUrl= '/api/v1/user/forget-password';
static String verifyEmailWithOtpUrl= '$baseUrl/auth/verify-email';
static String resendOtpUrl= '/api/v1/user/resend';
static String logInUrl= '/api/v1/user/login';
static String resetPasswordUrl= '/api/v1/user/reset-password';
static String changePasswordUrl= '/api/v1/user/change-password';
static String mechanicServiceUrl= '/api/v1/service/all';
static String userProfileUrl= '/api/v1/user/profile';
static String bookOrderUrl= '/api/v1/order';
static String addVehicleUrl= '/api/v1/vehicle';
static String allVehicleUrl= '/api/v1/vehicle/all';
static String bookedOrdersUrl= '/api/v1/order/user';
static String mechanicAvailabilityUrl= '/api/v1/mechanic/availability';
static String serviceAreaUrl= '/api/v1/mechanic/serviceRadius';
static String mechanicPaymentStatusUrl= '/api/v1/withdraw/mechanic';
static String walletOverviewUrl= '/api/v1/wallet';
static String withdrawRequestUrl= '/api/v1/withdraw/withdraw-request';
static String mechanicServiceRateUrl= '/api/v1/mechanicServiceRate';
static String addServiceRateUrl= '/api/v1/service/mechanic/add';
static String paymentMethodUrl= '/api/v1/payment-method';
static String paymentMethodCreationUrl= '/api/v1/payment-method/create';
static String myVehicleUrl = '/api/v1/vehicle/all';
static String vehicleCreateUrl = '/api/v1/vehicle';
static String favouriteAllUrl = '/api/v1/favourite/all';
static String updateProfileUrl = '/api/v1/user/updateProfile';
static String setLocationUrl = '/api/v1/user/set-location';
static String giveReviewUrl = '/api/v1/review';
static String notificationUrl = '/api/v1/notification';


}