# From commit fcd135252b

[DEFAULT]

# Show more verbose log output (sets INFO log level output)
verbose = False

# Show debugging output in logs (sets DEBUG log level output)
debug = False

# Which backend store should Keystone use by default.
# Default: 'sqlite'
# Available choices are 'sqlite' [future will include LDAP, PAM, etc]
default_store = sqlite

# Log to this file. Make sure you do not set the same log
# file for both the API and registry servers!
log_file = %DEST%/keystone/keystone.log

# List of backends to be configured
backends = keystone.backends.sqlalchemy
#For LDAP support, add: ,keystone.backends.ldap

# Dictionary Maps every service to a header.Missing services would get header
# X_(SERVICE_NAME) Key => Service Name, Value => Header Name
service_header_mappings = {
	'nova' : 'X-Server-Management-Url',
	'swift' : 'X-Storage-Url',
	'cdn' : 'X-CDN-Management-Url'}

#List of extensions currently supported
extensions= osksadm,oskscatalog

# Address to bind the API server
# TODO Properties defined within app not available via pipeline.
service_host = 0.0.0.0

# Port the bind the API server to
service_port = 5000

# SSL for API server
service_ssl = False

# Address to bind the Admin API server
admin_host = 0.0.0.0

# Port the bind the Admin API server to
admin_port = 35357

# SSL for API Admin server
admin_ssl = False

# Keystone certificate file (modify as needed)
# Only required if *_ssl is set to True
certfile = /etc/keystone/ssl/certs/keystone.pem

# Keystone private key file (modify as needed)
# Only required if *_ssl is set to True
keyfile = /etc/keystone/ssl/private/keystonekey.pem

# Keystone trusted CA certificates  (modify as needed)
# Only required if *_ssl is set to True
ca_certs = /etc/keystone/ssl/certs/ca.pem

# Client certificate required
# Only relevant if *_ssl is set to True
cert_required = True

#Role that allows to perform admin operations.
keystone_admin_role = admin

#Role that allows to perform service admin operations.
keystone_service_admin_role = KeystoneServiceAdmin

#Tells whether password user need to be hashed in the backend
hash_password = True

[keystone.backends.sqlalchemy]
# SQLAlchemy connection string for the reference implementation registry
# server. Any valid SQLAlchemy connection string is fine.
# See: http://bit.ly/ideIpI
sql_connection = %SQL_CONN%
backend_entities = ['UserRoleAssociation', 'Endpoints', 'Role', 'Tenant',
                    'User', 'Credentials', 'EndpointTemplates', 'Token',
                    'Service']

# Period in seconds after which SQLAlchemy should reestablish its connection
# to the database.
sql_idle_timeout = 30

[pipeline:admin]
pipeline =
    urlrewritefilter
    admin_api

[pipeline:keystone-legacy-auth]
pipeline =
    urlrewritefilter
    legacy_auth
    service_api

[app:service_api]
paste.app_factory = keystone.server:service_app_factory

[app:admin_api]
paste.app_factory = keystone.server:admin_app_factory

[filter:urlrewritefilter]
paste.filter_factory = keystone.middleware.url:filter_factory

[filter:legacy_auth]
paste.filter_factory = keystone.frontends.legacy_token_auth:filter_factory

[filter:debug]
paste.filter_factory = keystone.common.wsgi:debug_filter_factory

