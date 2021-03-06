# Oracle XE 11g on Ubuntu 12.04 using Vagrant

This project enables you to install Oracle 11g XE in a virtual machine running Ubuntu 12.04, using
[Vagrant] and [Puppet].

## Acknowledgements

This project was created based on the information in
[Installing Oracle 11g R2 Express Edition on Ubuntu 64-bit] by Manish Raj, and the GitHub repository
[vagrant-oracle-xe] by Stefan Glase. The former explains how to install Oracle XE 11g on Ubuntu
12.04, without explicitly providing a Vagrant or provisioner configuration. The latter has the same
purpose as this project but uses Ubuntu 11.10.

Thanks to André Kelpe, Brandon Gresham, Charles Walker, Chris Thompson, Jeff Caddel, Joe FitzGerald,
Justin Harringa, Mark Crossfield, Matthew Buckett, Richard Kolb, and Steven Hsu for various
contributions.

## Requirements

* You need to have [Vagrant] installed.
* The host machine probably needs at least 4 GB of RAM (I have only tested 8 GB of RAM).
* As Oracle 11g XE is only available for 64-bit machines at the moment, the host machine needs to
  have a 64-bit architecture.
* You may need to [enable virtualization] manually.

## Installation

* Check out this project:

        git clone https://github.com/rponte/vagrant-ubuntu-oracle-xe.git

* Install [vbguest]:

        vagrant plugin install vagrant-vbguest

* Install [[vagrant-proxyconf](https://github.com/tmatilai/vagrant-proxyconf)]:

        vagrant plugin install vagrant-proxyconf

* To configure all possible software on all Vagrant VMs, add the following to `$HOME/.vagrant.d/Vagrantfile` (or to a project specific `Vagrantfile`):

```ruby
Vagrant.configure("2") do |config|
  if Vagrant.has_plugin?("vagrant-proxyconf")
    config.proxy.http     = "http://mdbpx.mdb.com.br:8090"
    config.proxy.https    = "http://mdbpx.mdb.com.br:8090"
    config.proxy.no_proxy = "localhost,127.0.0.1,.example.com"
  end
  # ... other stuff
end
```

* Download [Oracle Database 11g Express Edition] for Linux x64. Place the file
  `oracle-xe-11.2.0-1.0.x86_64.rpm.zip` in the directory `modules/oracle/files` of this
  project. (Alternatively, you could keep the zip file in some other location and make a hard link
  to it from `modules/oracle/files`.)

* Run `vagrant up` from the base directory of this project. The first time this will take a while -- up to 30 minutes on
  my machine. Please note that building the VM involves downloading an Ubuntu 12.04
  [base box](http://docs.vagrantup.com/v2/boxes.html) which is 323MB in size.

These steps are also shown in an [asciicast] made by Daekwon Kang:

[![asciicast](https://asciinema.org/a/8438.png)](https://asciinema.org/a/8438)

## Connecting

You should now be able to
[connect](http://www.oracle.com/technetwork/developer-tools/sql-developer/downloads/index.html) to
the new database at `localhost:1521/XE` as `system` with password `manager`. For example, if you
have `sqlplus` installed on the host machine you can do

    sqlplus system/manager@//localhost:1521/XE

To make sqlplus behave like other tools (history, arrow keys etc.) you can do this:

    rlwrap sqlplus system/manager@//localhost:1521/XE

You might need to add an entry to your `tnsnames.ora` file first:

    XE =
      (DESCRIPTION =
        (ADDRESS = (PROTOCOL = TCP)(HOST = 127.0.0.1)(PORT = 1521))
        (CONNECT_DATA =
          (SERVER = DEDICATED)
          (SERVICE_NAME = XE)
        )
      )

## Troubleshooting

### Errors when Unzipping

If you get an error containing `/usr/bin/unzip -o oracle-xe-11.2.0-1.0.x86_64.rpm.zip returned 2` during `vagrant up`, then the zip file you have downloaded is probably corrupted. This can be fixed by re-downloading, replacing the corrupted file, and running `vagrant reload --provision`.

### Memory

It is important to assign enough memory to the virtual machine, otherwise you will get an error

    ORA-00845: MEMORY_TARGET not supported on this system

during the configuration stage. In the `Vagrantfile` 512 MB is assigned. Lower values may also work,
as long as (I believe) 2 GB of virtual memory is available for Oracle, swap is included in this
calculation.

### Concurrent Connections

If you want to raise the limit of the number of concurrent connections, say to 200, then according
to [How many connections can Oracle Express Edition (XE) handle?] you should run

    ALTER SYSTEM SET processes=200 scope=spfile

and restart the database.

## Alternatives

You may also want to consider a Docker-based solution such as
[docker-oracle-xe-11g](https://github.com/alexei-led/docker-oracle-xe-11g).

[Vagrant]: http://www.vagrantup.com/

[Puppet]: http://puppetlabs.com/

[Oracle Database 11g Express Edition]: http://www.oracle.com/technetwork/database/database-technologies/express-edition/downloads/index.html

[Oracle Database 11g EE Documentation]: http://docs.oracle.com/cd/E17781_01/index.htm

[Installing Oracle 11g R2 Express Edition on Ubuntu 64-bit]: http://meandmyubuntulinux.blogspot.co.uk/2012/05/installing-oracle-11g-r2-express.html

[vagrant-oracle-xe]: https://github.com/codescape/vagrant-oracle-xe

[vbguest]: https://github.com/dotless-de/vagrant-vbguest

[asciicast]: https://asciinema.org/a/8438

[How many connections can Oracle Express Edition (XE) handle?]: http://stackoverflow.com/questions/906541/how-many-connections-can-oracle-express-edition-xe-handle

[enable virtualization]: http://www.sysprobs.com/disable-enable-virtualization-technology-bios
