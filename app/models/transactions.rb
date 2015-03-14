class Transactions < ActiveRecord::Base
  require 'csv'
  serialize :info,Array

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
    text_array
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
      transactions = find_by_id(row["id"]) || new
      transactions.attributes = row
      transactions.save!
    end
  end

  def self.parse_transactions(row)

    attributes = {}
      amt = amount(row[:"<Withdrawal Amount>"], row[:"<Deposit Amount>"])
      unless amt.nil?
       attributes = {date: row[:"<Date>"], amount: amt, info: parse_additional_info(row[:"<Additional Info>"])}
     end
     attributes
  end
  # def self.open_spreadsheet(file)
  #   case File.extname(file.original_filename)
  #   when ".csv" then Csv.new(file.path, nil, :ignore)
  #   when ".xls" then Excel.new(file.path, nil, :ignore)
  #   when ".xlsx" then Excelx.new(file.path, nil, :ignore)
  #   else raise "Unknown file type: #{file.original_filename}"
  #   end
  # end

end
