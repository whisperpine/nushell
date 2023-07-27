# Module to setup proxy.

# Check proxy status.
def check_staus [] {
  print "Trying to connect to Google..."
  let response_code = (curl -I -s --connect-timeout 2 -m 2 -w "%{http_code}" -o /dev/null www.google.com)
  if $response_code == "200" {
    print "Proxy setup succeeded!"
  } else {
    print "Proxy setup *** failed ***"
  }
}

# Set up proxy for CLI and git.
# Suported arguments:
#   set     setup proxy and check status
#   unset   unset proxy
#   status  check whether proxy is setup
export def-env proxy [
    param?: string #  set, unset, status
    --git (-g) # modify git settings
    --npm # modify npm config
    --pnpm # modify pnpm config
  ] {
  if $param == "set" {
    if $git { git_set }
    if $npm {
      npm config -g set $"proxy=($env.PROXY_HTTP)"
      npm config -g set $"https-proxy=($env.PROXY_HTTP)"
      print "npm config has been set."
    }
    if $pnpm {
      pnpm config -g set $"proxy=($env.PROXY_HTTP)"
      pnpm config -g set $"https-proxy=($env.PROXY_HTTP)"
      print "pnpm config has been set."
    }
    $env.ALL_PROXY = $env.PROXY_HTTP
    print "Proxy has been opened."
    print $env.ALL_PROXY
    check_staus
  } else if $param == "unset" {
    if $git { git_unset }
    if $npm {
      npm config -g delete proxy
      npm config -g delete https-proxy
      print "npm config has been unset."
    }
    if $pnpm {
      pnpm config -g delete proxy
      pnpm config -g delete https-proxy
      print "pnpm config has been unset."
    }
    $env.ALL_PROXY = null
    print "Proxy has been closed."
  } else if $param == "status" {
    if $git {
      print "github.com settings:"
      git config --global --get http.https://github.com.proxy | print -n
    }
    if $npm {
      npm config -g get proxy | print -n $"npm proxy = ($in)"
      npm config -g get https-proxy | print -n $"npm https-proxy = ($in)"
    }
    if $pnpm {
      pnpm config -g get proxy | if $in == "" { "null\n" } else { $in } | print -n $"pnpm proxy = ($in)"
      pnpm config -g get https-proxy | if $in == "" { "null\n" } else { $in } | print -n $"pnpm https-proxy = ($in)"
    }
    check_staus
  } else {
    help proxy
  }
}

def git_set [] {
  git config --global http.https://github.com.proxy $env.PROXY_HTTP
  git config --global https.https://github.com.proxy $env.PROXY_HTTP

  git config --global http.https://lfs.github.com.proxy $env.PROXY_HTTP
  git config --global https.https://lfs.github.com.proxy $env.PROXY_HTTP

  git config --global http.https://raw.githubusercontent.com.proxy $env.PROXY_HTTP
  git config --global https.https://raw.githubusercontent.com.proxy $env.PROXY_HTTP

  git config --global http.https://media.githubusercontent.com.proxy $env.PROXY_HTTP
  git config --global https.https://media.githubusercontent.com.proxy $env.PROXY_HTTP

  print "~/.gitconfig has been modified."
}

def git_unset [] {
  git config --global --unset http.https://github.com.proxy
  git config --global --unset https.https://github.com.proxy

  git config --global --unset http.https://lfs.github.com.proxy
  git config --global --unset https.https://lfs.github.com.proxy

  git config --global --unset http.https://raw.githubusercontent.com.proxy
  git config --global --unset https.https://raw.githubusercontent.com.proxy

  git config --global --unset http.https://media.githubusercontent.com.proxy
  git config --global --unset https.https://media.githubusercontent.com.proxy

  print "~/.gitconfig has been modified."
}
