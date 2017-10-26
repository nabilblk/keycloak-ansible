#!/usr/bin/env bash

usage="$(basename "$0") [-h] [-m mode] -- Program to Generate Access Token

where:
    -h  show this help text
    -m  set the mode value (default: access) possible Values (access|refresh)
    -k  set the Keycloak Instance possible Value (1|2|3) 3 = LB"

seed=42
while getopts ':hmk:' option; do
  case "$option" in
    h) echo "$usage"
       exit
       ;;
    m) seed=$OPTARG
       ;;
    k) seed=$OPTARG
       ;;
    :) printf "missing argument for -%s\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
   \?) printf "illegal option: -%s\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
  esac
done
#shift $((OPTIND - 1))


KC_REALM=TEST
KC_USERNAME=nabil
KC_PASSWORD=nabil
KC_CLIENT=demo-ha
KC_CLIENT_SECRET=b2315d4b-8608-41a0-9ce8-a981180082e8

if [ "$4" = "1" ]
then
KC_URL="http://ec2-54-229-245-219.eu-west-1.compute.amazonaws.com:8080/auth"
fi

if [ "$4" = "2" ]
then
KC_URL="http://ec2-34-240-4-74.eu-west-1.compute.amazonaws.com:8080/auth"
fi

if [ "$4" = "3" ]
then
KC_URL="http://ec2-34-253-188-132.eu-west-1.compute.amazonaws.com/auth"
fi

echo $KC_URL

if [ "$2" = "access" ]
then
# Client defined as confidential
KC_RESPONSE=$( \
   curl -k -v \
        -d 'grant_type=password' \
        -d "username=$KC_USERNAME" \
        -d "password=$KC_PASSWORD" \
        -d "client_id=$KC_CLIENT" \
        -d "client_secret=$KC_CLIENT_SECRET" \
        "$KC_URL/realms/$KC_REALM/protocol/openid-connect/token" \
    | jq .
)
fi

if [ "$2" = "refresh" ]
then
# Client defined as confidential
echo 'REFRESH MODE'
KC_RESPONSE=$( \
   curl -k -v \
        -d 'grant_type=refresh_token' \
        -d "client_id=$KC_CLIENT" \
        -d "client_secret=$KC_CLIENT_SECRET" \
        -d "refresh_token=$3" \
        "$KC_URL/realms/$KC_REALM/protocol/openid-connect/token" \
    | jq .
)
fi


KC_ACCESS_TOKEN=$(echo $KC_RESPONSE| jq -r .access_token)
KC_ID_TOKEN=$(echo $KC_RESPONSE| jq -r .id_token)
KC_REFRESH_TOKEN=$(echo $KC_RESPONSE| jq -r .refresh_token)

echo '--------------------------'
echo '--------------------------'
echo $KC_RESPONSE | jq .
echo '--------------------------'
echo '--------------------------'
#echo 'ACCESS TOKEN : ' $KC_ACCESS_TOKEN
#echo '--------------------------'
#echo '--------------------------'
#echo 'ID TOKEN : ' $KC_ID_TOKEN
#echo '--------------------------'
#echo '--------------------------'
#echo 'REFRESH TOKEN : ' $KC_REFRESH_TOKEN
#echo '--------------------------'
#echo '--------------------------'
