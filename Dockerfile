FROM amazon/aws-cli:2.0.38

ARG IMG_NAME
ENV IMG_NAME $IMG_NAME

WORKDIR /

COPY data /upload
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["sh", "entrypoint.sh"]