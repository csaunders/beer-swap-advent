class BeerXMLRecipe
  attr_reader :document
  delegate :style, to: :document

  def initialize(file)
    xml = StringIO.new(file.read)
    @document = parse(xml).tap do |doc|
      doc.mash ||= OpenStruct.new(mash_steps: [])
      doc.yeasts ||= []
      doc.fermentables ||= []
      doc.hops ||= []
    end
  end

  def to_markdown
    """
**Style**: #{style.name}(#{style.category_number}#{style.style_letter})

**Batch Size**: #{document.batch_size}

**Boil Size**: #{document.boil_size}

**Boil Time**: #{document.boil_time}

**Efficiency:** #{document.efficiency}%

# Fermentables

|Amount|Name|Usage|
|------|----|-----|
#{table(fermentables)}

# Hops

|Amount|Name|Usage|
|------|----|-----|
#{table(hops)}

# Yeast

#{list(yeast)}

# Mash Schedule

#{list(mash)}
"""
  end

  private

  def fermentables
    total_weight = document.fermentables.reduce(0) do |memo, f|
      memo + f.amount
    end
    document.fermentables.map do |f|
      percentage_grist = "%5.2f" % ((f.amount / total_weight) * 100)
      %W(#{percentage_grist}% #{f.name} #{f.notes})
    end
  end

  def hops
    document.hops.map do |h|
      [
        "#{h.amount} (#{h.alpha}%AA)",
        "#{h.name} (#{h.form})",
        "#{h.time} #{h.use}"
      ]
    end
  end

  def mash
    document.mash.mash_steps.map do |m|
      "#{m.name} #{m.step_temp} for #{m.step_time} minutes"
    end
  end

  def yeast
    document.yeasts.map do |y|
      "#{y.name}"
    end
  end

  def table(rows)
    rows.map do |item|
      "|#{item.join('|')}|"
    end.join("\n")
  end

  def list(items)
    items.map {|i| "- #{i}"}.join("\n")
  end

  def parse(xml)
    parser = NRB::BeerXML::Parser.new(perform_validations: false)
    parser.parse(xml).first
  end
end
