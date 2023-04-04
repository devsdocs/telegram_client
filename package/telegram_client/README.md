# Telegram Client library
<p align="center">
  <img src="https://raw.githubusercontent.com/azkadev/telegram_client/main/assets/telegram.png" width="350px">
</p>
<h2 align="center">Fast, Enjoyable & Customizable Telegram Client</h2>

[![Pub Version](https://img.shields.io/pub/v/telegram_client?label=pub.dev&labelColor=333940&logo=dart)](https://pub.dev/packages/telegram_client)

Telegram client dart library untuk membuat telegram based flutter bot userbot bisa di server side dan client side

## Features

- 🚀 Cross platform: mobile, desktop, browser, server
- ⚡ Performance Bagus Dan Effisien
- ❤️ Simple, powerful, & intuitive API

## Examples App use Telegram Client


1. Azkagram

<img src="https://raw.githubusercontent.com/azkadev/azkagram/main/screenshot/home.png" width="250px"><img src="https://user-images.githubusercontent.com/82513502/205481759-b6815e2f-bd5d-4d72-9570-becd3829dd36.png" width="250px"><img src="https://raw.githubusercontent.com/azkadev/azkagram/main/screenshot/me.png" width="250px"><img src="https://user-images.githubusercontent.com/82513502/173319331-9e96fbe7-3e66-44b2-8577-f6685d86a368.png" width="250px"><img src="https://user-images.githubusercontent.com/82513502/173319541-19a60407-f410-4e95-8ac0-d0da2eaf2457.png" width="250px">

## Examples Bot use Telegram Client

1. AzkadevBot
  Telegram clone bot and userbot

<img src="https://github.com/azkadev/telegram_client/raw/main/assets/example/bot/azkadevbot_1.jpg" width="350px"><img src="https://github.com/azkadev/telegram_client/raw/main/assets/example/bot/azkadevbot_2.png" width="350"><img src="https://github.com/azkadev/telegram_client/raw/main/assets/example/bot/azkadevbot_3.png" width="350px"><img src="https://github.com/azkadev/telegram_client/raw/main/assets/example/bot/azkadevbot_4.png" width="350px">

2. Free Run User Bot
 Cloning userbot gratis tanpa server
https://user-images.githubusercontent.com/82513502/178153444-5f1a9074-8f43-48c1-bb12-ab1493d17143.mp4

---

### Install Library

1. Install Library

```bash
dart pub add telegram_client
```

2. For Flutter
```bash
flutter pub add telegram_client telegram_client_flutter
```

3. Cli

```bash
dart pub global activate telegram_client
```

### Add Library

```dart
import 'package:telegram_client/telegram_client.dart';
```

### Docs

### Feature
- ```telegram client dart```
    - ✅️ support server side & client side
    - ✅️ support multi token ( bot / userbot ) 
    - ✅️ support bot and userbot
    - ✅️ support telegram-bot-api (local / [Bot-Api](https://core.telegram.org/bots/api#recent-changes)
    - ✅️ Support long poll update bot api
    - ✅️ Support telegram database library ( [TDLIB](https://github.com/tdlib/td) )
    - ✅️ Add more Api Humanize pretty update and method api humanize
    - ✅️ Easy handle multi client
    
- ```telegram client node``` tidak di urus lagi
    - ✅️ support server side & client side
    - ✅️ support multi token ( bot / userbot )
    - ✅️ support bot and userbot
    - ✅️ support telegram-bot-api local server
    - ✅️ support telegram database library ( [TDLIB](https://github.com/tdlib/td) )
    - ✅️ Add more Api Humanize pretty update and method api humanize

- ```telegram client google apps script``` tidak di urus lagi
    - ✅️ support multi token ( bot / userbot )
    - ✅️ support bot and userbot
    - ❌️ support telegram-bot-api local server
    - ❌️ support telegram database library ( Tdlib )

1. Build [Tdlib](https://github.com/td/tdlib)
## Add library on project
  if you make app telegram based this library, you must add native compiled library

### Android
Copy `.so` files from archive to `example/android/app/main/jniLibs`:
```txt
└── example 
    └── android 
        └── app 
            └── main 
                └── jniLibs 
                    └── arm64-v8a
                    │   └── libtdjson.so
                    └── armeabi-v7a
                    │   └── libtdjson.so
                    └── x86
                    │   └── libtdjson.so
                    └── x86_64
                        └── libtdjson.so
```
Open file `example/android/app/build.gradle`

replace
```groovy
sourceSets {
  main.java.srcDirs += 'src/main/kotlin'
}
```
by 
```groovy
sourceSets {
  main {
    java.srcDirs += 'src/main/kotlin'
    jniLibs.srcDirs = ['src/main/jniLibs']
  }
}
```

### iOS and macOS
1. Copy `libtdjson.dylib` from archive to `example/ios`
2. Copy `libtdjson.dylib` from archive to `example/macos`
```txt
└── example 
    └── ios 
    │   └── libtdjson.dylib
    └── macos
        └── libtdjson.dylib
```
3. Open `Runner.xcworkspace` in Xcode.
4. Add `.dylib` file to project.
5. Find `Frameworks, Libraries, and EmbeddedContent`.
6. Against `libtdjson.dylib` choose `Embed & Sign`.
7. Find `Signing & Capabilities`.
8. In Section `App Sandbox (Debug and Profile)` set true `Outgoing Connections (Client)`.

### Windows
1. Copy files from archive to `example/windows/tdlib`
```txt
└── example 
    └── windows 
        └── tdlib 
            └── libcrypto-1_1.dll
            └── libssl-1_1.dll
            └── tdjson.dll
            └── zlib1.dll
```
2. Open `example/windows/CMakeLists.txt`.
3. Add below line `set(INSTALL_BUNDLE_LIB_DIR "${CMAKE_INSTALL_PREFIX}")`:
```c
# begin td
set(dll_path "${CMAKE_CURRENT_SOURCE_DIR}/tdlib")
install(FILES "${dll_path}/libcrypto-1_1.dll" DESTINATION "${INSTALL_BUNDLE_LIB_DIR}" COMPONENT Runtime)
install(FILES "${dll_path}/libssl-1_1.dll" DESTINATION "${INSTALL_BUNDLE_LIB_DIR}" COMPONENT Runtime)
install(FILES "${dll_path}/tdjson.dll" DESTINATION "${INSTALL_BUNDLE_LIB_DIR}" COMPONENT Runtime)
install(FILES "${dll_path}/zlib1.dll" DESTINATION "${INSTALL_BUNDLE_LIB_DIR}" COMPONENT Runtime)
# end td
```

### Linux
1. Copy file from archive to `example/linux/tdlib`
```
└── example 
    └── linux 
        └── tdlib 
            └── libtdjson.so
```
2. Open `example/linux/CMakeLists.txt`.
3. Add at the end of file:
```c
# begin td
install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/tdlib/libtdjson.so" DESTINATION "${INSTALL_BUNDLE_LIB_DIR}"
    COMPONENT Runtime)
# end td
```

- [Doc + Example](https://github.com/azkadev/telegram_client/tree/main/dart/telegram_client/doc)
- [Youtube-Tutorial](https://www.youtube.com/channel/UC928-F8HenjZD1zNdMY42vA)
- [Telegram Group Support](https://t.me/developer_group_chat)
  
## Feature

- Support Server Side and Client Side
- 3 library in one ( [Tdlib](#tdlib), [Telegram Bot Api](#telegrambotapi), [Mtproto](#mtproto) )
- Support Cross platform

## Docs

- [Tdlib](#tdlib)
- [Telegram Bot Api](#telegrambotapi)
- [Mtproto](#mtproto)
- [Tdlib-Official](https://core.telegram.org/tdlib/docs/classtd_1_1_tl_object.html)
## Tdlib
gunakan ini untuk membuat userbot / bot / application based tdlib,
quickstart:
more update example check on [this](https://github.com/azkadev/telegram_client/tree/main/example/dart/tdlib)
- single
```dart
import 'dart:io';
import 'package:telegram_client/telegram_client.dart';
void main(List<String> args) async {
  var path = Directory.current.path;
  Tdlib tg = Tdlib(path_tdlib:"./tdjson.so", clientOption: {
    'api_id': 12345,
    'api_hash': 'abcdefgjjaijiajdisd',
    'database_directory': "$path/user/",
    'files_directory': "$path/user/",
  });
  tg.on("update", (UpdateTd update) {
    print(update.raw);
  });
  await tg.initIsolate();
}
```
- multi
```dart
import 'dart:io';
import 'package:telegram_client/telegram_client.dart';
void main(List<String> args) async {
  var path = Directory.current.path;
  Tdlib tg = Tdlib(path_tdlib:"./tdjson.so", clientOption:{
    'api_id': 12345678,
    'api_hash': 'asaskaoskaoskoa',
    'database_directory': "$path/user_0/",
    'files_directory': "$path/user_0/",
  });
  tg.on("update", (UpdateTd update) {
    if (tg.client_id == update.client_id) {
      print("user_0");
    } else {
      print("user_1");
    }
    print(update.raw);
  });
  await tg.initIsolate();
  await tg.initIsolateNewClient(clientId: tg.client_create().address, clientOption: {
    'database_directory': "$path/user_1/",
    'files_directory': "$path/user_1/",
  });
}
```

#### constructor

| No |      key       |                             value                              | Deskripsi                                         | `required` |
|----|:--------------:|:--------------------------------------------------------------:|:--------------------------------------------------|:----------:|
| 1  |  `path_tdlib`  |                       String path tdlib                        |                                                   |   `yes`    |
| 2  | `clientOption` | [object](https://core.telegram.org/bots/api#available-methods) | parameters di butuhkan jika method membutuhkannya |    `no`    |
- examples
```js
Tdlib tg = Tdlib(path_tdlib:"./tdjson.so", clientOption: {
  'api_id': 123435,
  'api_hash': 'asmamskmaks',
  'database_directory': "",
  'files_directory': "",
  "use_file_database": true,
  "use_chat_info_database": true,
  "use_message_database": true,
  "use_secret_chats": true,
  'enable_storage_optimizer': true,
  'system_language_code': 'en',
  'new_verbosity_level': 0,
  'application_version': 'v1',
  'device_model': 'Telegram Client Hexaminate',
});
```

#### on
| No |      key      |       value       | Deskripsi                                         | `required` |
|----|:-------------:|:-----------------:|:--------------------------------------------------|:----------:|
| 1  | `type_update` | String path tdlib |                                                   |   `yes`    |
| 2  |  `function`   | [object](#object) | parameters di butuhkan jika method membutuhkannya |   `yes`    |
- examples
```js
tg.on("update", (UpdateTd update) {
  print(update.raw);    
});
```

#### initIsolate
| No |      key       |                             value                              | Deskripsi                                         | `required` |
|----|:--------------:|:--------------------------------------------------------------:|:--------------------------------------------------|:----------:|
| 1  |   `clientId`   |                    int addres client_create                    |                                                   |    `no`    |
| 2  | `clientOption` | [object](https://core.telegram.org/bots/api#available-methods) | parameters di butuhkan jika method membutuhkannya |    `no`    |
- examples
```js
tg.initIsolate();
```

#### request
| No |      key      |        value         | Deskripsi                                         | `required` |
|----|:-------------:|:--------------------:|:--------------------------------------------------|:----------:|
| 1  | `name_method` |        String        | more method check [tdlib-docs]()                  |   `yes`    |
| 2  | `parameters`  | [object](#methods-1) | parameters di butuhkan jika method membutuhkannya | `options`  |
- examples
```js
tg.request("sendMessage", parameters: {
  "chat_id": 123456,
  "text": "Hello world"
});
```
#### invoke
| No |     key      |        value         | Deskripsi                                         | `required` |
|----|:------------:|:--------------------:|:--------------------------------------------------|:----------:|
| 1  | `parameters` | [object](#methods-1) | parameters di butuhkan jika method membutuhkannya |   `yes`    |
- examples
```js
tg.invoke({
  "@type": "getMe",
});
```
#### invokeSync
| No |     key      |        value         | Deskripsi                                         | `required` |
|----|:------------:|:--------------------:|:--------------------------------------------------|:----------:|
| 1  | `parameters` | [object](#methods-1) | parameters di butuhkan jika method membutuhkannya |   `yes`    |
- examples
```js
tg.invokeSync({
  "@type": "getMe",
});
```
---
### Object
---
### UpdateTd

#### raw
#### raw_api_light
#### raw_api
#### message
#### channel_post
---
### methods
more method check [tdlib-docs]()
#### sendMessage
| No |    key    |     value     | Deskripsi | `required` |
|----|:---------:|:-------------:|:----------|:----------:|
| 1  | `chat_id` | String or int |           |   `yes`    |
| 2  |  `text`   |    String     |           |   `yes`    |

#### sendPhoto
| No |    key    |     value     | Deskripsi | `required` |
|----|:---------:|:-------------:|:----------|:----------:|
| 1  | `chat_id` | String or int |           |   `yes`    |
| 2  |  `photo`  |    String     |           |   `yes`    |

## TelegramBotApi
Gunakan ini untuk berinteraksi dengan api telegram, semua method disini sudah auto update

quickstart:
- single
```dart
import 'package:telegram_client/telegram_client.dart';
void main(List<String> args) async {
  TelegramBotApi tg = TelegramBotApi("token");
  tg.on("update", (UpdateApi update) {
    print(update.raw);
  });
  await tg.initIsolate(); // add this jika ingin menggunakan long poll update
}
```
- multi
```dart
import 'package:telegram_client/telegram_client.dart';
void main(List<String> args) async {
  TelegramBotApi tg = TelegramBotApi("token");
  tg.on("update", (UpdateApi update) {
    print(update.raw);
  });
  await tg.initIsolate();
  await tg.initIsolate(tokenBot: "new_token_bot");
}
```

#### constructor

| No |        key         |                             value                              | Deskripsi                                         | `required` |
|----|:------------------:|:--------------------------------------------------------------:|:--------------------------------------------------|:----------:|
| 1  | `string_token_bot` |     String token bot [@botfather](https://t.me/botfather)      |                                                   |   `yes`    |
| 2  |   `clientOption`   | [object](https://core.telegram.org/bots/api#available-methods) | parameters di butuhkan jika method membutuhkannya |    `no`    |
- examples
```js
TelegramBotApi tg = TelegramBotApi("token_bot");
```

##### request 
| No |      key      |        value         | Deskripsi                                         | `required` |
|----|:-------------:|:--------------------:|:--------------------------------------------------|:----------:|
| 1  | `name_method` |        String        | more method check [tdlib-docs]()                  |   `yes`    |
| 2  | `parameters`  | [object](#methods-1) | parameters di butuhkan jika method membutuhkannya | `options`  |
- examples
```dart
tg.request("sendMessage", parameters:{
  "chat_id": 123456,
  "text": "Hello world"
});
```

## MtProto
Untuk mtproto telegram ini belum jadi ya karena saya belum mengerti cara connect mtproto
Quickstart:
```dart
import 'package:telegram_client/telegram_client.dart';
void main() async {
  Mtproto tg = Mtproto();
  tg.connect();
  tg.on("update", (data) {
    print(data);
  });
}
```


- Tags:
  #telegram #telegram_client #tdlib #mtproto #telegram_bot_api #telegram_dart #telegram_flutter #telegram_clone #telegram_userbot #telegram_bot

- Seo
  Telegram Dart
  Telegram Client
  Telegram Flutter
  Telegram userbot
  Telegram Bot
  Telegram Tdlib
  Tdlib
  Mtproto
  Telegram Bot Api
  Telegram Library
  Telegram clone
  Telegram clone flutter
  Tdlib Dart
  Tdlib Flutter
  Mtproto dart
  Mtproto flutter
  Telegram Bot Api
  Telegram Bot Api dart
  Telegram Bot Api Flutter
---