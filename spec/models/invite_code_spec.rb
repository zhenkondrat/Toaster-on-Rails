require 'spec_helper'

describe InviteCode do

  let(:invite_code) { InviteCode.new }

  describe 'validates' do
    it { expect(invite_code).to validate_presence_of(:token) }
    it { expect(invite_code).to validate_uniqueness_of(:token) }
    it { expect(invite_code).to validate_uniqueness_of(:role) }
    it { expect(invite_code).to validate_uniqueness_of(:role) }
  end

  describe '#generate!' do
    it 'gives the result: array of tokens' do
      result = InviteCode.generate!
      puts result[:admin]
      puts result[:teacher]
      puts result[:user]
      expect(result.class).to eq Hash
    end

    it 'gives the result: array of two tokens' do
      result = InviteCode.generate!
      puts result[:admin]
      puts result[:teacher]
      puts result[:user]
      expect(result.size).to eq 3
    end

    it 'gives the result: array of two different tokens' do
      result = InviteCode.generate!
      puts result[:admin]
      puts result[:teacher]
      puts result[:user]
      expect(result[:admin]).not_to eq result[:user]
      expect(result[:admin]).not_to eq result[:teacher]
      expect(result[:user]).not_to eq result[:teacher]
    end

    it 'gives the result: array of two tokens that is not = previous' do
      old_tokens = InviteCode.generate!
      new_tokens = InviteCode.generate!
      expect(old_tokens).not_to eq new_tokens
    end

    it %q|return fail if it didn't successfully generate token| do
      expect_any_instance_of(ActiveModel::Errors).to receive(:empty?).exactly(3).times.and_return(false)
      expect{ InviteCode.generate! }.to raise_error(%q|Can't generate token|)
    end
  end

  describe '#get' do
    it 'should give new tokens if there are not have tokens yet' do
      InviteCode.delete_all
      expect(InviteCode.get.size).to eq 3
    end

    it 'should give local tokens' do
      expect(InviteCode.get).to eq InviteCode.get
    end
  end
end
