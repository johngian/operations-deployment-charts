# mediawiki-dev

mediawiki-dev is a helm chart for mediawiki/core. It is not suitable for production.

## Installing the chart

mediawiki-dev has been tested with mariadb. It is expected to work with mysql or mariadb. Further work and testing are necessary for other database types. The database location, name, and password are the only requirements for the default chart installation (`config.public.DB_SERVER`, `config.public.DB_NAME`, `config.private.DB_PASS`).

### Quick-install the mediawiki-dev chart using Helm
From this directory:
```sh
 helm install --set config.public.DB_SERVER="my_server" --set config.public.DB_NAME="my_name" --set config.private.DB_PASS="my_pass" .
 ```

## Configuration

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `docker.registry` | The registry from which to pull the mediawiki/core image | `docker-registry.wikimedia.org` |
| `docker.pull_policy` | Always, Never, or IfNotPresent | `IfNotPresent` |
| `resources.replicas` | The number of instances to deploy | `1` |
| `main_app.image` | The image name | `dev/mediawiki` |
| `main_app.version` | The image tag | `latest` |
| `main_app.ports` | The container ports to expose | `[80]`
| `main_app.command` | The command to run to override the entrypoint | `'["/bin/bash", "-c"]'` |
| `main_app.args` | The args to give to the command | `'/var/config/setup.sh && /usr/bin/php -S 0.0.0.0:80 -t /var/www/html'`
| `main_app.requests.cpu` | CPU allocation | `15m` |
| `main_app.requests.memory` | Memory allocation | `100Mi` |
| `main_app.limits.cpu` | CPU limit | `1` |
| `main_app.limits.memory` | Memory limit | `200Mi` |
| `main_app.liveness_probe.tcpSocket.port` | The port to use for healthchecks | `80` |
| `main_app.readiness_probe.httpGet.path` | The endpoint to check for readiness | `/wiki/Special:BlankPage` |
| `main_app.readiness_probe.httpGet.port1` | The port to use for readiness checks | `80` |
| `main_app.volumes` | Volumes to mount to the container. Useful for overriding LocalSettings or sharing local files | `[]` |
| `main_app.volumeMounts` | Mounted volumes to make accesible | `[]` |
| `main_app.xdebug.enabled` | Whether to enable xdebug | `false` |
| `main_app.xdebug.remoteHost` | The host that will be listening for xdebug | `''` |
| `monitoring.enabled` | Whether to enable monitoring | `false` |
| `monitoring.image_version` | The monitoring image tag | `latest` |
| `service.deployment` | production or minikube | `minikube` |
| `service.ports` | Ports to expose | `[ { name: http, protoco: TCP, targetPort: 80, port: 80, nodePort: null } ]` |
| `config.public.XDEBUG_CONFIG` | Environment variables for xdebug | `"remote_autostart=1 remote_enable=1 remote_handler=dbgp remote_host={{ .Values.main_app.xdebug.remoteHost }} remote_log=/tmp/xdebug_remote.log remote_mode=req remote_port=9000"` |
| `config.public.WIKI_NAME` | The name of the wiki | `"My Wiki"` |
| `config.public.WIKI_ADMIN` | The wiki admin username | `"admin"` |
| `config.public.DB_NAME` | The name of the database | `"my_wiki"` |
| `config.public.RESTBASE_NODEPORT` | The nodeport of the restbase server | `""` |
| `config.public.MEDIAWIKI_DOMAIN` | The domain (used in restbase and parsoid config) | `"{{ .Release.Name }}"` |
| `config.public.RESTBASE_URL` | The restbase connection string | `"http://restbase-{{ .Release.Name }}"` |
| `config.public.IS_RESTBASE_EXTERNAL` | Whether restbase is running outside the cluster | `false` |
| `config.public.PARSOID_URL` | The parsoid connection string | `"http://parsoid-{{ .Release.Name }}"` |
| `config.public.ENABLE_VISUAL_EDITOR` | Whether to enable the visual editor | `"false"` |
| `config.public.DB_SERVER` | The database connection string | `"mariadb-{{ .Release.Name }}"`
| `config.private.WIKI_ADMIN_PASS` | The wiki admin password | `"adminpass"` |
| `config.private.DB_PASS` | The database password | `"password"` |
| `config.private.WG_SECRET_KEY` | A secret key | `"d964ce98b272c2115d5f4960563af8fb8f02ff968bbb0d62bdf4e1e4c18393ed"` |
| `config.private.WG_UPGRADE_KEY` | A key for upgrading | `aed8ffeb5b5fba9e` |