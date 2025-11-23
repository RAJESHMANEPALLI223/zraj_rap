@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CONSUMPTION VIEW FOR THE TRAVEL'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZC_TRAVELRAJ_M  provider contract transactional_query as projection on ZI_TRAVELRAJ_M
{
    key TravelId,
    @ObjectModel.text.element: [ 'AgencyName' ]
    AgencyId,
    _AGENCY.Name as AgencyName,
     @ObjectModel.text.element: [ 'CustomerName' ]
    CustomerId,
    _customer.LastName as CustomerName,
    BeginDate,
    EndDate,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    BookingFee,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    TotalPrice,
    CurrencyCode,
    Description,
    @ObjectModel.text.element: [ 'OverallStatusText' ]
    OverallStatus,
    _status._Text.Text as OverallStatusText : localized,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    /* Associations */
    _AGENCY,
    _BOOKING : redirected to composition child ZC_BOOKINGRAJ_M ,
    _currency,
    _customer,
    _status
}
