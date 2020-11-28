FROM alpine:latest

#Base settings
ENV HOME /root

COPY requirements.txt /root/requirements.txt

#Install ZeroNet
RUN apk --no-cache --no-progress add python3 python3-dev py3-pip gcc libffi-dev musl-dev make openssl tzdata && \
	cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
	echo "Asia/Shanghai" > /etc/timezone && \
	pip3 install --no-cache-dir wheel && \
	pip3 install --no-cache-dir -r /root/requirements.txt && \
	apk del -qq --purge python3-dev gcc libffi-dev musl-dev make tzdata

#Add Zeronet source
COPY . /root
VOLUME /root/data

WORKDIR /root

#Set upstart command
CMD python3 zeronet.py --ui_ip 0.0.0.0 --fileserver_port 26552

#Expose ports
EXPOSE 43110 26552
