FROM alpine:latest

#Base settings
ENV HOME /root \
	ENABLE_TOR false \
	TZ=Asia/Shanghai

COPY requirements.txt /root/requirements.txt

#Install ZeroNet
RUN apk -qq --no-cache --no-progress add python3 python3-dev gcc libffi-dev musl-dev make tor openssl tzdata && \
	pip3 install --upgrade pip && \
	pip3 install -r /root/requirements.txt && \
	apk del -qq --purge python3-dev gcc libffi-dev musl-dev make && \
	echo -e 'ControlPort 9051\nCookieAuthentication 1' >> /etc/tor/torrc

#Add Zeronet source
COPY . /root
VOLUME /root/data

WORKDIR /root

#Set upstart command
CMD (! ${ENABLE_TOR} || tor&) && python3 zeronet.py --ui_ip 0.0.0.0 --fileserver_port 26552

#Expose ports
EXPOSE 43110 26552
