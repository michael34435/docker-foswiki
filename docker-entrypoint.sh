#!/bin/bash

echo "...preparing Solr for Foswiki"
chown -R 8983:8983 /opt/solr/server/solr
chown -R 8983:8983 /var/www/foswiki/solr

cd /opt/solr/server/solr/configsets
[ -L foswiki_configs ] && rm foswiki_configs
ln -s /var/www/foswiki/solr/configsets/foswiki_configs/ .

cd /opt/solr/server/solr/solr_foswiki
[ -L core.properties ] && rm core.properties
ln -s /var/www/foswiki/solr/cores/foswiki/core.properties

sed -i '/SolrPlugin..Url/s/localhost/solr/' /var/www/foswiki/lib/LocalSite.cfg

echo "...enabling NatSkin"
grep -q "Set SKIN = nat" /var/www/foswiki/data/Main/SitePreferences.txt || sed -i '/---++ Appearance/a\ \ \ * Set SKIN = nat' /var/www/foswiki/data/Main/SitePreferences.txt

echo "...starting iwatch"
iwatch -d

echo "...starting nginx+foswiki"
cd /var/www/foswiki/bin

./foswiki.fcgi -l 127.0.0.1:9000 -n 5 -d

nginx -g "daemon off;"
