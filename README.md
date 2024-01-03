# Telegram kbot 
## Link - https://t.me/obezsmertnyi_bot

## How to install
Install Golang on your computer https://go.dev/doc/install 

Clone git repository:
```
git clone https://github.com/obezsmertnyi/kbot.git kbot
```
Navigate into kbot folder:
```
cd kbot
```
Build application
```
go build -ldflags "-X 'github.com/obezsmertnyi/kbot/cmd.appVersion=v1.0.2'"
```
Import telegram token ```TELE_TOKEN``` or add system variable into the end of your ```bashrc``` file via text redactor:
```
export TELE_TOKEN=<your_telegram_token>
```
Run application:
```
./kbot start
```

Telegram kbot can return to Telegram user some answers.

For example if you send ```/start hello``` , bot will send hello message with version ```Hello I'm Kbot v1.0.2```

If you send ```/start version```, bot will send you current version of application in format: ```Current KBot version v1.0.3```
