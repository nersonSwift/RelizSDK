# RZViewBuilderKit

Модуль облегчающий верстку кастомных UIView

## Начало работы

Что бы начать работать с `RZViewBuilderKit` нужно обернуть UIView в него. Для этого можно воспользоваться двумя способами.

```Swift
let view = UIView()

RZViewBuilder(view) // Прямое оборачивание
view+>              // Оборачивание с помощью кастомного оператора
```

### Задать frame UIView

Для того, что бы задать frame UIView можно использовать следующие методы:

```Swift
let view = UIView()+>.width(100).height(100).x(100).y(100).view
```
Сдесь объединена инициализация с установкой frame. 

Данный способ работает, но он не адаптивен. Для адаптивной верстки, `RZViewBuilderKit` не использует констрейнты, вместо этого, используются вырождения на основе других UIView.

Для примера возьмем `rootView` за UIView которая имеет размер экрана устройства.

```Swift
let rootView = UIView()

let view = UIView()+>.width(50 % rootView*.w).height(50 % rootView*.w).view
```

В данном кода создаваемая `view` принимает форму квадрата, со сторонами равными 50% от ширины `rootView`. 

Для того, что бы немного упростить поддержку кода, и не задавать процент в нескольких местах, мы можем использовать тег.

```Swift
let rootView = UIView()

let view = UIView()+>.width(50 % rootView*.w).height(.selfTag(.w)).view
```

Этот тег использует ширину создаваемой `view`.

Теперь давайте разместим `view` на нашем `rootView`. Зададим ему отступы по 10% от высоты `rootView`, для x и y.

```Swift
let rootView = UIView()

let view = UIView()+>
    .width(50 % rootView*.w).height(.selfTag(.w))
    .x(10 % rootView*.h).y(.selfTag(.x))
    .view
rootView.addSubview(view)
```

Так же можно разместить `view` по центру экрана.

```Swift
let rootView = UIView()

let view = UIView()+>
    .width(50 % rootView*.w).height(.selfTag(.w))
    .x(rootView*.scX, .center).y(rootView*.scY, .center)
    .view
rootView.addSubview(view)
```

Адаптивная верстка - это не плохо, но на данном этапе, она статичная, то есть при изменении `rootView` ничего с `view` не произойдёт.

Для наблюдения за `rootView`, нужно совсем не много, просто заменить `*` на `|*`

```Swift
let rootView = UIView()

let view = UIView()+>
    .width(50 % rootView|*.w).height(50 % rootView|*.w)
    .x(rootView|*.scX, .center).y(rootView|*.scY, .center)
    .view
rootView.addSubview(view)
```

Все, теперь при изменении размеров `rootView`, `view` будет автоматически подстраиваться. К сожалению на данном этапе `selfTag` не поддерживает наблюдение, но в ближайшее время данная функция будет введена.

Как было упомянуто ранее, для задания `frame` можно использовать выражения, вот пример такого использования:

```Swift
let rootView = UIView()

let topView = UIView()+>
    .width(30 % rootView|*.w).height(30 % rootView|*.w)
    .x(rootView|*.scX, .center).y(10 % rootView|*.h)
    .view
rootView.addSubview(topView)

let downView = UIView()+>
    .width(30 % rootView|*.w).height(30 % rootView|*.w)
    .x(rootView|*.scX, .center).y(90 % rootView|*.h, .down)
    .view
rootView.addSubview(downView)

let view = UIView()+>
    .width(30 % rootView|*.w).height(30 % rootView|*.w)
    .x(rootView|*.scX, .center).y((topView|*.mY >< downView|*.y) + 5 % rootView|*.h)
    .view
rootView.addSubview(view)
```

В этом коде, все `view` имеют одинаковый размер (Квадрат со сторонами по 30% от ширины). `topView` находится по центру экрана, со смещением в 10% сверху от высоты `rootView`. `downView` так же находится по центру со смещением в 10%, но снизу от высоты `rootView`. `view` размещается по центру между ними (`><` находит центр между двумя точками) со смещением в 5% от высоты `rootView`.

Выражения могут быть любой сложности, с любым количеством наблюдаемы `UIView`, при изменении любой из включенных в выражение `UIView`, произойдет пересчет всего выражения.

Profit!

### Задать параметры UIView

`RZViewBuilder` не ограничивается только изменением `frame`, так же можно изменять большее количество параметров (цвет, текст, тени, скругления углов,..)

Пример создания  `UILabel`:

```Swift
let rootView = UIView()

let label = UILabel()
label+>
    .text("Hello world").font(.h1).color(.black, .content)
    .width(90 % rootView|*.w).sizeToFit()
    .x(rootView|*.scX, .center).y(rootView|*.scY, .center)
```

Пример создания  `UIButton`:

```Swift
let rootView = UIView()

let button = UIButton()
button+>
    .color(.blue)
    .text("Hello world").font(.h1).color(.white, .content)
    .width(90 % rootView|*.w).height(30 % button|*.w)
    .x(rootView|*.scX, .center).y(rootView|*.scY, .center)
    .cornerRadius(button|*.h / 2*)
    .addAction { print("Hello world") }
```

Profit!

### Создание шаблнов

Для избежания повторяющегося кода, часто используемые элементы можно задавать с помощью шаблонов. Для создания шаблона нужно добавить extension для `RZVBTemplate`.

```Swift
extension RZVBTemplate where View: UIButton{
    static var xButton: Self {
        .custom{
            $0+>
                .color(.black)
                .width(10 % .screenTag(.w, .vertical)).height(.selfTag(.w))
                .mask(
                    UIImageView(image: UIImage(named: "X"))+>.width(50 % $0*.w).height(.selfTag(.w)).view
                )
        }
    }
}
```

На данном примере, изображен шаблон для кнопки с крестиком. `screenTag` представляет параметры экрана устройста в вертикальном положении.

Для использования этого шаблона достаточно вызвать 1 метод `RZViewBuilder`.

```Swift
let rootView = UIView()

let button = UIButton()
button+>
    .template(.xButton)
    .x(rootView|*.scX, .center).y(rootView|*.scY, .center)
    .addAction { print("Close") }
```

Возможности шаблонов крайне велики. Пример шаблона, для шапки UIScrollView, которая будет автоматически ресайзится при прокручивании контента.

```Swift
extension RZVBTemplate{
    static func resizableTopView(_ standardHeight: RZProtoValue, _ scroll: UIScrollView) -> Self{
        .custom {[weak scroll] view in
            guard let scroll = scroll else { return }
            view.layer.masksToBounds = true
            view+>
                .y(scroll.rzContentOffsetY)
                .height(scroll.rzContentOffsetY.handler{[weak view] value -> (RZProtoValue) in
                    guard let view = view else {return 0*}
                    let height = standardHeight - value.new
                    if height.getValue(view) < 0 { return 0* }
                    return height
                })
        }
    }
}
```

В использовании:

```Swift
let rootView = UIView()
let scroll = UIScrollView()

let imageView = imageView
imageView+>
    .width(rootView|*.w)
    .template(.resizableTopView(23 % rootView*.h, scroll))
    .image(UIImage(named: "AnyImage"))
    .contentMode(.scaleAspectFill)
scroll.addSubview(imageView)
```

Profit!
