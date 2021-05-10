require "monads"

enum Bump
  Major
  Minor
  Patch
end 

struct Version
  include Comparable(Version)

  property major, minor, patch

  def initialize(@major : Int16, @minor : Int16, @patch : Int16)
  end

  def bump(change : Bump)
    case change
      when Bump::Major
        @major += 1
        @minor = 0
        @patch = 0
      when Bump::Minor
        @minor += 1
        @patch = 0
      when Bump::Patch
        @patch += 1
    end 
    self 
  end

  def <=>(other : Version)
    if other.major != @major
      return @major <=> other.major
    end

    if other.minor != @minor
      return @minor <=> other.minor
    end

    if other.patch != @patch
      return @patch <=> other.patch
    end
    
    return 0
  end

  def to_s
    "#{value.major}.#{value.minor}.#{value.patch}}"
  end

  def self.of_s(value : String)
    # TODO, handle -alpha.1 in the future
    parts = value.split(".")
    if parts.size < 3
      raise "Unexpected format: #{value}"
    else
      self.new(
        parts[0].to_i16,
        parts[1].to_i16,
        parts[2].to_i16
      )
    end
  end
end