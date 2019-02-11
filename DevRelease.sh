#!/bin/bash
# Created by Madhukara Kekulandara

cat welcome.txt

echo "-------------------------------------------"
echo "Pulling config changes"
cd /apps/src/symphony-conf-changes
git pull origin develop
echo "-------------------------------------------"
cd /apps/src/services-axipay
echo "stopping jetty"
sh /apps/servers/jetty/bin/jetty.sh stop
git checkout gradle.properties modules/src/main/resources/modules.properties
echo "-------------------------------------------"
echo "Previous Last Commit Id :-"
git log --format="%H" -n 1
echo "-------------------------------------------"
echo "Git Branch:-"
git rev-parse --abbrev-ref HEAD

echo "correct branch? (y- yes ; n - no)"
read branchResponse

if [ $branchResponse == 'y' ]
then
	echo "-------------------------------------------"
	echo "Pulling the latest code"
	git pull origin sd
	echo "-------------------------------------------"
	echo "New Last Commit Id :-"
	git log --format="%H" -n 1

	echo "correct commit? (y- yes ; n - no)"
	read commitResponse

	if [ $commitResponse == 'y' ]
	then
		cp /apps/src/symphony-conf-changes/dev/java-service/modules.properties /home/appusr/.genie/modules.properties
 		cp /apps/src/symphony-conf-changes/dev/java-service/modules.properties modules/src/main/resources/modules.properties
 		cp /apps/src/symphony-conf-changes/dev/java-service/gradle.properties gradle.properties
		source /apps/bin/jenv
		echo "-------------------------------------------"
		echo "bulding the war file"
		grd clean build -x test deploy
		rm -r /apps/servers/jetty/work/*
	fi
fi
echo "-------------------------------------------"
echo "starting jetty"
sh /apps/servers/jetty/bin/jetty.sh start
echo "-------------------------------------------"
echo "Initiated Key encryption key(Kek)"
sleep 15
curl \
--header "Content-type: application/json" \
--request POST \
--data '{"request":{"userId":21, "password":"","statusName":"Active"}}' \
http://

curl \
--header "Content-type: application/json" \
--request POST \
--data '{"request":{"userId":22, "password":"","statusName":"Active"}}' \
http://

curl \
--header "Content-type: application/json" \
--request POST \
--data '{"request":{"userId":23, "password":"","statusName":"Active"}}' \
http://

curl \
--header "Content-type: application/json" \
--request POST \
--data '{"request":{"statusName":"Active"}}' \
http://
echo "/\n"
echo "/\n"
echo "-------------------------------------------"
echo " --- ---"