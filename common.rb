class Movie
  attr_reader :name, :days

  def initialize(name:, days:)
    @name = name
    @days = days
  end
end

class ChildrensMovie < Movie
  def price
    return 1.5 if @days < 4
    1.5 + (@days * 1.5)
  end

  def points
    1
  end
end

class NewReleaseMovie < Movie
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
