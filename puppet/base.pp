
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

node default {
    import "build.pp"
    class {'build_depends':}
    class {'ntp':}
    class {'apt':}
    class {'apt::unattended-upgrade::automatic':}
    import "test_vm.pp"
}

