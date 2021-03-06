# frozen_string_literal: true

FactoryBot.define do
  factory :entry_type, class: SolidusContent::EntryType do
    sequence(:name) { |n| "entry_type_#{n}" }
  end

  factory :entry, class: SolidusContent::Entry do
    entry_type
  end
end
