# RZDarkModeKit

Модуль облегчающий работу с DarkMode

## Начало работы

### Изменение режима
Для того что-бы задать изначальный режим нужно добавить следующий код в `AppDelegate` 

```Swift
import RelizKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        RZDarkModeKit.mode = .auto
        
        return true
    }
}
```
Всего есть 3 режима DarkMode

```Swift
RZDarkModeKit.mode = .auto        // Мод зависит от темы опирационной системы
RZDarkModeKit.mode = .mod(.light) // Устанавливает светлую тему
RZDarkModeKit.mode = .mod(.dark)  // Устанавливает темную тему
```

### Создание адаптивного цвета

```Swift
let aColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0) | UIColor(red: 0, green: 0, blue: 0, alpha: 0)
```
Созданый цвет, при влючении темной темы будет черным, при светлой теме белым

### Установка адаптивного цвета

Если вы используете только `auto` mod, то адаптивный цвет можно устанавливать на прямую (Работает только с UIColor)
```Swift
let aColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0) | UIColor(red: 0, green: 0, blue: 0, alpha: 0)

let view = UIView()
view.backgroundColor = aColor
```

Для полноценной работы всего функционала, и использования CGColor, нужно устанавливать цвета следующим образом
```Swift
let aColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0) | UIColor(red: 0, green: 0, blue: 0, alpha: 0)

let view = UIView()
view <- { $0.backgroundColor = aColor }
```

Если вы используете [RZViewBuilderKit](../RZViewBuilderKit/README.md) то код можно сократить
```Swift
let aColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0) | UIColor(red: 0, green: 0, blue: 0, alpha: 0)

let view = UIView()+>.color(aColor).view
```
