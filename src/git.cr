require "./utils"

module Git
  TAG_DIR = Path[".git/refs/tags/"]

  def self.has_changes()
    return Utils.run_program("git", ["status", "--porcelain=v1"])
  end

  def self.root_dir()
    dir = Utils.run_program("git", ["rev-parse", "--show-toplevel"])
    dir.try do | dir |
      Path[dir]
    end
  end

  def self.push(item : String)
    Process.run(
      "git",
      ["push", "origin", item],
      output: Process::Redirect::Inherit,
      error: Process::Redirect::Inherit
    )
  end

  def self.tag(tag : String)
    Process.run(
      "git",
      ["tag", tag],
      output: Process::Redirect::Inherit,
      error: Process::Redirect::Inherit
    )
  end

  def self.read_tags(root_dir : Path)
    full_path = root_dir.join(TAG_DIR)
    dir = Dir.new(full_path)
    dir.children
  end

  def self.branch()
    Utils.run_program("git", ["symbolic-ref", "--short", "-q", "HEAD"])
  end
end