require_relative 'spec_helper'

describe 'box' do
  it 'should have a root user' do
    expect(user 'root').to exist
  end

  it 'should disable SELinux' do
    expect(selinux).to be_disabled
  end
end
