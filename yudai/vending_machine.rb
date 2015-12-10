class VendingMachine
  MONEY_TYPES = [10, 50, 100, 500, 1000]

  attr_reader :total_money, :sales
  def initialize
    @total_money = 0
    @stocks = {
      'コーラ' => Stock.new(Drink.new('コーラ', 120), 5),
      'レッドブル' => Stock.new(Drink.new('レッドブル', 200), 5),
      '水' => Stock.new(Drink.new('水', 100), 5)
    }
    @sales = 0
    @charge = {
      10: { count: 10 },
      50: { count: 10 },
      100: { count: 10 },
      1000: { count: 10 }
    }
  end

  def add_money(money)
    return money unless MONEY_TYPES.include?(money)
    @total_money += money
  end

  def refund
    total_money = @total_money
    @total_money = 0
    total_money
  end

  def stock_informations
    @stocks.map { |k, v| v.to_s }
  end

  def perchasable_drinks
    perchasable_stocks.map { |k, v| v.to_s }
  end

  def perchase(drink_name)
    return nil unless stock = find_stock(drink_name)
    return nil unless stock.perchasable?
    stock.decrement
    @sales += stock.drink.price
    @total_money -= stock.drink.price
    refund
  end

  private

  def find_stock(drink_name)
    @stocks[drink_name]
  end

  def perchasable_stocks
    @stocks.select { |k, v| v.perchasable? }
  end
end

class Drink
  attr_reader :name, :price
  def initialize(name, price)
    @name = name
    @price = price
  end
end

class Stock
  attr_reader :drink, :amount
  def initialize(drink, amount)
    @drink = drink
    @amount = amount
  end

  def to_s
    "名前: #{drink.name} | 値段: #{drink.price} | 個数: #{amount}"
  end

  def perchasable?(money)
    enough_money?(@total_money) || enough_amount? > 0 ? true : false
  end

  def decrement
    @amount -= 1
  end

  private

  def enough_money?(money)
    money > @drink.price
  end

  def enough_amount?
    @amount > 0
  end
end
