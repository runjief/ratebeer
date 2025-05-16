FactoryBot.define do
  factory :style do
    name { "MyString" }
    description { "MyText" }
  end

  factory :user do
    username { "Pekka" }
    password { "Foobar1" }
    password_confirmation { "Foobar1" }
  end

  factory :brewery do
    name { "anonymous" }
    year { 1900 }
  end

  factory :beer do
    name { "anonymous" }
    style { "Lager" }
    brewery # the brewery associated with beer is created with brewery factory
  end

  factory :rating do
    score { 10 }
    beer # The beer associated with rating is created with beer factory
    user # The user associated with rating is created with user factory
  end
end
