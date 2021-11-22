require 'spec_helper'

describe 'prosody::service' do
  let(:pre_condition) { 'include prosody' }

  shared_examples 'prosody::service with defaults' do
    it {
      if facts[:os]['family'] == 'Debian'
        if facts[:os]['name'] == 'Debian'
          is_expected.not_to contain_service('prosody')
        else
          is_expected.to contain_service('prosody')
            .with_ensure('running')
            .with_enable(true)
            .without_hasstatus
            .without_restart
        end

      elsif facts[:os]['family'] == 'OpenBSD'
        is_expected.not_to contain_service('prosody')
          .with_ensure('running')
          .with_enable(true)
          .without_hasstatus
          .without_restart
      else
        is_expected.to contain_service('prosody')
          .with_ensure('running')
          .with_hasstatus(false)
          .with_restart('/usr/bin/prosodyctl reload')
      end
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on os #{os}" do
      let(:facts) do
        os_facts
      end

      context 'with defaults' do
        let(:pre_condition) { 'class {"prosody": }' }

        it_behaves_like 'prosody::service with defaults'
      end
    end
  end
end
