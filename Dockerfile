FROM rocketchat/base:4

ENV RC_VERSION 0.44.0

MAINTAINER dehn@viada.de

LABEL io.k8s.description="Deplosy a Rocketchat ." \
      io.k8s.display-name="Rocketchat Chat tool" \
	  io.openshift.expose-services="3000:tcp" \
      io.openshift.tags="chat,rocketchat"

VOLUME /app/uploads

RUN set -x \
 && curl -SLf "https://rocket.chat/releases/${RC_VERSION}/download" -o rocket.chat.tgz \
 && curl -SLf "https://rocket.chat/releases/${RC_VERSION}/asc" -o rocket.chat.tgz.asc \
 && gpg --verify rocket.chat.tgz.asc \
 && tar -zxf rocket.chat.tgz -C /app \
 && rm rocket.chat.tgz rocket.chat.tgz.asc \
 && cd /app/bundle/programs/server \
 && npm install \
 && npm cache clear

USER rocketchat

WORKDIR /app/bundle

EXPOSE 3000

CMD ["node", "main.js"]
