# docker-foswiki, with Solr and NatSkin

## Why I created this dockerfile?
I finally got tired of the dependancy issues of Foswiki on RedHat so I modified michael34435/docker-foswiki. The goal of this release is to have a stable version that runs foswiki with all the perl modules required for foswiki to run almost any Plugin. It is served by nginx. Alpinelinux minimizes the size of the container, the total size for this image is `400MB`.

A `docker-compose` file is also available in order to have a complete Foswiki + Solr faceted search application. 

## Simple run

To start the image :

```bash
docker run -idt -p 80:80 timlegge/docker-foswiki

```

Once started, open `http://localhost` in your browser. The user running the command is in the docker group otherwise sudo is required.

### Resetting the Admin Password

   1. `cd [where the project has been cloned]`
   2. `docker exec -it docker-foswiki /bin/bash`
   3. `cd /var/www/foswiki/`
   4. `tools/configure -save -set {Password}='MyPassword'`

### Complete run

With the `docker-compose.yaml`, a Foswiki + Solr multi-container application is created. Start it with :

```bash
docker-compose up
```

Once started, open `http://localhost:8765` in your browser.

To use another port, prepend the command :

```bash
FOSWIKI_PORT=80 docker-compose up
```

### Persistent storage

See the volume declaration in the `docker-compose.yaml` file :
   * 4 volumes are created, for Foswiki data and Solr
   * the `:z` after the volume declaration is necessary with selinux on RedHat to set the permissions correctly
   * the volumes are located on the host by default under `/var/lib/docker/volumes/` and will keep any change you make when configuring the container

### Overiding the defaults 

Any setting declared in the compose file can be overidden within another yaml file. For instance to change the port number and the volume location of the `foswiki_www` volume, create an `overrides.yml` file with the following content :

```bash
services:
  foswiki:
    ports:
      - 8761:80

volumes:
  foswiki_www:
    driver: local
    driver_opts:
      type: none
      device: /opt/myVolumes/foswiki
      o: bind
```

And start the application with :

```bash
docker-compose -f docker-compose.yaml -f overrides.yml up -d
```

### Running multiple instances 

If multiple instances of Foswiki are needed, they have to live under different project name and TCP port :
- `FOSWIKI_PORT=8761 docker-compose -p project1 up`
- `FOSWIKI_PORT=8762 docker-compose -p project2 up`

Or use an override file per instance :
- `docker-compose -p project1 -f docker-compose.yaml -f overrides-project1.yml up`
- `docker-compose -p project2 -f docker-compose.yaml -f overrides-project2.yml up`

### Included Foswiki Contribs
   * CopyContrib
   * DBCacheContrib
   * FarscrollContrib
   * InfiniteScrollContrib
   * JQAutoColorContrib
   * JQMomentContrib
   * JQPhotoSwipeContrib
   * JQSelect2Contrib
   * JQSerialPagerContrib
   * JQTwistyContrib
   * JSTreeContrib
   * LdapContrib
   * OpenIDLoginContrib
   * SamlLoginContrib
   * StringifierContrib
   * WebFontsContrib
   * XSendFileContrib

### Included Foswiki Plugins
   * AttachContentPlugin
   * AutoRedirectPlugin
   * AutoTemplatePlugin
   * BreadCrumbsPlugin
   * CaptchaPlugin
   * ClassificationPlugin
   * DBCachePlugin
   * DiffPlugin
   * DigestPlugin
   * DocumentViewerPlugin
   * EditChapterPlugin
   * FilterPlugin
   * FlexFormPlugin
   * FlexWebListPlugin
   * GraphvizPlugin
   * GridLayoutPlugin
   * ImageGalleryPlugin
   * ImagePlugin
   * JQDataTablesPlugin
   * LdapNgPlugin
   * LikePlugin
   * ListyPlugin
   * MediaElementPlugin
   * MetaCommentPlugin
   * MetaDataPlugin
   * MimeIconPlugin
   * MoreFormfieldsPlugin
   * MultiLingualPlugin
   * NatSkinPlugin
   * NewUserPlugin
   * PageOptimizerPlugin
   * PubLinkFixupPlugin
   * RedDotPlugin
   * RenderPlugin
   * SecurityHeadersPlugin
   * SolrPlugin
   * TagCloudPlugin
   * TopicInteractionPlugin
   * TopicTitlePlugin
   * WebLinkPlugin
   * WorkflowPlugin

### Included Foswiki Skins
   * NatSkin

### Included Alpine Packages

The following base modules are installed to support Foswiki or the required Perl modules below.

Repo | Application | Alpine Package
-----|-------------|---------------
main | Bash | bash
main | Common-CA-certificates | ca-certificates
main | GraphVis | graphviz
main | Grep | grep
main | mailcap | mailcap
main | GNU-make | make
main | Lynx Texte Browser | lynx 
main | musl-LibC | musl
main | nginx-Web-Server | nginx
main | openSSL | openssl
main | Perl5 | perl
main | poppler-utils | poppler-utils
main | Timezone-Data | tzdata
main | unzip | unzip
main | wget | wget
main | zip | zip
community | ImageMagick | imagemagick
community | PerlMagick | imagemagick-perlmagick
testing | odt2txt | odt2txt

A lot of perl modules required by Foswiki and many of its expensions are included in this Docker file as native alpine packages:

Repo | Perl Module | Alpine Package
-----|-------------|---------------
main | Apache-LogFormat-Compiler | perl-apache-logformat-compiler
main | Archive-Zip | perl-archive-zip
main | Authen-SASL | perl-authen-sasl
main | CGI | perl-cgi
main | Cache-Cache | perl-cache-cache
main | Crypt-Eksblowfish | perl-crypt-eksblowfish
main | Crypt-OpenSSL-RSA | perl-crypt-openssl-rsa
main | Crypt-OpenSSL-Random | perl-crypt-openssl-random
main | Crypt-X509 | perl-crypt-x509
main | DBD-Pg | perl-dbd-pg
main | DBD-SQLite | perl-dbd-sqlite
main | DBD-mysql | perl-dbd-mysql
main | DBI | perl-dbi
main | DB_File | perl-db_file
main | DateTime | perl-datetime
main | Digest-SHA1 | perl-digest-sha1
main | Encode | perl-encode
main | Error | perl-error
main | FCGI | perl-fcgi
main | FCGI-ProcManager | perl-fcgi-procmanager
main | File-Copy-Recursive-$pkgver | perl-file-copy-recursive
main | File-Remove | perl-file-remove
main | File-Slurp | perl-file-slurp
main | File-Which | perl-file-which
main | GD | perl-gd
main | HTML-Tree | perl-html-tree
main | IO-Socket-INET6 | perl-io-socket-inet6
main | JSON | perl-json
main | MIME-Base64 | perl-mime-base64
main | Module-Install | perl-module-install
main | Module-Pluggable | perl-module-pluggable
main | Path-Tiny | perl-path-tiny
main | Stream-Buffered | perl-stream-buffered
main | Test-LeakTrace | perl-test-leaktrace
main | Text-Soundex | perl-text-soundex
main | Type-Tiny | perl-type-tiny
main | XML-Parser | perl-xml-parser
main | YAML-Tiny | perl-yaml-tiny
main | libwww-perl | perl-libwww
main | Filesys-Notify-Simple | perl-filesys-notify-simple
main | Hash-MultiValue | perl-hash-multivalue
main | Locale-Maketext-Lexicon | perl-locale-maketext-lexicon
main | URI | perl-uri
main | perl-ldap | perl-ldap
main | CGI-Session | perl-cgi-session
main | Class-Accessor | perl-class-accessor
community | Algorithm-Diff | perl-algorithm-diff
community | Algorithm-Diff-XS | perl-algorithm-diff-xs
community | AuthCAS | perl-authcas
community | BerkeleyDB | perl-berkeleydb
community | Crypt-PasswdMD5 | perl-crypt-passwdmd5
community | Crypt-SMIME | perl-crypt-smime
community | Convert-PEM | perl-convert-pem
community | Crypt-OpenSSL-Bignum | perl-crypt-openssl-bignum
community | Crypt-OpenSSL-DSA | perl-crypt-openssl-dsa
community | Crypt-OpenSSL-VerifyX509 | perl-crypt-openssl-verifyx509
community | Crypt-OpenSSL-X509 | perl-crypt-openssl-x509
community | Dancer | perl-dancer
community | DB_File-Lock | perl-db_file-lock
community | DateTime-Format-XSD | perl-datetime-format-xsd
community | Devel-OverloadInfo | perl-devel-overloadinfo
community | Digest-Perl-MD5 | perl-digest-perl-md5
communtiy | Email-Address-XS | perl-email-address-xs
community | Email-MIME | perl-email-mime
community | Hash-Merge-Simple | perl-hash-merge-simple
community | Image-Info | perl-image-info 
community | JSON-XS | perl-json-xs
community | GSSAPI | perl-gssapi
community | Locale-Codes | perl-locale-codes
community | Locale-Msgfmt | perl-locale-msgfmt
community | LWP-Protocol-https | perl-lwp-protocol-https
community | Moo | perl-moo
community | MooX-Types-MooseLike | perl-moox-types-mooselike
community | Moose | perl-moose
community | MooseX | perl-moosex
community | MooseX-Types | perl-moosex-types
community | MooseX-Types-Common | perl-moosex-types-common
community | MooseX-Types-DateTime | perl-moosex-types-datetime
community | MooseX-Types-URI | perl-moosex-types-uri
community | Spreadsheet-ParseExcel | perl-spreadsheet-parseexcel
community | Spreadsheet-XLSX | perl-spreadsheet-xlsx
community | Sub-Exporter-ForMethods | perl-sub-exporter-formethods
community | WWW-Mechanize | perl-www-mechanize
community | XML-CanonicalizeXML | perl-xml-canonicalizexml
community | XML-Easy | perl-xml-easy
community | XML-Generator | perl-xml-generator
community | XML-Tidy | perl-xml-tidy
community | XML-Writer | perl-xml-writer
community | XML-XPath | perl-xml-xpath
community | YAML | perl-yaml
testing | Crypt-JWT | perl-crypt-jwt
testing | Crypt-Random | perl-crypt-random
testing | libapreq2 | perl-libapreq2
testing | Sereal | perl-sereal
timlegge | Net-SAML2 | perl-net-saml2

## How to Build
You can build the docker image yourself from the git clone.  Simply do the following in the git directory:
```bash
docker build --no-cache -t docker-foswiki .
```
Building the docker image requires parts of the build process to get access to the internet so if you have a proxy server you will need to follow the directions below to pass the proxy settings to the bulid prodess
```bash
docker build --no-cache  --build-arg https_proxy=http://proxy.example.com:8080 --build-arg http_proxy=http://proxy.example.com:8080 --build-arg HTTPS_PROXY=http://proxy.example.com:8080 --build-arg HTTP_PROXY=http://proxy.example.com:8080 -t docker-foswiki .
```
Unfortunately as the build use's wget, perl LWP and apk from AlpineLinux all four environment variables are necessary as each uses a different case or protocol to download the proper files.

## How to run the Build
```bash
docker run --name docker-foswiki -d  -p 80:80 docker-foswiki
```
## How to access the running container as root
```bash
docker exec -it docker-foswiki /bin/sh
``` 
## How to stop the container
```bash
docker stop docker-foswiki
``` 
## How to remove the container
```bash
docker rm docker-foswiki
``` 
## How to publish image to Docker Hub
```bash
docker login
docker tag docker-foswiki $DOCKER_ID_USER/docker-foswiki
docker push  $DOCKER_ID_USER/docker-foswiki
``` 

## License
MIT
