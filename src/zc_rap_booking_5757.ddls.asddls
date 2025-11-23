@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'booking consumption view'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_RAP_BOOKING_5757 as projection on ZI_RAP_Booking_5757 as booking
{
    key BookingUUID,
    TravelUUID,
    @Search.defaultSearchElement: true
    BookingID,
    BookingDate,
    @Consumption.valueHelpDefinition: [{ entity :{name: '/DMO/I_Customer', element: 'CustomerID'}}]
    @ObjectModel.text.element: [ 'CustomerName' ]
    @Search.defaultSearchElement: true
    CustomerID,
    _Customer.LastName as CustomerName, 
    @Consumption.valueHelpDefinition: [{ entity : {name: '/DMO/I_Carrier',element: 'AirlineID'}  }]
    @ObjectModel.text.element: [ 'CarrierName' ]
    CarrierID,
    _Carrier.Name      as CarrierName, 
      @Consumption.valueHelpDefinition: [ {entity: {name: '/DMO/I_Flight', element: 
'ConnectionID'}, 
                                            additionalBinding: [ { localElement: 
'CarrierID',    element: 'AirlineID' }, 
                                                                 { localElement: 
'FlightDate',   element: 'FlightDate',   usage: #RESULT}, 
                                                                 { localElement: 
'FlightPrice',  element: 'Price',        usage: #RESULT }, 
                                                                 { localElement: 
'CurrencyCode', element: 'CurrencyCode', usage: #RESULT } ] } ] 
    ConnectionID,
    FlightDate,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    FlightPrice,
    @Consumption.valueHelpDefinition: [{entity: {name: 'I_Currency', element: 
'Currency' }}] 
    CurrencyCode,
    CreatedBy,
    LastChangedBy,
    LocalLastChangedAt,
    /* Associations */
    _Carrier,
    _Connection,
    _Currency,
    _Customer,
    _Flight,
    _travel :redirected to parent ZC_RAP_Travel_5757
    
}
