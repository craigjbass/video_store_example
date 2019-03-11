require_relative 'common'

class StatementPrinter
  def initialize(view_statement:)
    @view_statement = view_statement
  end

  def print
    response = @view_statement.execute({})

    output = "Statement for customer\n"

    response[:rentals].each do |rental|
      output << "  #{rental[:name]} #{rental[:price]}\n"
    end

    output << "You owe #{response[:owed]}\n"
    output << "You earned #{response[:points]} points\n"
  end
end

class CreateRental
  def initialize(rental_gateway:, rental_factory:)
    @rental_gateway = rental_gateway
    @rental_factory = rental_factory
  end

  def execute(type:, name:, days:)
    @rental_gateway.save(@rental_factory.make(type, { name: name, days: days }))
    {}
  end
end

class ViewStatement
  def initialize(rental_gateway:)
    @rental_gateway = rental_gateway
  end

  def execute(*)
    rentals = @rental_gateway.all
    owed = 0
    points = 0
    {
      rentals: rentals.map do |rental|
        owed += rental.price
        points += rental.points
        {
          name: rental.name,
          price: rental.price
        }
      end,
      owed: owed,
      points: points
    }
  end
end

class InMemoryRentalGateway
  def initialize(rental_factory:)
    @rental_factory = rental_factory
    @rentals = []
  end

  def save(rental)
    @rentals << {
      type: @rental_factory.to_type(rental),
      days: rental.days,
      name: rental.name
    }
  end

  def all
    @rentals.map do |rental|
      @rental_factory.make(
        rental[:type],
        name: rental[:name],
        days: rental[:days]
      )
    end
  end
end

rental_factory = RentalFactory.new
rental_gateway = InMemoryRentalGateway.new(rental_factory: rental_factory)
create_rental = CreateRental.new(rental_gateway: rental_gateway, rental_factory: rental_factory)
view_statement = ViewStatement.new(rental_gateway: rental_gateway)
statement = StatementPrinter.new(view_statement: view_statement)

create_rental.execute(type: 'childrens', name: 'Bugs Life', days: 4)
create_rental.execute(type: 'childrens', name: 'Bugs Life', days: 4)
create_rental.execute(type: 'new-release', name: '2 Fast 50', days: 4)
puts statement.print

