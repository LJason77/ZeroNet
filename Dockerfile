FROM alpine:latest

#Base settings
ENV HOME /root \
	ENABLE_TOR false

COPY requirements.txt /root/requirements.txt

#Install ZeroNet
RUN apk -q --no-cache add python3 py3-pip openssl && \
	apk -q --no-cache add --virtual .build-deps python3-dev build-base libffi-dev musl-dev tzdata autoconf automake libtool && \
	cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
	echo "Asia/Shanghai" > /etc/timezone && \
	pip3 install --no-cache-dir wheel && \
	pip3 install --no-cache-dir -r /root/requirements.txt && \
	apk del -qq --purge .build-deps

#Add Zeronet source
COPY . /root
VOLUME /root/data

WORKDIR /root

#Set upstart command
CMD python3 zeronet.py --ui_ip 0.0.0.0 --fileserver_port 26552

#Expose ports
EXPOSE 43110 26552
