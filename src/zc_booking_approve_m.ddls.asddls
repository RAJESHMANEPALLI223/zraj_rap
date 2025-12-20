@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CONSUMPTION VIEW FOR THE APPROVERbook'
@Metadata.ignorePropagatedAnnotations: true
@UI: {
  headerInfo: { typeName: 'Booking',
                typeNamePlural: 'Bookings',
                title: { type: #STANDARD, value: 'BookingID' }
  }
}

@Search.searchable: true
define view entity ZC_BOOKING_APPROVE_M as projection on ZI_BOOKINGRAJ_M
{

 @UI.facet: [ { id:            'Booking',
                           purpose:       #STANDARD,
                           type:          #IDENTIFICATION_REFERENCE,
                           label:         'Booking',
                           position:      10 }]
      @Search.defaultSearchElement: true
    key TravelId,
      @UI: { lineItem:       [ { position: 20, importance: #HIGH } ],
          identification: [ { position: 20 } ] }
      @Search.defaultSearchElement: true
    key BookingId,
      @UI: { lineItem:       [ { position: 30, importance: #HIGH } ],
             identification: [ { position: 30 } ] }
    BookingDate,
    @UI: { lineItem:       [ { position: 40, importance: #HIGH } ],
             identification: [ { position: 40 } ],
             selectionField: [{ position: 10 }]
              }
      @ObjectModel.text.element: ['CustomerName']
      @Search.defaultSearchElement: true
    CustomerId,
     _customer.LastName as CustomerName,
     @UI: { lineItem:       [ { position: 50, importance: #HIGH } ],
             identification: [ { position: 50 } ] }
      @ObjectModel.text.element: ['CarrierName']
    CarrierId,
    _Carrier.Name      as CarrierName,
     @UI: { lineItem:       [ { position: 60, importance: #HIGH } ],
             identification: [ { position: 60 } ] }
    ConnectionId,
      @UI: { lineItem:       [ { position: 70, importance: #HIGH } ],
             identification: [ { position: 70 } ] }
    FlightDate,
     @UI: { lineItem:       [ { position: 80, importance: #HIGH } ],
             identification: [ { position: 80 } ] }
      @Semantics.amount.currencyCode: 'CurrencyCode'
    FlightPrice,
      @UI: { lineItem:       [ { position: 90, importance: #HIGH, label: 'Status' } ],
             identification: [ { position: 90, label: 'Status' } ],
             textArrangement: #TEXT_ONLY }
      @Consumption.valueHelpDefinition: [{ entity: { name: '/DMO/I_Booking_Status_VH', element: 'BookingStatus' }}]
      @ObjectModel.text.element: ['BookingStatusText']
    CurrencyCode,
     @UI.hidden: true
      _booking_status._Text.Text as BookingStatusText : localized,
    BookingStatus,
     @UI.hidden: true
    LastChangedAt,
    /* Associations */
    _bookingsuppl,
    _booking_status,
    _Carrier,
    _connection,
    _customer,
    _travel : redirected to parent ZC_TRAVEL_APPROVE_M
}
