require 'spec_helper'
describe 'lampman' do
  context 'with default values for all parameters' do
    it { should contain_class('lampman') }
  end
end
