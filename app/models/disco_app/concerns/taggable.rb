module DiscoApp::Concerns::Taggable
  extend ActiveSupport::Concern

  def tags
    data['tags'].split(',').map(&:strip)
  end

  def add_tag(tag)
    data['tags'] = (tags + [tag]).uniq.join(',')
  end

  def remove_tag(tag)
    data['tags'] = (tags - [tag]).uniq.join(',')
  end

end
