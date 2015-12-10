class VendingMachine
  attr_reader :money

  def initialize
    @money = 0
    @available_money = [10, 50, 100, 500, 1000]
    @drinks = StockDrink.new
  end

  def insert(money)
    if @available_money.include?(money)
      @money += money
    else
    end
  end

  def return
    money = @money
    @money = 0
    return money
  end

  def buy(name)
    buy_drink = @drinks.buy(name)
    if buy_drink
      @money -= get_price(name)
    end
    return buy_drink
  end

  def get_price(name)
    @drinks.get_price(name)
  end

  def random_buy
    stock_drinks = self.stocks
    random_drinks = []
    stock_drinks.each do |stock_drink|
      if stock_drink[:price] < @money && stock_drink[:stocks] > 0
        random_drinks << stock_drink[:name]
      end
    end
    self.buy(random_drinks.sample) unless random_drinks.empty?
  end

  def stocks
    @drinks.list
  end

  private
end

class StockDrink
  attr_reader :quantity

  def initialize
    @stock_drinks = Hash.new { |h,k| h[k] = {} }
    create_drinks
  end

  def insert(drink, price)
    @stock_drinks[drink.name][:price] = price
    if @stock_drinks[drink.name][:drink].nil?
      @stock_drinks[drink.name][:drink] = { 0 => drink }
    else
      count = @stock_drinks[drink.name][:drink].count
      @stock_drinks[drink.name][:drink].store(count, drink)
    end
  end

  def buy(name)
    if @stock_drinks[name].nil?
      return false
    else
      @stock_drinks[name][:drink].each do |key, stock_drink|
        if stock_drink.expire_time > Time.now
          buy_drink = stock_drink
          @stock_drinks[name][:drink].delete(key)
          return buy_drink
        end
      end
    end
  end

  def get_price(name)
    if @stock_drinks[name].nil?
      return false
    else
      return @stock_drinks[name][:price]
    end
  end

  def list
    available_drinks = []
    @stock_drinks.each do |name,drinks|
      count = 0
      drinks[:drink].each do |key, drink|
        if drink.expire_time > Time.now
          count += 1
        end
      end
      available_drinks << {name: name, price:drinks[:price], stocks: count}
    end
    return available_drinks
  end

  private

  def create_drinks
    5.times do
      cola = Drink.new("コーラ", Time.now-3000000+rand(10000000))
      insert(cola, 120)
      dcola = Drink.new("ダイエットコーラ", Time.now-3000000+rand(10000000))
      insert(dcola, 120)
      tea = Drink.new("お茶", Time.now-3000000+rand(10000000))
      insert(tea, 120)
    end
  end
end

class Drink
  attr_reader :name, :expire_time

  def initialize(name, time)
    @name = name
    @expire_time = time
  end
end

class Money
  attr_reader :price

  def initialize(price)
    @price = price
  end
end
