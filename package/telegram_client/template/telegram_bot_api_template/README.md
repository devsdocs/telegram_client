# telegram_bot_api_template

## Requirement
Bahan yang di perlukan untuk mengdevelop / menjalankan kode ini

1. [Dart](https://dart.dev)
   Source Code bahasa ini menggunakan bahasa code dart jadi anda perlu menginstall dart dahulu (jika anda sudah menginstall flutter tidak usah karena sudah include)
2. [Telegram-Bot-Api](https://github.com/tdlib/telegram-bot-api.git)
   Jika anda ingin menjalankan bot ini di local tanpa public domain yang bisa di akses siapapun anda wajib mengcompile dan menginstall telegram-bot-api
3. Operating System
   Source code ini bisa di jalankan di manapun Android, Windows, Linux, MacOS

## Environment

| No | Name             | Value  | Default Value | Example Value                    | Require | Description |
|----|------------------|--------|---------------|----------------------------------|---------|-------------|
| 1. | PORT             | number | 8080          | 8080                             | NO      |             |
| 2. | HOST             | string | "0.0.0.0"     | "0.0.0.0"                        | NO      |             |
| 3. | is_local_bot_api | bool   | false         | true                             | NO      |             |
| 4. | api_id           | number |               | 12345                            | NO      |             |
| 5. | api_hash         | string |               | abchdkosa                        | NO      |             |
| 6. | tg_bot_webhook   | string |               | https://url.com/telegram/webhook | NO      |             |
| 7. | xen_key_api      | string |               | xen_production_sakmk1k31         | NO      |             |
| 8. | bot_api_port     | number | 9000          | 9000                             | NO      |             |
| 9. | token_bot        | String |               | "123456:asasmaksmkasmk"          | YES     |             |

## Compile To Executable

```bash
dart pub get
dart compile exe ./bin/telegram_bot_api_template.dart -o telegram_bot_api_template
```

## Development

```bash
is_local_bot_api=true api_id=12345 api_hash=abdkakm tg_bot_webhook="" xen_key_api="" bot_api_port=9000 token_bot="" dart run
```

### Resources
jika anda ingin serius membuat ini silahkan baca dokumentasi

1. [Dart](https://dart.dev)
2. [Telegram-Bot-Api](https://github.com/tdlib/telegram-bot-api.git)
3. [Telegram Client](https://github.com/azkadev/telegram_client)

Library yang saya buat selalu update dengan docs tdlib jadi anda perlu baca docs tdlib official ya


## Run In Local

```bash
is_local_bot_api=true api_id=12345 api_hash=abdkakm tg_bot_webhook="" xen_key_api="" bot_api_port=9000 token_bot="" ./telegram_bot_api_template
```

## Run In Docker
Untuk menjalankan project ini di docker anda harus mencompile dahulu ke exe, jika anda menggunakan docker anda bisa juga bisa menjalankan di manapun di vps, heroku, railway, local pc, dll

```Dockerfile
FROM ubuntu

WORKDIR /app/

ADD ./ /app/

RUN apt-get update

RUN apt-get install -y \
    sudo \
    wget \
    unzip

RUN apt-get update && \
    apt-get install -yq tzdata

ENV TZ="Asia/Jakarta"
 
ENV tg_url_webhook="https://web-name.domain.com/telegram/webhook" 
ENV xen_key_api="xendit_production_mkmk"
ENV token_bot="12121:samskamks"

CMD ["./telegram_bot_api_template"]
```

#### Tips

1. Run Program di layanan services gratis (Heroku, Railway, Okteto, Koyeb, Moge dll)<br>
   Sebelum deploy pastikan program ini berjalan di bawah memory dan cpu yang di berikan secara gratis, pastikan program ini berjalan dengan executable (bukan source code utuh), hapus kata terlarang "Bot, Userbot, Userbot Mirror", dan coba buat kode sefficient mungkin pastikan ada time out di loop, jika anda butuh bantuan silahkan Konsultasi Ke Azkadev

---

## Support Developer

Source Code , Library ini di buat 100% oleh [Azkadev](https://youtube.com/@azkadev) library ini bisa di gunakan lebih dari bot bisa juga untuk menjalankan multi bot userbot dan menghasilkan uang jika anda bisa menggunakan tolong jangan gunakan skill anda untuk melakukan tindakan kriminal (Phising, Scam, Doxing, Bullying), Jika anda ingin developer terus maintance library ini / lainya silahkan anda melakukan donasi (Subscribe semua social media, Donate uang, Tukar / Barter Source Code, Bikin video library ini di social media)