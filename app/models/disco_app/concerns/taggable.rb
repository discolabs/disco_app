module DiscoApp::Concerns::Taggable

  extend ActiveSupport::Concern

  def tags
    data[:tags].split(',').map(&:strip)
  end

  def add_tag(tag)
    data[:tags] = (tags + [tag]).uniq.join(',')
  end

  def remove_tag(tag)
    data[:tags] = (tags - [tag]).uniq.join(',')
  end

  def has_tag?(tag_to_check)
    tags.any? { |tag| tag.casecmp?(tag_to_check) }
  end

end
