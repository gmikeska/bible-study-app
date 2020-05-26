class Article < ApplicationRecord
  after_initialize do |article|
    if(article.slug.nil? && article.title.present?)
      article.slug = article.title.parameterize
      article.save
    end
  end
  def to_param
    slug
  end
end
