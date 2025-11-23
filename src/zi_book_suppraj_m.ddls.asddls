@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BOOKING SUPLEMENT INTERFACE VIEW'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_BOOK_SUPPRAJ_M as select from zbooksuppraj_m
association to parent ZI_BOOKINGRAJ_M as _Booking on $projection.BookingId = _Booking.BookingId
                                                  and $projection.TravelId = _Booking.TravelId
association [1..1] to ZI_TRAVELRAJ_M as _Travel on $projection.TravelId = _Travel.TravelId
association [1..1] to /DMO/I_Supplement as _supplement on $projection.SupplementId = _supplement.SupplementID
association [1..*] to /DMO/I_SupplementText as _Supplementtext on $projection.SupplementId = _Supplementtext.SupplementID
{
    key travel_id as TravelId,
    key booking_id as BookingId,
    key booking_supplement_id as BookingSupplementId,
    supplement_id as SupplementId,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    price as Price,
    currency_code as CurrencyCode,
    last_changed_at as LastChangedAt,
    _Booking,
    _Travel,
    _supplement,
    _Supplementtext
}
