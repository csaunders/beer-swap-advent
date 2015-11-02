class Submission < ActiveRecord::Base
  REGIONS = %w(east west)
  belongs_to :user
  enum region: {east: 1, west: 2}

  scope :visible, -> {where("day <= ?", Time.now.beginning_of_day).order(:day)}
  scope :invisible, -> {where("day > ?", Time.now.beginning_of_day).order(:day)}
  scope :unknown, -> {where(day: nil)}

  def recipe_html
    markdown.render(recipe).gsub('<table>', '<table class="table table-striped table-bordered">')
  end

  def beer_xml=(file)
    self.recipe = BeerXMLRecipe.new(file).to_markdown
  end

  private
  def markdown
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML, tables: true)
  end
end
