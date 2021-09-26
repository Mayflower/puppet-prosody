require 'spec_helper'

describe 'prosody' do
  on_supported_os.each do |os, os_facts|
    context "on os #{os}" do
      let(:facts) do
        os_facts
      end


      context 'on every platform' do
        it { is_expected.to contain_class 'prosody::package' }
        it { is_expected.to contain_class 'prosody::config' }
        it { is_expected.to contain_class 'prosody::service' }

        it { is_expected.to contain_package('prosody').with(ensure: 'present') }
        it {
          config_directory = case facts[:osfamily]
                             when 'Gentoo' then '/etc/jabber'
                             else '/etc/prosody'
                             end
          is_expected.to contain_file("#{config_directory}/conf.a'ail").with(ensure: 'directory')
        }
        it {
          config_directory = case facts[:osfamily]
                             when 'Gentoo' then '/etc/jabber'
                             else '/etc/prosody'
                             end
          is_expected.to contain_file("#{config_directory}/conf.d").with(ensure: 'directory')
        }
      end

      context 'with daemonize => true' do
        let(:params) { { daemonize: true } }

        it {
          is_expected.to contain_service('prosody').with(
            ensure: 'running'
          )
        }
      end

      context 'with daemonize => false' do
        let(:params) { { daemonize: false } }

        it {
          is_expected.not_to contain_service('prosody').with(
            ensure: 'running'
          )
        }
      end

      context 'with custom options' do
        let(:params) { { custom_options: { 'foo' => 'bar', 'baz' => 'quux' } } }

        it {
          config_directory = case facts[:osfamily]
                             when 'Gentoo' then '/etc/jabber'
                             else '/etc/prosody'
                             end
          is_expected.to contain_file("#{config_directory}/prosody.cfg.lua"). \
            with_content(%r{^foo = "bar"$}, %r{^baz = "quux"$})
        }
      end

      context 'with deeply nested custom options' do
        let(:params) { { custom_options: { 'foo' => { 'fnord' => '23', 'xyzzy' => '42' }, 'bar' => %w[cool elements], 'baz' => 'quux' } } }

        it {
          config_directory = case facts[:osfamily]
                             when 'Gentoo' then '/etc/jabber'
                             else '/etc/prosody'
                             end
          is_expected.to contain_file("#{config_directory}/prosody.cfg.lua"). \
            with_content(%r{^foo = {\n  fnord = "23";\n  xyzzy = "42";\n}$}, %r{^baz = "quux"$}, %r{^bar = [ "cool"; "elements" ]$})
        }
      end
    end
  end
end
