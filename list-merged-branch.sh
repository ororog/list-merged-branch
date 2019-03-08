#!/bin/sh

# Space separeted branch list to exclude.
excludes="master"

# Returns 0 if $excludes contains $1.
contains () {
  for v in $excludes
  do
    [[ $v = $1 ]] && return 0
  done
  return 1
}

log_master=`git log master | tr -d '\n'`

for branch in `git branch | cut -c 3-`
do
  contains $branch && continue

  log_branch=`git log master..$branch -n 1  | sed -e 1d | tr -d '\n'`

  # Skips a branch which does not have any commits.
  [ -z "$log_branch" ] && continue

  echo "$log_master" | grep "$log_branch" > /dev/null && echo $branch
done
