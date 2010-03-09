class Example
  
  prints_receiept
  
  def id
    125
  end
  
  def attributes
    {
      :name    => 'Receipt Example',
      :address => '2225 Coronation Blvd',
      :city    => 'Charlotte',
      :state   => 'NC',
      :zip     => '28227',
      :phone   => '1234567890',
      :contact => 'Adam Hunter',
      :value   => 10_000_000
    }
  end
  
  def method_missing(method_name, *args)
    attributes[method_name] ? attributes[method_name] : super
  end
  
end

