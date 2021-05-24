require "admiral"
require "./version"
require "./git"

# git rev-parse --show-toplevel
# .git/refs/tags/
# git symbolic-ref --short -q HEAD
# git push --all origin

def validate()
  # changes = Git.has_changes()
  # if !changes.nil?
  #   puts "Changes found:\n#{changes}\nCommit before continuing"
  #   exit(1)
  # end
  root_dir = Git.root_dir()
  if root_dir.nil?
    puts "Could not find root directory for repository, have you ran git init?"
    exit(1)
  end

  begin
    tags = Git.read_tags(root_dir).map { | v | Version.of_s v }.sort { |a, b| b <=> a }
  rescue ex
    puts "Failed to parse tags:\n  > #{ex.message}"
    exit(1)
  end

  branch = Git.branch()
  if branch.nil?
    puts "Could not find the branch, make sure you are in a git repository"
    exit(1)
  end

  if tags.size == 0
    puts "No tags found, please create initial tag"
    exit(1)
  else
    {tags[0], branch}
  end
end

# TODO:
# pre-release
ALLOWED_ACTIONS = [
  "major",
  "minor",
  "patch"
]
ALLOWED = ALLOWED_ACTIONS.join(", ")

class Cver < Admiral::Command
  define_argument action : String,
    description: "One of #{ALLOWED}",
    required: true

  def run
    aa = arguments.action
    if !ALLOWED_ACTIONS.includes?(aa)
      puts "Unexpect action: #{aa}\nExpected one of : #{ALLOWED}"
      exit(1)
    end
    # Now that everything else is confirmed, we can validate environment
    tag, branch = validate()
    new_tag = tag.bump(aa).to_s
    
    puts "Pushing changes to the branch [#{branch}]"
    Git.push(branch)

    puts "Creating new tag [#{new_tag}]"
    Git.tag(new_tag)

    puts "Pushing new tag [#{new_tag}]"
    Git.push(new_tag)

    puts "Done"
  end
end

Cver.run