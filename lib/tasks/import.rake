require 'csv'

namespace :import do
  desc "Seed database with all csv files"
  task all: :environment do
    # Reset database
    InvoiceItem.destroy_all
    Transaction.destroy_all
    Item.destroy_all
    Invoice.destroy_all
    Customer.destroy_all
    Merchant.destroy_all
    Discount.destroy_all

    CSV.foreach('db/data/merchants.csv', headers: true) do |row|
      Merchant.create!(row.to_hash)
    end

    CSV.foreach('db/data/customers.csv', headers: true) do |row|
      Customer.create!(row.to_hash)
    end


    CSV.foreach('db/data/items.csv', headers: true) do |row|
      Item.create!(row.to_hash)
    end

    CSV.foreach('db/data/invoices.csv', headers: true) do |row|
      if row.to_hash['status'] == 'cancelled'
        status = 0
      elsif row.to_hash['status'] == 'in progress'
        status = 1
      elsif row.to_hash['status'] == 'completed'
        status = 2
      end
      Invoice.create!({ id: row[0],
        customer_id: row[1],
        status:      status,
        created_at:  row[4],
        updated_at:  row[5] })
    end

    CSV.foreach('db/data/transactions.csv', headers: true) do |row|
      if row.to_hash['result'] == 'failed'
        result = 0
      elsif row.to_hash['result'] == 'success'
        result = 1
      end
      Transaction.create!({ id:        row[0],
          invoice_id:                  row[1],
          credit_card_number:          row[2],
          credit_card_expiration_date: row[3],
          result:                      result,
          created_at:                  row[5],
          updated_at:                  row[6] })
    end

    CSV.foreach('db/data/invoice_items.csv', headers: true) do |row|
      if row.to_hash['status'] == 'pending'
        status = 0
      elsif row.to_hash['status'] == 'packaged'
        status = 1
      elsif row.to_hash['status'] == 'shipped'
        status = 2
      end
      InvoiceItem.create!({ id:          row[0],
                            item_id:     row[1],
                            invoice_id:  row[2],
                            quantity:    row[3],
                            unit_price:  row[4],
                            status:      status,
                            created_at:  row[6],
                            updated_at:  row[7] })
    end
  end
end
