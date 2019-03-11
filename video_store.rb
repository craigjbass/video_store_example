require_relative 'common'

class StatementPrinter
  def initialize(rental_factory:)
    @rental_factory = rental_factory
    @rentals = []
  end

  def add_rental(type, request)
    @rentals << @rental_factory.make(type, request)
  end

  def print
    output = "Statement for customer\n"
    total = 0
    points = 0

    @rentals.each do |rental|
      total += rental.price
      points += rental.points
      output << "  #{rental.name} #{rental.price}\n"
    end

    output << "You owe #{total}\n"
    output << "You earned #{points} points\n"
    output
  end
end

rental_factory = RentalFactory.new

statement = StatementPrinter.new(rental_factory: rental_factory)
statement.add_rental('childrens', { name: 'Bugs Life', days: 3 })
statement.add_rental('new-release', { name: '2 Fast 50 ', days: 3 })

puts statement.print
