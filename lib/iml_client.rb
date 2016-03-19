require 'iml_client/client'

module ImlClient

  extend self

  REST_API_HOST = 'api.iml.ru'
  LIST_API_HOST = 'list.iml.ru'

  API_PATHS = {
    orders:                    'json/GetOrders',
    order_statuses:            'json/GetStatuses',
    create_order:              'json/CreateOrder',
    calculate_price:           'json/GetPrice',
    locations:                 'Location',
    exception_service_regions: 'ExceptionServiceRegion',
    regions:                   'region',
    pickup_points:             'SD',
    status_types:              'status',
    post_codes:                'PostCode',
    services:                  'service',
    zones:                     'zone'
  }.freeze

  RESPONSE_NORMALIZATION_RULES = {
    orders: {
      DeliveryDate: :to_date
    }.freeze,
    order_statuses: {
      StatusDate: :to_date
    }.freeze,
    create_order: {
      DeliveryDate: :to_date
    }.freeze,
    locations: {
      OpeningDate: :to_date,
      ClosingDate: :to_date
    }.freeze,
    exception_service_regions: {
      Open: :to_date,
      End:  :to_date
    }.freeze,
    pickup_points: {
      OpeningDate: :to_date,
      ClosingDate: :to_date
    }.freeze
  }.freeze

  REQUEST_DATE_FORMAT = '%d.%m.%Y'

end
