class Submission < ActiveRecord::Base
  REGIONS = %w(east west)
  belongs_to :user
  enum region: {east: 1, west: 2}

  scope :visible, -> {where("day <= ?", Time.now.beginning_of_day).order(:day)}
  scope :invisible, -> {where("day > ?", Time.now.beginning_of_day).order(:day)}

  def recipe_html
    markdown.render(recipe)
  end

  private
  def markdown
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML, tables: true)
  end
end
