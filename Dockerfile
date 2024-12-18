FROM alpine:3.15.0 as build
LABEL maintainer="Ross Stewart <rosskouk@gmail.com>"
LABEL org.opencontainers.image.source https://github.com/rosskouk/asknavidrome

RUN apk add python3 py3-pip git build-base python3-dev libffi-dev openssl-dev

WORKDIR /opt

RUN python3 -m venv env

RUN git clone https://github.com/easy20192018/asknavidrome.git

WORKDIR /opt/asknavidrome

RUN source ../env/bin/activate && pip --no-cache-dir install wheel && pip --no-cache-dir install -r skill/requirements-docker.txt


FROM alpine:3.15.0
LABEL maintainer="Ross Stewart <rosskouk@gmail.com>"

RUN apk add python3

COPY --from=build /opt/env /opt/env
COPY --from=build /opt/asknavidrome/skill /opt/asknavidrome/

WORKDIR /opt/asknavidrome

# Activate Python Virtual Environment
ENV PATH="/opt/env/bin:$PATH" NAVI_USER= NAVI_PASS= NAVI_URL= NAVI_API_PATH=/rest NAVI_API_VER=1.16.1 NAVI_SKILL_ID= NAVI_DEBUG=0

EXPOSE 5000

ENTRYPOINT ["python3", "app.py"]
