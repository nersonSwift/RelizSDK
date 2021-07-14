# RZStoreKit

Модуль облегчающий работу с StoreKit.

## Начало работы

### Создание продуктов

Для добавления подписки в приложение нужно создать extension для `RZProduct`

```Swift
extension RZProduct{
    static var weeklyA: RZProduct {
        RZProduct(id: "any product id",
                  customData: [
                      "af": "week_a",
                      "adjust": [false: "3u6waw"]
                  ]
        )
    }
}
```

В коде создается недельная подписка. id - это идентификатор продукта в AppStore, customData - это любая информация типа Any которую нужно будет использовать в дальнейшем. 

После создания всех продуктов, нужно инициализировать `sharedSecret` и созданные продукты.

```Swift
RZProduct.sharedSecret = "any shared secret"
RZProduct.add([
    .weeklyA,
    .weeklyB,
    
    .monthA,
    .monthB,
    
    .quarterlyA,
    .quarterlyB,
    
    .yearA,
    .yearB,

    .allTimeA
])
```

Profit!

### Создание делегата

Для отслеживания статусов подписки, нужно создать класс и подписать его на протокол `RZStoreDelegateProtocol`

```Swift
class RZStoreDelegate: RZStoreDelegateProtocol{
    static var instans = RZStoreDelegate()

    func update() {
        //Вызывается каждый раз при верификации продуктов (раз в 20 сек)
    }
    
    func buySuccess(product: RZProduct, customData: Any?) {
       //Вызывается когда пользователь успешно совершает покупку/подписку
       //Иногда, информация о удачной оплате может не пройти сразу, в таком случае данный метод может быть не вызван, для предоставления доступа к контенту рекомендуется использовать информацию после совершения `update`.
    }
    
    func buyFaild(product: RZProduct, customData: Any?) {
        //Вызывается когда пользователь не успешно совершает покупку/подписку
    }
    
    func productsReceived(skProducts: Set<SKProduct>){
        //Вызывается, когда информация о продуктах (Стоимость/Валюта/...) были получены.
    }
}
```

### Запуск RZStoreKit

```Swift
RZStoreKit.start(RZStoreDelegate.instans)
```

Для запуска `RZStoreKit`, нужно в метод `start` передать делегат. 

Поскольку `RZStoreKit` работает с помощью SwiftyStoreKit, так же до запуска нужно вызывать метод:

```Swift
SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
    for purchase in purchases {
        switch purchase.transaction.transactionState {
        case .purchased, .restored:
            if purchase.needsFinishTransaction {
                SwiftyStoreKit.finishTransaction(purchase.transaction)
            }
        case .failed, .purchasing, .deferred:
            break
        @unknown default:break
        }
    }
}
```

Profit!

### Получение активных продуктов

Все активные на текущий момент продукты можно получить из `RZStoreKit`

```Swift
RZStoreKit.activeProducts
```

Информация о активных продуктах обновляется каждые 20 секунд, отслеживать обновления можно через делегат.

Profit!
