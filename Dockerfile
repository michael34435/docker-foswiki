FROM alpine:3.6

ENV PERL_MM_USE_DEFAULT 1

RUN apk add --update && \
    apk add nginx wget unzip make zip perl perl-cgi perl-fcgi perl-cgi-session perl-error perl-json perl-file-copy-recursive

RUN perl -MCPAN -e 'install Crypt::PasswdMD5'

RUN wget --no-check-certificate https://ncu.dl.sourceforge.net/project/foswiki/foswiki/2.1.4/Foswiki-2.1.4.zip

RUN mkdir -p /var/www && \
    mv Foswiki-2.1.4.zip /var/www && \
    cd /var/www && \
    unzip Foswiki-2.1.4.zip -d /var/www/ && \
    mv Foswiki-2.1.4 foswiki && \
    rm -rf Foswiki-2.1.4.zip && \
    cd foswiki && \
    sh tools/fix_file_permissions.sh && \
    mkdir -p /run/nginx && \
    mkdir -p /etc/nginx/conf.d

COPY nginx.default.conf /etc/nginx/conf.d/default.conf
COPY docker-entrypoint.sh docker-entrypoint.sh

EXPOSE 80

CMD ["sh", "docker-entrypoint.sh"]
