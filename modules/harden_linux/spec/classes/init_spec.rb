require 'spec_helper'
describe 'harden_linux' do
  context 'with default values for all parameters' do
    it { should contain_class('harden_linux') }
  end
end
