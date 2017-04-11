misc.sh
exim4.sh
lamp.sh
(certbot.sh)
の順で実行。
status.sh
で状態を出力。

git clone https://github.com/kentasaito/server-construction.git && (cd server-construction; ./misc.sh && ./exim4.sh && ./lamp.sh)
(cd server-construction; ./status.sh)
