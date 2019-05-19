require 'spec_helper'

describe 'prosody' do
  let(:facts) do
    { osfamily: 'SomeOS' }
  end
  context 'on every platform' do
    it { should contain_class 'prosody::package' }
    it { should contain_class 'prosody::config' }
    it { should contain_class 'prosody::service' }

    it { should contain_package('prosody').with(ensure: 'present') }
  end

  context 'with daemonize => true' do
    let(:params) { { daemonize: true } }
    it {
      should contain_service('prosody').with(
        ensure: 'running'
      )
    }
  end

  context 'with daemonize => false' do
    let(:params) { { daemonize: false } }
    it {
      should_not contain_service('prosody').with(
        ensure: 'running'
      )
    }
  end
end
