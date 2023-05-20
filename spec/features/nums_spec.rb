require 'spec_helper'
require 'rails_helper'

describe '/nums' do
  subject do
    res_page val, key
  end

  def res_page(val, key)
    visit "http://localhost:3000/nums?val=#{val}&idempotency_key=#{key}"

    page
  end

  def rand_key
    rand(36**10).to_s(36)
  end

  let(:val) { nil }
  let(:key) { nil }

  context 'without params' do
    it { expect(subject.body).to eq "0" }
    it { expect(subject.status_code).to eq 200 }
  end

  context 'with params' do
    let(:val) { 5 }
    let(:key) { rand_key }

    it { expect(subject.body).to eq val.to_s }
    it { expect(subject.status_code).to eq 201 }

    context 'one more time' do
      context 'with same params' do
        before { res_page val, key }

        it { expect(page.body).to eq val.to_s }
        it { expect(page.status_code).to eq 200 }
      end

      context 'different params' do
        let(:val2) { 8 }
        let(:key2) { rand_key }

        before { res_page val2, key2 }

        it { expect(page.body).to eq (val + val2).to_s }
        it { expect(page.status_code).to eq 201 }
      end
    end
  end
end
