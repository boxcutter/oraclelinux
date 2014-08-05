#!/bin/bash -eux

# CM and CM_VERSION variables should be set inside of Packer's template:
#
# Values for CM can be:
#   'nocm'            -- build a box without a configuration management tool
#   'chef'            -- build a box with the Chef
#   'chefdk'          -- build a box with the Chef Development Kit
#   'puppet'          -- build a box with the Puppet
#   'pe'              -- build a box with Puppet Enterprise
#
# Values for CM_VERSION can be (when CM is chef|salt|puppet):
#   'x.y.z'           -- build a box with version x.y.z of Chef
#   'x.y'             -- build a box with version x.y of Salt
#   'latest'          -- build a box with the latest version
#
# Set CM_VERSION to 'latest' if unset because it can be problematic
# to set variables in pairs with Packer (and Packer does not support
# multi-value variables).
CM_VERSION=${CM_VERSION:-latest}

#
# CM installs.
#

install_chef()
{
    echo "==> Installing Chef"
    if [[ ${CM_VERSION:-} == 'latest' ]]; then
        echo "==> Installing latest Chef version"
        curl -Lk https://www.opscode.com/chef/install.sh | sh
    else
        echo "==> Installing Chef version ${CM_VERSION}"
        curl -Lk https://www.opscode.com/chef/install.sh | sh -s -- -v ${CM_VERSION}
    fi
}

install_chefdk()
{
    echo "==> Installing Chef Development Kit"
    if [[ ${CM_VERSION:-} == 'latest' ]]; then
        echo "==> Installing latest Chef version"
        curl -Lk https://www.opscode.com/chef/install.sh | sh -s -- -P chefdk
    else
        echo "==> Installing Chef version ${CM_VERSION}"
        curl -Lk https://www.opscode.com/chef/install.sh | sh -s -- -P chefdk -v ${CM_VERSION}
    fi

    echo "==> Adding Chef Development Kit and Ruby to PATH"
    echo 'eval "$(chef shell-init bash)"' >> /home/vagrant/.bash_profile
    chown vagrant /home/vagrant/.bash_profile
}

install_salt()
{
    echo "==> Installing Salt"
    if [[ ${CM_VERSION:-} == 'latest' ]]; then
        echo "==> Installing latest Salt version"
        curl -L http://bootstrap.saltstack.org | sudo sh
    else
        echo "==> Installing Salt version ${CM_VERSION}"
        curl -L http://bootstrap.saltstack.org | sudo sh -s -- git ${CM_VERSION}
    fi
}

install_puppet()
{
    echo "==> Installing Puppet"
    REDHAT_MAJOR_VERSION=$(egrep -Eo 'release ([0-9][0-9.]*)' /etc/redhat-release | cut -f2 -d' ' | cut -f1 -d.)

    echo "==> Installing Puppet Labs repositories"
    rpm -ipv "http://yum.puppetlabs.com/puppetlabs-release-el-${REDHAT_MAJOR_VERSION}.noarch.rpm"

    if [[ ${CM_VERSION:-} == 'latest' ]]; then
        echo "==> Installing latest Puppet version"
        yum -y install puppet
    else
        echo "==> Installing Puppet version ${CM_VERSION}"
        yum -y install "puppet-${CM_VERSION}"
    fi
}

install_puppet_enterprise()
{
  echo "==> Installing Puppet Enterprise"

  if [[ ${CM_VERSION:-} == 'latest' ]]; then
    echo "==> Downloading latest Puppet Enterprise"
    VERSION='3.2.3'
  else
    echo "==> Downloading Puppet Enterprise version ${CM_VERSION}"
    VERSION=$CM_VERSION
  fi

  REDHAT_MAJOR_VERSION=$(egrep -Eo 'release ([0-9][0-9.]*)' /etc/redhat-release | cut -f2 -d' ' | cut -f1 -d.)
  PKGNAME="puppet-enterprise-${VERSION}-el-${REDHAT_MAJOR_VERSION}-x86_64"
  TARFILE="${PKGNAME}.tar.gz"
  URL="https://pm.puppetlabs.com/puppet-enterprise/${VERSION}/${TARFILE}"

  TMPDIR='/tmp'
  HOSTNAME=`hostname`
  cd $TMPDIR
  echo "Fetching ${TARFILE}"
  [ -e $TARFILE ] || curl -fLO $URL
  echo "Extracting ${TARFILE}"
  [ -d $PKGNAME ] || tar -xf $TARFILE
  cd $PKGNAME

  cat > agent.ans <<EOF
q_all_in_one_install=n
q_database_install=n
q_pe_database=n
q_puppetca_install=n
q_puppetdb_install=n
q_puppetmaster_install=n
q_puppet_enterpriseconsole_install=n
q_run_updtvpkg=n
q_continue_or_reenter_master_hostname=c
q_fail_on_unsuccessful_master_lookup=n
q_puppetagent_certname=$HOSTNAME
q_puppetagent_install=y
q_puppetagent_server=puppet
q_puppet_cloud_install=y
q_puppet_symlinks_install=y
q_vendor_packages_install=y
q_install=y
EOF

  ./puppet-enterprise-installer -a agent.ans

  # Cleanup
  cd $TMPDIR && rm $TARFILE && rm -rf $PKGNAME

  # Remove certname so the system will use host FQDN
  sed -i '/certname =/d' /etc/puppetlabs/puppet/puppet.conf

  # Symlink so puppet is in vagrant provisioner PATH
  ln -s /opt/puppet/bin/facter /usr/bin/facter
  ln -s /opt/puppet/bin/puppet /usr/bin/puppet
}

#
# Main script
#

case "${CM}" in
  'chef')
    install_chef
    ;;

  'chefdk')
    install_chefdk
    ;;

  'salt')
    install_salt
    ;;

  'puppet')
    install_puppet
    ;;

  'pe')
    install_puppet_enterprise
    ;;

  *)
    echo "==> Building box without baking in a config management tool"
    ;;
esac
