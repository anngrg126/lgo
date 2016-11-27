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

Tag.create([
{  tag_category_id: 1 , name: 'family' },
{  tag_category_id: 1 , name: 'parents' },
{  tag_category_id: 1 , name: 'siblings' },
{  tag_category_id: 1 , name: 'friends' },
{  tag_category_id: 1 , name: 'i_just_met_you' },
{  tag_category_id: 1 , name: 'kids' },
{  tag_category_id: 1 , name: 'professional' },
{  tag_category_id: 1 , name: 'significant_other' },
{  tag_category_id: 1 , name: 'so_family' },
{  tag_category_id: 5 , name: 'girlfriend_parents' },
{  tag_category_id: 5 , name: 'girlfriend_family' },
{  tag_category_id: 5 , name: 'boyfriend_parents' },
{  tag_category_id: 5 , name: 'boyfriend_family' },
{  tag_category_id: 5 , name: 'in_laws' },
{  tag_category_id: 5 , name: 'father_in_law' },
{  tag_category_id: 5 , name: 'mother_in_law' },
{  tag_category_id: 5 , name: 'brother_in_law' },
{  tag_category_id: 5 , name: 'sister_in_law' },
{  tag_category_id: 5 , name: 'family_in_law' },
{  tag_category_id: 5 , name: 'friend' },
{  tag_category_id: 5 , name: 'sister' },
{  tag_category_id: 5 , name: 'brother' },
{  tag_category_id: 5 , name: 'mother' },
{  tag_category_id: 5 , name: 'father' },
{  tag_category_id: 5 , name: 'aunt' },
{  tag_category_id: 5 , name: 'uncle' },
{  tag_category_id: 5 , name: 'girlfriend' },
{  tag_category_id: 5 , name: 'boyfriend' },
{  tag_category_id: 5 , name: 'wife' },
{  tag_category_id: 5 , name: 'husband' },
{  tag_category_id: 5 , name: 'fiance' },
{  tag_category_id: 5 , name: 'niece' },
{  tag_category_id: 5 , name: 'nephew' },
{  tag_category_id: 5 , name: 'teacher' },
{  tag_category_id: 5 , name: 'boss' },
{  tag_category_id: 5 , name: 'colleagues' },
{  tag_category_id: 5 , name: 'employees' },
{  tag_category_id: 5 , name: 'team' },
{  tag_category_id: 5 , name: 'wedding_party' },
{  tag_category_id: 5 , name: 'bridesmaids' },
{  tag_category_id: 5 , name: 'groomsmen' },
{  tag_category_id: 5 , name: 'maid_of_honor' },
{  tag_category_id: 5 , name: 'best_man' },
{  tag_category_id: 5 , name: 'other' },
{  tag_category_id: 2 , name: 'anniversary' },
{  tag_category_id: 2 , name: 'birthday' },
{  tag_category_id: 2 , name: 'engagement' },
{  tag_category_id: 2 , name: 'fathers_day' },
{  tag_category_id: 2 , name: 'going_away' },
{  tag_category_id: 2 , name: 'graduation' },
{  tag_category_id: 2 , name: 'holidays' },
{  tag_category_id: 2 , name: 'christmas' },
{  tag_category_id: 2 , name: 'hanukkah' },
{  tag_category_id: 2 , name: 'just_because' },
{  tag_category_id: 2 , name: 'ramadan' },
{  tag_category_id: 2 , name: 'travel_souvenir' },
{  tag_category_id: 2 , name: 'mothers_day' },
{  tag_category_id: 2 , name: 'congratulations' },
{  tag_category_id: 2 , name: 'i_love_you' },
{  tag_category_id: 2 , name: 'i_miss_you' },
{  tag_category_id: 2 , name: 'sorry' },
{  tag_category_id: 2 , name: 'thank_you' },
{  tag_category_id: 2 , name: 'you_can_do_it' },
{  tag_category_id: 2 , name: 'showers' },
{  tag_category_id: 2 , name: 'bridal_shower' },
{  tag_category_id: 2 , name: 'baby_shower' },
{  tag_category_id: 2 , name: 'new_baby' },
{  tag_category_id: 2 , name: 'valentines_day' },
{  tag_category_id: 2 , name: 'visits_parties' },
{  tag_category_id: 2 , name: 'housewarming' },
{  tag_category_id: 2 , name: 'wedding' },
{  tag_category_id: 3 , name: 'diy' },
{  tag_category_id: 3 , name: 'budget' },
{  tag_category_id: 3 , name: 'experience' },
{  tag_category_id: 3 , name: 'fun' },
{  tag_category_id: 3 , name: 'group' },
{  tag_category_id: 3 , name: 'last_minute' },
{  tag_category_id: 3 , name: 'plan_in_advance' },
{  tag_category_id: 3 , name: 'personalized' },
{  tag_category_id: 3 , name: 'romantic' },
{  tag_category_id: 3 , name: 'sentimental' },
{  tag_category_id: 3 , name: 'surprise' },
{  tag_category_id: 3 , name: 'thoughtful' },
{  tag_category_id: 6 , name: 'aww' },
{  tag_category_id: 6 , name: 'lol' },
{  tag_category_id: 6 , name: 'win' },
{  tag_category_id: 4 , name: 'hobbies' },
{  tag_category_id: 4 , name: 'crafts' },
{  tag_category_id: 4 , name: 'reading' },
{  tag_category_id: 4 , name: 'cooking' },
{  tag_category_id: 4 , name: 'food' },
{  tag_category_id: 4 , name: 'pop culture' },
{  tag_category_id: 4 , name: 'health_fitness' },
{  tag_category_id: 4 , name: 'travel_adventure' },
{  tag_category_id: 4 , name: 'sports' },
{  tag_category_id: 4 , name: 'other' },
{  tag_category_id: 7 , name: 'engagement_stories' },
{  tag_category_id: 7 , name: 'gifts_that_keep_on_giving' },
{  tag_category_id: 7 , name: 'travel_gifts' },
{  tag_category_id: 7 , name: 'gifts_that_start_traditions' },
{  tag_category_id: 7 , name: 'white_elephant' },
{  tag_category_id: 7 , name: 'holidays_with_kids' },
{  tag_category_id: 7 , name: 'all_in_the_presentation' },
{  tag_category_id: 7 , name: 'other' }
  ])
