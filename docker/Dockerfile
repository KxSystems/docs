# Title: kxsys/docs on MkDocs with mkdocs-material theme
# Author: jhanna@kx.com
# Date: 2018.10.14
FROM python:2.7-alpine as base
ARG SITEVERSION=v1
ENV SITEVERSION=$SITEVERSION
COPY docker/piprequirements-${SITEVERSION}.txt /tmp/piprequirements.txt
COPY docker/init /init
FROM base

ARG BUILD_DATE=dev
ARG port=8888
ENV PORT=${port}
EXPOSE ${port}/tcp

LABEL	org.label-schema.schema-version="1.0" \
	org.label-schema.name=docs \
	org.label-schema.description="Preview container image" \
	org.label-schema.vendor="Kx" \
	org.label-schema.license="Apache-2.0" \
	org.label-schema.url="https://code.kx.com/" \
	org.label-schema.version="${VERSION:-dev}" \
	org.label-schema.vcs-url="https://github.com/KxSystems/docs.git" \
	org.label-schema.build-date="$BUILD_DATE" \
	org.label-schema.docker.cmd="docker run -it --rm -v $(pwd):/docs -p 9000:9000 kxsys/docs-${SITEVERSION}"
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir --upgrade -r /tmp/piprequirements.txt
ENTRYPOINT ["/init"]
CMD ["serve"]

