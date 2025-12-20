@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BOOKING SUPLEMENT CONSUMPTION  VIEW'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_BOOK_SUPPRAJ_M as projection on ZI_BOOK_SUPPRAJ_M
{
    key TravelId,
    key BookingId,
    key BookingSupplementId,
    @ObjectModel.text.element: [ 'SupplemenDesc' ]
    SupplementId,
     _Supplementtext.Description as SupplemenDesc : localized,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    Price,
    CurrencyCode,
    LastChangedAt,
    /* Associations */
    _Booking : redirected to parent ZC_BOOKINGRAJ_M,
    _supplement,
    _Supplementtext,
    _Travel : redirected to ZC_TRAVELRAJ_M
}
