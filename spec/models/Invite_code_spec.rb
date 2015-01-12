require 'spec_helper'

describe InviteCode do

  describe 'validates' do
    it { expect(InviteCode.new).to validate_presence_of(:token) }
    it { expect(InviteCode.new).to validate_presence_of(:date) }
    it { expect(InviteCode.new).to validate_uniqueness_of(:token) }
  end

  describe '#generate!' do
    it 'gives the result: array of tokens' do
      result = InviteCode.generate!
      puts result[:admin]
      puts result[:user]
      expect(result.class).to eq Hash
    end

    it 'gives the result: array of two tokens' do
      result = InviteCode.generate!
      puts result[:admin]
      puts result[:user]
      expect(result.size).to eq 2
    end

    it 'gives the result: array of two different tokens' do
      result = InviteCode.generate!
      puts result[:admin]
      puts result[:user]
      expect(result[:admin]).not_to eq result[:user]
    end

    it 'gives the result: array of two tokens that is not = previous' do
      old_tokens = InviteCode.generate!
      new_tokens = InviteCode.generate!
      expect(old_tokens).not_to eq new_tokens
    end
  end

  describe '#local' do
    it 'should give new tokens if there are not have tokens yet' do
      InviteCode.delete_all
      expect(InviteCode.local.size).to eq 2
    end

    it 'should give local tokens' do
      expect(InviteCode.local).to eq InviteCode.local
    end
  end

end