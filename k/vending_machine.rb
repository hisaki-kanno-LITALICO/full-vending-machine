class VendingMachine
  ALLOW_COINS_AND_BILLS = [10, 50, 100, 500, 1000].freeze
  attr_reader :feeding_money, :sales

  def initialize
    @feeding_money = 0
    @sales = 0
    @menus = {
      cola: Drink.new('コーラ', 120, 5),
      redbull: Drink.new('レッドブル', 200, 5),
      water: Drink.new('水', 120, 5)
    }
    @change_stock = ChangeStock.new(ALLOW_COINS_AND_BILLS)
  end

  def feed(money)
    return @feeding_money += money if ALLOW_COINS_AND_BILLS.include? money
    money
  end

  def refund
    refund_money = @feeding_money
    @feeding_money = 0
    refund_money
  end

  def menus
    @menus.collect do |menu|
      menu[1].to_s
    end
  end

  def getatable_menus
    @menus.select do |k, v|
      v.getatable?(@feeding_money)
    end.collect do |menu|
      menu[1].to_s
    end
  end

  def cola_getatable?
    @menus[:cola].getatable?(@feeding_money)
  end

  def buy_cola
    return unless cola_getatable?

    @menus[:cola].decrease_stock
    @feeding_money -= @menus[:cola].price
    @sales += @menus[:cola].price
  end
end

class Drink
  attr_reader :stock, :price

  def initialize(name, price, stock)
    @name = name
    @price = price
    @stock = stock
  end

  def to_s
    "商品名:#{@name} 値段:#{@price} 在庫数:#{@stock}"
  end

  def decrease_stock
    @stock -= 1 if @stock > 0
  end

  def getatable?(feeding_money)
    @stock > 0 && feeding_money >= @price
  end
end

class ChangeStock
  def initialize(allow_coins_and_bills)
    @coins_and_bills = {}
    allow_coins_and_bills.each do |acab|
      @coins_and_bills[acab] = 5
    end
    @coins_and_bills = @coins_and_bills.sort_by{ |k, v| k }.to_h
  end

  def refund!(refund_money)
    change = get_change(refund_money)
    return {} if change.nil?
    change.each { |money, count| @coins_and_bills[money] -= count }
    change
  end

  def enough_stock?(refund_money)
    !get_change(refund_money).nil?
  end

  private
  def get_change(refund_money)
    change = {}
    @coins_and_bills.each do |money, stock|
      refund_coin_count = [refund_money / money, stock].min
      change[money] = refund_coin_count
      refund_money -= refund_coin_count * money
      break if refund_money == 0
    end
    return nil unless refund_money == 0
    change
  end
end
