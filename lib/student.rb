require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :name, :album
attr_reader :id
 
  def initialize(id=nil, name, album)
    @id = id
    @name = name
    @album = album
  end
 
  def self.create_table
    sql =  <<-SQL
      CREATE TABLE IF NOT EXISTS songs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        album TEXT
        )
        SQL
    DB[:conn].execute(sql)
  end
 
  def save
    sql = <<-SQL
      INSERT INTO songs (name, album)
      VALUES (?, ?)
    SQL
 
    DB[:conn].execute(sql, self.name, self.album)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM songs")[0][0]
  end
 
  def self.create(name:, album:)
    song = Song.new(name, album)
    song.save
    song
  end
 
  def self.find_by_name(name)
    sql = "SELECT * FROM songs WHERE name = ?"
    result = DB[:conn].execute(sql, name)[0]
    Song.new(result[0], result[1], result[2])
  end


end
