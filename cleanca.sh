#! /bin/sh

cleanca() {
  TEMP=`getopt -o c:h --long ca:,help -n 'cleanca.sh' -- "$@"`

  eval set -- "$TEMP"
  while true; do
    case "$1" in
      -c|--ca) CA=$2; shift 2;;
      -h|--help) echo "Options:"
		 echo "  -c|--ca <ca>"
		 shift
		 exit 1
		 ;;
      --) shift; break;;
      *) echo "internal error"; exit 1;;
    esac
  done

  if [ -z "$CA" ]; then
    echo "CA identifier is missing."
    exit 1
  fi

  echo "====="
  echo "Cleaning CA $CA"
  rm -rf "database/$CA"
  cd store > /dev/null
  for i in *; do 
    if [ -h "$i" ]; then
      LINKED=`readlink "$i"`
      if [ "$LINKED" = $CA.pem -o "$LINKED" = $CA.crl ]; then
      # TODO: detect cross-signed certificates (*-$CA.pem)
        rm $i
      fi
    fi
  done
  rm -f $CA.pem *-$CA.pem $CA.crl
  cd .. > /dev/null
  
  rm -f users/$CA-*.crt users/$CA-*.p12 users/$CA-*.key
  echo "====="
}

cleanca "$@"
