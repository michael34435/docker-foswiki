FROM alpine:edge

ENV PERL_MM_USE_DEFAULT 1

ENV FOSWIKI_LATEST_URL https://github.com/foswiki/distro/releases/download/FoswikiRelease02x01x06/Foswiki-2.1.6.zip

ENV FOSWIKI_LATEST Foswiki-2.1.6

RUN apk add --update && \
    apk add nginx wget unzip make zip perl perl-cgi perl-fcgi perl-cgi-session \
        git perl-error perl-json perl-file-copy-recursive ca-certificates \
        perl-uri perl-digest-perl-md5 perl-lwp-protocol-https perl-html-tree \
        perl-email-mime perl-algorithm-diff perl-cache-cache  perl-file-which \
        perl-module-pluggable perl-moo perl-dbi perl-dbd-sqlite \
        perl-archive-zip mailcap imagemagick6 perl-authen-sasl perl-db_file \
        perl-ldap perl-xml-parser perl-path-tiny grep musl \
        perl-text-soundex perl-io-socket-inet6 tzdata openssl openssl-dev \
        expat-dev libxml2-dev gcc perl-dev musl-dev db-dev imagemagick6-dev \
        krb5-dev perl-filesys-notify-simple \
        perl-hash-multivalue perl-digest-sha1 perl-crypt-openssl-dsa \
        perl-crypt-openssl-bignum perl-crypt-openssl-rsa \
        perl-crypt-openssl-random perl-class-accessor perl-moose \
        perl-moox-types-mooselike perl-datetime perl-stream-buffered \
        perl-apache-logformat-compiler perl-mime-base64 perl-libwww \
        perl-file-slurp perl-crypt-x509 perl-hash-merge-simple perl-dancer \
        perl-yaml perl-test-leaktrace perl-locale-maketext-lexicon \
        perl-xml-xpath vim perl-module-install perl-yaml-tiny \
        perl-xml-writer perl-crypt-eksblowfish perl-dbd-mysql perl-dbd-pg && \
    apk add perl-crypt-passwdmd5 perl-berkeleydb perl-spreadsheet-xlsx \
        perl-xml-easy perl-type-tiny perl-json-xs perl-algorithm-diff-xs \
        perl-gssapi perl-time-parsedate perl-db_file-lock --update-cache \
        perl-devel-overloadinfo perl-xml-generator perl-xml-canonicalizexml \
        perl-crypt-openssl-x509 perl-moosex perl-sub-exporter-formethods \
        perl-moosex-types perl-crypt-openssl-verifyx509 perl-xml-tidy \
        perl-moosex-types-common perl-moosex-types-datetime \
        perl-moosex-types-uri perl-www-mechanize perl-datetime-format-xsd \
        perl-crypt-smime perl-convert-pem \
        # perl-libapreq2 -- Apache2::Request - Here for completeness but we use nginx \
            --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ \
            --allow-untrusted

RUN perl -MCPAN -e "install Net::SAML2" && \
         wget http://www.imagemagick.org/download/perl/PerlMagick-6.89.tar.gz && \
         tar xvfz PerlMagick-6.89.tar.gz && \
         cd PerlMagick-6.89 && \
         perl Makefile.PL && \
         make install && \
         cd / && \
         rm -f PerlMagick-6.89.tar.gz && \
         rm -fr PerlMagick-6.89 

RUN wget ${FOSWIKI_LATEST_URL} && \
    mkdir -p /var/www && \
    mv ${FOSWIKI_LATEST}.zip /var/www && \
    cd /var/www && \
    unzip ${FOSWIKI_LATEST}.zip -d /var/www/ && \
    rm -rf ${FOSWIKI_LATEST}.zip && \
    mv ${FOSWIKI_LATEST} foswiki && \
    cd foswiki && \
    sh tools/fix_file_permissions.sh

RUN cd /root && \
    git clone https://github.com/timlegge/perl-Net-SAML2.git && \
    cd perl-Net-SAML2 && \
    git fetch && \
    git rebase && \
    perl Makefile.PL && \
    make install 
 
RUN cd /var/www/foswiki && \
    tools/configure -save -noprompt && \
    tools/configure -save -set {DefaultUrlHost}='http://localhost' && \
    tools/configure -save -set {ScriptUrlPath}='/bin' && \
    tools/configure -save -set {ScriptUrlPaths}{view}='' && \
    tools/configure -save -set {PubUrlPath}='/pub' && \
    tools/configure -save -set {DefaultUrlHost}='http://localhost' && \
    tools/configure -save -set {SafeEnvPath}='/bin:/usr/bin'

RUN cd /var/www/foswiki && \
    tools/extension_installer ActionTrackerPlugin -r -enable install && \
    tools/extension_installer NatSkin -r -enable install && \
    tools/extension_installer JQPhotoSwipeContrib -r -enable install && \
    tools/extension_installer ClassificationPlugin -r -enable install && \
    tools/extension_installer DiffPlugin -r -enable install && \
    tools/extension_installer DocumentViewerPlugin -r -enable install && \
    tools/extension_installer FilterPlugin -r -enable install && \
    tools/extension_installer GluePlugin -r -enable install && \
    tools/extension_installer GraphvizPlugin -r -enable install && \
    tools/extension_installer GridLayoutPlugin -r -enable install && \
    tools/extension_installer ImageGalleryPlugin -r -enable install && \
    tools/extension_installer ImagePlugin -r -enable install && \
    tools/extension_installer JQDataTablesPlugin -r -enable install && \
    tools/extension_installer JQMomentContrib -r -enable install && \
    tools/extension_installer JQSelect2Contrib -r -enable install && \
    tools/extension_installer JQSerialPagerContrib -r -enable install && \
    tools/extension_installer JQTwistyContrib -r -enable install && \
    tools/extension_installer JSTreeContrib -r -enable install && \
    tools/extension_installer LdapNgPlugin -r -enable install && \
    tools/extension_installer LikePlugin -r -enable install && \
    tools/extension_installer ListyPlugin -r -enable install && \
    tools/extension_installer MediaElementPlugin -r -enable install && \
    tools/extension_installer MetaCommentPlugin -r -enable install && \
    tools/extension_installer MetaDataPlugin -r -enable install && \
    tools/extension_installer MimeIconPlugin -r -enable install && \
    tools/extension_installer MoreFormfieldsPlugin -r -enable install && \
    tools/extension_installer MultiLingualPlugin -r -enable install && \
    tools/extension_installer NewUserPlugin -r -enable install && \
    tools/extension_installer RedDotPlugin -r -enable install && \
    tools/extension_installer RenderPlugin -r -enable install && \
    tools/extension_installer SolrPlugin -r -enable install && \
    tools/extension_installer TagCloudPlugin -r -enable install && \
    tools/extension_installer TopicInteractionPlugin -r -enable install && \
    tools/extension_installer WorkflowPlugin -r -enable install

RUN mkdir -p /run/nginx && \
    mkdir -p /etc/nginx/conf.d

COPY LdapUserView.txt /var/www/foswiki/data/System/LdapUserView.txt
COPY HtmlTitle.pm.diff /HtmlTitle.pm.diff
COPY LdapContrib.pm.diff /LdapContrib.pm.diff
#RUN cd /var/www/foswiki/lib/Foswiki/Contrib && \
#    patch -p0 < /LdapContrib.pm.diff && \
#    cd /root && \

RUN git clone https://github.com/timlegge/SamlLoginContrib.git && \
    cd SamlLoginContrib && \
    tar cvf SamlLoginContrib.tar * && \
    cd /var/www/foswiki && \
    tar xvf /SamlLoginContrib/SamlLoginContrib.tar

COPY nginx.default.conf /etc/nginx/conf.d/default.conf
COPY docker-entrypoint.sh docker-entrypoint.sh

EXPOSE 80

CMD ["sh", "docker-entrypoint.sh"]
