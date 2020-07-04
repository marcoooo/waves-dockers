# Agave Pure-FTPD Image
================================
This is a standard installation of [pure-ftpd](http://www.pureftpd.org/project/pure-ftpd) on centos 6.5. The container has 4 users, a pure-ftpd server, and a SSH server running by default. Each user has
access to `/` with their standard home folder, `/home/$USERNAME`, set as the
virtual root directory.

> This image should not be used in production

## Container users

This development container will create three users for testing.
  root:root
  testuser:testuser
  testshareuser:testshareuser
  testotheruser:testotheruser

## Configuration

Nothing to see here

## Building Containers

Build from this directory using the enclosed Dockerfile

```
docker build -rm -t agaveapi/pure-ftpd .
```

## Running Containers

To run the container in daemon mode on port 21,

```
docker run -d --name=ftpd 	-h docker.example.com -p 20:20 -p 21:21 -p 30000:30000 -p 30001:30001 -p 30002:30002 -p 30003:30003 -p 30004:30004 -p 30005:30005 -p 30006:30006 -p 30007:30007 -p 30008:30008 -p 30009:30009 -p 30010:30010 -p 30011:30011 -p 30012:30012 -p 30013:30013 -p 30014:30014 -p 30015:30015 -p 30016:30016 -p 30017:30017 -p 30018:30018 -p 30019:30019 -p 30020:30020 -p 30021:30021 -p 30022:30022 -p 30023:30023 -p 30024:30024 -p 30025:30025 -p 30026:30026 -p 30027:30027 -p 30028:30028 -p 30029:30029 -p 30030:30030 -p 30031:30031 -p 30032:30032 -p 30033:30033 -p 30034:30034 -p 30035:30035 -p 30036:30036 -p 30037:30037 -p 30038:30038 -p 30039:30039 -p 30040:30040 -p 30041:30041 -p 30042:30042 -p 30043:30043 -p 30044:30044 -p 30045:30045 -p 30046:30046 -p 30047:30047 -p 30048:30048 -p 30049:30049 -p 30050:30050 -p 30051:30051 -p 30052:30052 -p 30053:30053 -p 30054:30054 -p 30055:30055 -p 30056:30056 -p 30057:30057 -p 30058:30058 -p 30059:30059 -p 30060:30060 -p 30061:30061 -p 30062:30062 -p 30063:30063 -p 30064:30064 -p 30065:30065 -p 30066:30066 -p 30067:30067 -p 30068:30068 -p 30069:30069 -p 30070:30070 -p 30071:30071 -p 30072:30072 -p 30073:30073 -p 30074:30074 -p 30075:30075 -p 30076:30076 -p 30077:30077 -p 30078:30078 -p 30079:30079 -p 30080:30080 -p 30081:30081 -p 30082:30082 -p 30083:30083 -p 30084:30084 -p 30085:30085 -p 30086:30086 -p 30087:30087 -p 30088:30088 -p 30089:30089 -p 30090:30090 -p 30091:30091 -p 30092:30092 -p 30093:30093 -p 30094:30094 -p 30095:30095 -p 30096:30096 -p 30097:30097 -p 30098:30098 -p 30099:30099 agaveapi/pure-ftpd  
```  

## Orchestrating Infrastructure

If you would prefer to stand everything up at once, you can use the agaveup.sh script to build and connect all the necessary containers for testing. Each container folder also contains a <systemid>.json file to register the systems once the containers have started. You may use the registration.sh file to register your containers as systems in Agave.
