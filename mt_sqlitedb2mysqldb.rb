# -*- encoding: utf-8 -*-

#This is a migration program sample for movabletype.
#Version 0.1


require 'sequel'

#Setup configration section for mt's db migration
from_db_type = 'sqlite'
from_db_name = 'sqlite_db_filename'

to_db_type = 'mysql'
username = 'username'
password = 'password'
to_db_server = 'localhost'
to_db_name = 'databasename'

#convert asset file uploaded path.
current_html_path = '/home/www'
new_html_path = '/var/www'

my_sleep_weight = 0.01
#generate db object
DB  = Sequel.connect("#{from_db_type}://#{from_db_name}")
DB2 = Sequel.connect("#{to_db_type}://#{username}:#{password}@#{to_db_server}/#{to_db_name}")

tables = DB.tables

# mt_session table is never migration.
tables.delete(:mt_session)
tables.delete(:mt_log)

tables.each do |table_name|
    p table_name
    sleep 5

    table = Array.new
    if table_name == :mt_asset
        table = DB[table_name].to_a
        table.each do |row|
            row.reject!{|key,val| key == :asset_meta}
            p row
            DB2[table_name].insert(row)
            sleep my_sleep_weight
        end
    elsif table_name == :mt_blog
        table = DB[table_name].to_a
        table.to_a.each do |row|
            row.reject!{|key,val| key == :blog_meta}
            row[:blog_site_path].sub!(current_html_path,new_html_path)
            p row
            DB2[table_name].insert(row)
            sleep my_sleep_weight
        end
    elsif table_name == :mt_fileinfo
        table = DB[table_name].to_a
        table.to_a.each do |row|
            unless row[:fileinfo_file_path].nil? or row[:fileinfo_file_path].empty?
                row[:fileinfo_file_path].sub!(current_html_path,new_html_path)
            end
            p row
            DB2[table_name].insert(row)
            sleep my_sleep_weight
        end
    elsif table_name == :mt_template
        table = DB[table_name].to_a
        table.to_a.each do |row|
            unless row[:template_linked_file].nil? or row[:template_linked_file].empty?
                row[:template_linked_file].sub!(current_html_path,new_html_path)
            end
            unless row[:template_outfile].nil? or row[:template_outfile].empty?
                row[:template_outfile].sub!(current_html_path,new_html_path)
            end
            p row
            DB2[table_name].insert(row)
            sleep my_sleep_weight
        end
    else
        table = DB[table_name].to_a
        table.to_a.each do |row|
            p row
            DB2[table_name].insert(row)
            sleep my_sleep_weight
        end
    end
end

