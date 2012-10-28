# Add a declarative step here for populating the DB with movies.

Given /^the following movies exist:$/ do |movies_table|
  Movie.delete_all
  movies_table.hashes.each do |movie|
    Movie.create :title =>movie['title'],
    :rating =>movie['rating'],
    :release_date =>movie['release_date']
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  assert (page.body.index(e1) < page.body.index(e2)),
  'Sorting was failed'

end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(',').each do |field|
   if uncheck=='un'
    step %{I uncheck "ratings_#{field.strip}"}
   else
    step %{I check "ratings_#{field.strip}"}
   end
  end
end

Then /I should ensure all videos visible/ do 
  assert all("table#movies/tbody tr").count == Movie.find(:all).count,"Something wrong"
end

When /I should ensure that visible only movies with ratings: (.*)/ do |rating_list|
  movies = Movie.find(:all,:conditions => ["rating IN (?)",rating_list.split(', ')])
  assert all("table#movies/tbody tr").count == movies.count,"something wrong"
end
