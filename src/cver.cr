require "admiral"
require "./version"
require "./git"

# git rev-parse --show-toplevel
# .git/refs/tags/
# git symbolic-ref --short -q HEAD
# git status --porcelain=v1 2>/dev/null | wc -l

Git.has_changes()
# result = Version.of_s("1.1.0") <=> Version.of_s("2.0.0")
# puts Version.of_s("1.1.0").bump(Bump::Major)

# patch
# minor
# major
# pre-release

# class Cver < Admiral::Command
#   def pathc
#     puts "Hello World"
#   end
# end