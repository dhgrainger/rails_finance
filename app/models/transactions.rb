class Transactions < ActiveRecord::Base
  require 'csv'
  validates :date, presence: true
  validates :amount, presence: true
  def self.amount(withdrawl, deposit)
    if withdrawl != nil
      total = withdrawl
    else
      total = deposit
    end
    total
  end

  def self.parse_additional_info(text)
    if text != nil
      text_array = text.gsub(/\d/,"").split('  ').first(4)
    else
      text_array = ["none"]
    end
    if text_array.length == 4
      info = {type: text_array[0],
              name: text_array[1],
              city: text_array[2],
              state: text_array[3]}
    else
      info = {type: nil, name: text_array.join(), city: nil, state: nil}
    end
    info
  end



  def self.arrest_illegal_characters(file)
    header = []
    transactions = []
    File.foreach(file.path) do |csv_line|

      row = CSV.parse(csv_line.gsub('\"', '""')).first

      if header.empty?
        header = row.map(&:to_sym)
        next
      end
      row = parse_transactions(Hash[header.zip(row)])
      transactions = Transactions.new
      transactions.attributes = row
      transactions.save
    end
  end

  def self.parse_transactions(row)
    attributes = {}
      amt = amount(row[:"<Withdrawal Amount>"], row[:"<Deposit Amount>"])
      unless amt.nil?
       attributes = {
        date: Date.strptime(row[:"<Date>"], '%m/%d/%Y'),
        amount: amt,
        info: row[:"<Additional Info>"]
       }
     end
     attributes
  end
end
  # def self.open_spreadsheet(file)
  #   case File.extname(file.original_filename)
  #   when ".csv" then Csv.new(file.path, nil, :ignore)
  #   when ".xls" then Excel.new(file.path, nil, :ignore)
  #   when ".xlsx" then Excelx.new(file.path, nil, :ignore)
  #   else raise "Unknown file type: #{file.original_filename}"
  #   end
  # end


  # def self.import(file)
  # spreadsheet = CSV.new(file.path)
  # header = spreadsheet[0]
  # (spreadsheet).each do |i|
  #     row = Hash[[header, spreadsheet.row(i)].transpose]
  #       binding.pry
  #     product = find_by_id(row["id"]) || new
  #     product.attributes = row.to_hash.slice(*accessible_attributes)
  #     product.save!
  #   end
  # end
