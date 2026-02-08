@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ROOT ENTITY FOR TRAVEL'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_TRAVELRAJ_M as select from ztravelraj_m
composition [0..*] of ZI_BOOKINGRAJ_M  as _BOOKING
association [0..1] to /DMO/I_Agency as _AGENCY on $projection.AgencyId = _AGENCY.AgencyID
association [0..1] to /DMO/I_Customer as _customer on $projection.CustomerId = _customer.CustomerID
association [0..1] to I_Currency as _currency on $projection.CurrencyCode = _currency.Currency
association [1..1] to /DMO/I_Overall_Status_VH as _status on $projection.OverallStatus = _status.OverallStatus 
{
    
    key ztravelraj_m.travel_id as TravelId,
    ztravelraj_m.agency_id as AgencyId,
    ztravelraj_m.customer_id as CustomerId,
    ztravelraj_m.begin_date as BeginDate,
    ztravelraj_m.end_date as EndDate,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    ztravelraj_m.booking_fee as BookingFee,
        @Semantics.amount.currencyCode: 'CurrencyCode'
    ztravelraj_m.total_price as TotalPrice,
    ztravelraj_m.currency_code as CurrencyCode,
    ztravelraj_m.description as Description,
    ztravelraj_m.overall_status as OverallStatus,
    @Semantics.user.createdBy: true
    ztravelraj_m.created_by as CreatedBy,
    @Semantics.systemDateTime.createdAt: true
    ztravelraj_m.created_at as CreatedAt,
    @Semantics.user.localInstanceLastChangedBy: true
    ztravelraj_m.last_changed_by as LastChangedBy,
    @Semantics.systemDateTime.localInstanceLastChangedAt: true
    ztravelraj_m.last_changed_at as LastChangedAt,
    _BOOKING,
    _AGENCY,
    _customer,
    _currency,
    _status
    
}
