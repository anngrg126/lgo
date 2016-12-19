FactoryGirl.define do
  factory :picture do
    image { Rack::Test::UploadedFile.new(Rails.root + 'spec/fixtures/image.png', 'image/png') }
#    image_file_name {'image.png'}
#    image_content_type {'image/png'}
#    image_file_size { 1024 }
  end
  
  factory :story do
    raw_title { Faker::Hipster.sentence }
    raw_body { Faker::Hipster.paragraph }
    published false
    after(:create) do |story|
      create(:picture, story: story, story_id: story.id )
    end
    user
    
    factory :published_story do
      published true
      final_title { Faker::Hipster.sentence }
      final_body { Faker::Hipster.paragraph }
      admin_published_at { Faker::Time.backward(1, :morning) }
      last_user_to_update { "Admin" }
      main_image { Rack::Test::UploadedFile.new(Rails.root + 'spec/fixtures/mainimage.png', 'image/png') }
    
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
    birthday { Faker::Date.birthday(min_age = 18, max_age = 65) }
    gender {"female"}
    
    factory :admin do
      admin true
    end
    
    factory :anonymous_user do
      email "anonymous@example.com"
      first_name "Brad"
      last_name "The Penguin"
      anonymous true
    end
    
    factory :user_with_unpublished_stories do
      transient do
        stories_count 1
      end
    
      after(:create) do |user, evaluator|
        create_list(:story, evaluator.stories_count, user: user, author_id: user.id)
      end
    end
    
    factory :user_with_unpublished_review_stories do
      transient do
        stories_count 1
      end
    
      after(:create) do |user, evaluator|
        create_list(:story, evaluator.stories_count, user: user, author_id: user.id, review: true)
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
        create_list(:published_anonymous_story, evaluator.stories_count, user: user, author_id: user.id, poster_id: 1)
        #1 is anonymous_user id because that user is created first in the test suite
      end
    end
    
    factory :user_with_unpublished_updated_stories do
      transient do
        stories_count 1
      end
    
      after(:create) do |user, evaluator|
        create_list(:unpublished_updated_story, evaluator.stories_count, author_id: user.id, last_user_to_update: "Author")
      end
    end
    
  end
  
end