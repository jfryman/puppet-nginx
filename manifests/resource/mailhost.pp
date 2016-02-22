# define: nginx::resource::mailhost
#
# This definition creates a virtual host
#
# Parameters:
#   [*ensure*]                   - Enables or disables the specified mailhost (present|absent)
#   [*listen_ip*]                - Default IP Address for NGINX to listen with this vHost on. Defaults to all interfaces (*)
#   [*listen_port*]              - Default IP Port for NGINX to listen with this vHost on. Defaults to TCP 80
#   [*listen_options*]           - Extra options for listen directive like 'default' to catchall. Undef by default.
#   [*ipv6_enable*]              - BOOL value to enable/disable IPv6 support (false|true). Module will check to see if IPv6
#     support exists on your system before enabling.
#   [*ipv6_listen_ip*]           - Default IPv6 Address for NGINX to listen with this vHost on. Defaults to all interfaces (::)
#   [*ipv6_listen_port*]         - Default IPv6 Port for NGINX to listen with this vHost on. Defaults to TCP 80
#   [*ipv6_listen_options*]      - Extra options for listen directive like 'default' to catchall. Template will allways add ipv6only=on.
#     While issue jfryman/puppet-nginx#30 is discussed, default value is 'default'.
#   [*index_files*]              - Default index files for NGINX to read when traversing a directory
#   [*ssl*]                      - Indicates whether to setup SSL bindings for this mailhost.
#   [*ssl_cert*]                 - Pre-generated SSL Certificate file to reference for SSL Support. This is not generated by this module.
#   [*ssl_ciphers*]              - SSL ciphers enabled. Defaults to
#     'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:CAMELLIA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA'.
#   [*ssl_client_cert*]          - Pre-generated SSL Certificate file to reference for client verify SSL Support. This is not generated by this module.
#   [*ssl_crl*]                  - String: Specifies CRL path in file system
#   [*ssl_dhparam*]              - This directive specifies a file containing Diffie-Hellman key agreement protocol cryptographic parameters, in PEM
#     format, utilized for exchanging session keys between server and client.
#   [*ssl_ecdh_curve*]           - This directive specifies a curve for ECDHE ciphers.
#   [*ssl_key*]                  - Pre-generated SSL Key file to reference for SSL Support. This is not generated by this module.
#   [*ssl_password_file*]        - This directive specifies a file containing passphrases for secret keys.
#   [*ssl_port*]                 - Default IP Port for NGINX to listen with this SSL vHost on. Defaults to TCP 443
#   [*ssl_protocols*]            - SSL protocols enabled. Defaults to 'TLSv1 TLSv1.1 TLSv1.2'.
#   [*ssl_session_cache*]        - Sets the type and size of the session cache.
#   [*ssl_session_ticket_key*]   - This directive specifies a file containing secret key used to encrypt and decrypt TLS session tickets.
#   [*ssl_session_tickets*]      - Wheter to enable or disable session resumption through TLS session tickets.
#   [*ssl_session_timeout*]      - String: Specifies a time during which a client may reuse the session parameters stored in a cache.
#     Defaults to 5m.
#   [*ssl_trusted_cert*]         - String: Specifies a file with trusted CA certificates in the PEM format used to verify client
#     certificates and OCSP responses if ssl_stapling is enabled.
#   [*ssl_verify_depth*]         - Sets the verification depth in the client certificates chain.
#   [*starttls*]                 - Enable STARTTLS support: (on|off|only)
#   [*protocol*]                 - Mail protocol to use: (imap|pop3|smtp)
#   [*auth_http*]                - With this directive you can set the URL to the external HTTP-like server for authorization.
#   [*xclient*]                  - Wheter to use xclient for smtp (on|off)
#   [*imap_auth*]                - Sets permitted methods of authentication for IMAP clients.
#   [*imap_capabilities*]        - Sets the IMAP protocol extensions list that is passed to the client in response to the CAPABILITY command.
#   [*imap_client_buffer*]       - Sets the IMAP commands read buffer size.
#   [*pop3_auth*]                - Sets permitted methods of authentication for POP3 clients.
#   [*pop3_capabilities*]        - Sets the POP3 protocol extensions list that is passed to the client in response to the CAPA command.
#   [*smtp_auth*]                - Sets permitted methods of SASL authentication for SMTP clients.
#   [*smtp_capabilities*]        - Sets the SMTP protocol extensions list that is passed to the client in response to the EHLO command.
#   [*proxy_pass_error_message*] - Indicates whether to pass the error message obtained during the authentication on the backend to the client.
#   [*server_name*]              - List of mailhostnames for which this mailhost will respond. Default [$name].
#
# Actions:
#
# Requires:
#
# Sample Usage:
#  nginx::resource::mailhost { 'domain1.example':
#    ensure      => present,
#    auth_http   => 'server2.example/cgi-bin/auth',
#    protocol    => 'smtp',
#    listen_port => 587,
#    ssl_port    => 465,
#    starttls    => 'only',
#    xclient     => 'off',
#    ssl         => true,
#    ssl_cert    => '/tmp/server.crt',
#    ssl_key     => '/tmp/server.pem',
#  }
define nginx::resource::mailhost (
  $listen_port,
  $ensure                   = 'present',
  $listen_ip                = '*',
  $listen_options           = undef,
  $ipv6_enable              = false,
  $ipv6_listen_ip           = '::',
  $ipv6_listen_port         = '80',
  $ipv6_listen_options      = 'default ipv6only=on',
  $ssl                      = false,
  $ssl_cert                 = undef,
  $ssl_ciphers              = 'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:CAMELLIA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA',
  $ssl_client_cert          = undef,
  $ssl_crl                  = undef,
  $ssl_dhparam              = undef,
  $ssl_ecdh_curve           = undef,
  $ssl_key                  = undef,
  $ssl_password_file        = undef,
  $ssl_port                 = undef,
  $ssl_protocols            = 'TLSv1 TLSv1.1 TLSv1.2',
  $ssl_session_cache        = undef,
  $ssl_session_ticket_key   = undef,
  $ssl_session_tickets      = undef,
  $ssl_session_timeout      = '5m',
  $ssl_trusted_cert         = undef,
  $ssl_verify_depth         = undef,
  $starttls                 = 'off',
  $protocol                 = undef,
  $auth_http                = undef,
  $xclient                  = 'on',
  $imap_auth                = undef,
  $imap_capabilities        = undef,
  $imap_client_buffer       = undef,
  $pop3_auth                = undef,
  $pop3_capabilities        = undef,
  $smtp_auth                = undef,
  $smtp_capabilities        = undef,
  $proxy_pass_error_message = 'off',
  $server_name              = [$name]
) {

  $root_group = $::nginx::config::root_group

  File {
    owner => 'root',
    group => $root_group,
    mode  => '0644',
  }

  if !is_integer($listen_port) {
    fail('$listen_port must be an integer.')
  }
  validate_re($ensure, '^(present|absent)$',
    "${ensure} is not supported for ensure. Allowed values are 'present' and 'absent'.")
  if !(is_array($listen_ip) or is_string($listen_ip)) {
    fail('$listen_ip must be a string or array.')
  }
  if ($listen_options != undef) {
    validate_string($listen_options)
  }
  validate_bool($ipv6_enable)
  if !(is_array($ipv6_listen_ip) or is_string($ipv6_listen_ip)) {
    fail('$ipv6_listen_ip must be a string or array.')
  }
  if !is_integer($ipv6_listen_port) {
    fail('$ipv6_listen_port must be an integer.')
  }
  validate_string($ipv6_listen_options)
  validate_bool($ssl)
  if ($ssl_cert != undef) {
    validate_string($ssl_cert)
  }
  if ($ssl_key != undef) {
    validate_string($ssl_key)
  }
  if ($ssl_port != undef) and (!is_integer($ssl_port)) {
    fail('$ssl_port must be an integer.')
  }
  validate_string($ssl_ciphers)
  if ($ssl_client_cert != undef) {
    validate_string($ssl_client_cert)
  }
  if ($ssl_crl != undef) {
    validate_string($ssl_crl)
  }
  if ($ssl_dhparam != undef) {
    validate_string($ssl_dhparam)
  }
  if ($ssl_ecdh_curve != undef) {
    validate_string($ssl_ecdh_curve)
  }
  validate_string($ssl_protocols)
  if ($ssl_session_cache != undef) {
    validate_string($ssl_session_cache)
  }
  if ($ssl_session_ticket_key != undef) {
    validate_string($ssl_session_ticket_key)
  }
  if ($ssl_session_tickets != undef) {
    validate_string($ssl_session_tickets)
  }
  validate_string($ssl_session_timeout)
  if ($ssl_password_file != undef) {
    validate_string($ssl_password_file)
  }
  if ($ssl_trusted_cert != undef) {
    validate_string($ssl_trusted_cert)
  }
  if ($ssl_verify_depth != undef) and (!is_integer($ssl_verify_depth)) {
    fail('$ssl_verify_depth must be an integer.')
  }
  validate_re($starttls, '^(on|only|off)$',
    "${starttls} is not supported for starttls. Allowed values are 'on', 'only' and 'off'.")
  if ($protocol != undef) {
    validate_string($protocol)
  }
  if ($auth_http != undef) {
    validate_string($auth_http)
  }
  validate_string($xclient)
  if ($imap_auth != undef) {
    validate_string($imap_auth)
  }
  if ($imap_capabilities != undef) {
    validate_array($imap_capabilities)
  }
  if ($imap_client_buffer != undef) {
    validate_string($imap_client_buffer)
  }
  if ($pop3_auth != undef) {
    validate_string($pop3_auth)
  }
  if ($pop3_capabilities != undef) {
    validate_array($pop3_capabilities)
  }
  if ($smtp_auth != undef) {
    validate_string($smtp_auth)
  }
  if ($smtp_capabilities != undef) {
    validate_array($smtp_capabilities)
  }
  validate_string($proxy_pass_error_message)
  validate_array($server_name)

  $config_file = "${::nginx::config::conf_dir}/conf.mail.d/${name}.conf"

  # Add IPv6 Logic Check - Nginx service will not start if ipv6 is enabled
  # and support does not exist for it in the kernel.
  if ($ipv6_enable and !$::ipaddress6) {
    warning('nginx: IPv6 support is not enabled or configured properly')
  }

  # Check to see if SSL Certificates are properly defined.
  if ($ssl or $starttls == 'on' or $starttls == 'only') {
    if ($ssl_cert == undef) or ($ssl_key == undef) {
      fail('nginx: SSL certificate/key (ssl_cert/ssl_cert) and/or SSL Private must be defined and exist on the target system(s)')
    }
  }

  concat { $config_file:
    owner  => 'root',
    group  => $root_group,
    mode   => '0644',
    notify => Class['::nginx::service'],
  }

  if ($listen_port != $ssl_port) {
    concat::fragment { "${name}-header":
      target  => $config_file,
      content => template('nginx/mailhost/mailhost.erb'),
      order   => '001',
    }
  }

  # Create SSL File Stubs if SSL is enabled
  if ($ssl) {
    concat::fragment { "${name}-ssl":
      target  => $config_file,
      content => template('nginx/mailhost/mailhost_ssl.erb'),
      order   => '700',
    }
  }
}
