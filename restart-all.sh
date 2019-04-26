#!/bin/bash
serverPath=$(cd `dirname $0`; pwd);
commonPath=$serverPath/common;
gamePath=$serverPath/game;
cdnPath=$serverPath/cdn;
voicePath=$serverPath/voice;
apiPath=$serverPath/api;
timerPath=$serverPath/timer;
cmsPath=$serverPath/cms;
cityPath=$serverPath/city;
managerPath=$serverPath/manager;
memberPath=$serverPath/member;
agentPath=$serverPath/agent;
myTestPath=$serverPath/myTest;
# select env
select env in  eerduosi eerduosi-test;
do 
	export NODE_ENV=$env;
	break;
done;
# dissolveAll room
curl -d "" "http://127.0.0.1:9990/debug/dissolveAll";
echo '';
for((i=3;i>0;i--));
do
	echo '解散房间中...'$i'秒后重启服务';
    sleep 1;
done
# stop server
pm2 delete all;
killall node;
killall node;
lsof -i :3005|grep -v "PID"|awk '{print "kill -9",$2}'|sh;
lsof -i :3006|grep -v "PID"|awk '{print "kill -9",$2}'|sh;
lsof -i :3007|grep -v "PID"|awk '{print "kill -9",$2}'|sh;
lsof -i :9990|grep -v "PID"|awk '{print "kill -9",$2}'|sh;
lsof -i :9991|grep -v "PID"|awk '{print "kill -9",$2}'|sh;
lsof -i :9992|grep -v "PID"|awk '{print "kill -9",$2}'|sh;
lsof -i :9993|grep -v "PID"|awk '{print "kill -9",$2}'|sh;
lsof -i :9994|grep -v "PID"|awk '{print "kill -9",$2}'|sh;
lsof -i :9995|grep -v "PID"|awk '{print "kill -9",$2}'|sh;
lsof -i :9996|grep -v "PID"|awk '{print "kill -9",$2}'|sh;
lsof -i :9997|grep -v "PID"|awk '{print "kill -9",$2}'|sh;
lsof -i :9998|grep -v "PID"|awk '{print "kill -9",$2}'|sh;
lsof -i :9999|grep -v "PID"|awk '{print "kill -9",$2}'|sh;
lsof -i :10000|grep -v "PID"|awk '{print "kill -9",$2}'|sh;
lsof -i :10001|grep -v "PID"|awk '{print "kill -9",$2}'|sh;
# kill pkcon
for((i=15000;i<=15019;i++));
do
    lsof -i :$i|grep -v "PID"|awk '{print "kill -9",$2}'|sh;
done;
# kill pkplayer
for((i=15100;i<=15119;i++));
do
    lsof -i :$i|grep -v "PID"|awk '{print "kill -9",$2}'|sh;
done;
# kill pkclub
for((i=15200;i<=15219;i++));
do
    lsof -i :$i|grep -v "PID"|awk '{print "kill -9",$2}'|sh;
done;
# kill pkroom
for((i=15300;i<=15319;i++));
do
    lsof -i :$i|grep -v "PID"|awk '{print "kill -9",$2}'|sh;
done;
# svn update
#svn up $serverPath/*;
# delete pm2 logs
rm -rf $serverPath/logs/*;
rm -rf $serverPath/.pm2/logs/*;
# start game-server
cd $gamePath;
pomelo start -e $NODE_ENV -D;
cd $serverPath;
case $NODE_ENV in
(nantong-test)
pm2 start $apiPath/main.js -n api -x;
pm2 start $cmsPath/main.js -n cms -x;
pm2 start $agentPath/main.js -n agent -x;
;;
(*)
#pm2 start $apiPath/main.js -n api -x;
pm2 start $cmsPath/main.js -n cms -x;
pm2 start $memberPath/main.js -n member -x;
pm2 start $managerPath/main.js -n manager -x;
pm2 start $cityPath/main.js -n city -x;
pm2 start $timerPath/main.js -n timer -x;
;;
esac;
tail -f $serverPath/logs/game/$(date +%Y%m%d).txt;
