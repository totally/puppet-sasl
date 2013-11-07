class sasl(
    $mechanisms = hiera('sasl_mechanisms', $sasl::params::mechanisms),
    $ldap_server= hiera('ldap_server',    $sasl::params::ldap_server),
    $ldap_ou    = hiera('ldap_ou',        $sasl::params::ldap_ou),
    $ldap_org   = hiera('ldap_org',       $sasl::params::ldap_org),
    $ldap_dom   = hiera('ldap_dom',       $sasl::params::ldap_dom),
    $ldap_filter= hiera('ldap_filter',    $sasl::params::ldap_filter),

) inherits sasl::params {
    package { ['libsasl2-dev','sasl2-bin']:
        ensure  => installed,
    } -> 
    file {'/etc/saslauthd.conf':
        ensure  => file,
        owner   => root, 
        group   => root,
        content => template('sasl/saslauthd.conf.erb'),
        notify  => Service['saslauthd'],
    } ->
    file {'/etc/default/saslauthd':
        ensure  => file,
        owner   => root, 
        group   => root,
        content => template('sasl/etc/default/saslauthd.erb'),
        notify  => Service['saslauthd'],
    } ->
    service {'saslauthd':
        ensure  => running,
    }
}
