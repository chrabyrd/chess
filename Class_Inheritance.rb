class Employee

  attr_reader :salary
  attr_accessor :manager

  def initialize(name, title, salary)
    @name = name
    @title = title
    @salary = salary
    @manager = nil
  end

  def bonus(multiplier)
    @salary * multiplier
  end
end

class Manager < Employee

  attr_reader :employees

  def initialize(name, title, salary)
    @employees = []
    super
  end

  def bonus(multiplier)
    queue = @employees.dup
    sub_sal = 0

    until queue.empty?
      employee = queue.shift
      sub_sal += employee.salary
      queue += employee.employees if employee.is_a? Manager
    end

    sub_sal * multiplier
  end

  def add_employee(employee)
    @employees << employee
    employee.manager = self
  end

end

emp = Employee.new("jerry", "stockboy", 400)
emp2 = Employee.new("donny", "stockboy", 400)

mang = Manager.new("Bob", "middle-manager", 5000)

mang.add_employee(emp)
mang.add_employee(emp2)

p emp.bonus(0.1)
p mang.bonus(0.1)
