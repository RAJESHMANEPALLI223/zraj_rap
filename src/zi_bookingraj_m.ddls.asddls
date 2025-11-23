@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'INTERFACE VIEW FOR BOOKING'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_BOOKINGRAJ_M as select from zbookingraj_m
association to parent ZI_TRAVELRAJ_M as _travel on $projection.TravelId = _travel.TravelId
composition [0..*] of ZI_BOOK_SUPPRAJ_M as _bookingsuppl
association [1..1] to /DMO/I_Carrier as _Carrier on $projection.CarrierId = _Carrier.AirlineID
association [1..1] to /DMO/I_Customer as _customer on $projection.CustomerId = _customer.CustomerID
association [1..1] to /DMO/I_Connection as _connection on $projection.ConnectionId = _connection.ConnectionID
                                                        and $projection.CarrierId = _connection.AirlineID
   association [1..1] to /DMO/I_Booking_Status_VH as _booking_status on $projection.BookingStatus = _booking_status.BookingStatus                                                     
{
    key travel_id as TravelId,
    key booking_id as BookingId,
    booking_date as BookingDate,
    customer_id as CustomerId,
    carrier_id as CarrierId,
    connection_id as ConnectionId,
    flight_date as FlightDate,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    flight_price as FlightPrice,
    currency_code as CurrencyCode,
    booking_status as BookingStatus,
    last_changed_at as LastChangedAt,
    _travel,
    _bookingsuppl,
    _Carrier,
    _connection,
    _customer,
    _booking_status
    
}
