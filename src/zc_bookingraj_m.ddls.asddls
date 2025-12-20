@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CONSUMPTION VIEW FOR THE BOOKING'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true

define view entity ZC_BOOKINGRAJ_M as projection on ZI_BOOKINGRAJ_M
{
    key TravelId,
    key BookingId,
    BookingDate,
    @ObjectModel.text.element: [ 'CustomerName' ]
    CustomerId,
     _customer.LastName         as CustomerName,
      @ObjectModel.text.element: [ 'CarrierName' ]
    CarrierId,
    
      _Carrier.Name              as CarrierName,
    ConnectionId,
    FlightDate,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    FlightPrice,
    CurrencyCode,
     @ObjectModel.text.element: [ 'BookingStatusText' ]
    BookingStatus,
    _booking_status._Text.Text as BookingStatusText : localized,
    LastChangedAt,
    /* Associations */
    _bookingsuppl : redirected to composition child ZC_BOOK_SUPPRAJ_M,
    _booking_status,
    _Carrier,
    _connection,
    _customer,
    _travel : redirected to parent ZC_TRAVELRAJ_M
}
