require "admiral"
require "./version"
require "./git"
require "./logger"

def validate()
  changes = Git.has_changes()
  if !changes.nil?
    Logger::Log.fatal { "Changes found:\n#{changes}\nCommit before continuing" }
    exit(1)
  end

  root_dir = Git.root_dir()
  if root_dir.nil?
    Logger::Log.fatal { "Could not find root directory for repository, have you ran git init?" }
    exit(1)
  end

  tags = Version.parse_tags(Git.read_tags(root_dir))

  branch = Git.branch()
  if branch.nil?
    Logger::Log.fatal { "Could not find the branch, make sure you are in a git repository" }
    exit(1)
  end

  if tags.size == 0
    Logger::Log.warn { "No tags found, creating initial tag" }
    {Version.new(0, 0, 1), branch}
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
      Logger::Log.fatal { "Unexpect action: #{aa}\nExpected one of : #{ALLOWED}" }
      exit(1)
    end
    # Now that everything else is confirmed, we can validate environment
    tag, branch = validate()
    new_tag = tag.bump(aa).to_s
    
    Logger::Log.info { "Pushing changes to the branch [#{branch}]" }
    Git.push(branch)

    Logger::Log.info { "Creating new tag [#{new_tag}]" }
    Git.tag(new_tag)

    Logger::Log.info { "Pushing new tag [#{new_tag}]" }
    Git.push(new_tag)
  end
end

Cver.run