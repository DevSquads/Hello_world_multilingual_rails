#todo remove duplication
def create_yml_file_for_locale_mission(main_language, id, title, instructions)
  File.open(yml_path(main_language), 'w+') do |file|
    file.write("#{main_language}:\n")
    file.write((' ' * 2) + "missions:\n")
    file.write((' ' * 4) + "#{mission_id_to_locale_id(id)}:\n")
    file.write((' ' * 6) + "title: '#{title}'\n")
    file.write((' ' * 6) + "instructions: '#{instructions}'")
  end
end


def create_base_yml_file_without_missions(main_language)
  File.open(yml_path(main_language), 'w+') do |file|
    file.write("#{main_language}:\n")
    file.write((' ' * 2) + "missions:\n")
    file.write((' ' * 4) + "hello: \"Hello world!\"\n")
  end
end

def yml_path language
  Rails.root.join('config', 'locales', "#{language}.yml")
end


def reset_locale language
  if language.nil? or language.empty?
    return
  end
  create_base_yml_file_without_missions(language) unless File.exists?(yml_path(language))

  I18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
  I18n.locale = language
end

def remove_locale_file language
  File.delete yml_path(language) if File.exists?(yml_path language)

  new_load_paths = I18n.load_path.map do |path|
    path unless path.include?("#{language}.yml")
  end.compact

  I18n.load_path = new_load_paths

  I18n.locale = I18n.default_locale
end