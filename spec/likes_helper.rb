require 'spec_helper'

# A shared example for testing a likeable object. Must be
# passed a :likeable object as a parameter.
#
# Author:: Melissa Winstanley
shared_examples_for "likeable" do

  # Songs should be created with likes intialized to 0
  it "should create songs with likes set to 0" do
    likeable.like_count.should eq(0)
  end

  # Liking once should increase the likes attribute by one
  it "should increase likes by one when liked" do
    likeable.like!
    likeable.like_count.should eq(1)
  end

  # Liking multiple times should increase the likes attribute
  # by the number of times that it was liked
  it "should increase likes when liked multiple times" do
    likeable.like!
    likeable.like!
    likeable.like!
    likeable.like!
    likeable.like_count.should eq(4)
  end

  # Unliking shoudl decrease the like count by one
  it "should allow you to unlike a song that you have liked" do
    likeable.like!
    likeable.unlike!
    likeable.like_count.should eq(0)
  end

  # Unliking should do nothing if the total likes are 0
  it "should not do anything if haven't liked the song" do
    likeable.unlike!
    likeable.like_count.should eq(0)
  end
end
