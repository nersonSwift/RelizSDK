# RZUIPacKit

Модуль облегчающий работу с экранами, 
переходы между экранами, встраивание экранов, разделение логик.

## Основные идеи UIPac архитектуры:

1. Модульность. Все экраны являются отдельными модулями, и не зависят друг от друга. Сам экран так-же состоит из модулей, которые берут на себя ответственность за разные логики. 
2. Заменяемость. Одно представление может иметь любое количество бизнес логик, одна бизнес логика может иметь любое количество представлений.
3. Встраиваемость. Любой экран встраивается в свою область и совершает переходы в рамках заданной области.
4. Кроссплатформенность. Экраны имеют возможность изменять свое представление в зависимости от платформы на которой запущено приложение. Все это осуществляется через Mac Catalyst.

Так же есть поддержка SwiftUI.

## Модули UIPac:

Каждый экран разделен на 3 модуля:

1. Controller. Отвечает за всю бизнес логику экрана, переходы между экранами, общение с Model.
2. Router. Отвечает за общение `Controller` и `View`, а так-же выполняет функцию ViewModel.
3. View. Отвечает за верстку экрана, анимации.

## Начало работы

### Создание UIPac:

Для примера создадим экран с надписью "Hello World" в центре.

Первое, что нужно сделать, создать `Controller` UIPac, он является ключевой сущность. Отвечает за бизнес логику и хранит ссылки на `Router` и `View`. Создаем класс c использованием typealias `RZUIPacController`. `RZUIPacController` включает в себя: UIViewController & `RZUIPacControllerProtocol`. 

```Swift
class ExampleC: RZUIPacController{
    
}
```

Дальше нам потребуется `Router`, в нем сразу укажем текст для нашего экрана.

```Swift
class ExampleR: RZUIPacRouter{
    var labelText: String = "Hello World"
}
```

Последняя сущность, которую нужно создать, это `View`. Для примера создадим 2 `View`, одну для iPhone другую для iPad, так-же `View` для iPad  напишем с использованием SwiftUI.

```Swift
//MARK: - iPhoneV
class ExampleIPhoneV: RZUIPacView{

}

//MARK: - iPadV
struct ExampleIPadV: RZSUIPacView{
    var body: some View{
        Text("")
    }
}
```

Если вставить этот код в проект, вы увидите ошибки компиляции, так как не реализованы свойства, требующиеся по протоколам.

Теперь давайте, добавим свойства, и подключим все части друг к другу.

В `Controller` подключим `Router` и укажем типы `View` для разных платформ.

```Swift
class ExampleC: RZUIPacController{
    var iPhoneViewType: RZUIPacAnyViewProtocol.Type? {ExampleIPhoneV.self}
    var iPadViewType:   RZUIPacAnyViewProtocol.Type? {ExampleIPadV.self}
    var macViewType:    RZUIPacAnyViewProtocol.Type? {ExampleIPadV.self}
    
    var router = ExampleR()
}
```

Во `View` просто добавим свойство, для роутера с указанием типа. Оно будет установлено автоматически.

```Swift
class ExampleIPhoneV: RZUIPacView{
    var router: ExampleR!
}

struct ExampleIPadV: RZSUIPacView{
    @ObservedObject var router: ExampleR
    
    var body: some View{
        Text("")
    }
}

```
При использовании SwiftUI важно использовать @ObservedObject, это необходимо, для поддержки @Published.

Теперь осталось только написать код верстки, и UIPac готов.

UIKit:
```Swift
class ExampleIPhoneV: RZUIPacView{
    var router: ExampleR!
    
    private var label = UILabel()
    
    func create() {
        createSelf()
        createLabel()
    }
    
    private func createSelf(){
        self.backgroundColor = .white
    }
    
    private func createLabel(){
        addSubview(label)
        label.text = router.labelText
        label.textColor = .black
        label.sizeToFit()
        label.center.x = self.bounds.midX
        label.center.y = self.bounds.midY
    }
}
```
Если вы используете `RZViewBuilderKit`:
```Swift
class ExampleIPhoneV: RZUIPacView{
    var router: ExampleR!
    
    private var label = UILabel()
    
    func create() {
        createSelf()
        createLabel()
    }
    
    private func createSelf(){
        self+>.color(.white)
    }
    
    private func createLabel(){
        addSubview(label)
        label+>
            .text(router.labelText).color(.black, .content)
            .sizeToFit().x(self*.scX, .center).y(self*.scY, .center)
    }
}
```
SwiftUI:
```Swift
struct ExampleIPadV: RZSUIPacView{
    @ObservedObject var router: ExampleR
    
    var body: some View{
        ZStack{
            Color(.white).edgesIgnoringSafeArea(.all)
            Text(router.labelText).foregroundColor(Color(.black))
        }
    }
}
```
Profit!


### Усановка первого UIPac:

Для того, чтобы запустить приложение с какого-то из UIPac, нужно написать немного кода в AppDelegate и SceneDelegate.

AppDelegate:
```Swift
func application(
    _ application: UIApplication, 
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
    
    RZLineController.addLines([
        .init(id: "Example", controller: ExampleC())
    ])
    RZLineController.setRootLine(id: "Example")
    
    return true
}
```
В данном коде происходит создание линий и установка корневой линии с которой стартует приложение. Линии используются для хранения состояний, но на этом сейчас не будет останавливаться.

SceneDelegate:
```Swift
func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    window = RZRootController.setupRootViewController(scene: scene)
}
```
Тут происходит создание window и установка корневого контроллера.

Profit!

Теперь можно запускать приложение!


### Переходы между UIPac:

Все переходы осуществляются с помощью класса `RZTransition`

Пример перехода с одного UIPac на другой:
```Swift
RZTransition(.Instead, self).uiPacC(ExampleC()).animation(.appearance).transit()
```
Простой переход между двумя экранами, при этом экран с которого осуществляется переход полностью удаляется с представления. 


Если необходимо открыть экран поверх текущего, а не заменить то нужно просто изменить тип перехода.
```Swift
RZTransition(.In, self).uiPacC(ExampleC()).animation(.appearance).transit()
```
При этом текущий экран останется на представлении. 


Для закрытия экрана, нужно в метод uiPacC передать nil.
```Swift
RZTransition(.Instead, self).uiPacC(nil).animation(.exhaustion).transit()
```


Если экран предполагает возвращение назад, то можно использовать:
```Swift
RZTransition(.Instead, self).uiPacC(ExampleC()).archive().animation(.appearance).transit()
```
При этом переход на предыдущий экран будет выглядит так:
```Swift
RZTransition(.Instead, self).back().animation(.exhaustion).transit()
```

Так же можно открыть UIPac в определенной области. В качестве области выступает UIView. Экран примет размер указанной области, будет встроен в нее, а так-же все переходы с этого экрана будут происходить в рамках заданной области.

```Swift
RZTransition(.In, self).view(anyView).transit()
```

Profit!

Этого достаточно, для начала работы, [подробная документация]()
