# Author:: Harnoor Singh
module UsersHelper

  # Takes an array of users and the search query
  # Returns the users in sorted order
  def sortUsersByRelevancy(users, query)
    if(users.empty?)
      Array.new
    else
      results = Hash.new
      users.each do |user|
        results[user] = editDistance(user, query)
      end

      # Sort the hash.  This returns a 2D array
      twoDResults = results.sort {|a,b| a[1] <=> b[1]}

      # Return an array of users in the sorted order
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
    return min(a, b, c)
  end


  # Return the min of three values
  def min(a, b, c)
    [a,b,c].min
  end

  # Calculate the edit distance between two strings (query and name)
  # indexQuery represents what index we're at for query
  # indexName represents what index we're at for name
  # match is a boolean initially set to false.  It is set to true if we have
  #   found at least one matching letter.  This prevents us from favoring
  #   short names with no letters in commin over long names with letters
  #   in common.  (Eg: Yi and Miller in a search for e)
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


  # Match is a boolean which indicates if any character matched the query.  
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


