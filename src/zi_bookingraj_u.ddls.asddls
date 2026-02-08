@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'UNMANAGED BOOKING'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_BOOKINGRAJ_U as select from /dmo/booking as Booking

association to parent ZI_TRAVELRAJ_U as _travel on $projection.TravelId = _travel.TravelId

association [1..1] to /DMO/I_Customer as _Customer on $projection.CustomerId = _Customer.CustomerID
association [1..1] to /DMO/I_Carrier as _Carrier on $projection.AirlineID = _Carrier.AirlineID
association [1..1] to /DMO/I_Connection as _connection on $projection.AirlineID = _connection.AirlineID
                                                  and $projection.ConnectionId = _connection.ConnectionID

{
   key travel_id as TravelId,
   key booking_id as BookingId,
   booking_date as BookingDate,
   customer_id as CustomerId,
   carrier_id as AirlineID,
   connection_id as ConnectionId,
   flight_date as FlightDate,
   @Semantics.amount.currencyCode: 'CurrencyCode'
   flight_price as FlightPrice,
   currency_code as CurrencyCode,
   _travel,
   _Customer,
   _connection,
   _Carrier
}
