# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusContent::EntryType do
  it 'has a valid factory' do
    expect(build(:entry_type)).to be_valid
  end

  describe '#content_for' do
    let(:entry_options) { {} }
    let(:entry_type_options) { {} }
    let(:entry_type) { create(:entry_type, provider_name: provider_name) }
    let(:entry) { create(:entry, slug: :example, entry_type: entry_type, options: entry_options) }

    shared_examples :provider do
      it 'calls the content-provider call method' do
        expect(
          SolidusContent.config.providers[provider_name.to_sym]
        ).to receive(:call).with(
          slug: entry.slug,
          type: entry_type.name,
          provider: provider_name,
          options: entry.options.symbolize_keys,
          type_options: entry_type.options.symbolize_keys,
        ).and_return(content)

        entry_type.content_for(entry)
      end
    end

    context 'with the JSON provider' do
      let(:provider_name) { 'json' }
      let(:entry_type_options) { {path: "#{FIXTURES_PATH}/content"} }
      let(:content) { {foo: "bar"} }

      it_behaves_like :provider
    end

    context 'with the RAW provider' do
      let(:provider_name) { 'raw' }
      let(:entry_options) { {foo: "bar"} }
      let(:content) { {foo: "bar"} }

      it_behaves_like :provider
    end

    context 'with the solidus static content provider' do
      let(:provider_name) { 'solidus_static_content' }
      let(:content) { { foo: 'bar' } }

      it_behaves_like :provider
    end

    context 'with the Prismic provider' do
      let(:provider_name) { 'prismic' }
      let(:content) { { foo: 'bar' } }

      it_behaves_like :provider
    end

    context 'with an unknown provider' do
      let(:provider_name) { 'unknown' }

      it 'raises an unknow provider error' do
        expect { entry_type.content_for(entry_options) }
          .to raise_error(SolidusContent::Configuration::UnknownProvider)
      end
    end
  end
end
