class Machine
  attr_reader :products, :earnings, :inserted_amount, :change_stock
  MONEY = [10, 50, 100, 500, 1000]

  def initialize
    @inserted_amount = 0
    @earnings = 0
    @products = {}
    #円 => 釣り銭の数
    @change_stock = { 10 => 10, 50 => 10, 100 => 10, 500 => 10, 1000 => 10 } 
  end

  def add_product_to_machine(product)
    @products.store("#{product.name}", product)
  end

  def insert_coin(inserted_money)
    @inserted_amount = @inserted_amount + inserted_money
    MONEY.reverse_each do |reverse_money|
      number = inserted_money.div(reverse_money).to_i
      if number > 0
        insert_coin_to_change_stock(reverse_money, number)
        inserted_money = inserted_money - (reverse_money*number)
      end
    end
  end

  def insert_coin_to_change_stock(money, number)
    @change_stock[money] = @change_stock[money] + number
  end

  def menus
    @products.each_value do |product_obj|
      p product_obj.name
    end
  end

  def check_list_purchasable_products
    @products.each_value do |product_obj|
      if product_obj.stock > 0 && @inserted_amount >= product_obj.price
        p product_obj.name + '購入できます'
      else
        p product_obj.name + '購入できません'
      end
    end
  end

  def getatable?(product_name)
    @products["#{product_name}"].stock > 0 && @inserted_amount >= @products["#{product_name}"].price
  end

  def buy_product(product_name)
    getatable?(product_name) ? buy_process("#{product_name}") : '買えません'
  end

  def buy_process(product)
    product = @products["#{product}"]
    p product
    @inserted_amount = @inserted_amount - product.price
    product.decrease_stock
    @earnings = @earnings + product.price
    refund
  end

  def refund
    MONEY.reverse_each do |i|
      num = @inserted_amount.div(i).to_i
      if num > 0 && @change_stock[i] >= num
        @inserted_amount = @inserted_amount - (i*num)
        refund_process(i, num)
      end
    end
  end

  def refund_process(money, num)
    @change_stock[money] = @change_stock[money].to_i - num
    p "#{money} x #{num}"
  end

  def random
    random = []
    random << 'cola' if getatable?('cola')
    random << 'zero' if getatable?('zero')
    random << 'tea' if getatable?('tea')
    return 'random項目がない' if random.empty? #nil(x)
    random_number = rand(random.size)
    buy_process("#{random[random_number]}")
  end
end

class Drink
  attr_reader :stock, :price, :name

  def initialize(name, price, stock)
    @name = name
    @price = price
    @stock = stock
  end

  def decrease_stock
    @stock = @stock - 1 if @stock > 0
  end
end
