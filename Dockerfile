FROM maven:3.6.0-jdk-8

WORKDIR /build

RUN git clone https://github.com/brianfrankcooper/YCSB.git
RUN cd YCSB \
  && mvn -am clean package -Dmaven.test.skip=true

FROM rijalati/alpine-zulu-jdk8:latest-mini
MAINTAINER suizman@outlook.com

ENV YCSB_VERSION=master \
    PATH=${PATH}:/usr/bin

COPY start.sh /start.sh
RUN chmod +x /start.sh
RUN apk --no-cache add mksh python

ENV ACTION='' DBTYPE='' WORKLETTER='' DBARGS='' RECNUM='' OPNUM=''

WORKDIR "/opt/ycsb-${YCSB_VERSION}"

COPY --from=0 /build/YCSB/distribution/target/*.tar.gz .
RUN tar zxf *.tar.gz --strip 1
RUN rm *.tar.gz 

ENTRYPOINT ["/start.sh"] 
