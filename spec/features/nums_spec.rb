require 'spec_helper'
require 'rails_helper'

describe '/nums' do
  subject do
    res_page val, idempotency_key
  end

  def res_page(val, idempotency_key)
    visit "/nums?val=#{val}&idempotency_key=#{idempotency_key}"

    page
  end

  def rand_key
    rand(36**10).to_s(36)
  end

  let(:val) { nil }
  let(:idempotency_key) { nil }

  context 'without params' do
    it { expect(subject.body).to eq "0" }
    it { expect(subject.status_code).to eq 200 }
  end

  context 'with params' do
    let(:val) { 5 }
    let(:idempotency_key) { rand_key }

    it { expect(subject.body).to eq val.to_s }
    it { expect(subject.status_code).to eq 201 }

    context 'one more time' do
      context 'with same params' do
        before { res_page val, idempotency_key }

        it { expect(subject.body).to eq val.to_s }
        it { expect(subject.status_code).to eq 200 }

      end

      context 'different params' do
        let(:val2) { 8 }
        let(:key2) { rand_key }

        before { res_page val2, key2 }

        it { expect(subject.body).to eq (val + val2).to_s }
        it { expect(subject.status_code).to eq 201 }
      end
    end

    context 'parallel running with same params' do
      it 'store value once' do
        expect do
          threads = 4.times.map do
            Thread.new { res_page(val, idempotency_key).body }
          end

          threads.map(&:join).map(&:value)
        end
          .to change(Num, :count).by 1
      end
    end
  end
end
