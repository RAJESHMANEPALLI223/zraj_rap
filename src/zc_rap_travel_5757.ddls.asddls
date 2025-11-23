@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CONSUMPTION VIEW'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_RAP_Travel_5757 as projection on ZI_RAP_Travel_5757
{
    key TravelUUID,
    @Search.defaultSearchElement: true
    TravelID,
    @Consumption.valueHelpDefinition: [{ entity :{ name: '/dmo/agency', element: 'AgencyID'  } }]
    @ObjectModel.text.element: [ 'AgencyName' ]
    AgencyID,
    _Agency.Name       as AgencyName, 
    @Consumption.valueHelpDefinition: [{ entity :{name: '/dmo/customer', element: 'CustomerID'}  }]
    CustomerID,
    BeginDate,
    EndDate,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    BookingFee,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    TotalPrice,
    @Consumption.valueHelpDefinition: [{ entity :{name: 'I_Currency', element: 'CurrencyCode'}  }]
    CurrencyCode,
    Description,
    TravelStatus,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    LocalLastChangedAt,
    /* Associations */
    _Agency,
    _Booking: redirected to composition child ZC_RAP_BOOKING_5757,
    _Currency,
    _Customer
}
