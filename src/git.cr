require "./utils"

module Git
  def self.has_changes()
    resp = Utils.run_program("git", ["status", "--porcelain=v1"])
    ! resp.nil?
    # rows = resp.split "\n"
    # puts rows.size
    # git status --porcelain=v1 2>/dev/null | wc -l
  end
end