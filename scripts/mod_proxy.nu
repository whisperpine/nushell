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
    --git (-g) # Modify git settings
  ] {
  if $param == "set" {
    if $git {
      git config --global http.https://github.com.proxy $env.PROXY_HTTP
      git config --global https.https://github.com.proxy $env.PROXY_HTTP

      git config --global http.https://raw.githubusercontent.com.proxy $env.PROXY_HTTP
      git config --global https.https://raw.githubusercontent.com.proxy $env.PROXY_HTTP

      git config --global http.https://media.githubusercontent.com.proxy $env.PROXY_HTTP
      git config --global https.https://media.githubusercontent.com.proxy $env.PROXY_HTTP

      print "~/.gitconfig has been modified."
    }
    let-env ALL_PROXY = $env.PROXY_HTTP
    print "Proxy has been opened."
    print $env.ALL_PROXY
    check_staus
  } else if $param == "unset" {
    if $git {
      git config --global --unset http.https://github.com.proxy
      git config --global --unset https.https://github.com.proxy

      git config --global --unset http.https://raw.githubusercontent.com.proxy
      git config --global --unset https.https://raw.githubusercontent.com.proxy

      git config --global --unset http.https://media.githubusercontent.com.proxy
      git config --global --unset https.https://media.githubusercontent.com.proxy

      print "~/.gitconfig has been modified."
    }
    let-env ALL_PROXY = null
    print "Proxy has been closed."
  } else if $param == "status" {
    if $git {
      print "github.com settings:"
      git config --global --get http.https://github.com.proxy | print -n
    }
    check_staus
  } else {
    help proxy
  }
}
