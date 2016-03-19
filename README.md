# ImlClient
Ruby клиент для API службы доставки IML ([www.iml.ru](http://iml.ru/)).

## Установка
Добавить в Gemfile:

    gem 'iml_client'
    
И выполнить:

    $ bundle

Или установить вручную:

    $ gem install iml_client

## Начало работы

Создать инстанс класса `ImlClient::Client`:
```ruby
client = ImlClient::Client.new ВАШ_ЛОГИН, ВАШ_ПАРОЛЬ
```
В тестовом режиме:
```
client = ImlClient::Client.new ВАШ_ЛОГИН, ВАШ_ПАРОЛЬ, test_mode: true
```

Вызовы возвращают объект класса `ImlClient::Result`. Результат хранится в атрибуте `data`, ошибки (если присутствуют) в `errors`. Полный результат запроса ([HTTParty](https://github.com/jnunemaker/httparty)) можно получить из атрибута `response`. Например: 
```ruby
result = client.orders DeliveryDateStart: Date.new(2015, 9, 20), DeliveryDateEnd: Date.new(2015, 9, 30)
result.errors.any? # => false
result.data.length # => 20
result.data.each do |order|
  puts order[:Job]
end

result = client.create_order Job: '24', CustomerOrder: 'R123456', Contact: 'John Doe', Phone: '123-456-789', RegionCodeFrom: 'МОСКВА', RegionCodeTo: 'ВИНТЕРФЕЛЛ'
result.data # => {}
result.errors.length # => 2
result.errors.each do |error|
  puts "#{error.code} - #{error.message}"
end
# RegionCodeTo - Неверно указан регион получения!
# Address - Адрес указан не верно!
```

## Ошибки
Классы ошибок наследуют от `ImlClient::Error`:
* StandardError
  * ImlClient::Error
    * ImlClient::ResponseError
    * ImlClient::APIError

Например:
```ruby
# ImlClient::ResponseError
error.code # => 500
error.message # => internal server error

# ImlClient::APIError
error.code # => RegionCodeTo
error.message # => Неверно указан регион получения!
```

## Методы
Для получения детальной информации о формате передаваемых и возвращаемых данных ознакомьтесь с официальной документацией к API: [api.iml.ru](http://api.iml.ru), [list.iml.ru](http://list.iml.ru).

Даты можно передавать как объекты класса `Date`, так и как строки в формате `%d.%m.%Y`.

#### Создание нового заказа
```ruby
client.create_order params
```

#### Список заказов
```ruby
client.orders
client.orders filter_params
```

#### Список статусов заказов
```ruby
client.order_statuses
client.order_statuses filter_params
```

#### Подсчёт стоимости доставки
```ruby
client.calculate_price params
```

#### Список складов
```ruby
client.locations
client.locations filter_params
```

Помимо параметров фильтрации, предоставляемых API, здесь также доступны два дополнительных параметра:
- `IncludeNotOpened`- `boolean`. Включить в список еще не открывшиеся склады (c `OpeningDate` больше текущей даты). По умолчанию `false`.
- `IncludeClosed`- `boolean`. Включить в список закрывшиеся склады (c `ClosingDate` меньше или равным текущей дате). По умолчанию `false`.

#### Список заблокированных регионов IML, в разрезе услуг
```ruby
client.exception_service_regions
client.exception_service_regions filter_params
```

Помимо параметров фильтрации, предоставляемых API, здесь также доступны два дополнительных параметра:
- `IncludeNotOpened`- `boolean`. Включить в список еще не заблокированные регионы (c `Open` больше текущей даты). По умолчанию `false`.
- `IncludeEnded`- `boolean`. Включить в список уже разблокированные регионы (c `End` меньше или равным текущей дате). По умолчанию `false`.

#### Список регионов IML
```ruby
client.regions
```

#### Список пунктов самовывоза
```ruby
client.pickup_points
client.pickup_points filter_params
```

Помимо параметров фильтрации, предоставляемых API, здесь также доступны два дополнительных параметра:
- `IncludeNotOpened`- `boolean`. Включить в список еще не открывшиеся пункты (c `OpeningDate` больше текущей даты). По умолчанию `false`.
- `IncludeClosed`- `boolean`. Включить в список закрывшиеся пункты (c `ClosingDate` меньше или равным текущей дате). По умолчанию `false`.

#### Справочник статусов
```ruby
client.status_types
```

#### Справочник почтовых индексов
```ruby
client.post_codes
```

#### Список услуг
```ruby
client.services
```

#### Список зон доставки
```ruby
client.zones
```

## TODO
- Тесты

## Ссылки
- [iml.ru](http://iml.ru/) - Сайт IML.
- [api.iml.ru](http://api.iml.ru/) - Документация к API IML.
- [list.iml.ru](http://list.iml.ru/) - Документация к API справочного сервиса IML.


Разработано при поддержке интернет-магазина настольных игр "[Танго и Кэш](http://tango-cash.ru/)"
