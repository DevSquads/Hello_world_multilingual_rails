# Writes a locale file's headers
def write_locale_file_headers(file, main_language)
  file.write("#{main_language}:\n")
  file.write((' ' * 2) + "missions:\n")
end

# Writes a mission in its correct file format
def write_mission_to_locale(file, id, instructions, title)
  file.write((' ' * 4) + "#{mission_id_to_locale_id(id)}:\n")
  file.write((' ' * 6) + "title: '#{title}'\n")
  file.write((' ' * 6) + "instructions: '#{instructions}'")
end

# Create a yml file for a language with a mission
def create_yml_file_for_locale_mission(main_language, id, title, instructions)
  File.open(yml_path(main_language), 'w+') do |file|
    write_locale_file_headers(file, main_language)
    write_mission_to_locale(file, id, instructions, title)
  end
end


# Creates a yml file with only the needed headers for a language
def create_base_yml_file_without_missions(main_language)
  File.open(yml_path(main_language), 'w+') do |file|
    write_locale_file_headers(file, main_language)
    file.write((' ' * 4) + "hello: \"Hello world!\"\n")
  end
end

# Returns file path to a language's locale file
def yml_path language
  Rails.root.join('config', 'locales', "#{language}.yml")
end


# Resets I18n.locale to a certain language, creating that language's locale file if needed
def reset_locale language
  if language.nil? or language.empty?
    return
  end
  create_base_yml_file_without_missions(language) unless File.exists?(yml_path(language))

  I18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
  I18n.locale = language
end

# Removes a specified language's locale file
def remove_locale_file language
  File.delete yml_path(language) if File.exists?(yml_path language)

  new_load_paths = I18n.load_path.map do |path|
    path unless path.include?("#{language}.yml")
  end.compact

  I18n.load_path = new_load_paths

  I18n.locale = I18n.default_locale
end