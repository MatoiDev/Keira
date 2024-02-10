<img src="README ASSETS/Preview.png">

# Keira

Приложения для управления FPV роботами на микроконтроллерах ESP, Arduino, STM и пр. через  Bluetooth Low Energy

Приложение написано под iOS, но вы спокойно можете запустить его на вашем Mac и управлять роботом, используя клавиатуру.

## Требования

- iOS 15.0 или более поздняя версия
- MacOS 12.0 (Monterey) или более поздняя версия

## Основной Функционал

1. Управление устройством по протоколу BLE с телефона через джойстики, или с компьютера через клавиатуру
2. [В разработке] Подключение и стриминг Bluetooth/WiFi камеры*
3. [В разработке] Возможность вести запись с камеры

## Структура протокола
>  Пример управления дроном на базе микроконтроллера ESP32, который имеет встроеный BLE модуль 
>###### * Приложение актуально и для проектов, использующие другие микроконтроллеры, к которым подключены BLE модули ( HM-10, AT-09, MLT-BT05, JDY-08 и пр. )

##### Идентификаторы

```c++
#define SERVICE_UUID                         "9A8CA9EF-E43F-4157-9FEE-C37A3D7DC12D" // ID сервиса
#define MSG_CHARACTERISTIC_UUID              "CC46B944-003E-42B6-B836-C4246B8F19A0" // ID характеристики передачи сообщений
#define LEFT_JOYSTICK_CHARACTERISTIC_UUID    "F2B9C6E1-4F9E-4E71-BB3C-7A3B6F8C0A8A" // ID характеристики левого джойстика
#define RIGHT_JOYSTICK_CHARACTERISTIC_UUID   "A8D6F7C4-9E3B-4B6E-8E9F-1E6C8B9A0D2D" // ID характеристики правого джойстика
```
В скетче уже создан сервис для общения, вы можете добавить новые характеристики, или изменить существующие. В таком случае вам нужно будет поработать с файлом [**BLEServer.h**](https://github.com/MatoiDev/Sentinel-ESP32/blob/main/BLEServer.h) и [**BTDevicesViewModel.swift**](https://github.com/MatoiDev/Keira/blob/main/Keira/ViewModels/BTDevicesViewModel.swift):
```swift
enum DeviceUUIDs: String {
    case __SERVICE_UUID = "9A8CA9EF-E43F-4157-9FEE-C37A3D7DC12D"
    case __CHARACTERISTIC_UUID = "CC46B944-003E-42B6-B836-C4246B8F19A0"
    case __LEFT_JOYSTICK_CHARACTERISTIC_UUID = "F2B9C6E1-4F9E-4E71-BB3C-7A3B6F8C0A8A"
    case __RIGHT_JOYSTICK_CHARACTERISTIC_UUID = "A8D6F7C4-9E3B-4B6E-8E9F-1E6C8B9A0D2D"
}
```
В сервисе реализованы 3 характеристики:
- `MSG_CHARACTERISTIC_UUID` - Используется для передачи текстовых команд и вывода на монитор (см. [Logger](https://github.com/MatoiDev/Sentinel-Logger) и [Sentinel-ESP32](https://github.com/MatoiDev/Sentinel-ESP32))
- `LEFT_JOYSTICK_CHARACTERISTIC_UUID` - Используется для передачи информации о текущем положении левого джойстика 
- `RIGHT_JOYSTICK_CHARACTERISTIC_UUID` - Используется для передачи информации о текущем положении правого джойстика

## Примечания

- Проект находится в процессе разработки
- README находится в процессе написания

