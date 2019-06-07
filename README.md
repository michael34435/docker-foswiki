# docker-foswiki

## Why I created this dockerfile?
I've found no one create a new version of foswiki with docker, so I created one.
And I minized the size of docker with alpinelinux, the total size for this image is `144MB`.

## How to use
```bash
docker run -idt -p 80:80 michael34435/docker-foswiki
```
or

```bash
docker run -idt -p 80:80 timlegge/docker-foswiki

```
### Running with persist storage

```bash
docker run --rm --name docker-foswiki -idt -p 80:80 -v foswiki_www:/var/www/foswiki:z timlegge/docker-foswiki
```

  * The assumption above is that the user running the command is in the docker group otherwise sudo is required
  * The -rm removes the container after it stops running (useful for testing)
  * The -v says to create a docker volume on the host system named foswiki_www and mount it to /var/www/foswiki in the running container
  * The :z after the volume is necessary with selinux on RedHat to set the permissions correctly

The volume is located on the host at /var/lib/docker/volumes/foswili_www and will keep any change you make when configuring the container

### Included Alpine Packages
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
main | Error | perl-error
main | FCGI | perl-fcgi
main | FCGI-ProcManager | perl-fcgi-procmanager
main | File-Copy-Recursive-$pkgver | perl-file-copy-recursive
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
community | Crypt-OpenSSL-Bignum | perl-crypt-openssl-bignum
community | Crypt-OpenSSL-DSA | perl-crypt-openssl-dsa
community | Dancer | perl-dancer
community | Digest-Perl-MD5 | perl-digest-perl-md5
community | Email-MIME | perl-email-mime
community | Hash-Merge-Simple | perl-hash-merge-simple
community | LWP-Protocol-https | perl-lwp-protocol-https
community | Moo | perl-moo
community | MooX-Types-MooseLike | perl-moox-types-mooselike
community | Moose | perl-moose
community | XML-Writer | perl-xml-writer
community | XML-XPath | perl-xml-xpath
community | YAML | perl-yaml
testing | Algorithm-Diff-XS | perl-algorithm-diff-xs
testing | BerkeleyDB | perl-berkeleydb
testing | Crypt-OpenSSL-VerifyX509 | perl-crypt-openssl-verifyx509
testing | Crypt-OpenSSL-X509 | perl-crypt-openssl-x509
testing | Crypt-PasswdMD5 | perl-crypt-passwdmd5
testing | Crypt-SMIME | perl-crypt-smime
testing | Convert-PEM | perl-convert-pem
testing | DB_File-Lock | perl-db_file-lock
testing | DateTime-Format-XSD | perl-datetime-format-xsd
testing | Devel-OverloadInfo | perl-devel-overloadinfo
testing | GSSAPI | perl-gssapi
testing | JSON-XS | perl-json-xs
testing | Locale-Codes | perl-locale-codes
testing | MooseX | perl-moosex
testing | MooseX-Types | perl-moosex-types
testing | MooseX-Types-Common | perl-moosex-types-common
testing | MooseX-Types-DateTime | perl-moosex-types-datetime
testing | MooseX-Types-URI | perl-moosex-types-uri
testing | Locale-Msgfmt | perl-locale-msgfmt
testing | Sereal | perl-sereal
testing | Spreadsheet-XLSX | perl-spreadsheet-xlsx
testing | Sub-Exporter-ForMethods | perl-sub-exporter-formethods
testing | Text-Unidecode | perl-text-unidecode
testing | Time-ParseDate | perl-time-parsedate
testing | WWW-Mechanize | perl-www-mechanize
testing | XML-CanonicalizeXML | perl-xml-canonicalizexml
testing | XML-Easy | perl-xml-easy
testing | XML-Generator | perl-xml-generator
testing | XML-Tidy | perl-xml-tidy
testing | libapreq2 | perl-libapreq2

## How to Build
You can build the docker image yourself from the git clone.  Dimply do the following in the git directory:
```bash
sudo docker build --no-cache -t docker-foswiki .
```
Building the docker image requires parts of the build process to get access to the internet so if you have a proxy server you will need to follow the directions below to pass the proxy settings to the bulid prodess
```bash
sudo docker build --no-cache  --build-arg https_proxy=http://proxy.example.com:8080 --build-arg http_proxy=http://proxy.example.com:8080 --build-arg HTTPS_PROXY=http://proxy.example.com:8080 --build-arg HTTP_PROXY=http://proxy.example.com:8080 -t docker-foswiki .
```
Unfortunately as the build use's wget, perl LWP and apk from AlpineLinux all four environment variables are necessary as each uses a different case or protocol to download the proper files.

## How to run the Build
```bash
sudo docker run --name docker-foswiki -d  -p 80:80 docker-foswiki
```
## How to access the running container as root
```bash
sudo docker exec -it docker-foswiki /bin/sh
``` 
## How to stop the container
```bash
sudo docker stop docker-foswiki
``` 
## How to remove the container
```bash
sudo docker rm docker-foswiki
``` 
## How to publish image to Docker Hub
```bash
sudo docker login
sudo docker tag docker-foswiki $DOCKER_ID_USER/docker-foswiki
sudo docker push  $DOCKER_ID_USER/docker-foswiki
``` 

## License
MIT
