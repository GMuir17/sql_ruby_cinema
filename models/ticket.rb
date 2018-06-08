require_relative("../db/sql_runner.rb")
require_relative("./customer.rb")
require_relative("./film.rb")

class Ticket

  attr_reader(:id)
  attr_accessor(:customer_id, :film_id)

# instance methods
  def initialize(options)
    @id = options["id"].to_i() if options["id"]
    @customer_id = options["customer_id"].to_i()
    @film_id = options["film_id"].to_i()
  end

  def save()
    sql = "INSERT INTO tickets (customer_id, film_id)
      VALUES ($1, $2)
      RETURNING id;"
    values = [@customer_id, @film_id]
    ticket = SqlRunner.run(sql, values).first()
    @id = ticket["id"].to_i()
  end

# class methods
  def self.all()
    sql = "SELECT * FROM tickets;"
    tickets = SqlRunner.run(sql)
    results = Ticket.map_items(tickets)
    return results
  end

  def self.map_items(ticket_data)
    return ticket_data.map {|ticket| Ticket.new(ticket)}
  end

end
