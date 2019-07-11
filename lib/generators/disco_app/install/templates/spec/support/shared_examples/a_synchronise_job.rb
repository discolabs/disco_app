RSpec.shared_examples :a_synchronise_job do |model|
  subject(:job) { described_class.perform_later(shop, data) }

  let(:shop) { create(:shop) }
  let(:data) { 'data' }

  it "synchronises #{model}" do
    expect(model).to receive(:synchronise).with(shop, data, any_args)

    perform_enqueued_jobs { job }
  end
end
