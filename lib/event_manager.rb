require "csv"
require "google/apis/civicinfo_v2"
require "erb"

def clean_zipcode(zipcode)
  # if zipcode.nil?
  #   "00000"
  # elsif zipcode.length > 5
  #   zipcode[0..4]
  # elsif zipcode.length < 5
  #   zipcode.rjust(5, "0")
  # else
  #   zipcode
  # end

  zipcode.to_s.rjust(5, "0")[0..4]
end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = File.read("secret.key").strip

  # legislators =
  civic_info.representative_info_by_address(
    address: zip,
    levels: "country",
    roles: %w[legislatorUpperBody legislatorLowerBody]
  ).officials
  # legislators = legislators.officials

  # legislators.map(&:name).join(", ")
rescue StandardError => e
  puts "#{e}: You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials"
end

def save_thank_you_letter(id, form_letter)
  FileUtils.mkdir_p("output")

  filename = "output/thanks_#{id}.html"

  File.open(filename, "w") do |file|
    file.puts form_letter
  end
end

puts "Event Manager Initialised!"

contents = CSV.open("event_attendees.csv", headers: true, header_converters: :symbol)

template_letter = File.read("form_letter.erb")
erb_template = ERB.new template_letter

contents.each do |row|
  user_id = row[0]
  first_name = row[:first_name]

  zipcode = clean_zipcode(row[:zipcode])
  legislators = legislators_by_zipcode(zipcode)

  form_letter = erb_template.result(binding)
  # puts form_letter

  save_thank_you_letter(user_id, form_letter)

  # personal_letter = template_letter.gsub("FIRST_NAME", first_name)
  # personal_letter = personal_letter.gsub("LEGISLATORS", legislators)
  # puts personal_letter

  # puts "#{first_name} - #{zipcode} - #{legislators}"
end

# confirm_file = File.exist? "event_attendees.csv"
# puts confirm_file

# contents = File.read("event_attendees.csv")
# puts contents

# lines = File.readlines("event_attendees.csv")
# lines.each do |line|
#   next if line == " ,RegDate,first_Name,last_Name,Email_Address,HomePhone,Street,City,State,Zipcode"

#   columns = line.split(",")

#   name = columns[2]
#   puts name
# end

# lines.each_with_index do |line, index|
#   next if index.zero?

#   columns = line.split(",")
#   name = columns[2]
#   puts name
# end
