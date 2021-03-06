# Introduction

Dockerfile for installation of [matrix] open federated Instant Messaging and
VoIP communication server.

The vector web client has now his own docker file at [github].

[matrix]: matrix.org
[github]: https://github.com/silvio/docker-matrix-vector

# Configuration

To configure run the image with "generate" as argument. You have to setup the
server domain and a `/data`-directory. After this you have to edit the
generated homeserver.yaml file.

To get the things done, "generate" will create a own self-signed certificate.

> This needs to be changed for production usage.

Example:

    $ docker run -v /tmp/data:/data --rm -e SERVER_NAME=localhost -e REPORT_STATS=no zboxapp/docker-matrix generate

# Start

For starting you need the port bindings and a mapping for the
`/data`-directory.

    $ docker run -d -p 8448:8448 -p 3478:3478 -v /tmp/data:/data zboxapp/docker-matrix start

# Port configurations

This following ports are used in the container. You can use `-p`-option on
`docker run` to configure this part (eg.: `-p 443:8448`).

* turnserver: 3478,3479,5349,5350 udp and tcp
* homeserver: 8008,8448 tcp

# Version information

To get the installed synapse version you can run the image with `version` as
argument or look at the container via cat.

    $ docker run -ti --rm zboxapp/docker-matrix version
    -=> Matrix Version
    synapse: master (7e0a1683e639c18bd973f825b91c908966179c15)
    coturn:  master (88bd6268d8f4cdfdfaffe4f5029d489564270dd6)

    # docker exec -it CONTAINERID cat /synapse.version
    synapse: master (7e0a1683e639c18bd973f825b91c908966179c15)
    coturn:  master (88bd6268d8f4cdfdfaffe4f5029d489564270dd6)


# Environment variables

* `SERVER_NAME`: Server and domain name, mandatory, needed only  for `generate`
* `REPORT_STATS`: statistic report, mandatory, values: `yes` or `no`, needed
  only for `generate`


# diff between system and fresh generated config file

To get a hint about new options etc you can do a diff between your configured
homeserver.yaml and a newly created config file. Call your image with `diff` as
argument.


```
$ docker run --rm -ti -v /tmp/data:/data zboxapp/docker-matrix diff
[...]
+# ldap_config:
+#   enabled: true
+#   server: "ldap://localhost"
+#   port: 389
+#   tls: false
+#   search_base: "ou=Users,dc=example,dc=com"
+#   search_property: "cn"
+#   email_property: "email"
+#   full_name_property: "givenName"
[...]
```

For generating of this output its `diff` from `busybox` used. The used diff
parameters can be changed through `DIFFPARAMS` environment variable. The
default is `Naur`.

# LDAP Configuration

You need to change the `server` parameter to `uri`, using the previous example:

```yaml
ldap_config:
  enabled: true
  uri: "localhost"
  port: 389
  tls: false
  search_base: "ou=Users,dc=example,dc=com"
  search_property: "cn"
  email_property: "email"
  full_name_property: "givenName"
```

# Exported volumes

* `/data`: data-container

# Disclaimer

This is an almost fork of: https://github.com/silvio/docker-matrix the original Maintainer is: Silvio Fricke so all the beers to him.
