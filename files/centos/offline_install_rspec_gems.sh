#!/bin/sh

CACHEDIR=/var/cache/rubygems/gems
RSPEC_PUPPET_GEMS='diff-lcs rspec-support rspec-mocks rspec-expectations rspec-core rspec rspec-puppet'
PSH_GEMS='metaclass mocha puppet-syntax puppet-lint puppetlabs_spec_helper'
SERVERSPEC_GEMS='sfl net-telnet net-scp specinfra multi_json rspec-its serverspec'

# Install the rspec-puppet gems in the proper order
for GEM in ${RSPEC_PUPPET_GEMS}; do
  /opt/puppetlabs/puppet/bin/gem install -l ${CACHEDIR}/${GEM}*.gem
done

# Install the puppetlabs_spec_helper gems in the proper order
for GEM in ${PSH_GEMS}; do
  /opt/puppetlabs/puppet/bin/gem install -l ${CACHEDIR}/${GEM}*.gem
done

# Install the serverspec gems in the proper order
for GEM in ${SERVERSPEC_GEMS}; do
  /opt/puppetlabs/puppet/bin/gem install -l ${CACHEDIR}/${GEM}*.gem
done

# Link the serverspec-init binary to /usr/local/bin so it's easier to
# access and fits better with the student exercise notes. Ideally, it's
# installed with the system `gem` command, but we're installing it with
# the Puppet-vendored `gem` command in order to cut down on the number of
# additional deps needed to install with the system `gem` command.
ln -s /opt/puppetlabs/puppet/bin/serverspec-init /usr/local/bin
