FactoryGirl.define do  
  
  factory :story do
    raw_title { Faker::Hipster.sentence }
    raw_body { Faker::Hipster.paragraph }
#    image Rack::Test::UploadedFile.new(Rails.root + 'spec/fixtures/image.png', 'image/png')
    image { fixture_file_upload( File.join(Rails.root, 'spec', 'fixtures', 'image.png'), 'image/png') }
    user
    
    factory :published_story do
      published true
      final_title { Faker::Hipster.sentence }
      final_body { Faker::Hipster.paragraph }
      admin_updated_at {Faker::Time.backward(1, :morning)}
      main_image { fixture_file_upload( File.join(Rails.root, 'spec', 'fixtures', 'mainimage.png'), 'image/png') }
    
      factory :unpublished_updated_story do
        published false
        updated_title { Faker::Hipster.sentence }
        updated_body { Faker::Hipster.paragraph }
#        updated_at {Faker::Time.forward(1, :afternoon)}
      end
      
      factory :published_anonymous_story do
        anonymous true
      end
    end
  end

  factory :user, aliases: [:author, :poster] do
    email {Faker::Internet.email }
    password { Faker::Internet.password }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    about_me { Faker::Hipster.sentence }
    
    factory :admin do
      admin true
    end
    
    factory :anonymous_user do
      email "anonymous@example.com"
      first_name "Brad"
      last_name "The Penguin"
      id 1000
    end
    
    factory :user_with_unpublished_stories do
      transient do
        stories_count 1
      end
    
      after(:create) do |user, evaluator|
        create_list(:story, evaluator.stories_count, user: user, author_id: user.id)
      end
    end
    
    factory :user_with_published_stories do
      transient do
        stories_count 1
      end
    
      after(:create) do |user, evaluator|
        create_list(:published_story, evaluator.stories_count, user: user, author_id: user.id, poster_id: user.id)
      end
    end
    
    factory :user_with_published_anonymous_stories do
      transient do
        stories_count 1
      end
    
      after(:create) do |user, evaluator|
        create_list(:published_anonymous_story, evaluator.stories_count, user: user, author_id: user.id, poster_id: 1000)
      end
    end
    
    factory :user_with_unpublished_updated_stories do
      transient do
        stories_count 1
      end
    
      after(:create) do |user, evaluator|
        create_list(:unpublished_updated_story, evaluator.stories_count, author_id: user.id)
      end
    end
    
  end
  
end