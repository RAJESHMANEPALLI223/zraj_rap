@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'UN MANAGED INTERFACE VIEW'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_TRAVELRAJ_U as  select from /dmo/travel as TRAVEL
composition  [0..*] of ZI_BOOKINGRAJ_U as _booking
association [0..1] to /dmo/agency as _AGENCY on $projection.AgencyId = _AGENCY.agency_id
association [0..1] to /DMO/I_Customer as _Customer on $projection.CustomerId = _Customer.CustomerID
association [0..1] to I_Currency as _Currency on $projection.CurrencyCode = _Currency.Currency
association [1..1] to /DMO/I_Travel_Status_VH as _TravelStatus on $projection.Status = _TravelStatus.TravelStatus
{
    
    key TRAVEL.travel_id as TravelId,
    
    TRAVEL.agency_id as AgencyId,
    
    TRAVEL.customer_id as CustomerId,
    
    TRAVEL.begin_date as BeginDate,
    
    TRAVEL.end_date as EndDate,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    TRAVEL.booking_fee as BookingFee,
      @Semantics.amount.currencyCode: 'CurrencyCode'
    TRAVEL.total_price as TotalPrice,
    TRAVEL.currency_code as CurrencyCode,
    TRAVEL.description as Description,
    TRAVEL.status as Status,
    TRAVEL.createdby as Createdby,
    TRAVEL.createdat as Createdat,
    TRAVEL.lastchangedby as Lastchangedby,
    TRAVEL.lastchangedat as Lastchangedat,
    _booking,
    _AGENCY,
    _Customer,
    _Currency,
    _TravelStatus
}
