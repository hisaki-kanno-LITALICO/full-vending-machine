class FullVendingMachine
 attr_reader :charged, :sales
 AVAILABLE_MONEY = [10, 50, 100, 500, 1000].freeze

 def initialize
   @charged = 0
   @sales = 0
   # 在庫
   @stocks_management = StockManagement.new
   @stocks_management.add_stock('cola', Drink.new('コーラ', 120), 5)
   @stocks_management.add_stock('redbull', Drink.new('レッドブル', 200), 5)
   @stocks_management.add_stock('water', Drink.new('水', 100), 5)
 end

 def charge(money)
   return money unless AVAILABLE_MONEY.include?(money)
   @charged += money
 end

 def refund
   refund_charged = @charged
   @charged = 0
   refund_charged
 end

 def all_stocks
   @stocks_management.all_stocks
 end

 def purchasable?(drink_name)
   @charged > @stocks_management.drink_info(drink_name).price && @stocks_management.drink_stocks(drink_name) > 0
 end

 def purchasable_list
   purchasable_list = []

   all_stocks.each do |drink_name, value|
     purchasable_list << drink_name.to_s if self.purchasable?(drink_name)
   end

   purchasable_list
 end

 def purchase(drink_name)
   if purchasable?(drink_name)
     @stocks_management.reduce_stock(drink_name)
     drink_price = @stocks_management.drink_info(drink_name).price
     @charged -= drink_price
     @sales += drink_price
   end
 end
end

class StockManagement
 attr_reader :all_stocks

 def initialize
   @all_stocks = {}
 end

 def add_stock(drink_name, drink, stocks)
   @all_stocks.store(:"#{drink_name}", { info: drink, stocks: stocks })
 end

 def reduce_stock(drink_name)
   @all_stocks[:"#{drink_name}"][:stocks] -= 1
 end

 def drink_info(drink_name)
   @all_stocks[:"#{drink_name}"][:info]
 end

 def drink_stocks(drink_name)
   @all_stocks[:"#{drink_name}"][:stocks]
 end

end

class Drink
 attr_reader :name, :price

 def initialize(name, price)
   @name = name
   @price = price
 end
end


full_vc = FullVendingMachine.new
full_vc.charge(500)
full_vc.purchasable_list
