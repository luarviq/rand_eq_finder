
$KCODE="U"

class DuplicateFinder<Struct.new(:pattern, :check)
  require 'find'
  require 'json'
  require 'jcode'
  
  # JSON module as mixin
  include JSON
  
  def initialize(args={})
      super(args[:pattern_dir],args[:check_dir])
	  
	  @patterns_hash=Hash.new()
	  @duplicates_hash=Hash.new()
	  
	  @P_coll=args[:collision_probability]||128
      initialize_patterns
	  find_duplicates
	  dump
  end
  
  # here we use the powerful Ruby technology named "mixins"
   def generate(obj,opts = nil)
       state = PRETTY_STATE_PROTOTYPE.dup
       state.generate(obj)
   end
  
  def initialize_patterns
      Find.find(self[:pattern]){|file_path| 
	      if File.file? file_path
	         @patterns_hash[file_path]=File.size file_path
			 @duplicates_hash[file_path]=Array.new()
		  end	 
	 	}
  end
  
  def are_equal(pattern_file,check_file) # these files are of equal size
      equal=true
      offsets_array=Array.new() # array of random offsets in file
	  file_size=File.size(check_file)
	  num_of_points=(file_size/@P_coll).floor #number of bytes need to check to achieve required precision
	  offsets_array=Array.new() # array of random offsets in file
	  
	  (1..num_of_points).each do |i|
	     offsets_array.push rand(file_size)
	  end
	  
	  fp=File.open(pattern_file,'r') # read the whole files to the buffers
	  bytes_p=fp.read
	  fc=File.open(check_file,'r')
	  bytes_c=fc.read
	  fc.close
	  fp.close
	  
	  offsets_array.each do |offset|   # compare each byte at appropriate offset
	  	  
	   byte_p=bytes_p[offset,1]
	   byte_c=bytes_c[offset,1]
		
       if byte_p!=byte_c
           equal=false
		   break
       end		
		 
	  end
	  equal
  end
  
  
  
  def find_duplicates
    num_of_matches=0
    @patterns_hash.each_pair do |p_file,size| 
	  puts "Finding duplicates for pattern file: #{p_file}"
      Find.find(self[:check]) {|check_file|
	         if File.file? check_file
			    out_string="   Checking file: #{check_file}:"
				out_string_plus=""
              	if size==File.size(check_file)
				    if are_equal p_file,check_file
					   num_of_matches+=1
					   out_string_plus+=" MATCH FOUND"
					   #---------------------------------------------------
					   flog=File.open("matches.log",'a')
                       flog.puts "#{num_of_matches}. #{p_file} => #{check_file} "
                       flog.close
					   
					   
					   #---------------------------------------------------
					  
					   found_file_hash=Hash.new()
					   found_file_hash[check_file]=Hash.new()
					   found_file_hash[check_file]["created"]=File.ctime(check_file)
					   found_file_hash[check_file]["modified"]=File.mtime(check_file)
					   #found_file_hash[check_file]["accessed"]=File.atime(check_file)
					   p_file=utf8_to_json_ascii p_file
					   @duplicates_hash[p_file].push found_file_hash
			   	                     			
					end
				else
                    out_string_plus+=" Not match."					 
				end
			 puts out_string+out_string_plus	 
			 end
        	        	   
	 }
    end	
	puts "#{num_of_matches} matches found."
  end 

  def dump
     fjson=File.open("duplicates.json",'w')
     json=generate @duplicates_hash
	 json=json.strip
     fjson.puts json
	 fjson.flush
     fjson.close
   end  
   
end

