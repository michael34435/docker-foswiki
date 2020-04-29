# Congratulations

You now have a running foswiki and solr container, and need to finalize some settings to ensure your work is complete.

## Necessary CapRover Changes

* Enable Force HTTPS.
* Enable HTTPS.

## Docker Administration

<a name="ContainerLogin"></a>

### Container Login

Login to the docker machine by identifying the container `docker ps` .

```shell
root@ubuntu-8gb-nbg1-1:~# docker ps
CONTAINER ID        IMAGE                               COMMAND                  CREATED             STATUS              PORTS                                      NAMES
d392b0392d5e        timlegge/docker-foswiki:latest      "sh docker-entrypoin…"   13 hours ago        Up 13 hours         80/tcp                                     srv-captain--foswiki.1.rl7vmf0qep9e8lbp2hqi4hp9o
```

and then using `docker exec -ti d392b0392d5e /bin/bash` to login to the machine.

### Set the Admin Password via the Container

1. `cd /var/www/foswiki/`
1. `tools/configure -save -set {Password}='MyPassword'`

<a name="CapRoverAdmin"></a>

## CapRover Administration

### Setting up HTTPS

1. Login to CapRover Dashboard.
1. Select the app created.
1. Choose Enable HTTPS.
1. Tick the checkbox "Force HTTPS by redirecting all HTTP traffic to HTTPS"
1. Click on `Save & Update`.

<a name="FoswikiAdmin"></a>

## Foswiki Administration Login

1. Connect to <https://foswiki.exapmle.com/>
1. Login as the admin user (username: admin, password: [as set above])
1. Access <https://foswiki.exapmle.com/bin/configure>

### Start Modifications

These settings are needed to ensure that your application can load java scripts and images.

1. Login to [foswiki](#FoswikiAdmin) as an administrator.
1. Under "General settings".
   1. Access "Web URLs and Paths".
1. Click on "Show expert options".
   1. Activate the checkbox for "ForceDefaultUrlHost".
1. Click "Save"
1. Confirm Changes.

### Setting up Solr

There are some small settings needed to ensure that the search works properly. At this point, there is a small caveat which means when the Solr container has been restarted, the URL must be changed.

### Prepare Index

This takes a few minutes.

1. Login to the [container](#ContainerLogin).

   ```bash
   cd /var/www/foswiki/tools
   ./solrindex mode=full optimize=on
   ```

---

Tip:

   You can do a partial test by running `./solrindex topic=Main.WebHome`.

---

### Enable Solr search on Foswiki

1. Login to [foswiki](#FoswikiAdmin) as an administrator.
1. Access Extensions
   1. Configure "SolrPlugin"
      1. Modify "{SolrPlugin}{Url}" by using the container name found with `docker ps` .
      (i.e.) <http://srv-captain--foswiki.1.rl7vmf0qep9e8lbp2hqi4hp9o:8983/solr/foswiki>
   1. Configure "AutoTemplatePlugin"
      1. Modify "{Plugins}{AutoTemplatePlugin}{ViewTemplateRules}
" Rules
      1. Change `'WebSearch' => 'WebSearchView' to 'WebSearch' => 'SolrSearchView'`
      1. Save Configuration Changes
1. Connect to <http://foswiki.example.com/>
1. Click Search
1. Type "Congrats" (you should see Main begin to appear)
1. Press Enter (you should see the Solr results for "Congrats" search term)

### Automating Solr Index

1. Login to [foswiki](#FoswikiAdmin) as an administrator.
1. Access Extensions.
   1. Configure "SolrPlugin".
      1. Activate "EnableOnSaveUpdates".
      1. Activate "EnableOnUploadUpdates".

---

Warning:

{SolrPlugin}{Url} needs to be changed, if the solr container is restarted.

---

## Best Practice

* Set up a new user, and add them to the Admin Group.
* Clear the shared administrator password.

   1. Login to [foswiki](#FoswikiAdmin) as an administrator.
   1. Access "Security and Authentication".
   1. Configure "Passwords".
      1. Empty the value for "Internal Admin Password:
    {Password}".
      1. Save Configuration Changes

## Credits

* timlegge/docker-foswiki is based on the original work of michael34435 docker-foswiki.
* The Alpine Linux project was very helpful in approving the required perl-modules that were submitted (full native packages to support Foswiki).
* Solr and their docker container simplified Solr setup.
* Shawn Beasley for the one-click app integration into CapRover.
