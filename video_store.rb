class StatementPrinter
  def initialize(rental_factory:)
    @rental_factory = rental_factory
    @rental = []
  end

  def add_rental(type, request)
   @rental << @rental_factory.make(type, request)
  end

  def print
    "Statement for customer\n" +
      "  #{@rental.first.name} #{@rental.first.price}\n" +
    "You owe #{@rental.first.price}\n" +
    "You earned #{@rental.first.points} points\n"
  end
end

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
    1.5
  end

  def points
    1
  end
end

class RentalFactory
  def initialize
    @things = {}
  end

  def make(type, request)
    callable = @things[type]
    callable.call(request)
  end

  def register(type, &block)
    @things[type] = block
  end
end

rental_factory = RentalFactory.new
rental_factory.register('childrens') do |request|
  ChildrensMovie.new(request)
end

statement = StatementPrinter.new(rental_factory: rental_factory)
statement.add_rental('childrens', { name: 'Bugs Life', days: 3 })

puts statement.print
