node default {

  # Installs Elasticsearch
  class { '::elasticsearch': }

  elasticsearch::instance { 'es-01': }

  package { [ 'chromium', 'lightdm', 'openbox', 'gnome-terminal' ]:
    ensure => present,
  }
  # Installs Logstash
  class { '::logstash':
    package_url => 'https://download.elastic.co/logstash/logstash/packages/debian/logstash_1.5.4-1_all.deb',
  }
  logstash::configfile { 'logstash-config-for-geor-logging':
    content => "
      input {
        log4j {
          mode => server
            port => 4712
        }
      }
    filter {
      grok { match => [ \"message\", \"%{COMMONAPACHELOG} (?<time.needed>(%{BASE10NUM}))\" ] }
      mutate {
        convert => {
          \"time.needed\" => \"float\"
            \"response\"    => \"integer\"
            \"bytes\"       => \"integer\"
        }
      }
    }
    output {
      elasticsearch {
      }
    }
    ",
  }

  # kibana4
  class { '::kibana4':
    package_ensure    => '4.1.1-linux-x64',
    package_provider  => 'archive',
    symlink           => false,
    manage_user       => true,
    kibana4_user      => kibana4,
    kibana4_group     => kibana4,
    kibana4_gid       => 200,
    kibana4_uid       => 200,
    elasticsearch_url => 'http://localhost:9200',
  }

  # nginx
  class { '::nginx': }
  nginx::resource::vhost { 'default-vhost':
    ensure               => present,
    proxy                => 'http://localhost:5601/',
  }

}
