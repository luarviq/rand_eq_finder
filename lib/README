 This is duplicates_finder, a little Ruby library for finding duplicates of binary files.
 It doesn't use any kind of hash sums. Instead, it compares a couple of bytes of both the files at random positions.
 Two files are equal with probability that depends on the count of compared bytes. 
 This level you can set manually.
 The results will be saved in JSON format.
 
 Author: Shandrikov Vadim, wadzime@tut.by
 Join my groups on LinkedIn
 
 There are a pair of questions appearing when you face this library:
  
 1. Why JSON?
    Because JSON is the most suitable format for storing such data structures and transferring it across Internet. Besides, this is the "native" data format for JavaScript.

 2. Why Ruby? 
    It's clear, I reckon=)
 
 Install:
 
 ruby setup.rb
 
 Use:
 
 dup_finder=DuplicateFinder.new(:pattern_dir=>'./dvd',
:check_dir=>'/hdd')  
 
 
 