class Movie
  attr_reader :name

  def initialize(name)
    @name = name
  end
end

class ChildrensMovie < Movie
  def initialize(name:, days:)
    super(name)
    @days = days
  end

  def price
    return 1.5 if @days < 4
    1.5 + (@days * 1.5)
  end

  def points
    1
  end
end

class NewReleaseMovie < Movie
  def initialize(name:, days:)
    super(name)
    @days = days
  end

  def price
    3 * @days
  end

  def points
    return 1 if @days == 1
    2
  end
end

class RentalFactory
  def make(type, request)
    case (type)
    when 'childrens'
      ChildrensMovie.new(request)
    when 'new-release'
      NewReleaseMovie.new(request)
    end
  end
end
