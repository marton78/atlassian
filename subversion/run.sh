#!/bin/sh

cat<<EOF >/etc/apache2/conf.d/subversion.conf

LoadModule dav_svn_module   modules/mod_dav_svn.so
LoadModule authz_svn_module modules/mod_authz_svn.so

ServerName "$SERVER_NAME"

<Location />
  DAV svn
  SVNParentPath /var/svn
  #AuthzSVNAccessFile /var/svn/users.authz
  AuthType Basic
  AuthBasicProvider ldap
  AuthName "Subversion server"
  AuthLDAPURL "$LDAP_URL" NONE
  AuthLDAPBindDN "$LDAP_BIND_DN"
  AuthLDAPBindPassword "$LDAP_BIND_PW"
  Require valid-user
  #Require ldap-attribute objectClass=user
  #Require ldap-group DN of group allowed access to repo
</Location>
EOF

httpd -D FOREGROUND

