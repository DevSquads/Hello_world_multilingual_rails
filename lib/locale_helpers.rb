#todo remove duplication
def create_yml_file_for_locale_mission(yaml_path, main_language, id, title, instructions)
  File.open(yaml_path, 'w+') do |file|
    file.write("#{main_language}:\n")
    file.write((' ' * 2) + "missions:\n")
    file.write((' ' * 4) + "m_#{id}:\n")
    file.write((' ' * 6) + "title: '#{title}'\n")
    file.write((' ' * 6) + "instructions: '#{instructions}'")
  end
end


def create_base_yml_file_without_missions(yaml_path, main_language)
  File.open(yaml_path, 'w+') do |file|
    file.write("#{main_language}:\n")
    file.write((' ' * 2) + "missions:\n")
    file.write((' ' * 4) + "hello: \"Hello world!\"\n")

  end
end

def yml_path language
  Rails.root.join('config', 'locales', "#{language}.yml")
end


def reset_locale language
  file_path = yml_path language
  create_base_yml_file_without_missions(file_path,language) unless File.exists?(file_path)

  I18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
  I18n.locale = language
end

def remove_locale_file language
  file_path = Rails.root.join('config/locales', "#{language}.yml")
  File.delete if File.exists?(file_path)

  I18n.load_path = Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
end