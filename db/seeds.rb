# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

ReactionCategory.create([
  { name: 'like' }, 
  { name: 'omg' },
  { name: 'lol' },
  { name: 'cool' },
  { name: 'love' }
])

NotificationCategory.create([
  { name: 'Story' }, 
  { name: 'Comment' },
  { name: 'Reaction' },
  { name: 'Bookmark' },
  { name: 'Following' }
])

TagCategory.create([
  { category: 'Relationship' }, 
  { category: 'Occasion' },
  { category: 'Type' },
  { category: 'Interests' },
  { category: 'To_recipient' },
  { category: 'Gifton_reaction' },
  { category: 'Collection' }
])

relationship_category = TagCategory.find_by(category: 'Relationship')
occasion_category = TagCategory.find_by(category: 'Occasion')
type_category = TagCategory.find_by(category: 'Type')
interests_category = TagCategory.find_by(category: 'Interests')
recipient_category = TagCategory.find_by(category: 'To_recipient')
reaction_category = TagCategory.find_by(category: 'Gifton_reaction')
collection_category = TagCategory.find_by(category: 'Collection')

Tag.create([
{  tag_category_id: relationship_category.id , name: 'family' },
{  tag_category_id: relationship_category.id , name: 'parents' },
{  tag_category_id: relationship_category.id , name: 'siblings' },
{  tag_category_id: relationship_category.id , name: 'friends' },
{  tag_category_id: relationship_category.id , name: 'i_just_met_you' },
{  tag_category_id: relationship_category.id , name: 'kids' },
{  tag_category_id: relationship_category.id , name: 'professional' },
{  tag_category_id: relationship_category.id , name: 'significant_other' },
{  tag_category_id: relationship_category.id , name: 'so_family' },
{  tag_category_id: recipient_category.id , name: "girlfriend's parents" },
{  tag_category_id: recipient_category.id , name: "girlfriend's family" },
{  tag_category_id: recipient_category.id , name: "boyfriend's parents" },
{  tag_category_id: recipient_category.id , name: "boyfriend's family" },
{  tag_category_id: recipient_category.id , name: 'in-laws' },
{  tag_category_id: recipient_category.id , name: 'father-in-law' },
{  tag_category_id: recipient_category.id , name: 'mother-in-law' },
{  tag_category_id: recipient_category.id , name: 'brother-in-law' },
{  tag_category_id: recipient_category.id , name: 'sister-in-law' },
{  tag_category_id: recipient_category.id , name: 'family_in_law' },
{  tag_category_id: recipient_category.id , name: 'friend' },
{  tag_category_id: recipient_category.id , name: 'sister' },
{  tag_category_id: recipient_category.id , name: 'brother' },
{  tag_category_id: recipient_category.id , name: 'mother' },
{  tag_category_id: recipient_category.id , name: 'father' },
{  tag_category_id: recipient_category.id , name: 'aunt' },
{  tag_category_id: recipient_category.id , name: 'uncle' },
{  tag_category_id: recipient_category.id , name: 'girlfriend' },
{  tag_category_id: 
  , name: 'boyfriend' },
{  tag_category_id: recipient_category.id , name: 'wife' },
{  tag_category_id: recipient_category.id , name: 'husband' },
{  tag_category_id: recipient_category.id , name: 'fiance' },
{  tag_category_id: recipient_category.id , name: 'niece' },
{  tag_category_id: recipient_category.id , name: 'nephew' },
{  tag_category_id: recipient_category.id , name: 'teacher' },
{  tag_category_id: recipient_category.id , name: 'boss' },
{  tag_category_id: recipient_category.id , name: 'colleagues' },
{  tag_category_id: recipient_category.id , name: 'colleague' },
{  tag_category_id: recipient_category.id , name: 'employees' },
{  tag_category_id: recipient_category.id , name: 'team' },
{  tag_category_id: recipient_category.id , name: 'wedding party' },
{  tag_category_id: recipient_category.id , name: 'bridesmaids' },
{  tag_category_id: recipient_category.id , name: 'groomsmen' },
{  tag_category_id: recipient_category.id , name: 'maid of honor' },
{  tag_category_id: recipient_category.id , name: 'best man' },
{  tag_category_id: recipient_category.id , name: 'other' },
{  tag_category_id: occasion_category.id , name: 'anniversary' },
{  tag_category_id: occasion_category.id , name: 'birthday' },
{  tag_category_id: occasion_category.id , name: 'engagement' },
{  tag_category_id: occasion_category.id , name: "father's day" },
{  tag_category_id: occasion_category.id , name: 'going_away' },
{  tag_category_id: occasion_category.id , name: 'graduation' },
{  tag_category_id: occasion_category.id , name: 'holidays' },
{  tag_category_id: occasion_category.id , name: 'christmas' },
{  tag_category_id: occasion_category.id , name: 'hanukkah' },
{  tag_category_id: occasion_category.id , name: 'just_because' },
{  tag_category_id: occasion_category.id , name: 'ramadan' },
{  tag_category_id: occasion_category.id , name: 'travel_souvenir' },
{  tag_category_id: occasion_category.id , name: "mother's day" },
{  tag_category_id: occasion_category.id , name: 'congratulations' },
{  tag_category_id: occasion_category.id , name: 'i_love_you' },
{  tag_category_id: occasion_category.id , name: 'i_miss_you' },
{  tag_category_id: occasion_category.id , name: 'sorry' },
{  tag_category_id: occasion_category.id , name: 'thank_you' },
{  tag_category_id: occasion_category.id , name: 'you_can_do_it' },
{  tag_category_id: occasion_category.id , name: 'showers' },
{  tag_category_id: occasion_category.id , name: 'bridal_shower' },
{  tag_category_id: occasion_category.id , name: 'baby_shower' },
{  tag_category_id: occasion_category.id , name: 'new_baby' },
{  tag_category_id: occasion_category.id , name: "valentine's day" },
{  tag_category_id: occasion_category.id , name: 'visits & parties' },
{  tag_category_id: occasion_category.id , name: 'housewarming' },
{  tag_category_id: occasion_category.id , name: 'wedding' },
{  tag_category_id: occasion_category.id , name: 'other' },
{  tag_category_id: 
  , name: 'diy' },
{  tag_category_id: type_category.id , name: 'budget' },
{  tag_category_id: type_category.id , name: 'experience' },
{  tag_category_id: type_category.id , name: 'fun' },
{  tag_category_id: type_category.id , name: 'group' },
{  tag_category_id: type_category.id , name: 'last_minute' },
{  tag_category_id: type_category.id , name: 'plan_in_advance' },
{  tag_category_id: type_category.id , name: 'personalized' },
{  tag_category_id: type_category.id , name: 'romantic' },
{  tag_category_id: type_category.id , name: 'sentimental' },
{  tag_category_id: type_category.id , name: 'surprise' },
{  tag_category_id: type_category.id , name: 'thoughtful' },
{  tag_category_id: type_category.id , name: 'other' },
{  tag_category_id: reaction_category.id , name: 'aww' },
{  tag_category_id: reaction_category.id , name: 'lol' },
{  tag_category_id: reaction_category.id , name: 'win' },
{  tag_category_id: interests_category.id , name: 'hobbies' },
{  tag_category_id: interests_category.id , name: 'crafts' },
{  tag_category_id: interests_category.id , name: 'reading' },
{  tag_category_id: interests_category.id , name: 'cooking' },
{  tag_category_id: interests_category.id , name: 'food' },
{  tag_category_id: interests_category.id , name: 'pop culture' },
{  tag_category_id: interests_category.id , name: 'health_fitness' },
{  tag_category_id: interests_category.id , name: 'travel_adventure' },
{  tag_category_id: interests_category.id , name: 'sports' },
{  tag_category_id: interests_category.id , name: 'other' },
{  tag_category_id: 
  , name: 'engagement_stories' },
{  tag_category_id: collection_category.id , name: 'gifts_that_keep_on_giving' },
{  tag_category_id: collection_category.id , name: 'travel_gifts' },
{  tag_category_id: collection_category.id , name: 'gifts_that_start_traditions' },
{  tag_category_id: collection_category.id , name: 'white_elephant' },
{  tag_category_id: collection_category.id , name: 'holidays_with_kids' },
{  tag_category_id: collection_category.id , name: 'all_in_the_presentation' },
{  tag_category_id: collection_category.id , name: 'other' }
  ])
