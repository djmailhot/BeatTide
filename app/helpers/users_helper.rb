# Author:: Harnoor Singh
module UsersHelper

  def sort(users, query)
    if(users.empty?)
      Array.new
    else
      # results = Array.new
      results = Hash.new
      max = users.length() - 1

      # Iterate over each user found and compute the edit distance to the query
      (0..max).each do |i|
        minDistance = editDistance(users[i], query)
        # If there are already 10 results 
        results[users[i]] = editDistance(users[i], query)
      end
      twoDResults = results.sort {|a,b| a[1] <=> b[1]}
      logger.info(results)
      sortedResults = Array.new
      twoDResults.each do |user, count| 
        sortedResults << user
      end
      sortedResults
    end
  end


private

  # Takes a user and a search query.  Compares the search query to the users name
  # and returns the edit difference
  def editDistance(user, query)
    a = calculateEditDistance(query, user.first_name, 0, 0, false)
    b = calculateEditDistance(query, user.last_name, 0, 0, false)
    c = calculateEditDistance(query, user.username, 0, 0, false)
    logger.info("User: " + user.username + " Min: " + min(a, b, c).to_s + ", " + a.to_s)
    return min(a, b, c)
  end


  # Return the min of three values
  def min(a, b, c)
    [a,b,c].min
  end

  def calculateEditDistance(query, name, indexQuery, indexName, match)
    # If we are at the end of both words
    if indexQuery == query.length && indexName == name.length
      return 0 + multiplier(match)
    # If we are the end of the query
    elsif indexQuery == query.length
      return multiplier(match) + name.length - indexName
    # If we are at the end of the name
    elsif indexName == name.length
      return multiplier(match) + query.length - indexQuery
    # If the letters match, change match to true to indicate we found at least one matching letter
    elsif query[indexQuery].casecmp(name[indexName]) == 0
      logger.info(name + " matched at index " + indexName.to_s + ", " + indexQuery.to_s)
      return calculateEditDistance(query, name, indexQuery + 1, indexName + 1, true)
    # If they letters are different
    else
      # These are the three possible changes we can make. 

      # Delete a character from the name
      del = calculateEditDistance(query, name, indexQuery + 1, indexName, match)
      # Insert a character into the query
      insert = calculateEditDistance(query, name, indexQuery, indexName + 1, match)
      # Swap two characters
      swap = calculateEditDistance(query, name, indexQuery + 1, indexName + 1, match)
      return 1 + min(del, insert, swap)
    end
  end


  # Match indicates if any character matched the query.  
  # If no characters matched we want to indicate this is a bad edit difference
  #   so we add 100 to weigh it down.  
  #   This prevents short names from being rated as good matches
  def multiplier(match)
    if(match)
      return 0
    end
    100
  end

end


