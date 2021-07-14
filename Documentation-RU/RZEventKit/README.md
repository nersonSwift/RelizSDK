# RZEventKit

Модуль облегчающий работу с ивент мапингом, 
можно настроить отправку в любые трекинговые системы.

## Начало работы

### Подключение трекинговой системы

Для того, что бы подключить трекинговую систему, нужно написать класс наследующийся  от `EventSendDelegate`. Пример кода для adjust:

```Swift
class AdjustEventSender: EventSendDelegate{
    var revenue: Double?
    var currency: String?
    
    init(_ revenue: Double?, _ currency: String?){
        self.revenue = revenue
        self.currency = currency
    }
    
    override func send(_ name: String?, _ value: Any?) {
        guard let name = name else {return}
        let event = ADJEvent(eventToken: name)
        if let revenue = revenue, let currency = currency{
            event?.setRevenue(revenue, currency: currency)
        }
        if let value = value as? [String: String]{
            value.forEach{ event?.addCallbackParameter($0.key, value: $0.value) }
        }
        Adjust.trackEvent(event)
    }
}
```

Для удобства можно добавить extension для `EventSendDelegate`

```Swift
extension EventSendDelegate{
    static func adjust(revenue: Double? = nil, currency: String? = nil) -> AdjustEventSender{
        AdjustEventSender(revenue, currency)
    }
}
```

Profit!

### Отправка ивента

Для отправки эвент можно использовать следующий код:

```Swift
RZEvent(.adjust(revenue: 5, currency: "USD")).name("roop6f").value(["period": "3"]).send()
```

В данном коде, производится отправка эвент подписки, с ценностью в $5, название эвента - это токен, значение словарь в котором передается период использования подписки.

P.S. Все используемые в примере значения могут отличаться в зависимости от настроек трекинговой системы.

Так же есть возможность компоновать эвенты и отправлять сразу в несколько мест.

```Swift
let type = "Test1"
let value = "A"
RZEvent{
    RZEvent(.amp(isProperty: true)).name(type).value(value)
    RZEvent{
        RZEvent(.amp()).name("Set test")
        RZEvent(.adjust()).name("roop6f")
    }.value([type: value])
}.send() 
```

Здесь производится отправка 3х эвентов. Данные эвенты нужны для трекинга а/б теста. Значение `type` это название теста, а `value` группа в которую попал юзер. Первый эвент отправляется в Amplitude и устанавливает user property с название теста и значением группы. Второй эвент отправляется так же в Amplitude, но уже в виде события, с названием "Set test". Третий эвент оправляется в Adjust по токену "roop6f". У второго и третьего эвента общие параметры, словарь с ключом == названию теста и значение == группе в которую был определен пользователь. 

Profit!
