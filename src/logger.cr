require "log"

Log.define_formatter CverFormat, "#{severity}: #{message}"
BUILDER = Log::Builder.new
BUILDER.bind("cver", :debug, Log::IOBackend.new(formatter: CverFormat))
module Logger
  Log = BUILDER.for("cver")
end