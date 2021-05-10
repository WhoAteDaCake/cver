module Utils
  def self.run_program(cmd, args)
    io = IO::Memory.new
    Process.run(cmd, args, output: io)
    io.close
    text = io.to_s
    # Remove EOF
    text[0, text.size - 1]
  end
end