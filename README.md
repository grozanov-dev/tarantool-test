Test task

Synopsys:

1) скачать/собрать тарантул
2) запустить тестовое приложение
3) реализовать kv-хранилище доступное по http
4) выложить на гитхаб 
 5) задеплоить где-нибудь в публичном облаке, чтобы мы смогли проверить работоспособность (или любым другим способом)


API:
 - POST /kv body: {key: "test", "value": {SOME ARBITRARY JSON}} 
 - PUT kv/{id} body: {"value": {SOME ARBITRARY JSON}}
 - GET kv/{id} 
 - DELETE kv/{id}


 - POST  возвращает 409 если ключ уже существует, 
 - POST, PUT возвращают 400 если боди некорректное
 - PUT, GET, DELETE возвращает 404 если такого ключа нет
 - все операции логируются
 - в случае, если число запросов в секунду в http api превышает заданый интервал, возвращать 429 ошибку.

Install:

1. Copy /usr to /usr, /etc to /etc
2. Leave /t at homedir or place it everywhere
3. Change host and port in /usr/local/share/tarantool/test.lua/config.lua corresponding to your host settings
4. Run test:

$ cd ~

$ prove

Dependencies:

* tarantool:
    tarantool-http

* perl:
    LWP::UserAgent
    Test::More
    JSON
