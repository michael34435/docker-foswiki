FROM alpine:3.7

ENV PERL_MM_USE_DEFAULT 1

ENV FOSWIKI_LATEST_URL https://github.com/foswiki/distro/releases/download/FoswikiRelease02x01x06/Foswiki-2.1.6.zip

ENV FOSWIKI_LATEST Foswiki-2.1.6

RUN apk add --update && \
    apk add nginx wget unzip make zip perl perl-cgi perl-fcgi perl-cgi-session perl-error perl-json perl-file-copy-recursive ca-certificates && \
    apk add perl-uri perl-digest-perl-md5 perl-lwp-protocol-https perl-html-tree perl-email-mime perl-algorithm-diff && \
    apk add perl-cache-cache  perl-file-which perl-module-pluggable perl-moo perl-json perl-dbi perl-dbd-sqlite && \
    apk add perl-archive-zip perl-time-modules mailcap imagemagick6 perl-authen-sasl perl-db_file perl-net-ldap && \
    apk add grep musl perl-text-soundex perl-io-socket-inet6 && \
    apk add perl-json-xs --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted && \
    apk add gcc perl-dev musl-dev db-dev imagemagick6-dev krb5-dev && \
    perl -MCPAN -e 'install Crypt::PasswdMD5, BerkeleyDB, Spreadsheet::XLSX ,XML::Easy, Time::ParseDate, Types::Standard, Algorithm::Diff::XS, GSSAPI' && \
    perl -MCPAN -e "CPAN::Shell->notest('install', 'DB_File::Lock')" && \
    wget http://www.imagemagick.org/download/perl/PerlMagick-6.89.tar.gz && \
    tar xvfz PerlMagick-6.89.tar.gz && \
    cd PerlMagick-6.89 && \
    perl Makefile.PL && \
    make install && \
    cd / && \
    rm -f PerlMagick-6.89.tar.gz && \
    rm -fr PerlMagick-6.89 && \
    apk del gcc perl-dev musl-dev db-dev imagemagick6-dev krb5-dev

RUN wget ${FOSWIKI_LATEST_URL} && \
    mkdir -p /var/www && \
    mv ${FOSWIKI_LATEST}.zip /var/www && \
    cd /var/www && \
    unzip ${FOSWIKI_LATEST}.zip -d /var/www/ && \
    rm -rf ${FOSWIKI_LATEST}.zip && \
    mv ${FOSWIKI_LATEST} foswiki && \
    cd foswiki && \
    sh tools/fix_file_permissions.sh

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
    tools/extension_installer JQPhotoSwipeContrib -r -enable install && \
    tools/extension_installer JQSelect2Contrib -r -enable install && \
    tools/extension_installer JQSerialPagerContrib -r -enable install && \
    tools/extension_installer JQTwistyContrib -r -enable install && \
    tools/extension_installer JSTreeContrib -r -enable install && \
    tools/extension_installer LikePlugin -r -enable install && \
    tools/extension_installer ListyPlugin -r -enable install && \
    tools/extension_installer LdapNgPlugin -r -enable install && \
    tools/extension_installer MediaElementPlugin -r -enable install && \
    tools/extension_installer MetaCommentPlugin -r -enable install && \
    tools/extension_installer MetaDataPlugin -r -enable install && \
    tools/extension_installer MimeIconPlugin -r -enable install && \
    tools/extension_installer MoreFormfieldsPlugin -r -enable install && \
    tools/extension_installer MultiLingualPlugin -r -enable install && \
    tools/extension_installer NatSkin -r -enable install && \
    tools/extension_installer RedDotPlugin -r -enable install && \
    tools/extension_installer RenderPlugin -r -enable install && \
    tools/extension_installer TagCloudPlugin -r -enable install && \
    tools/extension_installer TopicInteractionPlugin -r -enable install && \
    tools/extension_installer SolrPlugin -r -enable install && \
    tools/extension_installer WorkflowPlugin -r -enable install

RUN mkdir -p /run/nginx && \
    mkdir -p /etc/nginx/conf.d

COPY LdapUserView.txt /var/www/foswiki/data/System/LdapUserView.txt
COPY HtmlTitle.pm.diff /HtmlTitle.pm.diff
RUN cd /var/www/foswiki/lib/Foswiki/Plugins/NatSkinPlugin && \
    patch -p4 < /HtmlTitle.pm.diff

COPY nginx.default.conf /etc/nginx/conf.d/default.conf
COPY docker-entrypoint.sh docker-entrypoint.sh

EXPOSE 80

CMD ["sh", "docker-entrypoint.sh"]
