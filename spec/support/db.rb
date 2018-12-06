RSpec.configure do |c|
  c.before(:suite) do
    Sequel.extension :migration
    Sequel::Migrator.run(DB, 'db/migrations')
   
  end
  c.around(:example, :db) do |example|
     DB[:expenses].truncate
    DB.transaction(rollback: :always) { example.run }
  end
end