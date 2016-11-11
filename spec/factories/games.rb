FactoryGirl.define do
  factory :game do
    after(:create) do |instance|
      create_list :game_frames, 10, frame: instance
    end
  end
end
