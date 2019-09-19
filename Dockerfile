FROM jenkins/jenkins:lts

ENV DOCKER_CHANNEL stable
ENV DOCKER_VERSION 19.03.1
ENV DOCKER_GROUP_ID 971
ENV DOCKER_COMPOSE_VERSION 1.24.1

USER root

RUN set -eux \
	&& wget -O docker.tgz "https://download.docker.com/linux/static/${DOCKER_CHANNEL}/$(uname -m)/docker-${DOCKER_VERSION}.tgz" \
	&& tar --extract \
		--file docker.tgz \
		--strip-components 1 \
		--directory /usr/local/bin/ \
	&& rm docker.tgz \
	&& dockerd --version \
	&& docker --version \
    && apt-get update && apt-get install -y sudo \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd -g ${DOCKER_GROUP_ID} docker \
    && usermod -aG sudo,docker jenkins \
    && wget -O /usr/local/bin/docker-compose "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" \
    && chmod +x /usr/local/bin/docker-compose \
    && echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER jenkins
