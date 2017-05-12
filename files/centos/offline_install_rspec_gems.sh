#!/bin/sh

CACHEDIR=/var/cache/rubygems
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
